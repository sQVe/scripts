#!/usr/bin/env bash

# ┏━╸╻ ╻┏━┓┏━┓┏┳┓┏━╸   ┏━╸╻  ┏━┓┏━┓╺┳╸
# ┃  ┣━┫┣┳┛┃ ┃┃┃┃┣╸    ┣╸ ┃  ┃ ┃┣━┫ ┃
# ┗━╸╹ ╹╹┗╸┗━┛╹ ╹┗━╸   ╹  ┗━╸┗━┛╹ ╹ ╹
# Opens Chrome in app mode and positions it as a floating window in the
# bottom-right corner of the screen.

set -euo pipefail

position_floating_bottom_right() {
  local window_id="${1}"
  local size_percent="${2:-30}"
  local margin="${3:-8}"

  local screen_width screen_height
  read -r screen_width screen_height < <(niri msg --json focused-output | jq -r '.logical | "\(.width) \(.height)"')

  if [[ -z "${screen_width}" || -z "${screen_height}" ]]; then
    echo "Error: Failed to get screen dimensions from niri" >&2
    return 1
  fi

  local window_width window_height
  window_width=$((screen_width * size_percent / 100))
  window_height=$((screen_height * size_percent / 100))

  niri msg action set-window-width --id "${window_id}" "${window_width}"
  niri msg action set-window-height --id "${window_id}" "${window_height}"

  # The 25px offset is empirical - tested to align correctly with niri's
  # floating window coordinate system. Origin unknown.
  local position_x position_y
  position_x=$((screen_width - window_width - margin))
  position_y=$((screen_height - window_height - margin - 25))

  niri msg action move-floating-window --id "${window_id}" --x "${position_x}" --y "${position_y}"
}

if [[ -z "${1:-}" ]]; then
  echo "Error: URL required" >&2
  exit 1
fi

existing_ids=$(niri msg --json windows | jq -r '.[].id' | sort)

google-chrome-stable --app="${1}" &

# Wait for new window to appear.
chrome_id=""
for _ in {1..40}; do
  chrome_id=$(niri msg --json windows | jq -r '.[].id' | sort | comm -13 <(echo "${existing_ids}") - | head -1)
  if [[ -n "${chrome_id}" ]]; then
    break
  fi
  sleep 0.05
done

if [[ -z "${chrome_id}" ]]; then
  echo "Error: Chrome window didn't appear" >&2
  exit 1
fi

position_floating_bottom_right "${chrome_id}"
niri msg action toggle-windowed-fullscreen --id "${chrome_id}"
