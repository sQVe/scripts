#!/usr/bin/env bash

#  ┏━╸┏━┓┏┓╻╻ ╻┏━╸┏━┓╺┳╸   ╻┏━╸┏━┓┏┳┓┏━┓┏━┓┏┓╻
#  ┃  ┃ ┃┃┗┫┃┏┛┣╸ ┣┳┛ ┃    ┃┃  ┃ ┃┃┃┃┃ ┃┃ ┃┃┗┫
#  ┗━╸┗━┛╹ ╹┗┛ ┗━╸╹┗╸ ╹    ╹┗━╸┗━┛╹ ╹┗━┛┗━┛╹ ╹

# Convert the icon definitions, in the generated icomoon `style.css`, to a scss
# variable list.

if [[ $# -eq 0 ]]; then
  icomoon_styling="$(cat)"
else
  icomoon_styling="$(cat "$1")"
fi

function clean_icon_definitions() {
  sed -r 's/^\.icon-([a-z1-9_-]+).+/\t\1: /i'
}

function clean_content_definitions() {
  sed -r 's/^\s.+("\\\w+").+/\1,/'
}

function replace_underscores() {
  sed -r 's/_/-/'
}

function header() {
  echo "\$icons: ("
}

function find_icon_definitions() {
  grep -E '^(\.icon)|(\s+content)'
}

function footer() {
  echo ");"
}

function join_lines() {
  awk '{printf (NR%2 == 0) ? $0 "\n" : $0}'
}

function convert_definitions() {
  echo "$icomoon_styling"     |
    find_icon_definitions     |
    clean_icon_definitions    |
    clean_content_definitions |
    replace_underscores       |
    join_lines                |
    sort -u
}

echo -n "$(header)
$(convert_definitions)
$(footer)"
