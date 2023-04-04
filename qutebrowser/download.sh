#!/usr/bin/env bash

#  ╺┳┓┏━┓╻ ╻┏┓╻╻  ┏━┓┏━┓╺┳┓
#   ┃┃┃ ┃┃╻┃┃┗┫┃  ┃ ┃┣━┫ ┃┃
#  ╺┻┛┗━┛┗┻┛╹ ╹┗━╸┗━┛╹ ╹╺┻┛

set -euo pipefail

download_options=(
  "httpie"
  "svtplay-dl"
  "youtube-dl"
)
download_choice=$(printf '%s\n' "${download_options[@]}" | rofi -dmenu -p 'download')

if [[ -n "${download_choice}" ]]; then
  if ! cd "${DOWNLOAD}"; then
    notify-send "Could not change to download directory: ${DOWNLOAD}"
    exit 1
  fi

  case "${download_choice}" in
    "httpie")
      term "http --download \"${*}\""
      ;;
    "svtplay-dl" | "youtube-dl")
      term "${download_choice} \"${*}\""
      ;;
  esac
fi
