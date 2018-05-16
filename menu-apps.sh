#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "bc"
  "chromium"
  "gitkraken"
  "htop"
  "insomnia"
  "nvim"
  "qutebrowser"
  "ranger"
  "spotify"
  "weechat"
)

run="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return,space" -dmenu -p 'run')"

case "$run" in
  bc )
    term --title bc bc -l -q
    ;;
  weechat )
    term --title weechat weechat
    ;;
  htop | nvim | ranger )
    term "$run"
    ;;
  spotify | qutebrowser )
    "scaled-$run"
    ;;
  * )
    "$run"
    ;;
esac
