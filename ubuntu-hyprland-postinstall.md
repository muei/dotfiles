# Ubuntu 25.10 + Hyprland 后续个性化配置

> 基于 JaKooLit 安装脚本（分支：25.10）：<https://github.com/JaKooLit/Ubuntu-Hyprland/tree/25.10>
> 本文档用于记录工作电脑在脚本完成后继续的个性化设置。

## 环境基线
- 系统：Ubuntu 25.10（Wayland / Hyprland）
- 目标：日常开发与办公，强调稳定、快速启动、便于恢复

## 1) Shell：fish
- 安装并设为默认：
  - `sudo apt install -y fish`
  - `chsh -s $(which fish)`
  - 验证：`echo $SHELL` 应显示 `/usr/bin/fish`（需重新登录后生效）
- 启用 vi 模式：
  - 临时：`fish_vi_key_bindings`
  - 永久：在 `~/.config/fish/config.fish` 追加 `fish_vi_key_bindings`
  - 如需恢复默认 emacs 按键：`fish_default_key_bindings`

## 2) 企业 Wi-Fi 连接指南（Ubuntu 25.10 + Netplan）

- Ubuntu 25.10 默认使用 Netplan 进行网络配置，尤其是在服务器或新版桌面环境下，管理企业 Wi-Fi 建议直接编辑 Netplan 配置 YAML 文件（如 `/etc/netplan/*.yaml`）。
- 实际使用中的企业 Wi-Fi（如 `tes-data`，WPA2-Enterprise/EAP）配置模板如下：

```yaml
network:
  version: 2
  wifis:
    NM-<UUID>:
      renderer: NetworkManager
      match:
        name: "wlp0s20f3"              # 当前机器的无线网卡名，可用 `ip link` 或 `nmcli device` 查看
      dhcp4: true
      dhcp6: true
      access-points:
        "YOUR-ENTERPRISE-SSID":        # 企业 Wi-Fi 名称，如 tes-data
          auth:
            key-management: "eap"      # 使用 802.1X EAP，而不是普通 WPA-PSK
            method: "peap"             # 外层 EAP 方法：PEAP
            identity: "YOUR_USERNAME"  # 企业账号（勿硬编码真实值到仓库）
            phase2-auth: "mschapv2"    # 隧道内二次认证方式
            password: "YOUR_PASSWORD"  # 企业密码（勿硬编码真实值到仓库）
          networkmanager:
            uuid: "<UUID>"             # 对应 NetworkManager 连接的 UUID
            name: "YOUR-CONNECTION-NAME"
            passthrough:
              wifi-security.auth-alg: "open"
              ipv6.addr-gen-mode: "default"
              ipv6.ip6-privacy: "-1"
              proxy._: ""
              802-1x.phase1-auth-flags: "32"  # 关键参数：某些企业 Wi-Fi 认证失败时必须启用
      networkmanager:
        uuid: "<UUID>"
        name: "YOUR-CONNECTION-NAME"
```

- **注意事项**:
  - `802-1x.phase1-auth-flags: "32"` 是解决此企业 Wi-Fi 认证失败的关键参数（NetworkManager passthrough 中设置）。
  - `match.name` 需要改成当前机器实际的无线网卡名（如 `wlp0s20f3`，可通过 `ip link` 或 `nmcli device` 查看）。
  - `uuid` 与 `name` 一般来源于已有的 NetworkManager 连接，可以用 `nmcli connection show` 获取并复用，减少手动敲错。
  - 编辑后请运行 `sudo netplan apply` 生效，如遇问题用 `sudo netplan --debug apply` 排查。

- DNS 与代理设置参考：
  - DNS：如需全局自定义，编辑 `/etc/systemd/resolved.conf`，取消注释并写入 `DNS=1.1.1.1 8.8.8.8`，再用 `sudo systemctl restart systemd-resolved`
  - 终端代理：使用 `proxy.fish` 函数管理（详见第 6 节「终端与工具链」）
  - 图形界面临时代理：在需要时用 `env http_proxy=... app` 启动，避免全局污染
- VPN：建议记录实际使用的 VPN 客户端及其配置（例如 `wg-quick`、`.ovpn` 文件等），密钥存放在受限权限目录。

## 3) 时间与时区（双系统场景）

- 设置时区：`sudo timedatectl set-timezone Asia/Shanghai`（按需替换）
- 启用 NTP：`sudo timedatectl set-ntp true`

### NTP 换源（国内网络优化）

- **说明**：Ubuntu 25.10 默认已使用 chrony，无需安装。只需启用 NTP 并配置国内源即可。

- **备份原配置**：
  ```bash
  sudo cp /etc/chrony/sources.d/ubuntu-ntp-pools.sources /etc/chrony/sources.d/ubuntu-ntp-pools.sources.bak
  ```

- **配置国内 NTP 源**：创建新文件 `/etc/chrony/sources.d/ntp-cn.sources`，添加以下内容：
  ```conf
  # 替换为国内 NTP 源（阿里云/腾讯云，禁用 NTS 适配国内网络）
  # 移除 nts prefer 以关闭加密，避免端口拦截
  pool ntp.aliyun.com iburst maxsources 2
  pool time.cloud.tencent.com iburst maxsources 2
  pool cn.ntp.org.cn iburst maxsources 1
  ```

- **禁用原配置**（可选，如需完全使用国内源）：
  ```bash
  # 方法1：重命名原文件（推荐，便于恢复）
  sudo mv /etc/chrony/sources.d/ubuntu-ntp-pools.sources /etc/chrony/sources.d/ubuntu-ntp-pools.sources.disabled
  
  # 方法2：注释掉原文件内容
  # sudo sed -i 's/^/# /' /etc/chrony/sources.d/ubuntu-ntp-pools.sources
  ```

- **应用配置**：
  ```bash
  sudo systemctl restart chronyd
  sudo timedatectl set-ntp 1
  ```

- **验证**：
  ```bash
  chronyc sources -v
  # 或
  timedatectl timesync-status
  # 或
  timedatectl
  ```
- 若与 Windows 双系统出现时间不一致（开机互相改时间），实际验证只有下面命令有效：
  - `sudo timedatectl set-local-rtc 1 --adjust-system-clock`
  - 含义：将硬件时钟改为本地时间（local RTC），配合 Windows 默认行为，避免每次切换系统时互相“拉扯”时间。
- 验证：`timedatectl status` 查看 `Time zone` / `RTC in local TZ` / `NTP service` 等状态是否符合预期。

## 4) 显示
- 分辨率与缩放：`wlr-randr` 查看；在 `~/.config/hypr/hyprland.conf` 中为各显示器设定 `monitor=...`
- 触控板/鼠标：在 Hyprland 中调整自然滚动、速度；必要时通过 `libinput` 工具确认。

## 5) 输入法：fcitx5-rime + 小鹤双拼 + 雾凇
- 实践下来 `fcitx5-rime` 在 Hyprland 下体验更稳定，直接安装核心包即可：
  - 安装：`sudo apt install fcitx5-rime`
- 环境变量配置（推荐方式：系统级配置）：
  - 在 `/etc/environment.d/` 目录下创建配置文件（如 `50-fcitx5.conf`）：
    ```bash
    sudo tee /etc/environment.d/50-fcitx5.conf <<EOF
    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    XMODIFIERS=@im=fcitx
    EOF
    ```
  - 此方式会在系统级别设置环境变量，适用于所有桌面环境和应用。

- 环境变量配置（备选方式：Hyprland 专用）：
  - 按照 [JaKooLit Ubuntu-Hyprland 25.10 分支](https://github.com/JaKooLit/Ubuntu-Hyprland/tree/25.10) 的约定，写入 Hyprland 的环境变量配置 `~/.config/hypr/UserConfigs/ENVariables.conf`：
    - 添加：
      - `env = GTK_IM_MODULE,fcitx`
      - `env = QT_IM_MODULE,fcitx`
      - `env = XMODIFIERS,@im=fcitx`
- 安装 plum（Rime 配置管理器）：
  ```bash
  # 下载 plum 安装脚本
  cd ~/.local/share/fcitx5/rime
  git clone --depth 1 https://github.com/rime/plum.git
  cd plum
  ```

- 安装雾凇拼音（使用 plum）：
  ```bash
  # 在 plum 目录下执行安装命令
  cd ~/.local/share/fcitx5/rime/plum
  bash rime-install iDvel/rime-ice:others/recipes/full
  ```
  或者直接使用在线安装（无需先克隆 plum）：
  ```bash
  curl -fsSL https://raw.githubusercontent.com/rime/plum/master/rime-install | bash -s -- iDvel/rime-ice:others/recipes/full
  ```
  这会自动下载并安装雾凇拼音配置到 `~/.local/share/fcitx5/rime` 目录。

- 小鹤双拼配置：
  - 配置目录：`~/.local/share/fcitx5/rime`
  - 雾凇拼音安装后已包含小鹤双拼方案，只需创建或编辑 `default.custom.yaml` 启用：
    ```yaml
    # ~/.local/share/fcitx5/rime/default.custom.yaml
    patch:
      schema_list:
        - schema: double_pinyin_flypy   # 小鹤双拼（雾凇）
    ```

- 重新部署与选择方案：
  - 重启 fcitx5 或在 fcitx5 菜单中选择"重新部署"/`rime_deployer`
  - 在 fcitx5 设置中，将"小鹤双拼（雾凇）"设为首选方案，关闭不用的其他输入法，减少干扰。

## 5) Hyprland 继续调优
- 核心配置文件：`~/.config/hypr/hyprland.conf`

- **显示与缩放调优**
  - 高 DPI / 多屏缩放主要通过各 `monitor=...` 的 `scale` 参数控制，优先用 Hyprland 的缩放，不在这里全局设置 `GDK_SCALE`，避免应用模糊。
  - Waybar：在 `~/.config/waybar/style.css` 中增大字体和 padding 即可适配高 DPI，而不是用全局环境变量拉伸。
  - Rofi/Wofi：若字体/窗口过小，可在配置中调大 `font` 和 `width/height`，必要时为 rofi 单独设置 `GDK_SCALE=2 rofi -show drun` 这种启动方式。
  - GTK 应用（如 Gedit、Nautilus 等）：默认跟随 Hyprland scale，一般无需额外处理；个别应用过小可用单独启动脚本：
    - `env GDK_SCALE=2 GDK_DPI_SCALE=0.5 appname`
  - Qt / Electron 应用（如 VS Code、JetBrains、部分浏览器）：可通过环境变量微调：
    - `QT_SCALE_FACTOR=1.25` 或在应用启动参数中加 `--force-device-scale-factor=1.25`
    - 建议为问题应用写独立 `.desktop` 或脚本，不在全局环境配置中修改，避免影响其他程序。

- **全局环境变量管理**
  - 统一路径：`~/.config/hypr/UserConfigs/ENVariables.conf`
  - 在此集中设置全局或会话级环境变量（包括输入法、缩放等），例如：
    - `env = GDK_SCALE,2`
    - `env = QT_SCALE_FACTOR,2`
  - 建议只在确认 per-monitor `scale` 不够用时再启用这些全局缩放变量，避免所有应用都被拉伸模糊。

## 6) 终端与工具链
- 终端模拟器：kitty 或 alacritty，统一主题与字体（推荐等宽字体 + Nerd Font）
- 常用工具：`git`, `fzf`, `ripgrep`, `eza`, `bat`, `direnv`, `htop`, `btop`
- 语言环境（按需补充版本与路径）：
  - Python：优先使用 `uv` 管理解释器与依赖（替代传统 `pyenv` + `pip`/`pipx` 组合）
  - Node：`fnm`
  - Go/Java 等：记录安装路径与 GOPATH/JAVA_HOME

- **终端代理管理（proxy.fish）**
  - **安装**：将 `proxy.fish` 脚本复制到 fish 的 functions 目录：
    ```bash
    cp proxy.fish ~/.config/fish/functions/proxy.fish
    ```
    fish 会自动 source `~/.config/fish/functions/` 目录下的文件，无需执行权限。复制后重新打开终端或执行 `source ~/.config/fish/functions/proxy.fish` 即可使用。
  - **功能特点**：
    - 支持自定义 IP 和端口，协议自动区分（HTTP/HTTPS vs SOCKS5）
    - 默认配置：IP=`127.0.0.1`，端口=`7890`（可在脚本中修改 `default_proxy_ip` 和 `default_proxy_port`）
    - 自动设置所有常用代理环境变量（大小写兼容）：`http_proxy`, `https_proxy`, `HTTP_PROXY`, `HTTPS_PROXY`, `all_proxy`, `ALL_PROXY`
    - 支持一键启用/关闭代理，以及代理连通性测试
  - **使用方法**：
    - `proxy` - 显示帮助信息
    - `proxy on` - 启用默认代理（使用默认 IP 和端口）
    - `proxy on <ip> <port>` - 启用自定义 IP+端口的代理（例如：`proxy on 192.168.1.100 8080`）
    - `proxy off` - 一键关闭所有代理环境变量
    - `proxy test` - 验证当前代理的可用性（通过访问 Google 测试）
  - **工作原理**：
    - HTTP/HTTPS 协议使用 `http://` 前缀
    - SOCKS5 协议使用 `socks5://` 前缀（通过 `all_proxy` / `ALL_PROXY` 设置）
    - 使用 `set -xU` 设置全局环境变量，确保在当前会话和后续会话中生效

## 7) 备份与快照
- 若使用 timeshift/snapper，记录计划与排除项
- dotfiles 版本控制：私有仓库/子模块同步，定期推送

## 8) 快捷键与习惯
- **Hyprland/Waybar 常用快捷键**：切换工作区、浮动/平铺、锁屏、截图、音量/亮度（参考 JaKooLit 默认配置与 `KeyHints.sh`）

- **vim 风格方向键（用 `hjkl` 替代方向键）**
  - **绑定文件位置**（基于 JaKooLit Ubuntu-Hyprland）：`~/.config/hypr/UserConfigs/Keybinds.conf`
  - **修改步骤（命令行 + 编辑器）**：
    - 找出所有方向键相关绑定：
      - `rg 'left|right|up|down' ~/.config/hypr/UserConfigs/Keybinds.conf`
    - 检查是否已有 `$mainMod + H/J/K/L` 相关绑定：
      - `rg '\$mainMod.*\b[HJKL]\b' ~/.config/hypr/UserConfigs/Keybinds.conf`
    - 在编辑器中打开该文件，对照下面方案进行替换和清理。

  - **原始方向键方案（典型默认绑定，准备被覆盖）**：

```conf
# 焦点移动（原始方向键）
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# 移动窗口（原始方向键）
bind = $mainMod SHIFT, left, movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up, movewindow, u
bind = $mainMod SHIFT, down, movewindow, d

# 调整窗口大小（原始方向键）
bind = $mainMod CTRL, left, resizeactive, l
bind = $mainMod CTRL, right, resizeactive, r
bind = $mainMod CTRL, up, resizeactive, u
bind = $mainMod CTRL, down, resizeactive, d
```

  - **最终采用的 hjkl 方案（覆盖上面的方向键方案）**：

```conf
### 焦点移动：方向键 -> hjkl
# 原始方向键方案（建议注释掉）
# bind = $mainMod, left, movefocus, l
# bind = $mainMod, right, movefocus, r
# bind = $mainMod, up, movefocus, u
# bind = $mainMod, down, movefocus, d

# vim 风格方向移动（推荐）
bind = $mainMod, H, movefocus, l
bind = $mainMod, L, movefocus, r
bind = $mainMod, K, movefocus, u
bind = $mainMod, J, movefocus, d

### 移动窗口：方向键 -> SHIFT + hjkl
# bind = $mainMod SHIFT, left, movewindow, l
# bind = $mainMod SHIFT, right, movewindow, r
# bind = $mainMod SHIFT, up, movewindow, u
# bind = $mainMod SHIFT, down, movewindow, d

bind = $mainMod SHIFT, H, movewindow, l
bind = $mainMod SHIFT, L, movewindow, r
bind = $mainMod SHIFT, K, movewindow, u
bind = $mainMod SHIFT, J, movewindow, d

### 调整窗口大小：方向键 -> CTRL + hjkl
# bind = $mainMod CTRL, left, resizeactive, l
# bind = $mainMod CTRL, right, resizeactive, r
# bind = $mainMod CTRL, up, resizeactive, u
# bind = $mainMod CTRL, down, resizeactive, d

bind = $mainMod CTRL, H, resizeactive, l
bind = $mainMod CTRL, L, resizeactive, r
bind = $mainMod CTRL, K, resizeactive, u
bind = $mainMod CTRL, J, resizeactive, d

### 快捷键帮助 / cheat sheet
bind = $mainMod SHIFT, H, exec, $scriptsDir/KeyHints.sh
```

  - **冲突检查与清理规则**：
    - 用 `rg 'left|right|up|down'` 检查是否还有基于方向键的 `movefocus` / `movewindow` / `resizeactive`，全部改为注释或删除。
    - 用 `rg '\$mainMod.*\b[HJKL]\b'` 检查 `$mainMod(+SHIFT/CTRL) + H/J/K/L` 是否只剩下上述导航/移动/调整相关绑定：
      - 若有其他用途占用了这些组合，将其改到新的键位（如 `$mainMod + U/I/O/P`），并更新 `KeyHints.sh` 中的说明。
    - 最终约定：`$mainMod(+SHIFT/CTRL) + H/J/K/L` **专用于**「焦点移动 / 移动窗口 / 调整窗口大小（vim 风格）」这三类功能。
    - 修改完成后，通过 `hyprctl reload` 重新加载 Hyprland 配置，或直接重新登录 Hyprland 以使新的按键绑定生效。

- 自定义脚本：将常用脚本放入 `~/bin` 或 JaKooLit 提供的 `$scriptsDir`，并在 fish PATH 中提前

## 9) 在 Linux 中运行 Windows（dockur/windows）
- 目的：在 Ubuntu + Hyprland 下偶尔需要使用 Windows（测试 IE/Edge-only 应用、Office、企业工具等），不想单独装双系统，可用 Docker 方式启动一个 Windows VM。
- 参考项目：
  - 容器镜像与使用说明：[dockur/windows](https://github.com/dockur/windows)
  - 一键脚本思路（包装 docker 命令、打开浏览器/RDP）：可参考 `omarchy-windows-vm` 脚本的做法（`omarchy` 仓库中的 `bin/omarchy-windows-vm` 会封装启动与连接逻辑）。

- 基本 docker-compose 配置（与本仓库 `docker-compose.windows.yaml` 一致或类似）：

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "11"          # 若使用在线下载 ISO，则指定版本；若已下载本地 ISO，会被忽略
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006            # Web 控制台
      - 3389:3389/tcp        # RDP
      - 3389:3389/udp
    volumes:
      - ./windows:/storage   # 持久化 Windows 磁盘数据
    restart: always
    stop_grace_period: 2m
```

- 若**直接使用已下载好的 ISO 镜像**（不再从网络自动下载），按照 [dockur/windows 文档](https://github.com/dockur/windows) 的建议：
  - 将 ISO 文件放在当前目录（例如 `./win11.iso`），并在 compose 中绑定为 `/boot.iso`：

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "11"          # 此时可保留占位，实际会被本地 /boot.iso 覆盖
    volumes:
      - ./windows:/storage   # Windows 系统及数据存储目录
      - ./win11.iso:/boot.iso  # 已下载好的 Windows 安装镜像
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    restart: always
    stop_grace_period: 2m
```

- 使用流程（本地 ISO 场景）：
  - 在本仓库下准备好 `docker-compose.windows.yaml`，并确认 `./win11.iso` 已存在：
    - `docker compose -f docker-compose.windows.yaml up -d`
  - 浏览器访问 `http://localhost:8006`，容器会使用本地 `/boot.iso` 自动完成 Windows 安装。
  - 安装完成后，可通过 RDP 客户端连接：`host:3389`（用户名 `Docker`，密码 `admin`，详见 [dockur/windows readme](https://github.com/dockur/windows)）。

- 在 Ubuntu Hyprland（Wayland）下使用 `sdl-freerdp3` 连接容器中的 Windows：
  - 安装：`sudo apt install freerdp3-sdl`
  - 典型连接命令（动态分辨率 + 剪贴板）：

```bash
# 直接在终端前台运行（会占用当前 terminal）
sdl-freerdp3 /v:localhost:3389 /u:Docker /p:admin /dynamic-resolution +clipboard /cert:ignore
```

- 如果不希望占用当前 terminal，有两种方式：
  - **在 Hyprland 中通过按键绑定启动**（推荐）：

```conf
# 写入 ~/.config/hypr/UserConfigs/Keybinds.conf
# Super + W 启动 / 连接 dockur/windows 容器中的 Windows
bind = $mainMod, W, exec, sdl-freerdp3 /v:localhost:3389 /u:Docker /p:admin /dynamic-resolution +clipboard /cert:ignore
```

  - **用 shell 后台方式启动**（终端中执行，不关心输出）：

```bash
nohup sdl-freerdp3 /v:localhost:3389 /u:Docker /p:admin /dynamic-resolution +clipboard /cert:ignore >/dev/null 2>&1 &
```

  - 若容器使用了 macvlan 独立 IP（参考 [dockur/windows 文档](https://github.com/dockur/windows) 中的 macvlan 部分），则将 `localhost` 替换为容器 IP，例如：

```bash
sdl-freerdp3 /v:192.168.0.100:3389 /u:Docker /p:admin /dynamic-resolution +clipboard /cert:ignore
```

- 后续可以参考 `omarchy-windows-vm` 的结构写一个本地脚本（例如 `~/bin/windows-vm`）：
  - 封装：启动容器（若未启动）、在默认浏览器中打开 `http://localhost:8006` 或调用 `xfreerdp` / `mstsc` 之类的 RDP 客户端。
  - 脚本放入 `~/bin` 并在 fish 的 PATH 中提前，方便通过一个命令快速启动/连接 Windows。

## 10) 待办（逐步补充）
- [ ] 填写实际显示器布局与 `monitor` 配置
- [ ] 添加 fcitx5 或其他输入法的具体配置路径
- [ ] 记录实际代理/VPN 工具与配置文件位置
- [ ] 列出开发语言版本与安装方式
- [ ] Waybar/Rofi 样式与模块精简方案
 - [ ] 整理 SSH/GPG/磁盘挂载等安全与凭据相关配置说明（原第 7 节）


