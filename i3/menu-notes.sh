#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

# shellcheck disable=SC2153

notes="$(command fd --extension md --max-depth 1 . "$NOTES" | sed -r -e 's/\.md//' -e 's/^.+notes\///')"
choice="$(echo "$notes" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'note: ')"

if [[ -n "$choice" && -f "$NOTES/$choice.md" ]]; then
  term nvim "$NOTES/$choice.md" +"cd $NOTES"
fi
