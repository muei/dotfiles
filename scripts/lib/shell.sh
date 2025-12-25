#!/bin/bash
# Shell 配置模块 (fish)
# 安装并配置 fish shell

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_fish() {
    log_info "开始安装 fish shell..."
    
    # 检查是否已安装
    if command_exists fish; then
        log_info "fish 已安装，版本: $(fish --version)"
    else
        install_apt fish
    fi
    
    # 设置 fish 为默认 shell
    local fish_path=$(which fish)
    if [[ "$SHELL" != "$fish_path" ]]; then
        log_info "设置 fish 为默认 shell..."
        chsh -s "$fish_path"
        log_success "fish 已设置为默认 shell（需要重新登录后生效）"
    else
        log_info "fish 已经是默认 shell"
    fi
    
    # 配置 fish vi 模式
    local fish_config="$HOME/.config/fish/config.fish"
    ensure_dir "$(dirname "$fish_config")"
    
    if ! grep -q "fish_vi_key_bindings" "$fish_config" 2>/dev/null; then
        append_file "$fish_config" "fish_vi_key_bindings"
        log_success "已启用 fish vi 模式"
    else
        log_info "fish vi 模式已配置"
    fi
    
    log_success "fish shell 配置完成"
}

main() {
    install_fish
}

main "$@"

