# .bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH
export EDITOR=nvim
export CXX=clang++

history -c && history -w
trap 'history -c' EXIT

alias gad="git add"
alias gaa="git add -A"
alias gcm="git commit"
alias gca="git commit -a"
alias gcma="git commit --amend"
alias gcaa="git commit -a --amend"
alias gph="git push"
alias gpo="git push origin"
alias gpf="git push --force"
alias gplr="git pull -r"
alias gpln="git pull --no-rebase"
alias gre="git rebase"
alias gri="git rebase -i"
alias gbra="git branch -a"
alias gbr="git branch"
alias gsw="git switch"
alias gst="git status -sb"
alias glg="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias cmk="cmake -S . -B build"
alias cbld="cmake --build /build"
alias rebld="rm -rf build/ && cmake -S . -B build && cmake --build build/"

alias ping='ping -c 2'
alias md='mkdir -p'
alias rd='rmdir'
alias cls='clear'
alias ll='exa --header --long --group --git -Alh --sort=name'
alias l='exa -1'
alias ls='exa -Ah'
alias cpy='wl-copy'
alias cat='bat --style plain --paging never --theme OneHalfDark'
alias bat='bat --theme OneHalfDark'
alias ins='sudo dnf install'
alias upd='sudo dnf update'

alias ..='cd ..'
alias ...='cd ../..'
alias dow='cd ~/Downloads'
alias doc='cd ~/Documents'

alias edb='${EDITOR} ~/.bashrc'
alias edvi='${EDITOR} ~/.config/nvim/init.vim'
alias edclangf='${EDITOR} ~/.clang-format'
alias edhy='${EDITOR} ~/.config/hypr/hyprland.conf'
alias edwb='${EDITOR} ~/.config/waybar/config.jsonc'
alias edwbs='${EDITOR} ~/.config/waybar/style.css'
alias reswb='killall waybar && waybar &'
alias ed='${EDITOR}'
alias sour='source ~/.bashrc'

function run {
    local target="temp_bin_$(date +%s)"
    local flags="-Wall -Wextra -O2"
    $CXX $flags -o $target *.cpp 
    ./$target $@
    rm -f ./$target
}

function gdf {
    git diff $@ | bat -l C++
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

    PS1+="${RED}\u${RESET}"
    local SSH_IP="${SSH_CLIENT%% *}"
    if [[ -n "$SSH_IP" ]]; then
        PS1+="${RED}@\h${RESET}"
    fi
    PS1+="${SEPARATOR}${BROWN}\w${RESET}"

    local branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        local modified=$(git diff --name-only 2>/dev/null | wc -l)
        local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
        local staged=$(git diff --cached --name-only 2>/dev/null | wc -l)
        local to_push=$(git log origin/$branch..$branch --oneline 2>/dev/null | wc -l)

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

command_not_found_handle() {
    error_msg="Command not found"
}

PROMPT_COMMAND='save_last_status; custom_prompt'

