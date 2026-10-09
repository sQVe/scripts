#!/usr/bin/env bash

# Sets the laptop panel to 165 Hz on AC and 60 Hz on battery.
#   refresh-rate.sh apply   Set the mode once for the current power source.
#   refresh-rate.sh watch   Apply now, then again on every power_supply change.
# kanshi calls `apply` after it enables the panel, because its profiles set 165 Hz.

set -euo pipefail

OUTPUT="eDP-1"
AC_MODE="2560x1600@165.004"
BATTERY_MODE="2560x1600@60.002"

on_ac() {
  local online

  for online in /sys/class/power_supply/AC*/online; do
    [[ -r "${online}" && "$(< "${online}")" == 1 ]] && return 0
  done

  return 1
}

power_source() {
  if on_ac; then
    echo ac
  else
    echo battery
  fi
}

panel_enabled() {
  niri msg --json outputs | jq -e --arg output "${OUTPUT}" '.[$output].current_mode != null' > /dev/null
}

apply() {
  local mode="${BATTERY_MODE}"

  on_ac && mode="${AC_MODE}"
  panel_enabled || return 0
  niri msg output "${OUTPUT}" mode "${mode}"
}

watch() {
  local last_source current_source line

  last_source=$(power_source)
  apply || true

  # The battery also sends change events, so apply only when the power source flips.
  # Otherwise a mode set by hand would be reverted on the next battery update.
  udevadm monitor --udev --subsystem-match=power_supply | while read -r line; do
    [[ "${line}" == *" change "* ]] || continue
    sleep 1
    current_source=$(power_source)
    [[ "${current_source}" == "${last_source}" ]] && continue
    last_source=${current_source}
    apply || true
  done
}

case "${1:-}" in
  apply) apply ;;
  watch) watch ;;
  *)
    echo "usage: ${0##*/} apply|watch" >&2
    exit 2
    ;;
esac
