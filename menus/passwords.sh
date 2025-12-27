#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓╻ ╻┏━┓┏━┓╺┳┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣━┫┗━┓┗━┓┃╻┃┃ ┃┣┳┛ ┃┃┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹ ╹┗━┛┗━┛┗┻┛┗━┛╹┗╸╺┻┛┗━┛

passwords=$(fd --extension gpg . "${PASSWORD_STORE_DIR}" | sed "s#${PASSWORD_STORE_DIR}/##" | sed 's/\.gpg$//')
choice="$(echo "${passwords}" | rg "${1:-.}" | rofi -dmenu -p 'password')"

if [[ -n "${choice}" ]]; then
  if pass show --clip "${choice}"; then
    notify-send -t 1000 -i dialog-password "Password copied" "${choice}"
  else
    notify-send -t 1000 -i dialog-password "Failed to copy password" "${choice}"
  fi
fi
