#!/usr/bin/env bash

#  ╺┳╸┏━╸┏━╸   ┏━┓┏━┓┏━┓┏━╸╻╻  ┏━╸
#   ┃ ┃  ┃  ╺━╸┣━┛┣┳┛┃ ┃┣╸ ┃┃  ┣╸
#   ╹ ┗━╸┗━╸   ╹  ╹┗╸┗━┛╹  ╹┗━╸┗━╸
# Reads and sets the active TUXEDO Control Center profile for the bar widget.
#   tcc-profile.sh get         Print the active profile name.
#   tcc-profile.sh set <name>  Switch to <name>, one of PROFILES, and print it.
# The switch is tccd's temporary profile: plugging in or unplugging returns to the state profile
# (AC: Work, battery: Eco).

set -euo pipefail

PROFILES=("Max" "Work" "Eco" "Quiet")

tccd() {
  busctl --system --json=short call com.tuxedocomputers.tccd /com/tuxedocomputers/tccd \
    com.tuxedocomputers.tccd "$@"
}

active_name() {
  tccd GetActiveProfileJSON | jq -r '.data[0] | fromjson | .name'
}

# tccd answers true for any name, so an unknown name must be rejected here.
set_profile() {
  local name=$1 known

  for known in "${PROFILES[@]}"; do
    if [[ "${known}" == "${name}" ]]; then
      tccd SetTempProfile s "${name}" | jq -e '.data[0] == true' > /dev/null
      echo "${name}"
      return 0
    fi
  done

  echo "tcc-profile: unknown profile ${name}" >&2
  exit 1
}

case "${1:-}" in
  get) active_name ;;
  set) set_profile "${2:-}" ;;
  *)
    echo "usage: ${0##*/} get | set <name>" >&2
    exit 2
    ;;
esac
