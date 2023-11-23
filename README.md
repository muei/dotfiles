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
## font
# chinese font
paru -S noto-fonts-cjk # Google Noto CJK fonts
paru -S ttf-jetbrains-mono-nerd # nerd font


## input methods

paru -S fcitx5-im fcitx5-im

## waybar
paru -S waybar-hyprland
# default config path: /etc/xdg/waybar

## Zellij

```bash
yay -Sy zellij
```

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
