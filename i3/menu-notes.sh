#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

notes="$(command fd --extension md --max-depth 1 . "$HOME/notes" | sed -r -e 's/\.md//' -e 's/^.+notes\///')"
choice="$(echo "$notes" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'note: ')"

if [[ -n "$choice" && -f "$HOME/notes/$choice.md" ]]; then
  term nvim-pwd "$HOME/notes/$choice.md"
fi
