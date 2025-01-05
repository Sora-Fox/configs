# .zshenv

export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$XDG_CONFIG_HOME/local/share
export XDG_CACHE_HOME=$XDG_CONFIG_HOME/cache

export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export HISTFILE=$ZDOTDIR/.zhistory
export HISTSIZE=10000
export SAVEHIST=0

export EDITOR=nvim
export TERM=xterm-256color

export CXX=clang++
export CC=clang
export CXXFLAGS="-O2 -march=native -mtune=native -Wall -Wextra -Wpedantic -stdlib=libc++"
export CFLAGS="-O2 -Wall -Wextra -Wpedantic -march=native"

#unset WAYLAND_DISPLAY
#export DISPLAY=:0
#export GDK_BACKEND=x11
#export XDG_SESSION_TYPE=x11
