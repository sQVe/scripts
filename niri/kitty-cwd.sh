#!/usr/bin/env bash

#  ╻┏ ╻╺┳╸╺┳╸╻ ╻   ┏━╸╻ ╻╺┳┓
#  ┣┻┓┃ ┃  ┃ ┗┳┛╺━╸┃  ┃╻┃ ┃┃
#  ╹ ╹╹ ╹  ╹  ╹    ┗━╸┗┻┛╺┻┛
# Run a command at the focused kitty window's CWD.

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: kitty-cwd.sh <command> [args...]" >&2
  exit 1
fi

socket="${KITTY_LISTEN_ON:-$(find /tmp -maxdepth 1 -name "kitty-${USER}-*" 2> /dev/null | head -1)}"

if [[ -n "${socket}" ]]; then
  cwd=$(kitty @ --to "unix:${socket}" ls 2> /dev/null \
    | jq -r '.[] | .tabs[] | .windows[] | select(.is_focused) | .cwd' \
    | head -1)
fi

cd "${cwd:-${HOME}}" && "$@"
