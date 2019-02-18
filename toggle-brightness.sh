#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏┓ ┏━┓╻┏━╸╻ ╻╺┳╸┏┓╻┏━╸┏━┓┏━┓
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┻┓┣┳┛┃┃╺┓┣━┫ ┃ ┃┗┫┣╸ ┗━┓┗━┓
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ┗━┛╹┗╸╹┗━┛╹ ╹ ╹ ╹ ╹┗━╸┗━┛┗━┛

current_brightness=$(light | cut -d '.' -f 1)

if [[ current_brightness -lt 50 ]]; then
  light -S 80 && pkill -RTMIN+10 i3blocks
else
  light -S 5 && pkill -RTMIN+10 i3blocks
fi
