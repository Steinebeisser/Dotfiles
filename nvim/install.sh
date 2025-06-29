#!/bin/bash

update_system() {
    echo "Updating system for neovim installation..."
    sudo pacman -Syu --noconfirm > /dev/null || { echo "Failed to update system"; exit 1; }
    echo ""
}

check_command() {
    local command_name=$1
    command -v "$command_name" &>/dev/null
}

install_package_if_needed() {
    local package_name=$1
    local command_name=$2
    echo "Checking if $package_name is installed..."

    if ! check_command "$command_name"; then
        echo "    $package_name not found. Installing..."
        sudo pacman -S --noconfirm "$package_name" || { echo "Failed to install $package_name"; exit 1; }
    else
        echo "    $package_name is already installed."
    fi
    echo ""
}

install_clipboard_manager() {
    echo "Installing clipboard manager (wl-clipboard)..."
    install_package_if_needed "wl-clipboard" "wl-copy"
}

install_dotnet_sdk() {
    echo "Checking installed .NET SDKs..."
    installed_sdks=$(dotnet --list-sdks 2>/dev/null)

    if [[ "$installed_sdks" == *"8.0"* ]]; then
        echo "    .NET 8.0 SDK is already installed."
    else
        echo "    .NET 8.0 SDK is not installed. Installing..."
        sudo pacman -S --noconfirm dotnet-sdk-8.0 || { echo "Failed to install .NET 8.0 SDK"; exit 1; }
    fi

    if [[ "$installed_sdks" == *"9.0"* ]]; then
        echo "    .NET 9.0 SDK is already installed."
    else
        echo "    .NET 9.0 SDK is not installed. Installing..."
        sudo pacman -S --noconfirm dotnet-sdk-9.0 || { echo "Failed to install .NET 9.0 SDK"; exit 1; }
    fi
    echo ""
}

install_neovim() {
    echo "Installing Neovim..."
    install_package_if_needed "neovim" "nvim"
}

main() {
    update_system
    install_neovim
    install_clipboard_manager
    install_dotnet_sdk
    install_package_if_needed "fd" "fd"
    install_package_if_needed "ripgrep" "rg"
    install_package_if_needed "npm" "npm"
    
    echo "Neovim Setup complete!"
}

main
