#!/usr/bin/env bash

#  ┏━╸┏━┓┏┳┓┏━┓┏━┓┏━┓┏━╸
#  ┃  ┃ ┃┃┃┃┣━┛┃ ┃┗━┓┣╸
#  ┗━╸┗━┛╹ ╹╹  ┗━┛┗━┛┗━╸

is_included_reply_only=$(head -n 1 "$1" | rg '^On' | wc -l)

if [[ $is_included_reply_only -eq 0 ]]; then
  nvim "+StripWhitespace" "$1"
else
  nvim "+norm ggOO" "+StripWhitespace" "$1"
fi
