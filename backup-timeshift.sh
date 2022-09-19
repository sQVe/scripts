#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ╺┳╸╻┏┳┓┏━╸┏━┓╻ ╻╻┏━╸╺┳╸
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛    ┃ ┃┃┃┃┣╸ ┗━┓┣━┫┃┣╸  ┃
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹      ╹ ╹╹ ╹┗━╸┗━┛╹ ╹╹╹   ╹

if [[ -z "$1" ]]; then
  echo "No drive specified. Exiting."
  exit 1
fi

path="$1/systems/$(nmcli general hostname)"

sudo mkdir -p "$path"
sudo rsync -AHPXa --delete --delete-excluded /timeshift "$path"

echo "Successfully created timeshift backup at: $path."
