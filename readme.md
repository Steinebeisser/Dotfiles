# Dotfiles

---

This repo contains the setup for my linux machiens. \
Im using [Chezmoi](https://www.chezmoi.io) as my dotfile manager

Currently no automated script to install packages/setup everything, therefore here a list of needed packages

---

## packages

```
kitty
neovim
zsh
waybar
hyprland

maybe more
```

---

## How to run

```
chezmoi init --apply https://github.com/Steinebeisser/Dotfiles.git
```

After that rejoin or reboot for everything to apply correctly

---

## Specialties

### LSP

I myself work on nixos which is different from other distros with managing binaries, \
therefore Mason cant Install Lsps and they need to get installed via `Home Manager`

What does this mean for you?

You manually have to edit [lsp.lua](./dot_config/nvim/lua/plugins/lsp.lua) and uncomment masons autoinstall, and uncomment each lsp config that you dont want, also nix specific

and if you want to use Roslyn just edit [roslyn.lua](./dot_config/nvim/lua/plugins/roslyn.lua) and uncomment this part 
```lua
vim.lsp.config("roslyn", {
    cmd = {
        "dotnet",
        "/nix/store/din99b4x7v99w1cny76fpf90kw83s3kj-roslyn-ls-5.0.0-1.25312.6/lib/roslyn-ls/Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel=Information",
        "--extensionLogDirectory=/home/stein",
        "--stdio",
    },
}),
```
