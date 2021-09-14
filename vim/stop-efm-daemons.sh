#!/usr/bin/env bash

#  ┏━┓╺┳╸┏━┓┏━┓   ┏━╸┏━╸┏┳┓   ╺┳┓┏━┓┏━╸┏┳┓┏━┓┏┓╻┏━┓
#  ┗━┓ ┃ ┃ ┃┣━┛   ┣╸ ┣╸ ┃┃┃    ┃┃┣━┫┣╸ ┃┃┃┃ ┃┃┗┫┗━┓
#  ┗━┛ ╹ ┗━┛╹     ┗━╸╹  ╹ ╹   ╺┻┛╹ ╹┗━╸╹ ╹┗━┛╹ ╹┗━┛

is_efm_running() {
  pgrep efm-langserver &> /dev/null
}

stop_daemons() {
  pkill eslint_d
  pkill prettierd
}

# Exit if efm is running.
if is_efm_running; then
  exit 0
fi

sleep 1m
! is_efm_running && stop_daemons
