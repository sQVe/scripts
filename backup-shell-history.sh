#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ┏━┓╻ ╻┏━╸╻  ╻     ╻ ╻╻┏━┓╺┳╸┏━┓┏━┓╻ ╻
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┗━┓┣━┫┣╸ ┃  ┃     ┣━┫┃┗━┓ ┃ ┃ ┃┣┳┛┗┳┛
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ┗━┛╹ ╹┗━╸┗━╸┗━╸   ╹ ╹╹┗━┛ ╹ ┗━┛╹┗╸ ╹

readonly backup_name="${HISTFILE}.backup"
readonly max_backup_count=9

function find_backup_files() {
  command find "$(command dirname "${HISTFILE}")" \
    -type f \
    -name "${backup_name}.[0-${max_backup_count}]" \
    | command sort -n
}

# Exit if HISTFILE does not exist.
if [[ ! -e "${HISTFILE}" ]]; then
  printf "No history file found at %s\n" "${HISTFILE}" >&2
  exit 1
fi

# Backup HISTFILE.
command cp -f "${HISTFILE}" "${backup_name}.0"

# Iterate over all files and sort them by index.
readarray -t files <<< "$(find_backup_files)"

for ((idx = max_backup_count; idx >= 0; idx--)); do
  file="${files[${idx}]}"

  if [[ -e "${file}" ]]; then
    mv -f "${file}" "${backup_name}.$((idx + 1))"
  fi
done

# Cleanup outdated backup.
command rm -f "${backup_name}.$((max_backup_count + 1))"
