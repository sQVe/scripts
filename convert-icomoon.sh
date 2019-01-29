#!/usr/bin/env bash

#  ┏━╸┏━┓┏┓╻╻ ╻┏━╸┏━┓╺┳╸   ╻┏━╸┏━┓┏┳┓┏━┓┏━┓┏┓╻
#  ┃  ┃ ┃┃┗┫┃┏┛┣╸ ┣┳┛ ┃    ┃┃  ┃ ┃┃┃┃┃ ┃┃ ┃┃┗┫
#  ┗━╸┗━┛╹ ╹┗┛ ┗━╸╹┗╸ ╹    ╹┗━╸┗━┛╹ ╹┗━┛┗━┛╹ ╹

if [[ $# -eq 0 ]]; then
  icomoon_styling="$(cat)"
else
  icomoon_styling="$(cat "$1")"
fi

clean_icon_definitions() {
  sed -r 's#^\.icon-(\w+).+#\t\1: #'
}

clean_content_definitions() {
  sed -r 's#^\s.+("\\\w+").+#\1,#'
}

header() {
  echo "\$icons: ("
}

find_icon_definitions() {
  grep -E '^(\.icon)|(\s+content)'
}

footer() {
  echo ");"
}

join_lines() {
  awk '{printf (NR%2 == 0) ? $0 "\n" : $0}'
}

convert() {
  echo "$icomoon_styling"     |
    find_icon_definitions     |
    clean_icon_definitions    |
    clean_content_definitions |
    join_lines
}

echo -n "$(header)
$(convert)
$(footer)"
