#!/usr/bin/env bash

#  ╻ ╻┏━┓┏━┓┏┓╻   ╻ ╻┏━┓╺┳┓┏━┓╺┳╸┏━╸   ┏━┓╻  ╻
#  ┗┳┛┣━┫┣┳┛┃┗┫   ┃ ┃┣━┛ ┃┃┣━┫ ┃ ┣╸    ┣━┫┃  ┃
#   ╹ ╹ ╹╹┗╸╹ ╹   ┗━┛╹  ╺┻┛╹ ╹ ╹ ┗━╸   ╹ ╹┗━╸┗━╸

tmp_file=$(mktemp)

function get_outdated_dependencies() {
  local answer
  local raw_dependency_output

  echo "Getting outdated dependencies via 'yarn outdated'..."
  raw_dependency_output=$(yarn outdated 2>/dev/null)
  echo "$raw_dependency_output" |
    grep --ignore-case 'dependencies' |
    awk '{print $1 "@" $4}' >"$tmp_file"

  echo "Found the following outdated dependencies:"
  while read -r line; do
    echo "  $line"
  done <"$tmp_file"
  echo -n "Would you like to edit the list? [y/N] "
  read -r answer

  if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
    $EDITOR "$tmp_file"
  fi

  mapfile -t outdated_dependencies <"$tmp_file"
}

get_outdated_dependencies

echo "Adding all outdated_dependencies via 'yarn add'..."
yarn add "${outdated_dependencies[@]}"
echo "Dependency update successful!"
