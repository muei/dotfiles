#!/bin/bash
# NTP 时间同步配置模块
# 配置国内 NTP 源和双系统时间同步

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

configure_timezone() {
    log_info "配置时区为 Asia/Shanghai..."
    retry 3 2 sudo timedatectl set-timezone Asia/Shanghai
    log_success "时区配置完成"
}

configure_ntp_sources() {
    log_info "配置国内 NTP 源..."
    
    local ntp_sources_dir="/etc/chrony/sources.d"
    local backup_file="$ntp_sources_dir/ubuntu-ntp-pools.sources.bak"
    local original_file="$ntp_sources_dir/ubuntu-ntp-pools.sources"
    local new_file="$ntp_sources_dir/ntp-cn.sources"
    
    # 备份原配置
    if [[ -f "$original_file" ]] && [[ ! -f "$backup_file" ]]; then
        log_info "备份原 NTP 配置..."
        sudo cp "$original_file" "$backup_file"
    fi
    
    # 创建国内 NTP 源配置
    local ntp_config="# 替换为国内 NTP 源（阿里云/腾讯云，禁用 NTS 适配国内网络）
# 移除 nts prefer 以关闭加密，避免端口拦截
pool ntp.aliyun.com iburst maxsources 2
pool time.cloud.tencent.com iburst maxsources 2
pool cn.ntp.org.cn iburst maxsources 1
"
    
    write_file "$new_file" "$ntp_config" true
    
    # 可选：禁用原配置
    if [[ -f "$original_file" ]]; then
        log_info "禁用原 NTP 配置..."
        sudo mv "$original_file" "${original_file}.disabled" 2>/dev/null || true
    fi
    
    # 重启 chronyd
    log_info "重启 chronyd 服务..."
    retry 3 2 sudo systemctl restart chronyd
    retry 3 2 sudo timedatectl set-ntp 1
    
    log_success "NTP 源配置完成"
}

configure_dual_boot_time() {
    log_info "配置双系统时间同步（Windows 兼容）..."
    retry 3 2 sudo timedatectl set-local-rtc 1 --adjust-system-clock
    log_success "双系统时间同步配置完成"
}

verify_ntp() {
    log_info "验证 NTP 配置..."
    if command_exists chronyc; then
        chronyc sources -v || log_warn "chronyc 查询失败"
    fi
    timedatectl status || log_warn "timedatectl 查询失败"
}

main() {
    configure_timezone
    configure_ntp_sources
    configure_dual_boot_time
    verify_ntp
    log_success "NTP 配置模块完成"
}

main "$@"

