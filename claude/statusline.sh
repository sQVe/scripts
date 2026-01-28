#!/usr/bin/env bash

# ┏━┓╺┳╸┏━┓╺┳╸╻ ╻┏━┓╻  ╻┏┓╻┏━╸
# ┗━┓ ┃ ┣━┫ ┃ ┃ ┃┗━┓┃  ┃┃┗┫┣╸
# ┗━┛ ╹ ╹ ╹ ╹ ┗━┛┗━┛┗━╸╹╹ ╹┗━╸
# Claude Code status line showing cwd and git status.

set -euo pipefail

cwd=$(jq -r '.workspace.current_dir // empty') || exit 1
[[ -z "${cwd}" ]] && exit 1

blue='\033[38;2;40;80;168m'
green='\033[38;2;40;112;40m'
yellow='\033[38;2;128;96;16m'
peach='\033[38;2;168;88;32m'
mauve='\033[38;2;124;50;168m'
reset='\033[0m'

output="${blue}${cwd}${reset}"

if [[ $(git -C "${cwd}" rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
  branch=$(git -C "${cwd}" branch --show-current 2> /dev/null)
  [[ -z "${branch}" ]] && branch="detached"

  # shellcheck disable=SC1083
  read -r behind ahead < <(GIT_TERMINAL_PROMPT=0 git -C "${cwd}" rev-list --left-right --count @{u}...HEAD 2> /dev/null) || {
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
  ((unstaged)) && output+=" ${peach}!${unstaged}${reset}"
  ((untracked)) && output+=" ${mauve}?${untracked}${reset}"
fi

printf "%b" "${output}"
