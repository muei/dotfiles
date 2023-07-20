# set -x ALL_PROXY socks5://(grep nameserver /etc/resolv.conf | awk '{ print $2 }'):7890
set -x ALL_PROXY socks5://10.20.34.58:7890
