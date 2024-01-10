#!/usr/bin/env bash

# ┏┳┓┏━╸┏┓╻╻ ╻   ┏┓╻┏━┓╺┳╸┏━╸┏┓ ┏━┓╻ ╻
# ┃┃┃┣╸ ┃┗┫┃ ┃   ┃┗┫┃ ┃ ┃ ┣╸ ┣┻┓┃ ┃┏╋┛
# ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹┗━┛ ╹ ┗━╸┗━┛┗━┛╹ ╹

# shellcheck disable=SC2153

notes="$(command fd --extension md --max-depth 3 . "${NOTEBOX}" | sed -r -e 's/\.md//' -e 's/^.+notebox\///')"
choice="$(echo "${notes}" | rofi -dmenu -p 'note')"

if [[ -n "${choice}" && -f "${NOTEBOX}/${choice}.md" ]]; then
  term note "${choice}"
fi
