#!/usr/bin/env bash

set -euo pipefail

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ╻ ╻╻┏━┓╺┳╸┏━┓┏━┓╻ ╻
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┣━┫┃┗━┓ ┃ ┃ ┃┣┳┛┗┳┛
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ╹ ╹╹┗━┛ ╹ ┗━┛╹┗╸ ╹

readonly max_backup_count=9

# Exit if HISTFILE does not exist.
if [[ ! -e "${HISTFILE}" ]]; then
  printf "No history file found at %s\n" "${HISTFILE}" >&2
  exit 1
fi

# Rotate existing backups (high to low to avoid overwrites).
for ((idx = max_backup_count; idx >= 0; idx--)); do
  file="${HISTFILE}.backup.${idx}"

  if [[ -e "${file}" ]]; then
    mv -f "${file}" "${HISTFILE}.backup.$((idx + 1))"
  fi
done

# Create fresh backup.
command cp -f "${HISTFILE}" "${HISTFILE}.backup.0"

# Cleanup outdated backup.
command rm -f "${HISTFILE}.backup.$((max_backup_count + 1))"
