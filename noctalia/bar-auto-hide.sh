#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━┓   ┏━┓╻ ╻╺┳╸┏━┓   ╻ ╻╻╺┳┓┏━╸
#  ┣┻┓┣━┫┣┳┛╺━╸┣━┫┃ ┃ ┃ ┃ ┃╺━╸┣━┫┃ ┃┃┣╸
#  ┗━┛╹ ╹╹┗╸   ╹ ╹┗━┛ ╹ ┗━┛   ╹ ╹╹╺┻┛┗━╸
# Toggles the Noctalia bar's auto-hide.

set -euo pipefail

# Noctalia only sets auto-hide, never toggles it, and reports the mode nowhere:
# bar-auto-hide-set leaves settings.toml untouched, and msg status carries only
# barVisible, which also flips on hover. So this file carries the live mode as
# "<pid> <mode>". The pid pins it to one Noctalia run, because a restart drops
# the runtime mode back to the saved setting while the file would outlive it.
state_file="${XDG_RUNTIME_DIR}/noctalia-bar-auto-hide"

# The CLI runs the same binary as the daemon, so a concurrent `noctalia msg`
# also matches; the oldest match is the daemon.
noctalia_pid="$(pgrep -o -x noctalia)" || {
  echo "noctalia is not running" >&2
  exit 1
}

# The first press flips the saved setting, so it is read rather than assumed.
# `full` earns its place: a bar that never had auto_hide written is answered by
# the built-in defaults layer alone, never by settings.toml.
saved_auto_hide() {
  local config bar_id
  config="$(noctalia config export full)"
  bar_id="$(taplo get -- 'bar.order[0]' <<< "${config}")"
  taplo get -- "bar.${bar_id}.auto_hide" <<< "${config}"
}

current=""
if [[ -f "${state_file}" ]]; then
  # A truncated or unreadable file must fall through to the saved setting, not
  # abort: `|| true` covers a failing read, the empty defaults cover a failing
  # redirect, which skips the read entirely.
  state_pid=""
  state_mode=""
  read -r state_pid state_mode < "${state_file}" || true

  if [[ "${state_pid}" == "${noctalia_pid}" ]]; then
    current="${state_mode}"
  fi
fi

# Assigned before the test so a failing export aborts instead of reading as off.
if [[ -z "${current}" ]]; then
  saved="$(saved_auto_hide)"

  if [[ "${saved}" == "true" ]]; then
    current="on"
  else
    current="off"
  fi
fi

if [[ "${current}" == "on" ]]; then
  next="off"
else
  next="on"
fi

noctalia msg bar-auto-hide-set "${next}"
echo "${noctalia_pid} ${next}" > "${state_file}"
