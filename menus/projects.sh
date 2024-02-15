#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓ ┏┓┏━╸┏━╸╺┳╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣┳┛┃ ┃  ┃┣╸ ┃   ┃ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹┗╸┗━┛┗━┛┗━╸┗━╸ ╹ ┗━┛

projects=$(fd --type directory --hidden --no-ignore --exclude '.steam' --exclude 'Steam' '^.git$' | sed -r 's/\/.git\/?$//')
choice="$(echo "${projects}" | rofi -dmenu -p 'project')"

if [[ -n "${choice}" && -d "${HOME}/${choice}" ]]; then
  term builtin cd "${HOME}/${choice}"
fi
