#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓╻ ╻┏━┓┏━┓╺┳┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣━┫┗━┓┗━┓┃╻┃┃ ┃┣┳┛ ┃┃┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹ ╹┗━┛┗━┛┗┻┛┗━┛╹┗╸╺┻┛┗━┛

passwords=$(fd --extension gpg . "$PASSWORD_STORE_DIR" | sed "s#$PASSWORD_STORE_DIR/##" | sed s/\.gpg$// )
choice="$(echo "$passwords" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

if [[ -n "$choice" ]]; then
  pass show --clip "$choice" && notify-send -t 1000 -i password "Password copied" "$choice"
fi
