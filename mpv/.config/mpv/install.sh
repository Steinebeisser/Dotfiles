#!/bin/bash

QUIET=0

for arg in "$@"; do
    case $arg in
        --quiet)
            QUIET=1
            ;;
    esac
done

say() {
    if [ "$QUIET" -eq 0 ]; then
        echo "$@"
    fi
}

yell() {
    echo "ERROR [$@]" >&2
}

update_system() {
    say "Updating system..."
    sudo pacman -Syu --noconfirm > /dev/null || { yell "Failed to update system"; exit 1; }
    say ""
}

check_command() {
    local command_name=$1
    command -v "$command_name" &>/dev/null
}

install_package_if_needed() {
    local package_name=$1
    local command_name=$2
    say "Checking if $package_name is installed..."

    if ! check_command "$command_name"; then
        say "    $package_name not found. Installing..."
        sudo pacman -S --noconfirm "$package_name" || { yell "Failed to install $package_name"; exit 1; }
    else
        say "    $package_name is already installed."
    fi
    say ""
}

start_msg() {
    say "[MPV SCRIPT]"
    say "    Installing dependencies"
}

end_msg() {
    say "[MPV SCRIPT]"
    say "    Finished installing dependencies"
}

install_script() {
    local pwd="$(dirname "$(realpath "$0")")"

    say "[MPV SCRIPT]"
    say "    Moving mpv_yt_mix.sh to path"
    sudo cp "$pwd/mpv_yt_mix.sh" "/usr/bin/"
    sudo chmod +x "/usr/bin/mpv_yt_mix.sh"
    say "    Moved mpv_yt_mix.sh to path"
    say ""
}

main() {
    start_msg
    update_system
    install_package_if_needed "mpv" "mpv"
    install_package_if_needed "yt-dlp" "yt-dlp"
    install_script
    end_msg
}

main
