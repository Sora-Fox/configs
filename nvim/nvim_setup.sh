#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
NODE_VERSION=22
OK_MSG="\t[ ${GREEN}OK${NC} ]"

detect_package_manager() {
  if command -v apt &> /dev/null; then
    echo "apt"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  elif command -v pacman &> /dev/null; then
    echo "pacman"
  else
    echo "Unknown package manager (expected apt/dnf/pacman)"
    exit 1
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)

install_package() {
  PACKAGE=$1
  echo -n "Installing: $PACKAGE"
  case $PACKAGE_MANAGER in
    apt)
      sudo apt update -qq && sudo apt install -y $PACKAGE &> /dev/null
      ;;
    dnf)
      sudo dnf install -y $PACKAGE &> /dev/null
      ;;
    pacman)
      sudo pacman -Sy --noconfirm $PACKAGE &> /dev/null
      ;;
  esac
  echo -e $OK_MSG 
}

CONFIG_DIR=~/.config/nvim
if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
elif [ -f $CONFIG_DIR/init.vim ]; then
  echo -e "${RED}Remove ~/.config/nvim/init.vim and try again${NC}"
  exit 1
fi

sudo echo none &> /dev/null

if ! command -v nvim &> /dev/null; then
    install_package "neovim"
fi

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  echo -n "Installing: vim-plug"
  curl -s -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo -e $OK_MSG 
fi

if ! command -v node &> /dev/null; then
  echo -n "Installing: nvm"
  curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash &> /dev/null
  export NVM_DIR="$HOME/.nvm" &> /dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &> /dev/null
  echo -e $OK_MSG 


  echo -n "Installing: node$NODE_VERSION"
  nvm install $NODE_VERSION &> /dev/null
  nvm use $NODE_VERSION &> /dev/null
  echo -e $OK_MSG 
fi

if ! command -v clang-format &> /dev/null; then
  echo -n "Installing: clang-format"
  #install_package "clang-format"
  echo -e $OK_MSG 
fi

if ! command -v nvim &> /dev/null || ! command -v node &> /dev/null; then
    echo -e "${RED}Some issue during dependeces instalation. Try to restart terminal and run script again.${NC}"
    exit 1
fi

echo -n "Copying ./init.vim to ~/.config/nvim/init.vim"
cp ./init.vim $CONFIG_DIR/init.vim
echo -e $OK_MSG 

echo -n "Installing: plugins"
nvim --headless +PlugInstall +qall &> /dev/null
nvim --headless +"CocInstall -sync coc-clangd" +qall &> /dev/null
nvim --headless +"CocCommand clangd.install" +qall &> /dev/null
echo -e $OK_MSG 

echo -e "${GREEN}Setup finised${NC}"
