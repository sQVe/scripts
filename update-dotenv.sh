#!/usr/bin/env bash

#  ╻ ╻┏━┓╺┳┓┏━┓╺┳╸┏━╸   ╺┳┓┏━┓╺┳╸┏━╸┏┓╻╻ ╻
#  ┃ ┃┣━┛ ┃┃┣━┫ ┃ ┣╸     ┃┃┃ ┃ ┃ ┣╸ ┃┗┫┃┏┛
#  ┗━┛╹  ╺┻┛╹ ╹ ╹ ┗━╸   ╺┻┛┗━┛ ╹ ┗━╸╹ ╹┗┛

# This script finds all dotenv files, excluding *.local, and checks if the
# values differ from the system environment. Given the "write" option it will
# override the dotenv files with found system environment values.

# Exit on error.
set -o errexit

# Use provided path if given one.
[[ -n "$1" ]] && cd "$1"

env_files=$(find . -maxdepth 1 -type f -name '.env*' -not -name '*.local*')

for file in $env_files; do
  # Check if file exists.
  [[ ! -e "$file" ]] && continue

  # Create a temporary file.
  tmp=$(command mktemp)

  while read -r line; do
    # Ensure that line has KEY= or KEY=VALUE format.
    if grep -Eq '\w+=' <<<"$line"; then
      IFS='=' read -ra key_value <<<"$line"
      key=${key_value[0]}

      if system_env=$(command printenv "${key_value[0]}"); then
        # Use the system environment value.
        echo "$key=$system_env" >>"$tmp"
        continue
      fi
    fi

    # Use the existing environment value.
    echo "$line" >>"$tmp"
  done <"$file"

  if [[ "$1" == '-w' || "$1" == '--write' ]]; then
    cp -f "$tmp" "$file"
  else
    command diff -u "$file" "$tmp"
  fi
done
