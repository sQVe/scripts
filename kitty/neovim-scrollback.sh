#!/usr/bin/env bash

# ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓   ┏━┓┏━╸┏━┓┏━┓╻  ╻  ┏┓ ┏━┓┏━╸╻┏
# ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃   ┗━┓┃  ┣┳┛┃ ┃┃  ┃  ┣┻┓┣━┫┃  ┣┻┓
# ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹   ┗━┛┗━╸╹┗╸┗━┛┗━╸┗━╸┗━┛╹ ╹┗━╸╹ ╹

set -euo pipefail

INPUT_LINE_NUMBER="${1:-0}"
CURSOR_LINE="${2:-1}"
CURSOR_COLUMN="${3:-1}"

exec nvim \
  -u NONE \
  -c "noremap q ZZ" \
  -c "noremap ö :" \
  -c "noremap Ö :" \
  -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus" \
  -c "set hlsearch incsearch ignorecase smartcase" \
  -c "autocmd TermEnter * stopinsert" \
  -c "autocmd TermClose * call cursor(max([0,${INPUT_LINE_NUMBER}-1])+${CURSOR_LINE}, ${CURSOR_COLUMN})" \
  -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b'']2;"' 63<&0 0< /dev/null
