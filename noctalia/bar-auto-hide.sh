#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━┓   ┏━┓╻ ╻╺┳╸┏━┓   ╻ ╻╻╺┳┓┏━╸
#  ┣┻┓┣━┫┣┳┛╺━╸┣━┫┃ ┃ ┃ ┃ ┃╺━╸┣━┫┃ ┃┃┣╸
#  ┗━┛╹ ╹╹┗╸   ╹ ╹┗━┛ ╹ ┗━┛   ╹ ╹╹╺┻┛┗━╸
# Toggles the Noctalia bar's auto-hide.

set -euo pipefail

# Noctalia only sets auto-hide, never toggles it, and reports the mode nowhere:
# bar-auto-hide-set leaves settings.toml untouched, and msg status carries only
# barVisible, which also flips on hover. So this file carries the live mode, and
# XDG_RUNTIME_DIR wipes it at logout, exactly when Noctalia goes back to the
# saved setting.
state_file="${XDG_RUNTIME_DIR}/noctalia-bar-auto-hide"

# The first press flips the saved setting, so it is read rather than assumed.
# `full` earns its place: a bar that never had auto_hide written is answered by
# the built-in defaults layer alone, never by settings.toml.
saved_auto_hide() {
  local config bar_id
  config="$(noctalia config export full)"
  bar_id="$(taplo get -- 'bar.order[0]' <<< "${config}")"
  taplo get -- "bar.${bar_id}.auto_hide" <<< "${config}"
}

if [[ -f "${state_file}" ]]; then
  current="$(< "${state_file}")"
elif [[ "$(saved_auto_hide)" == "true" ]]; then
  current="on"
else
  current="off"
fi

if [[ "${current}" == "on" ]]; then
  next="off"
else
  next="on"
fi

noctalia msg bar-auto-hide-set "${next}"
echo "${next}" > "${state_file}"
