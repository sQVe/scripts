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
socket="${socket#unix:}"

cwd=""
if [[ -n "${socket}" ]]; then
  focused=$(kitty @ --to "unix:${socket}" ls 2> /dev/null \
    | jq -c '.[].tabs[].windows[] | select(.is_focused)' \
    | head -1)

  if [[ -n "${focused}" ]]; then
    # Inside herdr the kitty window's CWD is herdr's own, not the pane shell's;
    # ask herdr for the focused pane's foreground CWD instead.
    foreground=$(jq -r '[.foreground_processes[].cmdline[0]] | join(" ")' <<< "${focused}")
    if command -v herdr > /dev/null && grep -qw herdr <<< "${foreground}"; then
      cwd=$(herdr pane list 2> /dev/null \
        | jq -r '.result.panes[] | select(.focused) | (.foreground_cwd // .cwd)' \
        | head -1)
    else
      cwd=$(jq -r '.cwd' <<< "${focused}")
    fi
  fi
fi

cd "${cwd:-${HOME}}" && "$@"
