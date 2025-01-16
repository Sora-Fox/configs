#!/bin/bash

FAIL="\033[31mFAIL:\033[0m"
FINE="\033[32mFINE:\033[0m"
WARN="\033[33mWARN:\033[0m"

check_dependencies() {
    echo -en "\033[34mChecking for system dependencies...\033[0m"
    local dependencies=("$@")
    local all_found=true
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo -e "$WARN Dependency '$dep' is not installed or not in PATH."
            all_found=false
        fi
    done
    if [ "$all_found" = true ]; then
        echo -e " \033[32mDone\033[0m"
    fi
}

backup_if_exists() {
    local file_path="$1"
    local file_name="$(basename "$file_path")"
    if [ -f "$file_path" ]; then
        local backup_dir="$(dirname "$0")"
        local timestamp="$(date +%Y%m%d%H%M%S)"
        local backup_path="$backup_dir/$file_name.bak.$timestamp"
        echo -e "$WARN $file_name already exists. Creating backup at $backup_path"
        cp "$file_path" "$backup_path"
    fi
}

ask_user() {
    echo -en "\033[36m$1\033[0m (y/n): "
    read choice
    choice=${choice:-n}
    case "$choice" in
        y|Y ) return 0;;
        n|N ) return 1;;
        * ) echo -e "$FAIL Invalid choice. Please answer y or n."; ask_user "$1";;
    esac
}

echo -e "\033[34mPlease choose which configs to install.\033[0m"

if ask_user "Alacritty"; then
    check_dependencies "alacritty"
    mkdir -p "$HOME/.config/alacritty"
    backup_if_exists "$HOME/.config/alacritty/alacritty.toml"
    cp alacritty/alacritty.toml "$HOME/.config/alacritty/"
fi

if ask_user "Bash"; then
    check_dependencies "bash"
    backup_if_exists "$HOME/.bashrc"
    cp bash/.bashrc "$HOME/"
    echo -e "$FINE Bash config installed to $HOME/.bashrc."
fi

if ask_user "Fastfetch"; then
    check_dependencies "fastfetch"
    mkdir -p "$HOME/.config/fastfetch"
    for file in fastfetch/*; do
        backup_if_exists "$HOME/.config/fastfetch/$(basename "$file")"
        cp "$file" "$HOME/.config/fastfetch/"
    done
fi

if ask_user "Neovim"; then
    check_dependencies "nvim" "node"
    mkdir -p "$HOME/.config/nvim"
    backup_if_exists "$HOME/.config/nvim/init.vim"
    cp nvim/init.vim "$HOME/.config/nvim/"
fi

if ask_user "Qutebrowser"; then
    check_dependencies "qutebrowser"
    mkdir -p "$HOME/.config/qutebrowser"
    for file in qutebrowser/*; do
        backup_if_exists "$HOME/.config/qutebrowser/$(basename "$file")"
        cp "$file" "$HOME/.config/qutebrowser/"
    done
fi

if ask_user "Zsh"; then
    check_dependencies "zsh"
    backup_if_exists "$HOME/.zshenv"
    cp zsh/.zshenv "$HOME/"
    mkdir -p "$HOME/.config/zsh"
    for file in zsh/*; do
        backup_if_exists "$HOME/.config/zsh/$(basename "$file")"
        cp "$file" "$HOME/.config/zsh/"
    done
    cp zsh/.zshrc "$HOME/.config/zsh"
fi

echo -e "\033[34mAll selected configurations have been installed.\033[0m"
