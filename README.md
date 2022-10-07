# Dotfiles

## Neovim
### Install
1. Install neovim
```bash
# arch linux
sudo pacman -Sy neovim
```
2. Clone the repo to the place you want 
```bash
git clone https://github.com/muei/dotfiles.git ~/dotfiles
```
3. Associated configuration
```bash
# create the configuration dir if not exist
mkdir ~/.config
cd ~/.config

# link nvim
ln -s ~/dotfiles/.config/nvim nvim

# link sway
ln -s ~/dotfiles/.config/sway sway

# link fish
ln -s ~/dotfiles/.config/fish fish
```
4. Install plugins
```bash
nvim +PackerSync
```
### Key bindings

#### File
| Shortcut | Description |
| -------- | ----------- |
| `<leader>e` | Find files |
