#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓╺┳╸┏━┓╺┳╸┏━╸
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┗━┓ ┃ ┣━┫ ┃ ┣╸
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━┛ ╹ ╹ ╹ ╹ ┗━╸

exits=(
  "exit"
  "lock"
  "poweroff"
  "reboot"
  "shutdown"
  "shutdown 15"
  "shutdown 30"
  "shutdown 45"
  "shutdown 60"
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
  *)
    if [[ "${choice}" =~ shutdown\ [0-9]+ ]]; then
      "${choice% *}" "${choice#* }"
    fi
    ;;
esac
