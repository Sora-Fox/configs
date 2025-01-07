# .zshenv

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$XDG_CONFIG_HOME/local/share
export XDG_CACHE_HOME=$XDG_CONFIG_HOME/cache

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export HISTFILE=$ZDOTDIR/.zhistory
export HISTSIZE=10000
export SAVEHIST=0

export EDITOR=nvim
bindkey -e

export CXX=clang++
export CC=clang
export CFLAGS="-O2 -march=corei7 -mtune=corei7 -pipe -Wall -Wextra -Wpedantic"
export CXXFLAGS="${CFLAGS}"

export TERM=xterm-256color

#unset WAYLAND_DISPLAY
#export DISPLAY=:0
#export GDK_BACKEND=x11
#export XDG_SESSION_TYPE=x11
