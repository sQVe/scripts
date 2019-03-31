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
  htop | node | nvim | ranger | rtv )
    term --title "$choice"
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
  neomutt | weechat )
    term --instance "$choice" --title "$choice" "$choice"
    ;;
  * )
    "$choice"
    ;;
esac
