#!/usr/bin/env bash

#  ╺┳┓┏━┓╻ ╻┏┓╻╻  ┏━┓┏━┓╺┳┓┏━╸┏━┓
#   ┃┃┃ ┃┃╻┃┃┗┫┃  ┃ ┃┣━┫ ┃┃┣╸ ┣┳┛
#  ╺┻┛┗━┛┗┻┛╹ ╹┗━╸┗━┛╹ ╹╺┻┛┗━╸╹┗╸

target_url=$*
downloader_selection="httpie
svtplay-dl
youtube-dl"

downloader_choice="$(
  echo "$downloader_selection" |
    rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'downloader: '
)"

if [[ -n "$downloader_choice" ]]; then
  cd "$DOWNLOAD" || exit

  if [[ "$downloader_choice" == "httpie" ]]; then
    term "http --download \"$target_url\""
  else
    term "$downloader_choice \"$target_url\""
  fi
fi
