#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "chromium"
  "htop"
  "insomnia"
  "menu-bluetooth"
  "menu-calculator"
  "menu-clipboard"
  "menu-exit"
  "menu-notes"
  "menu-passwords"
  "menu-projects"
  "neomutt"
  "node"
  "nvim"
  "qutebrowser"
  "rtv"
  "spotify"
  "term"
  "twitch"
  "vifm"
  "weechat"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

case "$choice" in
  htop | node | nvim | vifm | rtv )
    term --title "$choice" "$choice"
    ;;
  menu-bluetooth | menu-calculator | menu-clipboard | menu-exit | menu-notes | menu-passwords | menu-projects )
    "$HOME/scripts/i3/$choice.sh"
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
