#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓╻  ┏━┓╻ ╻┏━╸┏━┓┏━┓╻ ╻┏┓╻╺┳┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┃  ┣━┫┗┳┛┃╺┓┣┳┛┃ ┃┃ ┃┃┗┫ ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ┗━╸╹ ╹ ╹ ┗━┛╹┗╸┗━┛┗━┛╹ ╹╺┻┛

playground=(
  "javascript.js"
  "typescript.ts"
)

choice="$(printf '%s\n' "${playground[@]}" | rofi -dmenu -p 'playground')"

if [[ -n "${choice}" ]]; then
  term "cd ${CODE}/playground && nvim +vsplit +\"terminal npm run ${choice}\" +'wincmd h' +'norm G$' \"boxes/${choice}\""
fi
