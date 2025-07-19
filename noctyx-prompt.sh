#!/bin/bash
# Noctyx Hacker Prompt - Personalized Version
# License: MIT

# ======================
#  USER CONFIGURATION
# ======================
[ -z "$NOCTYX_NICKNAME" ] && export NOCTYX_NICKNAME="NIGHTWALKER"  # Default nickname

# ======================
#  COLOR DEFINITIONS
# ======================
NOCTYX_COLOR="\[\e[1;38;5;99m\]"    # Purple
ROOT_COLOR="\[\e[1;38;5;196m\]"     # Red 
DIR_COLOR="\[\e[1;38;5;226m\]"      # Yellow
GIT_COLOR="\[\e[1;38;5;51m\]"       # Cyan
PROMPT_COLOR="\[\e[1;34m\]"         # Blue
RESET="\[\e[0m\]"

# ======================
#  CORE FUNCTIONS
# ======================
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

get_threat_level() {
  local rand=$((RANDOM % 6))
  case $rand in
    0) echo "\[\e[1;32m\]■ SAFE${RESET}";;
    1) echo "\[\e[1;36m\]● SCANNING${RESET}";;
    2) echo "\[\e[1;33m\]▲ WARNING${RESET}";;
    3) echo "\[\e[1;31m\]! DANGER${RESET}";;
    4) echo "\[\e[5;31m\]‼ INTRUSION${RESET}";;
    5) echo "\[\e[1;35m\]✧ STEALTH${RESET}";;
  esac
}

__noctyx_prompt() {
  local EXIT="$?"
  
  # Status indicator
  if [ $EXIT -eq 0 ]; then
    STATUS="\[\e[1;32m\]✔${RESET}"
  else
    STATUS="\[\e[1;31m\]✘ \[\e[0;31m\][$EXIT]${RESET}"
  fi

  # User/Root detection
  if [ "$(id -u)" -eq 0 ]; then
    USER_PROMPT="${ROOT_COLOR}☠ ROOT${RESET}"
  else
    USER_PROMPT="${NOCTYX_COLOR}☠ ${NOCTYX_NICKNAME}${RESET}"
  fi

  # Git branch and threat level
  local GIT_BRANCH=$(parse_git_branch)
  [ -n "$GIT_BRANCH" ] && GIT="${GIT_COLOR}${GIT_BRANCH}${RESET}" || GIT=""
  local THREAT=$(get_threat_level)

  # Build prompt
  PS1="${PROMPT_COLOR}┌─[${RESET} ${USER_PROMPT} ${PROMPT_COLOR}]─[${DIR_COLOR}\w${PROMPT_COLOR}]${GIT}─[ ${THREAT} ${PROMPT_COLOR}]\n└─▶ ${RESET}"
}

PROMPT_COMMAND=__noctyx_prompt
