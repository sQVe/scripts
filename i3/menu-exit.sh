#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸╻ ╻╻╺┳╸
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣╸ ┏╋┛┃ ┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸╹ ╹╹ ╹

exits=(
  "exit"
  "hibernate"
  "lock"
  "poweroff"
  "reboot"
  "shutdown"
  "shutdown 15"
  "shutdown 30"
  "shutdown 45"
  "shutdown 60"
  "shutdown 75"
  "shutdown 90"
  "suspend"
)

choice="$(printf '%s\n' "${exits[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'exit: ')"

case "$choice" in
exit)
  i3-msg exit
  ;;
lock)
  lock
  ;;
shutdown)
  systemctl poweroff
  ;;
*)
  if [[ "$choice" =~ shutdown\ [0-9]+ ]]; then
    "${choice% *}" "${choice#* }"
  else
    systemctl "$choice"
  fi
  ;;
esac
