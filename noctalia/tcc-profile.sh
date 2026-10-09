#!/usr/bin/env bash

#  ╺┳╸┏━╸┏━╸   ┏━┓┏━┓┏━┓┏━╸╻╻  ┏━╸
#   ┃ ┃  ┃  ╺━╸┣━┛┣┳┛┃ ┃┣╸ ┃┃  ┣╸
#   ╹ ┗━╸┗━╸   ╹  ╹┗╸┗━┛╹  ╹┗━╸┗━╸
# Reads and switches the active TUXEDO Control Center profile for the bar widget.
#   tcc-profile.sh get    Print the active profile name.
#   tcc-profile.sh next   Switch to the next profile in CYCLE.
#   tcc-profile.sh prev   Switch to the previous profile in CYCLE.
# The switch is tccd's temporary profile: plugging in or unplugging returns to the state profile
# (AC: Max, battery: Eco).

set -euo pipefail

CYCLE=("Max" "Eco" "Quiet")

tccd() {
  busctl --system --json=short call com.tuxedocomputers.tccd /com/tuxedocomputers/tccd \
    com.tuxedocomputers.tccd "$@"
}

active_name() {
  tccd GetActiveProfileJSON | jq -r '.data[0] | fromjson | .name'
}

profile_id() {
  local name=$1

  tccd GetProfilesJSON | jq -er --arg name "${name}" \
    '.data[0] | fromjson | map(select(.name == $name)) | first | .id'
}

# Prints -1 for a profile outside CYCLE.
cycle_index() {
  local name=$1 index

  for index in "${!CYCLE[@]}"; do
    [[ "${CYCLE[index]}" == "${name}" ]] && echo "${index}" && return 0
  done

  echo -1
}

switch() {
  local step=$1 count=${#CYCLE[@]} index target id

  index=$(cycle_index "$(active_name)")

  # A profile outside CYCLE sits between the last and the first, so `next` goes to Max and
  # `prev` to Quiet.
  if ((index < 0 && step < 0)); then
    index=${count}
  fi

  target=${CYCLE[(index + step + count) % count]}
  id=$(profile_id "${target}") || {
    echo "tcc-profile: no profile named ${target}" >&2
    exit 1
  }
  tccd SetTempProfileById s "${id}" | jq -e '.data[0] == true' > /dev/null
  echo "${target}"
}

case "${1:-}" in
  get) active_name ;;
  next) switch 1 ;;
  prev) switch -1 ;;
  *)
    echo "usage: ${0##*/} get|next|prev" >&2
    exit 2
    ;;
esac
