#!/usr/bin/env bash

#  ╻┏ ╻╺┳╸╺┳╸╻ ╻   ┏━╸╻ ╻╺┳┓
#  ┣┻┓┃ ┃  ┃ ┗┳┛╺━╸┃  ┃╻┃ ┃┃
#  ╹ ╹╹ ╹  ╹  ╹    ┗━╸┗┻┛╺┻┛
# Run a command at the CWD of the focused kitty window or Herdr app pane.

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: kitty-cwd.sh <command> [args...]" >&2
  exit 1
fi

herdr_app_cwd() {
  local pane terminal

  pane=$(herdr-app status 2> /dev/null | jq -r '.focused_pane // empty')
  [[ -n "${pane}" ]] || return 0

  # A terminal on another machine has a CWD that does not exist here.
  terminal=$(herdr-app ls 2> /dev/null \
    | jq -r --arg pane "${pane}" \
      '.spaces[] | select(.machine == null) | .tabs[].terminals[] | select(.pane == $pane) | .terminal' \
    | head -1)
  [[ -n "${terminal}" ]] || return 0

  hc get "${terminal}" 2> /dev/null | jq -r '.foreground.cwd // .cwd // empty'
}

kitty_cwd() {
  local socket focused="" foreground

  # Several kitty instances can be running, so ask each one until a socket
  # reports the window that actually holds focus.
  for socket in /tmp/kitty-"${USER}"-*; do
    [[ -S "${socket}" ]] || continue

    focused=$(kitty @ --to "unix:${socket}" ls 2> /dev/null \
      | jq -c '.[].tabs[].windows[] | select(.is_focused)' \
      | head -1)

    [[ -n "${focused}" ]] && break
  done

  [[ -n "${focused}" ]] || return 0

  # Inside herdr the kitty window's CWD is herdr's own, not the pane shell's;
  # ask herdr for the focused pane's foreground CWD instead.
  foreground=$(jq -r '[.foreground_processes[].cmdline[0]] | join(" ")' <<< "${focused}")
  if command -v herdr > /dev/null && grep -qw herdr <<< "${foreground}"; then
    herdr pane list 2> /dev/null \
      | jq -r '.result.panes[] | select(.focused) | (.foreground_cwd // .cwd)' \
      | head -1
  else
    jq -r '.cwd' <<< "${focused}"
  fi
}

app_id=$(niri msg -j focused-window 2> /dev/null | jq -r '.app_id // empty')

cwd=""
case "${app_id}" in
  herdr-app) cwd=$(herdr_app_cwd || true) ;;
  *) cwd=$(kitty_cwd || true) ;;
esac

cd "${cwd:-${HOME}}" && "$@"
