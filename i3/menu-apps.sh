#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "chromium"
  "gitkraken"
  "htop"
  "insomnia"
  "menu-bluetooth"
  "menu-clipboard"
  "menu-exit"
  "menu-notes"
  "menu-notes"
  "menu-passwords"
  "menu-projects"
  "neomutt"
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
  chromium )
    optirun "$choice"
    ;;
  htop | neomutt | node | nvim | ranger | rtv )
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
