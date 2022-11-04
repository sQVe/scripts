#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓ ┏┓┏━╸┏━╸╺┳╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣┳┛┃ ┃  ┃┣╸ ┃   ┃ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹┗╸┗━┛┗━┛┗━╸┗━╸ ╹ ┗━┛

projects=$(fd --max-depth 3 --hidden --strip-cwd-prefix --exclude ".{local}" --type directory '^.git$' | sed -r 's/\/.git\/$//')
choice="$(echo "${projects}" | rofi -dmenu -p 'project')"

if [[ -n "${choice}" && -d "${HOME}/${choice}" ]]; then
  term cd "${HOME}/${choice}"
fi
