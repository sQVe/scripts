#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "chromium"
  "gitkraken"
  "htop"
  "insomnia"
  "mailspring"
  "node"
  "nvim"
  "qutebrowser"
  "ranger"
  "rtv"
  "speedcrunch"
  "spotify"
  "twitch"
  "weechat"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

case "$choice" in
  htop | node | nvim | ranger | rtv )
    term "$choice"
    ;;
  spotify | qutebrowser )
    "scaled-$choice"
    ;;
  twitch )
    streamlink-twitch-gui
    ;;
  weechat )
    term --name weechat weechat
    ;;
  * )
    "$choice"
    ;;
esac
