#!/usr/bin/env bash

#  ┏━╸┏━┓┏┓╻╻ ╻┏━╸┏━┓╺┳╸   ╻┏━╸┏━┓┏┳┓┏━┓┏━┓┏┓╻
#  ┃  ┃ ┃┃┗┫┃┏┛┣╸ ┣┳┛ ┃    ┃┃  ┃ ┃┃┃┃┃ ┃┃ ┃┃┗┫
#  ┗━╸┗━┛╹ ╹┗┛ ┗━╸╹┗╸ ╹    ╹┗━╸┗━┛╹ ╹┗━┛┗━┛╹ ╹

if [[ $# -eq 0 ]]; then
  icomoon_styling="$(cat)"
else
  icomoon_styling="$(cat "$1")"
fi

function clean_icon_definitions() {
  sed -r 's#^\.icon-(\w+).+#\t\1: #'
}

function clean_content_definitions() {
  sed -r 's#^\s.+("\\\w+").+#\1,#'
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

function convert() {
  echo "$icomoon_styling"     |
    find_icon_definitions     |
    clean_icon_definitions    |
    clean_content_definitions |
    join_lines
}

echo -n "$(header)
$(convert)
$(footer)"
