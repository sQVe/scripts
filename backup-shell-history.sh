#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ┏━┓╻ ╻┏━╸╻  ╻     ╻ ╻╻┏━┓╺┳╸┏━┓┏━┓╻ ╻
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┗━┓┣━┫┣╸ ┃  ┃     ┣━┫┃┗━┓ ┃ ┃ ┃┣┳┛┗┳┛
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ┗━┛╹ ╹┗━╸┗━╸┗━╸   ╹ ╹╹┗━┛ ╹ ┗━┛╹┗╸ ╹

function find_backup_files() {
  command find "$(command dirname "$HISTFILE")" \
    -type f \
    -name "${HISTFILE##*/}.backup.[0-3]" |
    command sort -n
}

# Exit without HISTFILE.
[[ ! -e "$HISTFILE" ]] && exit 0

# Backup HISTFILE.
command cp -f "$HISTFILE" "$HISTFILE.backup.0"

# Iterate over all files and sort them by index.
readarray -t files <<<"$(find_backup_files)"

for ((idx = 3; idx >= 0; idx--)); do
  file="${files[$idx]}"

  [[ -e "$file" ]] && mv -f "$file" "$HISTFILE.backup.$((idx + 1))"
done

# Cleanup outdated backup.
command rm -f "$HISTFILE.backup.4"
