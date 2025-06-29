#!/bin/bash

DOTFILES="$(pwd)"  

get_next_backup_name() {
    local path="$1"
    local backupPath="${path}.bak"

    
    while [ -e "$backupPath" ]; do
        backupPath="${backupPath}.bak"
    done

    echo "$backupPath"
}

create_symlink() {
    local target="$1"
    local linkPath="$2"

    if [ -e "$linkPath" ] || [ -L "$linkPath" ]; then
        local backupPath
        backupPath=$(get_next_backup_name "$linkPath")
        echo "[$(date '+%H:%M:%S')] Moving existing: $linkPath → $backupPath"
        mv -f "$linkPath" "$backupPath"
    fi

    echo "[$(date '+%H:%M:%S')] Creating symlink: $linkPath → $target"
    ln -s "$target" "$linkPath"
}

execute_install_script() {
    local dir="$1"
    if [ ! -d $dir ]; then
        echo "tried installing $dir install script but directory doesnt exist" >&2
        return
    fi
    local file="$dir/install.sh"
    if [ ! -f $file ]; then
        echo "no install file found in folder $dir" >&2
        return
    fi
    chmod +x $file
    $file
}

create_symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES/kitty" "$HOME/.config/kitty"
execute_install_script "$DOTFILES/kitty"
