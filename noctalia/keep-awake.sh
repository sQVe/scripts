#!/usr/bin/env bash

#  ╻┏ ┏━╸┏━╸┏━┓   ┏━┓╻ ╻┏━┓╻┏ ┏━╸
#  ┣┻┓┣╸ ┣╸ ┣━┛╺━╸┣━┫┃╻┃┣━┫┣┻┓┣╸
#  ╹ ╹┗━╸┗━╸╹     ╹ ╹┗┻┛╹ ╹╹ ╹┗━╸
# Prevents screen from sleeping via systemd-inhibit.

set -euo pipefail

pid_file="${XDG_RUNTIME_DIR}/keep-awake.pid"

case "${1:-}" in
  on)
    if [[ ! -f "${pid_file}" ]]; then
      systemd-inhibit --what=idle --who="keep-awake" --why="Manual inhibit" sleep infinity &
      echo $! > "${pid_file}"
    fi
    notify-send -i /usr/share/icons/Papirus/48x48/apps/caffeine.svg "Staying awake" "Screen stays on"
    ;;
  off)
    if [[ -f "${pid_file}" ]]; then
      kill "$(cat "${pid_file}")" 2> /dev/null || true
      rm -f "${pid_file}"
    fi
    notify-send -i /usr/share/icons/Papirus/48x48/status/notification-display-brightness-off.svg "Sleep allowed" "Normal timeout restored"
    ;;
  toggle)
    if [[ -f "${pid_file}" ]]; then
      "$0" off
    else
      "$0" on
    fi
    ;;
  json)
    if [[ -f "${pid_file}" ]]; then
      echo '{"icon": "eye", "tooltip": "Keep awake: on"}'
    else
      echo '{"icon": "eye-off", "tooltip": "Keep awake: off"}'
    fi
    ;;
esac
