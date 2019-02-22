#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏┓ ┏━┓╻┏━╸╻ ╻╺┳╸┏┓╻┏━╸┏━┓┏━┓
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┻┓┣┳┛┃┃╺┓┣━┫ ┃ ┃┗┫┣╸ ┗━┓┗━┓
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ┗━┛╹┗╸╹┗━┛╹ ╹ ╹ ╹ ╹┗━╸┗━┛┗━┛

current_brightness=$(light | cut -d '.' -f 1)

if [[ current_brightness -lt 20 ]]; then
  light -S 40 && pkill -RTMIN+10 i3blocks
elif [[ current_brightness -lt 60 ]]; then
  light -S 80 && pkill -RTMIN+10 i3blocks
else
  light -S 10 && pkill -RTMIN+10 i3blocks
fi
