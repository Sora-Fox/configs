# .bashrc

# Global configurations
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH
export EDITOR=nvim
export CXX=clang++

# Clear and save history
history -c && history -w
trap 'history -c' EXIT

# Git Aliases
alias gst="git status -sb"
alias gad="git add"
alias gaa="git add -A"
alias gcm="git commit"
alias gca="git commit -a"
alias gph="git push"
alias gpo="git push origin"
alias gbra="git branch -a"
alias gbr="git branch"
alias gsw="git switch"
alias glg="git log --graph --decorate --pretty=oneline --abbrev-commit"

# Utility Aliases
alias ping='ping -c 2'
alias mkdir='mkdir -p'
alias cls='clear'
alias ll='exa --header --long --group --git -Alh --sort=name'
alias l='exa -1'
alias ls='exa -Ah'
alias cpy='wl-copy'
alias cat='bat --style plain --paging never --theme OneHalfDark'
alias bat='bat --theme OneHalfDark'
alias ins='sudo dnf install'
alias upd='sudo dnf update'

# Navigation Aliases 
alias ..='cd ..'
alias ...='cd ../..'
alias dow='cd ~/Downloads'
alias doc='cd ~/Documents'

# Editor Aliases 
alias edb='${EDITOR} ~/.bashrc'
alias edvi='${EDITOR} ~/.config/nvim/init.vim'
alias edclangf='${EDITOR} ~/.clang-format'
alias edhy='${EDITOR} ~/.config/hypr/hyprland.conf'
alias edwb='${EDITOR} ~/.config/waybar/config.jsonc'
alias reswb='killall waybar; waybar &'
alias ed='${EDITOR}'
alias sed='sudo ${EDITOR}'
alias sour='source ~/.bashrc'

# Permissions Aliases 
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

function run {
    local target="temp_bin_$(date +%s)"
    local flags="-Wall -Wextra -O2"
    $CXX $flags -o $target *.cpp 
    ./$target $@
    rm -f ./$target
}

function gdf {
    git diff $@ | bat
}

function custom_prompt {
    local RED="\[\033[0;31m\]"
    local LIGHT_RED="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local BROWN="\[\033[0;33m\]"
    local CYAN="\[\033[0;36m\]"
    local LIGHT_GRAY="\[\033[0;37m\]"
    local RESET="\[\033[0m\]"
    local YELLOW="\[\033[38;5;220m\]"
    local ORANGE="\[\033[38;5;208m\]"
    local SAND="\[\033[38;5;183m\]"

    local SEPARATOR="${LIGHTGRAY} • ${RESET}"
    # Error Display
    if [[ $LAST_STATUS != 0 ]]; then
        case $LAST_STATUS in
            1) error_msg="Error" ;;
            126) error_msg="Permission denied" ;;
            #127) error_msg="Command not found" ;;
            130) error_msg="Terminated by Ctrl-C" ;;
            137) error_msg="Killed (signal 9)" ;;
            *) error_msg="Error code: $LAST_STATUS" ;;
        esac
        PS1="${RED}ERROR: $error_msg${RESET}\n"
    else
        PS1=""
    fi

    # User and Host Display for SSH
    PS1+="${RED}\u${RESET}"
    local SSH_IP="${SSH_CLIENT%% *}"
    if [[ -n "$SSH_IP" ]]; then
        PS1+="${RED}@\h${RESET}"
    fi

    PS1+="${SEPARATOR}${BROWN}\w${RESET}"

    # Git Information
    local branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        local modified=$(git diff --name-only | wc -l)
        local untracked=$(git ls-files --others --exclude-standard | wc -l)
        local staged=$(git diff --cached --name-only | wc -l)
        local to_push=$(git log origin/$branch..$branch --oneline | wc -l)

        PS1+=$SEPARATOR"${CYAN}$branch${RESET}"
        ((untracked > 0)) && PS1+="${SEPARATOR}${YELLOW}U~${untracked}${RESET}"
        ((modified > 0)) && PS1+="${SEPARATOR}${ORANGE}M~${modified}${RESET}"
        ((staged > 0)) && PS1+="${SEPARATOR}${SAND}S~${staged}${RESET}"
        ((to_push > 0)) && PS1+="${SEPARATOR}${SAND}P~${to_push}${RESET}"
    fi

    if [[ $EUID -ne 0 ]]; then
        PS1+="\n${GREEN}> ${RESET}"
    else
        PS1+="\n${RED}# ${RESET}"
    fi
}

function save_last_status {
    LAST_STATUS=$?
}

#command_not_found_handle() {
    #error_msg="Command not found"
#}

PROMPT_COMMAND='save_last_status; custom_prompt'

