#!/usr/bin/env bash

#  ╺┳╸┏━┓┏┓ ╻  ┏━╸╺┳╸   ┏━┓┏━┓   ┏━┓┏━╸┏━┓┏━╸┏━╸┏┓╻
#   ┃ ┣━┫┣┻┓┃  ┣╸  ┃    ┣━┫┗━┓   ┗━┓┃  ┣┳┛┣╸ ┣╸ ┃┗┫
#   ╹ ╹ ╹┗━┛┗━╸┗━╸ ╹    ╹ ╹┗━┛   ┗━┛┗━╸╹┗╸┗━╸┗━╸╹ ╹

# Thanks to https://etam-software.eu/blog/2021-01-09-virtual-screen.html for
# an excellent guide on how to get this up and running properly.

width=2800
height=1752

# shellcheck disable=SC2046
set -- $(cvt "$width" "$height" 60 | rg Modeline)
settings="${2#\"}"
settings="${settings%\"}"
shift 2

echo "Setting new display mode..."
xrandr --newmode "$settings" "$@"
xrandr --addmode DVI-I-1-1 "$settings"
xrandr \
  --output DVI-I-1-1 \
  --mode "$settings" \
  --right-of eDP-1

echo "Enable ADB USB connection..."
adb reverse tcp:5900 tcp:5900

echo "Starting VNC server..."
mode="$(xrandr | grep DVI-I-1-1 | cut -d " " -f 3)"
x11vnc -display :0 -clip "$mode" -forever -noxdamage
