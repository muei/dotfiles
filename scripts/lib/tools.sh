#!/bin/bash
# 终端与工具链安装模块

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_terminal_tools() {
    log_info "安装终端工具..."
    
    local tools=(
        "git"
        "fzf"
        "ripgrep"
        "eza"
        "bat"
        "direnv"
        "htop"
        "btop"
    )
    
    install_apt "${tools[@]}"
    log_success "终端工具安装完成"
}

install_terminal_emulators() {
    log_info "安装终端模拟器..."
    
    # 可以根据需要选择 kitty 或 alacritty
    local emulators=("kitty")  # 或 "alacritty"
    
    install_apt "${emulators[@]}"
    log_success "终端模拟器安装完成"
}

install_language_tools() {
    log_info "安装语言环境工具..."
    
    # Python: uv
    if ! command_exists uv; then
        log_info "安装 uv (Python 包管理器)..."
        curl -LsSf https://astral.sh/uv/install.sh | sh || log_warn "uv 安装失败"
    fi
    
    # Node: fnm
    if ! command_exists fnm; then
        log_info "安装 fnm (Node 版本管理器)..."
        curl -fsSL https://fnm.vercel.app/install | bash || log_warn "fnm 安装失败"
    fi
    
    log_success "语言环境工具安装完成"
}

main() {
    install_terminal_tools
    install_terminal_emulators
    install_language_tools
    log_success "工具链安装模块完成"
}

main "$@"

