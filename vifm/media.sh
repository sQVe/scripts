#!/usr/bin/env bash

#  ┏┳┓┏━╸╺┳┓╻┏━┓
#  ┃┃┃┣╸  ┃┃┃┣━┫
#  ╹ ╹┗━╸╺┻┛╹╹ ╹

function list() {
  mapfile -t devices < <(
    udiskie-info --all --output \
      "toplevel={is_toplevel};device={device_file};label={id_label};mount-point={mount_path}" |
      rg '^toplevel=False;' | sed 's/^toplevel=False;//' | sed 's/;mount-point=$//'
  )

  for device in "${devices[@]}"; do
    sed 's/;/\n/g' <<<"$device"
  done
}

function help() {
  echo "Usage: media list | mount <device> | unmount <path>"
  exit 1
}

case "$1" in
list) list ;;
mount) udiskie-mount "$2" ;;
unmount) udiskie-umount "$2" ;;
*) help ;;
esac
