#!/usr/bin/env bash

# ┏━╸┏━╸┏┓╻╺┳╸┏━╸┏━┓   ┏━╸╻ ╻┏━┓┏━┓┏━┓┏━┓   ┏━╸┏━┓┏━╸╻ ╻┏━┓┏━╸╺┳┓
# ┃  ┣╸ ┃┗┫ ┃ ┣╸ ┣┳┛   ┃  ┃ ┃┣┳┛┗━┓┃ ┃┣┳┛   ┣╸ ┃ ┃┃  ┃ ┃┗━┓┣╸  ┃┃
# ┗━╸┗━╸╹ ╹ ╹ ┗━╸╹┗╸   ┗━╸┗━┛╹┗╸┗━┛┗━┛╹┗╸   ╹  ┗━┛┗━╸┗━┛┗━┛┗━╸╺┻┛
# Center the cursor in the focused window.

# Enable strict mode.
set -euo pipefail

center_cursor() {
  # Get window geometry, capture any errors.
  if ! window_info=$(
    xdotool getactivewindow getwindowgeometry --shell 2> /dev/null
  ); then
    return
  fi

  # Evaluate the window info.
  if ! eval "${window_info}"; then
    return
  fi

  focused_window_center_x=$((X + WIDTH / 2))
  focused_window_center_y=$((Y + HEIGHT / 2))

  # Ignore invalid center coordinates.
  if
    [[ "${focused_window_center_x}" == "-1" ]] \
      || [[ "${focused_window_center_y}" == "-1" ]]
  then
    return
  fi

  # Run this async with proc.
  xdotool mousemove "${focused_window_center_x}" "${focused_window_center_y}"
}

# Listen to specific i3wm events.
i3-msg -t subscribe -m '[ "binding", "window" ]' | while read -r event; do
  event_type=$(jq -r '.change' 2> /dev/null <<< "${event}")

  case "${event_type}" in
    "run")
      binding=$(jq -r '.binding.command' 2> /dev/null <<< "${event}")

      if [[ 
        "${binding}" =~ ^exec ||
        "${binding}" =~ ^kill$ ||
        "${binding}" =~ ^layout ||
        "${binding}" =~ ^mode ||
        "${binding}" =~ ^split ||
        "${binding}" =~ ^sticky ]]; then
        continue
      fi

      center_cursor
      ;;
    "close" | "new")
      center_cursor
      ;;
  esac
done
