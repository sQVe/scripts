#!/usr/bin/env bash

# ┏━┓╺┳╸┏━┓╺┳╸╻ ╻┏━┓╻  ╻┏┓╻┏━╸
# ┗━┓ ┃ ┣━┫ ┃ ┃ ┃┗━┓┃  ┃┃┗┫┣╸
# ┗━┛ ╹ ╹ ╹ ╹ ┗━┛┗━┛┗━╸╹╹ ╹┗━╸
# Claude Code status line showing cwd and git status.

set -euo pipefail

readonly DEFAULT_WIDTH=200
readonly MIN_WIDTH=60
readonly WIDTH_RESERVE=40

readonly BLUE='\033[38;2;40;80;168m'
readonly GREEN='\033[38;2;40;112;40m'
readonly YELLOW='\033[38;2;128;96;16m'
readonly PEACH='\033[38;2;168;88;32m'
readonly MAUVE='\033[38;2;124;50;168m'
readonly RESET='\033[0m'

branch=""
ahead=0 behind=0 staged=0 unstaged=0 untracked=0
git_indicators=""
display_path=""
show_branch=""

get_terminal_width() {
  local width tty pid

  pid=${PPID}
  while [[ -n "${pid}" && "${pid}" != "1" && "${pid}" != "0" ]]; do
    tty=$(readlink "/proc/${pid}/fd/0" 2> /dev/null)
    if [[ "${tty}" == /dev/pts/* || "${tty}" == /dev/tty* ]]; then
      width=$(stty size < "${tty}" 2> /dev/null | awk '{print $2}')
      [[ -n "${width}" && "${width}" -gt 0 ]] && echo "${width}" && return
    fi
    pid=$(ps -o ppid= -p "${pid}" 2> /dev/null | tr -d ' ')
  done

  width=$(tput cols 2> /dev/null)
  [[ -n "${width}" && "${width}" -gt 0 ]] && echo "${width}" && return

  echo "${DEFAULT_WIDTH}"
}

fish_path() {
  local path=$1
  [[ "${path}" == "/" ]] && printf '/' && return
  path="${path/#${HOME}/\~}"

  local IFS='/'
  local -a segments
  read -ra segments <<< "${path}"

  local result="" last_idx=$((${#segments[@]} - 1))
  for i in "${!segments[@]}"; do
    local seg="${segments[i]}"
    [[ -z "${seg}" ]] && continue
    [[ -n "${result}" ]] && result+="/"

    if ((i == last_idx)); then
      result+="${seg}"
    elif [[ "${seg}" == .* ]]; then
      result+="${seg:0:2}"
    else
      result+="${seg:0:1}"
    fi
  done

  [[ "${path}" == /* ]] && result="/${result}"
  [[ "${path}" == "~"* ]] && result="~${result#\~}"

  printf '%s' "${result}"
}

truncate() {
  local text=$1 max=$2
  if ((max <= 0)); then
    printf ''
  elif ((max == 1)); then
    printf '…'
  elif ((${#text} > max)); then
    printf '%s…' "${text:0:max-1}"
  else
    printf '%s' "${text}"
  fi
}

get_git_info() {
  local dir=$1

  branch=""
  ahead=0 behind=0 staged=0 unstaged=0 untracked=0
  git_indicators=""

  [[ $(git -C "${dir}" rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]] || return

  branch=$(git -C "${dir}" branch --show-current 2> /dev/null)
  [[ -z "${branch}" ]] && branch="detached"

  # shellcheck disable=SC1083
  read -r behind ahead < <(
    GIT_TERMINAL_PROMPT=0 git -C "${dir}" rev-list --left-right --count @{u}...HEAD 2> /dev/null
  ) || {
    behind=0
    ahead=0
  }

  local status
  status=$(git -C "${dir}" status --porcelain 2> /dev/null)
  [[ -z "${status}" ]] && return
  staged=$(grep -c '^[MADRC]' <<< "${status}" 2> /dev/null) || staged=0
  unstaged=$(grep -c '^.[MADRC]' <<< "${status}" 2> /dev/null) || unstaged=0
  untracked=$(grep -c '^??' <<< "${status}" 2> /dev/null) || untracked=0

  ((ahead)) && git_indicators+=" >${ahead}"
  ((behind)) && git_indicators+=" <${behind}"
  ((staged)) && git_indicators+=" +${staged}"
  ((unstaged)) && git_indicators+=" !${unstaged}"
  ((untracked)) && git_indicators+=" ?${untracked}"
  :
}

choose_display_path() {
  local full_path=$1 fish_path=$2 max_width=$3 branch_len=$4 git_len=$5

  local sep_len=0
  ((branch_len > 0)) && sep_len=1
  local space_for_path=$((max_width - branch_len - git_len - sep_len))

  if ((${#full_path} <= space_for_path)); then
    display_path="${full_path}"
    show_branch="true"
    return
  elif ((${#fish_path} <= space_for_path)); then
    display_path="${fish_path}"
    show_branch="true"
    return
  fi

  local space_without_branch=$((max_width - git_len))
  show_branch="false"

  if ((${#full_path} <= space_without_branch)); then
    display_path="${full_path}"
  elif ((${#fish_path} <= space_without_branch)); then
    display_path="${fish_path}"
  else
    display_path=$(truncate "${fish_path}" "${space_without_branch}")
  fi
}

format_output() {
  local path=$1 show_branch=$2

  local output="${BLUE}${path}${RESET}"

  if [[ "${show_branch}" == "true" && -n "${branch}" ]]; then
    output+=" ${GREEN}${branch}${RESET}"
  fi

  ((ahead)) && output+=" ${GREEN}>${ahead}${RESET}"
  ((behind)) && output+=" ${GREEN}<${behind}${RESET}"
  ((staged)) && output+=" ${YELLOW}+${staged}${RESET}"
  ((unstaged)) && output+=" ${PEACH}!${unstaged}${RESET}"
  ((untracked)) && output+=" ${MAUVE}?${untracked}${RESET}"
  :

  printf '%b' "${output}"
}

main() {
  local cwd
  cwd=$(jq -r '.workspace.current_dir // empty') || exit 1
  [[ -z "${cwd}" ]] && exit 1

  local terminal_width max_width
  terminal_width=$(get_terminal_width)
  max_width=$((terminal_width - WIDTH_RESERVE))
  ((max_width < MIN_WIDTH)) && max_width=${MIN_WIDTH}

  [[ "${STATUSLINE_DEBUG:-}" == "1" ]] && printf "[w:%d] " "${terminal_width}"

  local full_path fish_path_str
  full_path="${cwd/#${HOME}/\~}"
  fish_path_str=$(fish_path "${cwd}")

  get_git_info "${cwd}"

  choose_display_path "${full_path}" "${fish_path_str}" "${max_width}" "${#branch}" "${#git_indicators}"

  format_output "${display_path}" "${show_branch}"
}

main
