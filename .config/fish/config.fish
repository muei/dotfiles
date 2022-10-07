if status is-interactive # Commands to run in interactive sessions can go here
end

# golang
set -x GOPATH $HOME/go
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin
set -x GO111MODULE on
set -x GOPROXY https://goproxy.cn,direct

# rust
set -gx PATH "$HOME/.cargo/bin" $PATH

# python
set -gx PATH "$HOME/.local/bin" $PATH

# Wayland
set -x MOZ_ENABLE_WAYLAND 1
# set -x SDL_VIDEODRIVER wayland
#set WAYLAND_DISPLAY alacritty


# Input Method
set GTK_IM_MODULE fcitx5
set QT_IM_MODULE fcitx5
set XMODIFIERS @im fcitx5


#set -x http_proxy  http://127.0.0.1:7890
#set -x https_proxy http://127.0.0.1:7890
#set -x all_proxy socks5://127.0.0.1:7891
set -x http_proxy  http://10.253.253.242:8083
set -x https_proxy http://10.253.253.242:8083
#set -x all_proxy socks5://10.253.253.242:7891


alias unproxy='set -u all_proxy http_proxy https_proxy'

alias vi=nvim
alias v=nvim
