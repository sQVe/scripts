#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓ ╻  ╻ ╻┏━╸╺┳╸┏━┓┏━┓╺┳╸╻ ╻
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣┻┓┃  ┃ ┃┣╸  ┃ ┃ ┃┃ ┃ ┃ ┣━┫
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━┛┗━╸┗━┛┗━╸ ╹ ┗━┛┗━┛ ╹ ╹ ╹

devices=$(bluetoothctl paired-devices | cut -d ' ' -f 2-)
choice="$(echo "$devices" | cut -d ' ' -f 2- | rofi -kb-accept-entry "Return" -dmenu -p 'run')"
mac=$(echo "$devices" | ag "$choice" | awk '{print $1}')

if [[ -n "$mac" ]]; then
  connected=$(bluetoothctl info "$mac" | ag 'Connected: yes' | wc -l)

  if [[ connected -eq 1 ]]; then
    bluetoothctl disconnect "$mac"
  else
    bluetoothctl connect "$mac"
  fi
fi
