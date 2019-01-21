#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

notes="$(command fd --extension md . "$HOME/notes" | sed -r -e 's/\.md//' -e 's/^.+notes\///')"
choice="$(echo "$notes" | rofi -kb-accept-entry "Return" -dmenu -p 'run')"


if [[ -n "$choice" && -f "$HOME/notes/$choice.md" ]]; then
  term nvim "$HOME/notes/$choice.md"
fi
