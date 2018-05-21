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
  "weechat"
)

run="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return,space" -dmenu -p 'run')"

case "$run" in
  weechat )
    term --name weechat weechat
    ;;
  htop | node | nvim | ranger )
    term "$run"
    ;;
  spotify | qutebrowser )
    "scaled-$run"
    ;;
  * )
    "$run"
    ;;
esac
