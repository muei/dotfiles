# Dotfiles

## Arch

## hyprland

## Neovim

### Install

1. Install neovim

```bash
# arch linux
sudo pacman -Sy neovim
chmod +x install.sh
./install.sh

## fish shell
sudo pacman -S fish
```

## Node

```
# install node version manager
cargo install fnm
# add cargo bin to path
fish_add_path ~/.cargo/bin
# Create ~/.config/fish/conf.d/fnm.fish add this line to it:
echo "fnm env --use-on-cd | source" >> fnm.fish
```

## font

```
# chinese font
paru -S noto-fonts-cjk # Google Noto CJK fonts
paru -S ttf-jetbrains-mono-nerd # nerd font
paru -S ttf-firacode-nerd
```

## input methods

```
paru -S fcitx5-im fcitx5-im
```

## waybar

````
paru -S waybar
# default config path: /etc/xdg/waybar

## alacritty
```bash
sudo pacman -S alacritty
# sample config
cp /usr/share/doc/alacritty/example/alacritty.yml
````

````

## Zellij
```bash
yay -Sy zellij
````

## Nushell

```bash
yay -Sy nushell
# set as default shell
chsh -s ${which nu}
```

## Commands

```bash
# list installed package
paru -Ps
```

## PVE K8S

https://gist.github.com/acj/3cb5674670e6145fa4f355b3239165c7?permalink_comment_id=4760024#gistcomment-4760024
