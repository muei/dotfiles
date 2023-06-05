set -x ALL_PROXY socks5://(grep nameserver /etc/resolv.conf | awk '{ print $2 }'):7890
