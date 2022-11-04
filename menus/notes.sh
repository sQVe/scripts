#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

# shellcheck disable=SC2153

notes="$(command fd --extension md --max-depth 1 . "${NOTES}" | sed -r -e 's/\.md//' -e 's/^.+notes\///')"
choice="$(echo "${notes}" | rofi -dmenu -p 'note')"

if [[ -n "${choice}" && -f "${NOTES}/${choice}.md" ]]; then
  term note "${choice}"
fi
