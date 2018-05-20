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
    term --name bc bc -l -q
    ;;
  weechat )
    term --name weechat weechat
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
