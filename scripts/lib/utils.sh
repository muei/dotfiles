#!/bin/bash
# 工具函数库
# 提供日志、错误处理、重试等通用功能

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# 错误处理函数
error_exit() {
    log_error "$1"
    exit 1
}

# 重试函数
# 用法: retry <最大重试次数> <重试间隔秒数> <命令>
retry() {
    local max_attempts=${1:-3}
    local delay=${2:-5}
    shift 2
    local n=0
    
    while true; do
        if "$@"; then
            return 0
        else
            if [[ $n -lt $max_attempts ]]; then
                ((n++))
                log_warn "命令失败，正在重试 ($n/$max_attempts)..."
                sleep $delay
            else
                log_error "命令在 $max_attempts 次尝试后仍然失败: $*"
                return 1
            fi
        fi
    done
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查是否为 root 用户
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error_exit "请不要使用 root 用户运行此脚本"
    fi
}

# 检查 sudo 权限
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_info "需要 sudo 权限，请输入密码..."
        sudo -v
    fi
}

# 保持 sudo 权限
keep_sudo() {
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# 备份文件
backup_file() {
    local file=$1
    if [[ -f "$file" ]] && [[ ! -f "${file}.bak" ]]; then
        log_info "备份文件: $file -> ${file}.bak"
        sudo cp "$file" "${file}.bak"
    fi
}

# 创建目录（如果不存在）
ensure_dir() {
    local dir=$1
    if [[ ! -d "$dir" ]]; then
        log_info "创建目录: $dir"
        mkdir -p "$dir"
    fi
}

# 写入文件（带备份）
write_file() {
    local file=$1
    local content=$2
    local need_sudo=${3:-false}
    
    backup_file "$file"
    
    if [[ "$need_sudo" == "true" ]]; then
        echo "$content" | sudo tee "$file" >/dev/null
    else
        echo "$content" > "$file"
    fi
    
    log_success "已写入文件: $file"
}

# 追加内容到文件
append_file() {
    local file=$1
    local content=$2
    local need_sudo=${3:-false}
    
    if ! grep -q "$content" "$file" 2>/dev/null; then
        if [[ "$need_sudo" == "true" ]]; then
            echo "$content" | sudo tee -a "$file" >/dev/null
        else
            echo "$content" >> "$file"
        fi
        log_success "已追加内容到: $file"
    else
        log_info "内容已存在于: $file"
    fi
}

# 安装 apt 包（带重试）
install_apt() {
    local packages=("$@")
    log_info "安装 apt 包: ${packages[*]}"
    retry 3 5 sudo apt update
    retry 3 5 sudo apt install -y "${packages[@]}"
    log_success "apt 包安装完成: ${packages[*]}"
}

# 检查服务状态
check_service() {
    local service=$1
    if systemctl is-active --quiet "$service"; then
        log_success "服务 $service 正在运行"
        return 0
    else
        log_warn "服务 $service 未运行"
        return 1
    fi
}

# 启用并启动服务
enable_service() {
    local service=$1
    log_info "启用服务: $service"
    retry 3 2 sudo systemctl enable "$service"
    retry 3 2 sudo systemctl restart "$service"
    check_service "$service"
}

