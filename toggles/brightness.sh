#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏┓ ┏━┓╻┏━╸╻ ╻╺┳╸┏┓╻┏━╸┏━┓┏━┓
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┻┓┣┳┛┃┃╺┓┣━┫ ┃ ┃┗┫┣╸ ┗━┓┗━┓
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ┗━┛╹┗╸╹┗━┛╹ ╹ ╹ ╹ ╹┗━╸┗━┛┗━┛

current_brightness=$(brightnessctl --machine-readable | cut -d ',' -f 4)

if [[ "${current_brightness}" == '30%' ]]; then
  brightnessctl set 70%
else
  brightnessctl set 30%
fi

pkill -SIGRTMIN+10 i3blocks
