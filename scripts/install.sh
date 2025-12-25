#!/bin/bash
# 主安装脚本
# 参考: https://github.com/end-4/dots-hyprland/tree/main/sdata/lib

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# 加载工具函数
source "$LIB_DIR/utils.sh"

# 模块列表
MODULES=(
    "shell"          # Shell 配置 (fish)
    "ntp"            # NTP 时间同步
    "input-method"   # 输入法配置
    "tools"          # 终端与工具链
)

# 显示帮助信息
show_help() {
    cat << EOF
用法: $0 [选项] [模块...]

选项:
    -h, --help      显示帮助信息
    -a, --all       安装所有模块（默认）
    -l, --list      列出所有可用模块
    -s, --skip      跳过指定模块（用逗号分隔）

模块:
    shell          安装并配置 fish shell
    ntp            配置 NTP 时间同步（国内源）
    input-method   安装并配置 fcitx5-rime + 雾凇 + 小鹤双拼
    tools          安装终端工具和语言环境

示例:
    $0                          # 安装所有模块
    $0 shell ntp                # 只安装 shell 和 ntp 模块
    $0 --all --skip tools       # 安装所有模块，但跳过 tools
EOF
}

# 列出所有模块
list_modules() {
    echo "可用模块:"
    for module in "${MODULES[@]}"; do
        echo "  - $module"
    done
}

# 检查模块是否存在
module_exists() {
    local module=$1
    [[ -f "$LIB_DIR/$module.sh" ]]
}

# 运行模块
run_module() {
    local module=$1
    
    if ! module_exists "$module"; then
        log_error "模块 '$module' 不存在"
        return 1
    fi
    
    log_info "=========================================="
    log_info "开始执行模块: $module"
    log_info "=========================================="
    
    if bash "$LIB_DIR/$module.sh"; then
        log_success "模块 '$module' 执行完成"
        return 0
    else
        log_error "模块 '$module' 执行失败"
        return 1
    fi
}

# 主函数
main() {
    local modules_to_run=()
    local skip_modules=()
    local run_all=true
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_modules
                exit 0
                ;;
            -a|--all)
                run_all=true
                shift
                ;;
            -s|--skip)
                IFS=',' read -ra skip_modules <<< "$2"
                shift 2
                ;;
            *)
                modules_to_run+=("$1")
                run_all=false
                shift
                ;;
        esac
    done
    
    # 检查 root
    check_root
    
    # 检查并保持 sudo
    check_sudo
    keep_sudo
    
    # 确定要运行的模块
    if [[ "$run_all" == true ]] && [[ ${#modules_to_run[@]} -eq 0 ]]; then
        modules_to_run=("${MODULES[@]}")
    fi
    
    # 过滤跳过的模块
    local filtered_modules=()
    for module in "${modules_to_run[@]}"; do
        local skip=false
        for skip_module in "${skip_modules[@]}"; do
            if [[ "$module" == "$skip_module" ]]; then
                skip=true
                break
            fi
        done
        if [[ "$skip" == false ]]; then
            filtered_modules+=("$module")
        fi
    done
    
    if [[ ${#filtered_modules[@]} -eq 0 ]]; then
        log_error "没有要运行的模块"
        exit 1
    fi
    
    # 运行模块
    local failed_modules=()
    for module in "${filtered_modules[@]}"; do
        if ! run_module "$module"; then
            failed_modules+=("$module")
        fi
    done
    
    # 总结
    log_info "=========================================="
    log_info "安装完成"
    log_info "=========================================="
    
    if [[ ${#failed_modules[@]} -eq 0 ]]; then
        log_success "所有模块安装成功！"
        exit 0
    else
        log_error "以下模块安装失败: ${failed_modules[*]}"
        exit 1
    fi
}

main "$@"

