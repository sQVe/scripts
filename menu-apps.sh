#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "chromium"
  "gitkraken"
  "htop"
  "insomnia"
  "node"
  "nvim"
  "qutebrowser"
  "ranger"
  "spotify"
  "twitch"
  "weechat"
)

run="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

case "$run" in
  htop | node | nvim | ranger )
    term "$run"
    ;;
  spotify | qutebrowser )
    "scaled-$run"
    ;;
  twitch )
    streamlink-twitch-gui
    ;;
  weechat )
    term --name weechat weechat
    ;;
  * )
    "$run"
    ;;
esac
