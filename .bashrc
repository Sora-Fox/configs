# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
export EDITOR=nvim

# no history but current session
history -c && history -w

alias gst="git status"
alias gs="git status -sb"
alias glg="git log"
alias gad="git add"
alias gaa="git add -A"
alias gdf="git diff"
alias gcm="git commit"
alias gca="git commit -a"
alias gph="git push"
alias gpo="git push origin"

alias ping='ping -c 2'
alias mkdir='mkdir -p'
alias cls='clear'
alias ll='ls -A | sort | ls -Alh'
alias ls='ls -1'
alias l='ls -aFh --color=always'
alias cpy='wl-copy'

alias ..='cd ..'
alias ...='cd ../..'
alias dow='cd ~/Downloads'
alias doc='cd ~/Documents'

alias edb='${EDITOR} ~/.bashrc'
alias evirc='${EDITOR} ~/.config/nvim/init.vim'
alias eclangf='${EDITOR} ~/.clang-format'
alias ed='${EDITOR}'
alias sed='sudo ${EDITOR}'
alias sour='source ~/.bashrc'

alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done"

function __prompt {
    local LIGHTGRAY="\033[0;37m"
    local WHITE="\033[1;37m"
    local BLACK="\033[0;30m"
    local DARKGRAY="\033[1;30m"
    local RED="\033[0;31m"
    local LIGHTRED="\033[1;31m"
    local GREEN="\033[0;32m"
    local LIGHTGREEN="\033[1;32m"
    local BROWN="\033[0;33m"
    local YELLOW="\033[1;33m"
    local BLUE="\033[0;34m"
    local LIGHTBLUE="\033[1;34m"
    local MAGENTA="\033[0;35m"
    local LIGHTMAGENTA="\033[1;35m"
    local CYAN="\033[0;36m"
    local LIGHTCYAN="\033[1;36m"
    local NOCOLOR="\033[0m"

    local SEPARATOR="\[${LIGHTGRAY}\] ॰ "

    local LAST_COMMAND=$? # Status of the last command
    # Show error exit code if there is one
    if [[ $LAST_COMMAND != 0 ]]; then
        case $LAST_COMMAND in
            1) error_msg="General error" ;;
            2) error_msg="Missing keyword, command, or permission problem" ;;
            126) error_msg="Permission problem or command is not executable" ;;
            127) error_msg="Command not found" ;;
            128) error_msg="Invalid argument to exit" ;;
            130) error_msg="Script terminated by Control\-C" ;;
            137) error_msg="Killed \(signal 9\)" ;;
            *) error_msg="Unknown error code: $LAST_COMMAND" ;;
        esac
            PS1="\[${RED}\]ERROR: $error_msg\[${NOCOLOR}\]\n"
    else
        PS1=""
    fi

    # User and server
    local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
    local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
    if [ $SSH2_IP ] || [ $SSH_IP ] ; then
        PS1+="\[${RED}\]\u@\h"
    else
        PS1+="\[${RED}\]\u"
        #PS1+=" "
    fi
    # Current directory
    PS1+=$SEPARATOR
	PS1+="\[${BROWN}\]\w"

    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    modified_files=$(git diff --name-only 2>/dev/null | wc -l)
    untracked_files=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
    staged_files=$(git diff --cached --name-only 2>/dev/null | wc -l)
    max_length=20
    if [ ${#current_branch} -gt $max_length ]; then
        current_branch="${current_branch:0:$max_length}…"
    fi
    if [ -n "$current_branch" ]; then
        PS1+=$SEPARATOR
        PS1+="\[${CYAN}\]$current_branch"
    fi; if [ "$untracked_files" -ne 0 ]; then
        PS1+=$SEPARATOR
        PS1+="\[${BROWN}\]U~${untracked_files}\e[0m"
    fi; if [ "$modified_files" -ne 0 ]; then
        PS1+=$SEPARATOR
        PS1+="\[${MAGENTA}\]M~${modified_files}\e[0m"
    fi; if [ "$staged_files" -ne 0 ]; then
        PS1+=$SEPARATOR
        PS1+="\[${BLUE}\]S~${staged_files}\e[0m"
    fi

	if [[ $EUID -ne 0 ]]; then
		PS1+="\n\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
	else
        PS1+="\n\[${RED}\]➤ \[${NOCOLOR}\] "
	fi
}

PROMPT_COMMAND='__prompt'


