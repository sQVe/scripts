#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹

if [[ -z "$1" ]]; then
  echo "No backup options supplied"
  exit 1
fi

if [[ -z "$2" ]]; then
  echo "No backup target supplied"
  exit 1
fi

sudo mkdir -p "$2"

sudo rsync "$1" --delete --delete-excluded \
  --exclude="/dev/*" \
  --exclude="/home/*/.builds/*" \
  --exclude="/home/*/.cache/*" \
  --exclude="/home/*/.config/chromium-back*" \
  --exclude="/home/*/.ghc/" \
  --exclude="/home/*/.local/share/Steam" \
  --exclude="/home/*/.local/share/TabNine" \
  --exclude="/home/*/.local/share/Trash/*" \
  --exclude="/home/*/.local/share/mail/" \
  --exclude="/home/*/.local/share/nvim/" \
  --exclude="/home/*/.local/share/qutebrowser-back*" \
  --exclude="/home/*/.node-gyp/" \
  --exclude="/home/*/.npm/" \
  --exclude="/home/*/.nvm/" \
  --exclude="/home/*/.stack/" \
  --exclude="/home/*/.virtualbox/" \
  --exclude="/home/*/.yarn/" \
  --exclude="/home/*/code/*" \
  --exclude="/home/*/download/*" \
  --exclude="/home/*/media/*" \
  --exclude="/home/*/work/*" \
  --exclude="/lost+found" \
  --exclude="/media/*" \
  --exclude="/mnt/*" \
  --exclude="/proc/*" \
  --exclude="/run/*" \
  --exclude="/srv/*" \
  --exclude="/swapfile" \
  --exclude="/sys/*" \
  --exclude="/tmp/*" \
  --exclude="/var/lib/docker/*" \
  --exclude="/var/lib/libvirt/*" \
  / "$2"
