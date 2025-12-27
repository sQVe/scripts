#!/usr/bin/env bash

set -euo pipefail

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ╻ ╻╻┏━┓╺┳╸┏━┓┏━┓╻ ╻
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┣━┫┃┗━┓ ┃ ┃ ┃┣┳┛┗┳┛
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ╹ ╹╹┗━┛ ╹ ┗━┛╹┗╸ ╹

readonly max_backup_count=9

find_backup_files() {
  command fd "${HISTFILE##*/}.backup" "$(command dirname "${HISTFILE}")" \
    | command sort -n
}

# Exit if HISTFILE does not exist.
if [[ ! -e "${HISTFILE}" ]]; then
  printf "No history file found at %s\n" "${HISTFILE}" >&2
  exit 1
fi

# Backup HISTFILE.
command cp -f "${HISTFILE}" "${HISTFILE}.backup.0"

# Iterate over all files and sort them by index.
readarray -t files <<< "$(find_backup_files)"

for ((idx = max_backup_count; idx >= 0; idx--)); do
  file="${files[${idx}]}"

  if [[ -e "${file}" ]]; then
    mv -f "${file}" "${HISTFILE}.backup.$((idx + 1))"
  fi
done

# Cleanup outdated backup.
command rm -f "${HISTFILE}.backup.$((max_backup_count + 1))"
