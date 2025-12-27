#!/usr/bin/env bash

# ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓   ┏━┓┏━╸┏━┓┏━┓╻  ╻  ┏┓ ┏━┓┏━╸╻┏
# ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃   ┗━┓┃  ┣┳┛┃ ┃┃  ┃  ┣┻┓┣━┫┃  ┣┻┓
# ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹   ┗━┛┗━╸╹┗╸┗━┛┗━╸┗━╸┗━┛╹ ╹┗━╸╹ ╹

set -euo pipefail

exec nvim \
  -u NONE \
  -c "noremap q ZZ" \
  -c "noremap ö :" \
  -c "noremap Ö :" \
  -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus" \
  -c "autocmd TermEnter * stopinsert" \
  -c "autocmd TermClose * normal Gkzb" \
  -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b'']2;"' 63<&0 0< /dev/null
