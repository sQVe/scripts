#!/usr/bin/env bash

#  ╻  ┏━┓┏━╸╻┏   ╻ ╻┏━┓┏━┓╻┏ ┏━┓
#  ┃  ┃ ┃┃  ┣┻┓  ┣━┫┃ ┃┃ ┃┣┻┓┗━┓
#  ┗━╸┗━┛┗━╸╹ ╹  ╹ ╹┗━┛┗━┛╹ ╹┗━┛

set -euo pipefail

PID_FILE="${XDG_RUNTIME_DIR}/lock-hooks-pids"

lock() {
  qs msg -c noctalia-shell media pause &

  (sleep 1m && sudo -K) &
  echo $! > "${PID_FILE}"

  (sleep 5m && niri msg action power-off-monitors) &
  echo $! >> "${PID_FILE}"

  (sleep 15m && gpg-connect-agent reloadagent /bye) &
  echo $! >> "${PID_FILE}"
}

unlock() {
  if [[ -f "${PID_FILE}" ]]; then
    while read -r pid; do
      kill "${pid}" 2> /dev/null
    done < "${PID_FILE}"
    rm "${PID_FILE}"
  fi
}

case "${1:-}" in
  lock) lock ;;
  unlock) unlock ;;
esac
