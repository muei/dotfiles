# 快速开始

## 基本使用

```bash
# 1. 进入脚本目录
cd ~/dotfiles/scripts

# 2. 查看帮助
./install.sh --help

# 3. 安装所有模块（推荐首次使用）
./install.sh

# 4. 或选择性安装
./install.sh shell ntp input-method
```

## 模块对应关系

| 模块 | 功能 | 文档章节 |
|------|------|----------|
| `shell` | fish shell 配置 | 第 1 节 |
| `ntp` | NTP 时间同步（国内源） | 第 3 节 |
| `input-method` | fcitx5-rime + 雾凇 + 小鹤双拼 | 第 5 节 |
| `tools` | 终端工具和语言环境 | 第 6 节 |

## 常见问题

### Q: 如何只安装某个模块？
```bash
./install.sh <模块名>
# 例如：./install.sh shell
```

### Q: 如何跳过某个模块？
```bash
./install.sh --all --skip <模块名>
# 例如：./install.sh --all --skip tools
```

### Q: 脚本执行失败怎么办？
- 脚本会自动重试失败的操作（最多 3 次）
- 查看错误日志，根据提示修复问题
- 可以单独运行失败的模块：`./install.sh <模块名>`

### Q: 配置文件会被覆盖吗？
- 不会，所有配置文件修改前都会自动备份为 `.bak` 文件
- 可以随时恢复备份

### Q: 需要 root 权限吗？
- 不需要 root 用户，但需要 sudo 权限
- 脚本会自动请求 sudo 权限

## 执行流程示例

```bash
$ ./install.sh shell ntp

[INFO] 开始执行模块: shell
[INFO] 开始安装 fish shell...
[SUCCESS] fish shell 配置完成
[SUCCESS] 模块 'shell' 执行完成

[INFO] 开始执行模块: ntp
[INFO] 配置时区为 Asia/Shanghai...
[INFO] 配置国内 NTP 源...
[SUCCESS] NTP 配置模块完成
[SUCCESS] 模块 'ntp' 执行完成

[INFO] ==========================================
[INFO] 安装完成
[INFO] ==========================================
[SUCCESS] 所有模块安装成功！
```

