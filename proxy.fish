# fish 代理脚本：IP+端口支持自定义，协议区分（HTTP/HTTPS vs SOCKS5）
function proxy
    # 默认配置：IP+端口统一，协议分离（按需修改基础默认值）
    set default_proxy_ip "127.0.0.1"
    set default_proxy_port 7890
    # 自动拼接默认协议地址
    set default_http "http://$default_proxy_ip:$default_proxy_port"
    set default_socks5 "socks5://$default_proxy_ip:$default_proxy_port"

    # 无参数时显示帮助信息
    if test (count $argv) -eq 0
        echo "===== Fish 代理管理（IP+端口可自定义，协议区分） ====="
        echo "默认配置：IP=$default_proxy_ip，端口=$default_proxy_port"
        echo "使用方法："
        echo "  proxy on                - 启用默认代理（HTTP/HTTPS + SOCKS5，IP+端口默认）"
        echo "  proxy on <ip> <port>    - 启用自定义IP+端口的代理（协议自动区分）"
        echo "  proxy off               - 一键关闭所有代理"
        echo "  proxy test              - 验证当前代理可用性"
        return 0
    end

    # 1. 启用代理（支持默认 IP+端口 / 自定义 IP+端口）
    if test $argv[1] = on
        # 定义局部变量存储代理 IP 和端口
        set proxy_ip ""
        set proxy_port ""

        # 分支1：仅输入 proxy on - 使用默认 IP+端口
        if test (count $argv) -eq 1
            set proxy_ip $default_proxy_ip
            set proxy_port $default_proxy_port
            # 分支2：输入 proxy on <ip> <port> - 使用自定义 IP+端口
        else if test (count $argv) -eq 3
            set proxy_ip $argv[2]
            set proxy_port $argv[3]
            # 非法参数提示
        else
            echo "❌ 错误：自定义 IP+端口请传入 2 个参数（IP 和 端口）"
            echo "示例：proxy on 192.168.1.100 8080"
            return 1
        end

        # 自动拼接不同协议的代理地址（IP+端口统一，协议区分）
        set http_proxy_addr "http://$proxy_ip:$proxy_port"
        set socks5_proxy_addr "socks5://$proxy_ip:$proxy_port"

        # 批量设置所有代理环境变量（大小写兼容，适配所有程序）
        set -xU http_proxy $http_proxy_addr
        set -xU https_proxy $http_proxy_addr
        set -xU HTTP_PROXY $http_proxy_addr
        set -xU HTTPS_PROXY $http_proxy_addr
        set -xU all_proxy $socks5_proxy_addr
        set -xU ALL_PROXY $socks5_proxy_addr

        echo "✅ 代理已启用！"
        echo "  统一配置：IP=$proxy_ip，端口=$proxy_port"
        echo "  HTTP/HTTPS 协议：$http_proxy_addr"
        echo "  SOCKS5     协议：$socks5_proxy_addr"
        return 0
    end

    # 2. 关闭代理：批量清除所有代理环境变量（屏蔽不存在变量的报错）
    if test $argv[1] = off
        set -eU http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY 2>/dev/null
        echo "❌ 所有代理已关闭！"
        return 0
    end

    # 3. 验证代理可用性：通过公共接口快速判断
    if test $argv[1] = test
        echo "🔍 正在验证代理连通性（超时时间 5 秒）..."
        if curl -s --connect-timeout 5 https://www.google.com/generate_204
            echo "✅ 代理可用！"
        else
            echo "❌ 代理不可用（请检查代理工具状态/IP+端口配置）"
        end
        return 0
    end

    # 无效参数提示
    echo "❌ 无效参数！输入 proxy 查看完整帮助信息"
    return 1
end
