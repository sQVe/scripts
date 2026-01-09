#!/usr/bin/env bash

#  ╻  ┏━┓┏━╸╻┏   ╻ ╻┏━┓┏━┓╻┏ ┏━┓
#  ┃  ┃ ┃┃  ┣┻┓  ┣━┫┃ ┃┃ ┃┣┻┓┗━┓
#  ┗━╸┗━┛┗━╸╹ ╹  ╹ ╹┗━┛┗━┛╹ ╹┗━┛
# Screen lock/unlock hooks - pauses media, clears credentials after timeout,
# powers off monitors.

set -euo pipefail

pid_file="${XDG_RUNTIME_DIR}/lock-hooks-pids"

lock() {
  qs msg -c noctalia-shell media pause &

  : > "${pid_file}"

  if [[ ! -f "${XDG_RUNTIME_DIR}/keep-creds" ]]; then
    (sleep 1m && sudo -K) &
    echo $! >> "${pid_file}"

    (sleep 15m && gpg-connect-agent reloadagent /bye) &
    echo $! >> "${pid_file}"
  fi

  (sleep 5m && niri msg action power-off-monitors) &
  echo $! >> "${pid_file}"
}

unlock() {
  if [[ -f "${pid_file}" ]]; then
    while read -r pid; do
      kill "${pid}" 2> /dev/null
    done < "${pid_file}"
    rm "${pid_file}"
  fi
}

case "${1:-}" in
  lock) lock ;;
  unlock) unlock ;;
esac
