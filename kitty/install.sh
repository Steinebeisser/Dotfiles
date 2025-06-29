#!/bin/bash

overwrite=0
pwd="$(dirname "$(realpath "$0")")"
source="$pwd/assets/kitty_bg.png"
dest="/usr/share/backgrounds/kitty_bg.png"

for arg in "$@"; do
    if [ "$arg" == "--overwrite" ]; then
        overwrite=1
    fi
done

if [ ! -f "$source" ]; then
    echo "Source image not found: $source"
    exit 1
fi

if [ -f "$dest" ]; then
    if [ $overwrite -eq 0 ]; then
        echo "[KITTY] [$pwd/$(basename "$0")] Add --overwrite to overwrite the current background image. "
        exit 1
    fi
else
    echo "Copying background to the shared backgrounds folder."
fi

sudo cp "$source" "$dest"
echo "Background image copied to $dest"

echo "Installing font"
if ! pacman -Qs "ttf-jetbrains-mono-nerd" | grep -q "ttf-jetbrains-mono-nerd"; then
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
    fc-cache -f -v
else 
    echo "Font already installed"
fi
