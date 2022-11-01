#!/bin/bash

username="nossal"
packages=(
        "util-linux-core"
        "which"
        "fzf"
        "fd"
        "exa"
        "ripgrep"
        "bat"
        "passwd"
        "cracklib-dicts"
        "util-linux-user"
        "zsh"
        "git"
        "tig"
        "nvim"
        "tmux"
        "dnf-plugins-core"
        "dnf-plugin-system-upgrade"
        "containerd")

"shadow-utils"

sudo dnf reinstall -y shadow-utils
sudo dnf install -y procps-ng iputils
sudo sysctl -w net.ipv4.ping_group_range="0 2000"

sudo dnf group install "C Development Tools and Libraries"


curl -sS https://starship.rs/install.sh | sh
cargo install starship --locked
eval "$(starship init zsh)"


"curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

printf "\n[user]\ndefault = $username\n" | sudo tee -a /etc/wsl.conf



useradd -G wheel $username
