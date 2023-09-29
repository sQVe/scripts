#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏┓ ┏━┓╻┏━╸╻ ╻╺┳╸┏┓╻┏━╸┏━┓┏━┓
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┻┓┣┳┛┃┃╺┓┣━┫ ┃ ┃┗┫┣╸ ┗━┓┗━┓
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ┗━┛╹┗╸╹┗━┛╹ ╹ ╹ ╹ ╹┗━╸┗━┛┗━┛

current_brightness=$(light | cut -d '.' -f 1)

if [[ current_brightness -lt 30 ]]; then
  light -S 30
elif [[ current_brightness -lt 50 ]]; then
  light -S 50
elif [[ current_brightness -lt 70 ]]; then
  light -S 70
elif [[ current_brightness -lt 90 ]]; then
  light -S 90
else
  light -S 10
fi

pkill -SIGRTMIN+10 i3blocks
