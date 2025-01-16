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
            echo -en "\n$WARN Dependency '$dep' is not installed or not in PATH."
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
        local backup_path="$backup_dir/$file_name$timestamp.bak"
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

install_config() {
    local source_dir=$1
    local target_dir=$2
    local dependencies=("${@:3}")

    check_dependencies ${dependencies[@]}
    mkdir -p $target_dir

    shopt -s dotglob
    for file in $source_dir/*; do
        local target_file=$target_dir/$(basename $file)
        backup_if_exists $target_file
    done
    echo -e "$FINE configs installed to $target_dir"
}

main() {
    echo -e "\033[34mPlease choose which configs to install.\033[0m"

    if ask_user "Alacritty"; then
        install_config "alacritty" "$HOME/.config/alacritty" "alacritty"
    fi

    if ask_user "Bash"; then
        install_config "bash" "$HOME" "bash" "eza" "bat"
    fi

    if ask_user "Fastfetch"; then
        install_config "fastfetch" "$HOME/.config/fastfetch" "fastfetch"
    fi

    if ask_user "Neovim"; then
        install_config "nvim" "$HOME/.config/nvim" "nvim" "node" "npm"
        if ! nvim --headless +PlugInstall +qall &>/dev/null; then
            echo -e "${FAIL} Failed to install plugins with vim-plug."
        else
            echo -e "$FINE Neovim plugins installed"
            if ! nvim --headless +"CocInstall -sync coc-clangd coc-cmake coc-spell-checker coc-nav coc-git coc-sh coc-snippets" +qall &>/dev/null; then
                echo -e "${FAIL} Failed to install coc extensions."
            else
                echo -e "$FINE CocNvim extensions installed"
            fi
        fi
    fi

    if ask_user "Qutebrowser"; then
        install_config "qutebrowser" "$HOME/.config/qutebrowser" "qutebrowser"
    fi

    if ask_user "Zsh"; then
        install_config "zsh" "$HOME/.config/zsh" "zsh" "eza" "bat" "btop" "rg" "fastfetch"
        rm "$HOME/.config/zsh/.zshenv"
        backup_if_exists "$HOME/.zshenv"
        cp "zsh/.zshenv" "$HOME/"
    fi

    echo -e "\033[34mAll selected configurations have been installed.\033[0m"
}

main
