#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\e[0;33m'
NC='\033[0m'

OK_MSG="[ ${GREEN}DONE${NC} ]  "
ERR_MSG="[ ${RED}FAIL${NC} ]  "
WARN_MSG="[ ${YELLOW}WARN${NC} ]  "
INFO_MSG="[ INFO ]  "

VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
VIM_PLUG_PATH="${HOME}/.local/share/nvim/site/autoload"

CONFIG_DIR=~/.config/nvim
CONFIG_FILE="${CONFIG_DIR}/init.vim"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"


install_package() {
    PACKAGE=$1
    COMMAND_FOR_CHECK=$2
    
    if command -v $COMMAND_FOR_CHECK &> /dev/null; then
        echo none &> /dev/null
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y $PACKAGE > /dev/null 2>&1
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y $PACKAGE > /dev/null 2>&1
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm $PACKAGE > /dev/null 2>&1
    else
        echo -en $ERR_MSG
        echo -e "Package manager not supported!"
        exit 1
    fi

    if command -v $COMMAND_FOR_CHECK &> /dev/null; then
        echo -e "${OK_MSG}${PACKAGE}" 
    else
        echo -e "${ERR_MSG}${PACKAGE} (can't perform command $COMMAND_FOR_CHECK)"
    fi
}

if [ ! -f $SCRIPT_DIR/init.vim ]; then
  echo -en $ERR_MSG
  echo -e "Can't find init.vim file in the current dir. Make sure that you're in the script dir."
  exit 1
fi

if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
elif [ -f $CONFIG_FILE ]; then
  cp $CONFIG_FILE $CONFIG_DIR/init.vim.old
  echo -e "${WARN_MSG}Previous init.vim was copied to init.vim.old."
fi

echo -e "${INFO_MSG}Cheking packages: neovim, nodejs, clang, vim-plug"
install_package neovim nvim
install_package nodejs node
install_package clang clang-format

if [ ! -d $VIM_PLUG_PATH ]; then
  rm -rf $VIM_PlUG_PATH
fi
mkdir -p $VIM_PLUG_PATH;
curl -so $VIM_PLUG_PATH/plug.vim $VIM_PLUG_URL
echo -e "${OK_MSG}vim-plug"

echo -e "${INFO_MSG}Installing neovim plugins"
cp $SCRIPT_DIR/init.vim $CONFIG_DIR/init.vim
nvim --headless +PlugInstall +qall &> /dev/null
nvim --headless +"CocInstall -sync coc-clangd" +qall &> /dev/null
nvim --headless +"CocCommand clangd.install" +qall &> /dev/null
echo -e "${OK_MSG}neovim plugins"

echo -e "${INFO_MSG}Neovim setup finised!"
