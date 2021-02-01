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

if [[ -x "$(command -v optimus-manager)" ]]; then
  gpu=$(optimus-manager --print-mode | rg -o "intel|nvidia")

  case "$gpu" in
    intel)
      exits+=("gpu nvidia")
      ;;
    nvidia)
      exits+=("gpu intel")
      ;;
  esac
fi

if mullvad status | rg --quiet 'Connected'; then
  exits+=("vpn disconnect")
else
  exits+=("vpn connect")
fi

choice="$(printf '%s\n' "${exits[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'exit: ')"

case "$choice" in
  exit | lock | shutdown | poweroff | suspend | reboot)
    state "$choice"
    ;;
  gpu*)
    optimus-manager --no-confirm --switch "$(rg -o "intel|nvidia" <<< "$choice")"
    ;;
  vpn*)
    mullvad "$(rg -o "connect|disconnect" <<< "$choice")"
    ;;
  *)
    if [[ "$choice" =~ shutdown\ [0-9]+ ]]; then
      "${choice% *}" "${choice#* }"
    fi
    ;;
esac
