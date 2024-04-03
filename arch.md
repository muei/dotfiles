# Hyprland Arch

## VMware install
1. Download arch iso image.
2. Create a new Virtual Machine to install
3. VM settings, set display enable 3D graphics, otherwise may loop login hyprland.
4. Boot and install.
```bash
archinstall --skip-version-check
```

## yay
```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay --version
cd ..
sudo rm -rf yay-bin
```

## Font
```bash
yay -Sy noto-fonts-cjk ttf-jetbrains-mono-nerd
```

## fish

```bash
sudo pacman -Sy fish
```

## neovim

```bash
yay -Sy neovim-nightly-bin

# install lazyvim
git clone https://github.com/LazyVim/starter ~/dotfiles/.config/nvim
rm -rf ~/dotfiles/.config/nvim/.git
```

## zellij
```bash
sudo pacman -Sy zellij
```
## alacritty
```bash
sudo pacman -Sy alacritty
# sample config
cp /usr/share/doc/alacritty/example/alacritty.yml
```
