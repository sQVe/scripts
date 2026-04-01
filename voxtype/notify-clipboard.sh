#!/usr/bin/env bash

#  ┏┓╻┏━┓╺┳╸╻┏━╸╻ ╻   ┏━╸╻  ╻┏━┓┏┓ ┏━┓┏━┓┏━┓╺┳┓
#  ┃┗┫┃ ┃ ┃ ┃┣╸ ┗┳┛╺━╸┃  ┃  ┃┣━┛┣┻┓┃ ┃┣━┫┣┳┛ ┃┃
#  ╹ ╹┗━┛ ╹ ╹╹   ╹    ┗━╸┗━╸╹╹  ┗━┛┗━┛╹ ╹╹┗╸╺┻┛
# Show a notification with the current clipboard content.
# Used as a voxtype post_output_command.

set -euo pipefail

readonly text="$(wl-paste)"

if [[ -n "${text}" ]]; then
  notify-send -a Voxtype "Copied to clipboard" "${text}"
fi
