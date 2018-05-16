#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸╻ ╻╻╺┳╸
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣╸ ┏╋┛┃ ┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸╹ ╹╹ ╹

exits=(
  "exit"
  "hibernate"
  "lock"
  "reboot"
  "shutdown"
  "shutdown 1"
  "shutdown 15"
  "shutdown 30"
  "shutdown 45"
  "shutdown 60"
  "suspend"
)

run="$(printf '%s\n' "${exits[@]}" | rofi -kb-accept-entry "Return,space" -dmenu -p 'run')"

case "$run" in
  exit )
    i3-msg exit
    ;;
  lock )
    lock
    ;;
  shutdown )
    systemctl poweroff
    ;;
  * )
    if [[ "$run" =~ shutdown\ [0-9]+ ]]; then
      "${run% *}" "${run#* }"
    else
      systemctl "$run"
    fi
    ;;
esac
