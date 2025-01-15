# .zshenv

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$XDG_CONFIG_HOME/local/share
export XDG_CACHE_HOME=$XDG_CONFIG_HOME/cache

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export HISTFILE=$ZDOTDIR/.zhistory
export HISTSIZE=10000
export SAVEHIST=0

export CXX=clang++
export CC=clang
export COMMON_FLAGS="-O2 -pipe -march=native -Wall -Wextra"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

export TERM=xterm-256color
export EDITOR=nvim
