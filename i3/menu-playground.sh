#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓╻  ┏━┓╻ ╻┏━╸┏━┓┏━┓╻ ╻┏┓╻╺┳┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┃  ┣━┫┗┳┛┃╺┓┣┳┛┃ ┃┃ ┃┃┗┫ ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ┗━╸╹ ╹ ╹ ┗━┛╹┗╸┗━┛┗━┛╹ ╹╺┻┛

playground=(
  "clean.js"
  "clean.ts"
  "fp.js"
  "fp.ts"
)

choice="$(printf '%s\n' "${playground[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'playground: ')"

if [[ -n "$choice" ]]; then
  term "playground-$choice"
fi
