#!/usr/bin/env bash

#  ┏━┓┏━┓┏┳┓┏━╸╺┳┓╻┏━┓
#  ┗━┓┣━┫┃┃┃┣╸  ┃┃┃┣┳┛
#  ┗━┛╹ ╹╹ ╹┗━╸╺┻┛╹╹┗╸

PID=$(xprop -id "$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')" | \
      grep -m 1 PID | \
      cut -d " " -f 3)
PID=$(pstree -pAT "$PID" | rg -o '\d+' | tail -n 1)

cd "$(readlink /proc/"$PID"/cwd)" || exit
term
