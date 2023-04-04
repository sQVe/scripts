#!/usr/bin/env bash

# ┏━┓┏━┓┏━╸┏┓╻
# ┃ ┃┣━┛┣╸ ┃┗┫
# ┗━┛╹  ┗━╸╹ ╹

set -euo pipefail

open_options=(
  "httpie"
  "mimeo"
  "mpv"
)
open_choice=$(printf '%s\n' "${open_options[@]}" | rofi -dmenu -p 'open')

if [[ -n "${open_choice}" ]]; then
  case "${open_choice}" in
    "httpie")
      term "http --pretty none \"${*}\" | nvim"
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
  esac
fi
