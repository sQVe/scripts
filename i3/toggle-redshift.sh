#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏━┓┏━╸╺┳┓┏━┓╻ ╻╻┏━╸╺┳╸
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┳┛┣╸  ┃┃┗━┓┣━┫┃┣╸  ┃
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ╹┗╸┗━╸╺┻┛┗━┛╹ ╹╹╹   ╹

if [[ $(pidof redshift | wc -w) == 0 ]]; then
  redshift -m randr &
else
  pkill redshift
fi

pkill -RTMIN+2 i3blocks
