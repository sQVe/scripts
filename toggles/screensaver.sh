#!/usr/bin/env bash

#  ┏━┓┏━╸┏━┓┏━╸┏━╸┏┓╻┏━┓┏━┓╻ ╻┏━╸┏━┓
#  ┗━┓┃  ┣┳┛┣╸ ┣╸ ┃┗┫┗━┓┣━┫┃┏┛┣╸ ┣┳┛
#  ┗━┛┗━╸╹┗╸┗━╸┗━╸╹ ╹┗━┛╹ ╹┗┛ ┗━╸╹┗╸

current_timeout_seconds=$(xset q | rg 'timeout:' | awk '{print $2}')

if [[ "${current_timeout_seconds}" == '0' ]]; then
  xset s 240 0
else
  xset s off
fi

pkill -SIGRTMIN+6 i3status-rs
