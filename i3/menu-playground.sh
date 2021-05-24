#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓╻  ┏━┓╻ ╻┏━╸┏━┓┏━┓╻ ╻┏┓╻╺┳┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┛┃  ┣━┫┗┳┛┃╺┓┣┳┛┃ ┃┃ ┃┃┗┫ ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹  ┗━╸╹ ╹ ╹ ┗━┛╹┗╸┗━┛┗━┛╹ ╹╺┻┛

playground=(
  "javascript.js"
  "typescript.ts"
)

choice="$(printf '%s\n' "${playground[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'playground: ')"

if [[ -n "$choice" ]]; then
  term "cd ~/code/playground && nvim +vsplit +\"terminal npm run $choice\" +'wincmd h' +'norm G$' \"boxes/$choice\""
fi
