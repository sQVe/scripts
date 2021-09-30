#!/usr/bin/env bash

# ┏━┓╺┳╸┏━┓┏━┓   ┏┓╻╻ ╻╻┏┳┓   ╺┳┓┏━┓┏━╸┏┳┓┏━┓┏┓╻┏━┓
# ┗━┓ ┃ ┃ ┃┣━┛   ┃┗┫┃┏┛┃┃┃┃    ┃┃┣━┫┣╸ ┃┃┃┃ ┃┃┗┫┗━┓
# ┗━┛ ╹ ┗━┛╹     ╹ ╹┗┛ ╹╹ ╹   ╺┻┛╹ ╹┗━╸╹ ╹┗━┛╹ ╹┗━┛

is_nvim_running() {
  pgrep nvim &> /dev/null
}

stop_daemons() {
  pkill eslint_d
  pkill prettierd
}

# Exit if nvim still is running after waiting for one second.
sleep 1
if is_nvim_running; then
  exit 0
fi

current_pids=$(pgrep -f 'stop-nvim-daemons.sh')

# Clear previous ongoing checks.
echo "$current_pids" | while read -r pid; do
  if [[ $pid -ne $$ ]]; then
    kill "$pid"
  fi
done

sleep 1m
! is_nvim_running && stop_daemons
