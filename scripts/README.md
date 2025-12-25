# 安装脚本说明

参考 [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland/tree/main/sdata/lib) 的模块化脚本结构，为 Ubuntu 25.10 + Hyprland 环境提供自动化安装和配置脚本。

## 目录结构

```
scripts/
├── install.sh           # 主安装脚本
├── lib/                 # 模块脚本目录
│   ├── utils.sh         # 工具函数库（日志、重试、错误处理等）
│   ├── shell.sh         # Shell 配置模块 (fish)
│   ├── ntp.sh           # NTP 时间同步配置模块
│   ├── input-method.sh  # 输入法配置模块 (fcitx5-rime + 雾凇)
│   └── tools.sh         # 终端与工具链安装模块
└── README.md            # 本文档
```

## 特性

- ✅ **模块化设计**：每个功能独立脚本，便于维护和扩展
- ✅ **错误重试机制**：关键操作支持自动重试，提高成功率
- ✅ **详细日志输出**：彩色日志，清晰显示执行过程
- ✅ **灵活执行**：支持安装所有模块或选择性安装
- ✅ **安全备份**：自动备份配置文件，避免数据丢失

## 使用方法

### 安装所有模块（推荐）

```bash
cd ~/dotfiles/scripts
./install.sh
```

### 安装指定模块

```bash
# 只安装 shell 和 ntp 模块
./install.sh shell ntp

# 只安装输入法模块
./install.sh input-method
```

### 跳过指定模块

```bash
# 安装所有模块，但跳过 tools
./install.sh --all --skip tools
```

### 查看帮助

```bash
./install.sh --help
```

### 列出所有模块

```bash
./install.sh --list
```

## 模块说明

### 1. shell (Shell 配置)

- 安装 fish shell
- 设置 fish 为默认 shell
- 配置 fish vi 模式

**对应文档章节**: `ubuntu-hyprland-postinstall.md` 第 1 节

### 2. ntp (NTP 时间同步)

- 设置时区为 Asia/Shanghai
- 配置国内 NTP 源（阿里云、腾讯云、cn.ntp.org.cn）
- 配置双系统时间同步（Windows 兼容）
- 验证 NTP 配置

**对应文档章节**: `ubuntu-hyprland-postinstall.md` 第 3 节

### 3. input-method (输入法配置)

- 安装 fcitx5-rime
- 配置系统级环境变量
- 安装 plum (Rime 配置管理器)
- 安装雾凇拼音
- 配置小鹤双拼

**对应文档章节**: `ubuntu-hyprland-postinstall.md` 第 5 节

### 4. tools (终端与工具链)

- 安装常用终端工具（git, fzf, ripgrep, eza, bat, direnv, htop, btop）
- 安装终端模拟器（kitty）
- 安装语言环境工具（uv, fnm）

**对应文档章节**: `ubuntu-hyprland-postinstall.md` 第 6 节

## 工具函数库 (utils.sh)

提供以下通用功能：

- `log_info/log_success/log_warn/log_error`: 彩色日志输出
- `retry`: 命令重试机制
- `command_exists`: 检查命令是否存在
- `check_root/check_sudo`: 权限检查
- `backup_file`: 文件备份
- `write_file/append_file`: 文件写入（带备份）
- `install_apt`: apt 包安装（带重试）
- `enable_service`: 服务启用和启动

## 错误处理

- 所有脚本使用 `set -euo pipefail` 确保错误时退出
- 关键操作使用 `retry` 函数自动重试（默认 3 次，间隔 5 秒）
- 失败模块会在最后总结中列出

## 注意事项

1. **不要使用 root 用户运行**：脚本会自动检查并提示
2. **需要 sudo 权限**：脚本会自动请求 sudo 权限
3. **配置文件备份**：所有配置文件修改前会自动备份为 `.bak` 文件
4. **fish shell 配置**：设置 fish 为默认 shell 后需要重新登录才能生效
5. **输入法配置**：安装完成后需要在 fcitx5 设置中手动选择"小鹤双拼（雾凇）"方案

## 扩展新模块

要添加新模块，只需：

1. 在 `lib/` 目录创建新的脚本文件（如 `new-module.sh`）
2. 在脚本开头加载工具函数：`source "$SCRIPT_DIR/utils.sh"`
3. 实现 `main()` 函数
4. 在 `install.sh` 的 `MODULES` 数组中添加模块名

示例：

```bash
#!/bin/bash
# 新模块示例

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

main() {
    log_info "执行新模块..."
    # 你的安装逻辑
    log_success "新模块完成"
}

main "$@"
```

## 参考

- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland/tree/main/sdata/lib) - 脚本结构参考
- [JaKooLit Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland/tree/25.10) - 基础安装脚本

