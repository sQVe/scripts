#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓ ┏┓┏━╸┏━╸╺┳╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣┳┛┃ ┃  ┃┣╸ ┃   ┃ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹┗╸┗━┛┗━┛┗━╸┗━╸ ╹ ┗━┛

projects=$(fd --max-depth 4 --hidden --exclude ".{builds,local}" --type directory '^.git$' . | sed -r 's/\/.git$//')
choice="$(echo "$projects" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

if [[ -n "$choice" && -d "$HOME/$choice" ]]; then
  term cd "$HOME/$choice"
fi
