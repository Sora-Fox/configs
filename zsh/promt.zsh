git_prompt_status() {
  local CYAN="%F{cyan}"
  local SAND="%F{183}"
  local YELLOW="%F{220}"
  local RESET="%f"
  local SEPARATOR="%F{white} • ${RESET}"

  local git_info=""
  local branch=$(git branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
      local modified=$(git diff --name-only                      2>/dev/null | wc -l)
      local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
      local staged=$(git diff --cached --name-only               2>/dev/null | wc -l)
      local to_push=$(git log origin/$branch..$branch --oneline  2>/dev/null | wc -l)

      git_info+=${CYAN}$branch${RESET}
      ((untracked > 0)) && git_info+="${SEPARATOR}${YELLOW}U~${untracked}${RESET}"
      ((modified > 0))  && git_info+="${SEPARATOR}${ORANGE}M~${modified}${RESET}"
      ((staged > 0))    && git_info+="${SEPARATOR}${SAND}S~${staged}${RESET}"
      ((to_push > 0))   && git_info+="${SEPARATOR}${SAND}P~${to_push}${RESET}"
  fi
  echo "$git_info"
}

custom_prompt() {
  local RED="%F{red}"
  local GREEN="%F{green}"
  local BROWN="%F{yellow}"
  local RESET="%f"
  local SEPARATOR="${LIGHT_GRAY} • ${RESET}"

  PROMPT=${RED}%n${RESET}
  PROMPT+=${SEPARATOR}
  PROMPT+=${BROWN}%~${RESET}
  PROMPT+=$'\n'
  PROMPT+="${GREEN}>${RESET} "
  RPROMPT=$(git_prompt_status)
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd custom_prompt

