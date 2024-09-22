#!/bin/bash
set -e
    
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
  case $PACKAGE_MANAGER in
    apt)
      sudo apt update && sudo apt install -y $PACKAGE
      ;;
    dnf)
      sudo dnf install -y $PACKAGE
      ;;
    pacman)
      sudo pacman -Sy --noconfirm $PACKAGE
      ;;
  esac
}

CONFIG_DIR=~/.config/nvim
if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
elif [ -f $CONFIG_DIR/init.vim ]; then
    echo "Remove ~/.config/nvim/init.vim and try again"
    exit 1
fi

if ! command -v nvim &> /dev/null; then
    echo "Installing neovim..."
    install_package "neovim"
fi

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  echo "Installing vim-plug..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > dev/null
else
  echo "vim-plug already installed"
fi

# Node.js for coc.nvim
if ! command -v node &> /dev/null; then
  echo "Installing Node.js..."
  # Node Version Manager
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 22 > dev/null
else
  echo "Node.js already installed"
fi

if ! command -v clang-format &> /dev/null; then
  echo "Installing clang-format..."
  #install_package "clang-format" > dev/null
else
  echo "clang-format already installed"
fi

if command -v nvim &> /dev/null && command -v node &> /dev/null; then
  echo "All dependeces are installed"
else
    echo "Some issue during dependeces instalation"
    exit 1
fi

echo "Copying ./init.vim to ~/.config/nvim/init.vim"
cp ./init.vim $CONFIG_DIR/init.vim

echo "Installing Neovim plugins..."
nvim --headless +PlugInstall +qall > /dev/null

echo "Installing coc-clangd extension..."
nvim --headless +"CocInstall -sync coc-clangd" +qall > /dev/null

echo "Setup finised"
