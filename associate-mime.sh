#!/usr/bin/env bash

#  ┏━┓┏━┓┏━┓┏━┓┏━╸╻┏━┓╺┳╸┏━╸   ┏┳┓╻┏┳┓┏━╸
#  ┣━┫┗━┓┗━┓┃ ┃┃  ┃┣━┫ ┃ ┣╸    ┃┃┃┃┃┃┃┣╸
#  ╹ ╹┗━┛┗━┛┗━┛┗━╸╹╹ ╹ ╹ ┗━╸   ╹ ╹╹╹ ╹┗━╸

get_types() {
  mimeo -m "${files[@]}" | \
    sed -n 'n;p' | \
    sed -r s/\ +//
}

open() {
  local type

  mapfile -t types < <(get_types)

  for type in "${types[@]}"; do
    mimeo --add "$type" "$desktop"
  done
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -h | --help )
    echo "Usage: $(basename "$0") [DESKTOP-FILE] [FILE]..."
    echo "Associate files mime-type with a set desktop-file via mimeo."
    echo ""
    echo "  -h, --help          Display this help"
    echo ""
    echo "Example:"
    echo "  $(basename "$0") feh.desktop example.gif          Associate gif mime-type to feh.desktop"
    echo ""
    exit
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

desktop="$1"; shift;
files=("$@")

if [[ -z "$desktop" ]]; then
  echo "Missing a desktop file."
  exit 1;
elif [[ -z "${files[*]}" ]]; then
  echo "Missing file/files."
  exit 1;
fi

open
