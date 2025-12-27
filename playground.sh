#!/usr/bin/env bash

#  ┏━┓╻  ┏━┓╻ ╻┏━╸┏━┓┏━┓╻ ╻┏┓╻╺┳┓
#  ┣━┛┃  ┣━┫┗┳┛┃╺┓┣┳┛┃ ┃┃ ┃┃┗┫ ┃┃
#  ╹  ┗━╸╹ ╹ ╹ ┗━┛╹┗╸┗━┛┗━┛╹ ╹╺┻┛

# Enable strict mode.
set -euo pipefail

term --class "playground" \
  "builtin cd \"${CODE}/personal/playground\" && nvim +vsplit +\"terminal npm run start\" +'wincmd h' +'norm G\$' \"src/index.ts\""
