#!/usr/bin/env bash

# ┏━┓┏━┓┏━╸┏┓╻
# ┃ ┃┣━┛┣╸ ┃┗┫
# ┗━┛╹  ┗━╸╹ ╹

set -euo pipefail

open_options=(
  "chrome"
  "mimeo"
  "mpv"
  "xh"
)
open_choice=$(printf '%s\n' "${open_options[@]}" | rofi -dmenu -p 'open')

if [[ -n "${open_choice}" ]]; then
  case "${open_choice}" in
    "chrome")
      google-chrome-stable --app="${*}" &
      ;;
    "mimeo")
      mimeo -q "${*}"
      ;;
    "mpv")
      if ! "mpv" "${*}"; then
        notify-send "Error running command: ${open_choice}"
        exit 1
      fi
      ;;
    "xh")
      term "xh --pretty none \"${*}\" | nvim"
      ;;
  esac
fi
