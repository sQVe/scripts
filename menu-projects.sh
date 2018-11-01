#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓ ┏┓┏━╸┏━╸╺┳╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┣┳┛┃ ┃  ┃┣╸ ┃   ┃ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ╹┗╸┗━┛┗━┛┗━╸┗━╸ ╹ ┗━┛

projects=$(fd --max-depth 4 --hidden --exclude ".{builds,local}" --type directory '^.git$' . | sed -r 's/\/.git$//')
run="$(echo "$projects" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"

if [[ -n "$run" && -d "$HOME/$run" ]]; then
  term cd "$HOME/$run"
fi
