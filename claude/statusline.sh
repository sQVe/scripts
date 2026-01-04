#!/usr/bin/env bash

# ┏━┓╺┳╸┏━┓╺┳╸╻ ╻┏━┓╻  ╻┏┓╻┏━╸
# ┗━┓ ┃ ┣━┫ ┃ ┃ ┃┗━┓┃  ┃┃┗┫┣╸
# ┗━┛ ╹ ╹ ╹ ╹ ┗━┛┗━┛┗━╸╹╹ ╹┗━╸
# Claude Code status line showing cwd and git status.

set -euo pipefail

cwd=$(jq -r '.workspace.current_dir // empty') || exit 1
[[ -z "${cwd}" ]] && exit 1

cyan='\033[36m'
yellow='\033[33m'
magenta='\033[35m'
green='\033[32m'
reset='\033[0m'

output="${cyan}${cwd}${reset}"

if [[ $(git -C "${cwd}" rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
  branch=$(git -C "${cwd}" branch --show-current 2> /dev/null)
  [[ -z "${branch}" ]] && branch="detached"

  # shellcheck disable=SC1083
  read -r behind ahead < <(git -C "${cwd}" rev-list --left-right --count @{u}...HEAD 2> /dev/null) || {
    behind=0
    ahead=0
  }

  status=$(git -C "${cwd}" status --porcelain 2> /dev/null)
  staged=$(grep -c '^[MADRC]' <<< "${status}" 2> /dev/null) || staged=0
  unstaged=$(grep -c '^.[MADRC]' <<< "${status}" 2> /dev/null) || unstaged=0
  untracked=$(grep -c '^??' <<< "${status}" 2> /dev/null) || untracked=0

  output+=" ${green}${branch}${reset}"
  ((ahead)) && output+=" ${green}>${ahead}${reset}"
  ((behind)) && output+=" ${green}<${behind}${reset}"
  ((staged)) && output+=" ${yellow}+${staged}${reset}"
  ((unstaged)) && output+=" ${yellow}!${unstaged}${reset}"
  ((untracked)) && output+=" ${magenta}?${untracked}${reset}"
fi

printf "%b" "${output}"
