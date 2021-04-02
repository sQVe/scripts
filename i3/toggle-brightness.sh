#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏┓ ┏━┓╻┏━╸╻ ╻╺┳╸┏┓╻┏━╸┏━┓┏━┓
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┻┓┣┳┛┃┃╺┓┣━┫ ┃ ┃┗┫┣╸ ┗━┓┗━┓
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ┗━┛╹┗╸╹┗━┛╹ ╹ ╹ ╹ ╹┗━╸┗━┛┗━┛

current_brightness=$(light | cut -d '.' -f 1)

if [[ current_brightness -lt 30 ]]; then
  light -S 30 && pkill -RTMIN+10 i3blocks
elif [[ current_brightness -lt 50 ]]; then
  light -S 50 && pkill -RTMIN+10 i3blocks
elif [[ current_brightness -lt 70 ]]; then
  light -S 70 && pkill -RTMIN+10 i3blocks
elif [[ current_brightness -lt 90 ]]; then
  light -S 90 && pkill -RTMIN+10 i3blocks
else
  light -S 10 && pkill -RTMIN+10 i3blocks
fi
