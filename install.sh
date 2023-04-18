#!/bin/bash

dotfiles=~/dotfiles
if [ -d "$dotfiles" ]; then
	cd $dotfiles && git pull
else
	git clone git@github.com:muei/dotfiles.git ~/dotfiles
fi

items=("nvim")
for item in "${items[@]}"; do
	echo $item
	ln -s $dotfiles/config/$item ~/.config/$item
done
