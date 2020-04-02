#!/usr/bin/env bash

#  ┏━┓┏━┓┏┳┓┏━╸╺┳┓╻┏━┓
#  ┗━┓┣━┫┃┃┃┣╸  ┃┃┃┣┳┛
#  ┗━┛╹ ╹╹ ╹┗━╸╺┻┛╹╹┗╸

pid=$(xprop -id "$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')" |
  grep -m 1 PID |
  cut -d " " -f 3)
pid=$(pstree -pAT "$pid" | rg -o '\d+' | tail -n 1)
cwd=$(readlink "/proc/$pid/cwd")

if [[ $cwd != "/" ]]; then
  cd "$(readlink /proc/"$pid"/cwd)" || exit
fi

term
