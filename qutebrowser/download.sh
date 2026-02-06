#!/usr/bin/env bash

#  ╺┳┓┏━┓╻ ╻┏┓╻╻  ┏━┓┏━┓╺┳┓
#   ┃┃┃ ┃┃╻┃┃┗┫┃  ┃ ┃┣━┫ ┃┃
#  ╺┻┛┗━┛┗┻┛╹ ╹┗━╸┗━┛╹ ╹╺┻┛

set -euo pipefail

download_options=(
  "svtplay-dl"
  "xh"
  "youtube-dl"
)
download_choice=$(printf '%s\n' "${download_options[@]}" | rofi -dmenu -p 'download')

if [[ -n "${download_choice}" ]]; then
  if ! builtin cd "${DOWNLOAD}"; then
    notify-send -a "Qutebrowser" "Could not change to download directory: ${DOWNLOAD}"
    exit 1
  fi

  case "${download_choice}" in
    "svtplay-dl")
      term "svtplay-dl \"${*}\""
      ;;
    "youtube-dl")
      term "yt-dlp \"${*}\""
      ;;
    "xh")
      term "xh --download \"${*}\""
      ;;
  esac
fi
