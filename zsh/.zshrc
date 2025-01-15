# .zshrc

# https://github.com/zsh-users/zsh-completions
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)
fpath=($ZDOTDIR/plugins $fpath)

source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/promt.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

setopt HIST_SAVE_NO_DUPS

bindkey -e

fastfetch --config $XDG_CONFIG_HOME/fastfetch/greeting.jsonc
