if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_indent 2
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR


# EDITOR
abbr v nvim
abbr vi nvim
abbr vim nvim
abbr sv sudoedit

# Tmux
abbr t tmux
abbr tc 'tmux attach'
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new -s'
abbr tl 'tmux ls'
abbr tk 'tmux kill-session -t'

# Files & Directories
abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"

# Path
# golang
# set -x GOROOT /usr/local/go
# set -x GOPATH $HOME/go # workspace path
# set -x GOBIN $GOPATH/bin
# set -x PATH $PATH /usr/local/go/bin $GOPATH/bin
# fish_add_path $PATH /usr/local/go/bin $GOPATH/bin
set -x GO111MODULE on
set -x GOPROXY https://goproxy.cn,direct

# .net
# set -x DOTNET_ROOT $HOME/.dotnet
# set -x PATH $PATH $DOTNET_ROOT $DOTNET_ROOT/tools

# local bin
set -x PATH $PATH $HOME/.local/bin

# pyenv
pyenv init - | source
