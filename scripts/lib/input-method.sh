#!/bin/bash
# 输入法配置模块 (fcitx5-rime + 雾凇 + 小鹤双拼)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

install_fcitx5_rime() {
    log_info "安装 fcitx5-rime..."
    
    if command_exists fcitx5; then
        log_info "fcitx5 已安装"
    else
        install_apt fcitx5-rime
    fi
    
    log_success "fcitx5-rime 安装完成"
}

configure_environment() {
    log_info "配置输入法环境变量..."
    
    local env_file="/etc/environment.d/50-fcitx5.conf"
    local env_config="GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
"
    
    ensure_dir "/etc/environment.d"
    write_file "$env_file" "$env_config" true
    
    log_success "环境变量配置完成"
}

install_plum() {
    log_info "安装 plum (Rime 配置管理器)..."
    
    local rime_dir="$HOME/.local/share/fcitx5/rime"
    local plum_dir="$rime_dir/plum"
    
    ensure_dir "$rime_dir"
    
    if [[ -d "$plum_dir" ]]; then
        log_info "plum 已存在，跳过安装"
    else
        log_info "克隆 plum 仓库..."
        retry 3 5 git clone --depth 1 https://github.com/rime/plum.git "$plum_dir"
        log_success "plum 安装完成"
    fi
}

install_rime_ice() {
    log_info "安装雾凇拼音..."
    
    local rime_dir="$HOME/.local/share/fcitx5/rime"
    local plum_dir="$rime_dir/plum"
    
    if [[ ! -d "$plum_dir" ]]; then
        install_plum
    fi
    
    # 使用 plum 安装雾凇拼音
    log_info "使用 plum 安装雾凇拼音配置..."
    cd "$plum_dir"
    retry 3 10 bash rime-install iDvel/rime-ice:others/recipes/full
    
    log_success "雾凇拼音安装完成"
}

configure_flypy() {
    log_info "配置小鹤双拼..."
    
    local rime_dir="$HOME/.local/share/fcitx5/rime"
    local config_file="$rime_dir/default.custom.yaml"
    
    ensure_dir "$rime_dir"
    
    local flypy_config="# ~/.local/share/fcitx5/rime/default.custom.yaml
patch:
  schema_list:
    - schema: double_pinyin_flypy   # 小鹤双拼（雾凇）
"
    
    write_file "$config_file" "$flypy_config"
    
    log_success "小鹤双拼配置完成"
}

deploy_rime() {
    log_info "重新部署 Rime 配置..."
    
    if command_exists rime_deployer; then
        rime_deployer || log_warn "rime_deployer 执行失败，可能需要手动重新部署"
    else
        log_warn "rime_deployer 未找到，请手动在 fcitx5 设置中重新部署"
    fi
    
    log_info "提示：请在 fcitx5 设置中将'小鹤双拼（雾凇）'设为首选方案"
}

main() {
    install_fcitx5_rime
    configure_environment
    install_rime_ice
    configure_flypy
    deploy_rime
    log_success "输入法配置模块完成"
}

main "$@"

