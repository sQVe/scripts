#!/usr/bin/env bash

#  ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸   ┏━┓┏━╸╺┳┓┏━┓╻ ╻╻┏━╸╺┳╸
#   ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸    ┣┳┛┣╸  ┃┃┗━┓┣━┫┃┣╸  ┃
#   ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸   ╹┗╸┗━╸╺┻┛┗━┛╹ ╹╹╹   ╹

if [[ $(pidof redshift | wc -w) == 0 ]]; then
  redshift -m randr &
else
  pkill redshift
fi

pkill -SIGRTMIN+8 i3status-rs
