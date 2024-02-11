#!/bin/bash

declare -a dotfiles=(
    ".zshrc"
    ".local/bin"   
    ".config/alacritty"
    ".config/hypr"
    ".config/lf"
    ".config/dunst"
    ".config/cava"
    ".config/gtk-3.0"
    ".config/waybar"
)

dotfilesPath="$HOME/Dev/dotfiles"

cp -f "$HOME/Pictures/bg/wall.png" "$dotfilesPath/wallpaper"

for f in "${dotfiles[@]}"; do
	rm -rf "${dotfilesPath}/${f}"
	mkdir -p "$(dirname "${dotfilesPath}/${f}")" && cp -r "$HOME/${f}" "${dotfilesPath}/${f}"
done

yay -Qeqa > "$dotfilesPath/pkglist.txt"