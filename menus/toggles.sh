#!/usr/bin/env bash

# ┏┳┓┏━╸┏┓╻╻ ╻   ╺┳╸┏━┓┏━╸┏━╸╻  ┏━╸┏━┓
# ┃┃┃┣╸ ┃┗┫┃ ┃    ┃ ┃ ┃┃╺┓┃╺┓┃  ┣╸ ┗━┓
# ╹ ╹┗━╸╹ ╹┗━┛    ╹ ┗━┛┗━┛┗━┛┗━╸┗━╸┗━┛

toggles=(
  "brightness"
  "microphone"
  "redshift"
  "screensaver"
  "volume"
)

choice="$(printf '%s\n' "${toggles[@]}" | rofi -dmenu -p 'toggles')"

if [[ -n "${choice}" ]]; then
  "${SCRIPTS}/toggles/${choice}.sh"
fi
