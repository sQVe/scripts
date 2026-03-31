#!/usr/bin/env bash

#  ╻ ╻┏━┓╻ ╻╺┳╸╻ ╻┏━┓┏━╸
#  ┃┏┛┃ ┃┏╋┛ ┃ ┗┳┛┣━┛┣╸
#  ┗┛ ┗━┛╹ ╹ ╹  ╹ ╹  ┗━╸
# Voxtype status for Noctalia bar widget.

set -euo pipefail

state_file="${XDG_RUNTIME_DIR}/voxtype/state"

get_state() {
  if [[ -f "${state_file}" ]]; then
    cat "${state_file}"
  else
    echo "stopped"
  fi
}

state_to_json() {
  case "${1}" in
    recording)
      echo '{"icon": "ripple", "tooltip": "Voxtype: recording"}'
      ;;
    transcribing)
      echo '{"icon": "loader", "tooltip": "Voxtype: transcribing"}'
      ;;
    outputting)
      echo '{"icon": "keyboard", "tooltip": "Voxtype: outputting"}'
      ;;
    *)
      echo '{"icon": "ripple-off", "tooltip": "Voxtype: idle"}'
      ;;
  esac
}

case "${1:-}" in
  toggle)
    voxtype record toggle
    ;;
  json)
    state_to_json "$(get_state)"
    ;;
  stream)
    state_to_json "$(get_state)"
    stdbuf -oL voxtype status --follow | while IFS= read -r line; do
      state_to_json "${line}"
    done
    ;;
esac
