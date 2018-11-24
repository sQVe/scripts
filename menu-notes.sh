#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

notes="$(fd --type f . "$HOME/notes" | sed -r 's/^.+notes\///')"
choice="$(echo "$notes" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"


if [[ -n "$choice" && -f "$HOME/notes/$choice" ]]; then
  term nvim "$HOME/notes/$choice"
fi
