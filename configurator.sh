#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

create_symlink() {
    local source_file=$1
    local target_file=$2
    mkdir -p "$(dirname "$target_file")"
    ln -sf "$source_file" "$target_file"
    echo "Linked: $source_file -> $target_file"
}

copy_file() {
    local source_file=$1
    local target_file=$2
    mkdir -p "$(dirname "$target_file")"
    cp -f "$source_file" "$target_file"
    echo "Copied: $source_file -> $target_file"
}

remove_file() {
    local target_file=$1
    if [ -e "$target_file" ]; then
        rm -f "$target_file"
        echo "Removed: $target_path"
    fi
}

show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    printf "%-12s %s\n" "Options:"
    printf "  %-10s %-5s %s\n" "--copy" "-c" "Copy files from script directory to target locations."
    printf "  %-10s %-5s %s\n" "--symlink" "-s" "Create symlinks from script directory to target locations."
    printf "  %-10s %-5s %s\n" "--remove" "-r" "Remove target files."
    printf "  %-10s %-5s %s\n" "--help" "-h" "Display this help message."
    echo ""
    printf "%-12s %s\n" "Environment:"
    printf "  %-16s %s\n" "XDG_CONFIG_HOME" "Base directory for user-specific configuration files."
    printf "  %-16s %s\n" "" "Defaults to ~/.config if not set."
    echo ""
    echo "Files processed:"
    for source in "${!files_to_process[@]}"; do
        printf "  %-30s -> %s\n" "$source" "${files_to_process[$source]}"
    done
}

declare -A files_to_process=(
    ["alacritty/alacritty.toml"]="$CONFIG_HOME/alacritty/alacritty.toml"
    ["fastfetch/arch_logo.txt"]="$CONFIG_HOME/fastfetch/arch_logo.txt"
    ["fastfetch/greeting.jsonc"]="$CONFIG_HOME/fastfetch/greeting.jsonc"
    ["nvim/init.vim"]="$CONFIG_HOME/nvim/init.vim"
    ["qutebrowser/config.py"]="$CONFIG_HOME/qutebrowser/config.py"
    ["bash/bashrc"]="$HOME/.bashrc"
    ["other/xinitrc"]="$HOME/.xinitrc"
    ["vim/vimrc"]="$HOME/.vimrc"
    ["zsh/zshenv"]="$HOME/.zshenv"
    ["zsh/aliases.zsh"]="$CONFIG_HOME/zsh/aliases.zsh"
    ["zsh/completion.zsh"]="$CONFIG_HOME/zsh/completion.zsh"
    ["zsh/promt.zsh"]="$CONFIG_HOME/zsh/promt.zsh"
    ["zsh/zshrc"]="$CONFIG_HOME/zsh/.zshrc"
    ["zsh/zprofile"]="$CONFIG_HOME/zsh/.zprofile"
    ["lf/lfrc"]="$CONFIG_HOME/lf/lfrc"
)

if [[ $# -ne 1 ]]; then
    echo "Invalid number of arguments."
    echo "Use $0 --help for more information."
    exit 1
elif [[ $1 == "--help" || $1 == "-h" ]]; then
    show_help
    exit 0
elif [[ $1 == "--copy" || $1 == "-c" ]]; then
    action="copy"
elif [[ $1 == "--symlink" || $1 == "-s" ]]; then
    action="symlink"
elif [[ $1 == "--remove" || $1 == "-r" ]]; then
    action="remove"
else
    echo "Invalid option: $1"
    echo "Use $0 --help for more information."
    exit 1
fi

for source in "${!files_to_process[@]}"; do
    source_path="$SCRIPT_DIR/$source"
    target_path="${files_to_process[$source]}"

    if [[ $action == "copy" ]]; then
        copy_file "$source_path" "$target_path"
    elif [[ $action == "symlink" ]]; then
        create_symlink "$source_path" "$target_path"
    elif [[ $action == "remove" ]]; then
        remove_file "$target_path"
    fi
done
