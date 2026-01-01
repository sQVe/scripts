#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓╺┳╸┏━┓╺┳╸┏━╸
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┗━┓ ┃ ┣━┫ ┃ ┣╸
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━┛ ╹ ╹ ╹ ╹ ┗━╸

exits=(
  "exit"
  "lock"
  "poweroff"
  "reboot"
  "shutdown"
  "suspend"
)

if mullvad status | rg --quiet 'Connected'; then
  exits+=("vpn disconnect")
else
  exits+=("vpn connect")
fi

choice="$(printf '%s\n' "${exits[@]}" | rofi -dmenu -p 'exit')"

case "${choice}" in
  exit | lock | shutdown | poweroff | suspend | reboot)
    state "${choice}"
    ;;
  vpn*)
    mullvad "$(rg -o "connect|disconnect" <<< "${choice}")"
    ;;
esac
