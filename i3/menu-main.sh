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
  "menu-bluetooth"
  "menu-exit"
  "menu-notes"
  "menu-projects"
  "node"
  "nvim"
  "qutebrowser"
  "ranger"
  "rtv"
  "speedcrunch"
  "spotify"
  "term"
  "twitch"
  "weechat"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

case "$choice" in
  htop | node | nvim | ranger | rtv )
    term "$choice"
    ;;
  menu-bluetooth | menu-exit | menu-notes | menu-projects )
    "$HOME/scripts/$choice.sh"
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
