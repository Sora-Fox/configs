#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
INFO="[ INFO ]"
OK="[ ${GREEN}DONE${NC} ]"
WARN="[ ${YELLOW}WARN${NC} ]"
FAIL="[ ${RED}FAIL${NC} ]"

VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
NVIM_BIN_URL="https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz"
NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh"
VIM_PLUG_PATH="${HOME}/.local/share/nvim/site/autoload"
CONFIG_DIR="${HOME}/.config/nvim"
CONFIG_FILE="${CONFIG_DIR}/init.vim"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_package() {
    local package="$1" command="$2"
    if command -v "$command" &>/dev/null; then
        echo -e "${OK} $package is already installed."
        return
    fi
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y && sudo apt-get install -y "$package"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "$package"
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm "$package"
    else
        echo -e "${FAIL} Unknown package manager."
        exit 1
    fi
    if command -v "$command" &>/dev/null; then
        echo -e "${OK} $package installed"
    else
        echo -e "${FAIL} $package: can't perform $command"
    fi
}

install_neovim() {
    echo -e "${INFO} Installing Neovim from github..."
    curl -Lso "${SCRIPT_DIR}/nvim.tar.gz" "$NVIM_BIN_URL"
    tar -xf "${SCRIPT_DIR}/nvim.tar.gz" -C "$SCRIPT_DIR"
    sudo cp "${SCRIPT_DIR}/nvim-linux64/bin/nvim" /usr/local/bin/
    sudo cp -r "${SCRIPT_DIR}/nvim-linux64/share/nvim" /usr/local/share
    rm -rf "${SCRIPT_DIR}/nvim-linux64" "${SCRIPT_DIR}/nvim.tar.gz"
    if command -v nvim &> /dev/null; then
        echo -e "${OK} Neovim installed from github"
    else
        echo -e "${FAIL} Neovim"
    fi
}

install_node() {
    curl -so- ${NVM_URL} | bash &>/dev/null
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install 22 &>/dev/null
    if command -v node &> /dev/null; then
        echo -e "${OK} Node.js installed via nvm"
    else
        echo -e "${FAIL} Node.js"
    fi
}

install_vim_plug() {
    if [[ -f "$VIM_PLUG_PATH/plug.vim" ]]; then
        echo -e "${WARN} Existing vim-plug found. Reinstalling..."
        rm -f "$VIM_PLUG_PATH/plug.vim"
    else
        echo -e "${INFO} Installing vim-plug..."
    fi
    mkdir -p "$VIM_PLUG_PATH"
    curl -so "$VIM_PLUG_PATH/plug.vim" "$VIM_PLUG_URL"
    echo -e "${OK} vim-plug installed"
}

configure_neovim() {
    if [[ -f "$CONFIG_FILE" ]]; then
        local backup_file="${SCRIPT_DIR}/init.vim.backup.$(date +%s)"
        mv "$CONFIG_FILE" "$backup_file"
        echo -e "${WARN} Existing Neovim config backed up to $backup_file."
    fi
    if [[ -f "${SCRIPT_DIR}/init.vim" ]]; then
        mkdir -p "$CONFIG_DIR"
        cp "${SCRIPT_DIR}/init.vim" "$CONFIG_FILE"
        echo -e "${OK} Configuration copied to $CONFIG_FILE."
    else
        echo -e "${FAIL} init.vim not found in script directory."
        exit 1
    fi
}

install_plugins() {
    echo -e "${INFO} Installing plugins..."
    if ! nvim --headless +PlugInstall +qall &>/dev/null; then
        echo -e "${FAIL} Failed to install plugins with vim-plug."
        exit 1
    fi
    if ! nvim --headless +"CocInstall -sync coc-clangd" +qall &>/dev/null; then
        echo -e "${WARN} Failed to install coc-clangd plugin."
    fi
    echo -e "${OK} Plugins installed."
}

main() {
    echo -e "\e[34m===== NEOVIM SETUP SCRIPT =====\e[0m"
    echo -e "Choose installation method:\n0 - Package Manager (default)\n1 - From Source\nq - Quit"
    read -r -p "Your choice: " choice

    while true ; do
        if [ -z "$choice" ]; then
            choice=0
        fi
        case $choice in
            0) install_package neovim nvim; install_package nodejs node; install_package clang clang-format; break ;;
            1) install_neovim; install_node; break ;;
            q) exit 0 ;;
            *) echo "Invalid choice"; read -r -p "Your choice: " choice ;;
        esac
    done 
    install_vim_plug
    configure_neovim
    install_plugins
    echo -e "${OK} Installation completed."
}

main
