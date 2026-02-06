#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓╻ ╻┏━┓┏━┓╺┳┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣━┫┗━┓┗━┓┃╻┃┃ ┃┣┳┛ ┃┃┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹ ╹┗━┛┗━┛┗┻┛┗━┛╹┗╸╺┻┛┗━┛

passwords=$(fd --extension gpg . "${PASSWORD_STORE_DIR}" | sed "s#${PASSWORD_STORE_DIR}/##" | sed 's/\.gpg$//')
choice="$(echo "${passwords}" | rg "${1:-.}" | rofi -dmenu -p 'password')"

if [[ -n "${choice}" ]]; then
  if pass show --clip "${choice}"; then
    notify-send -a "Passwords" -t 1000 -i /usr/share/icons/Papirus/48x48/status/dialog-password.svg "Password copied" "${choice}"
  else
    notify-send -a "Passwords" -t 1000 -i /usr/share/icons/Papirus/48x48/status/dialog-password.svg "Failed to copy password" "${choice}"
  fi
fi
