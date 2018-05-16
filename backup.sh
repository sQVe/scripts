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

sudo rsync "$1" --delete --delete-excluded \
  --exclude="/dev/*" \
  --exclude="/home/*/.builds/*" \
  --exclude="/home/*/.cache/*" \
  --exclude="/home/*/.config/chromium-back*" \
  --exclude="/home/*/.ghc/" \
  --exclude="/home/*/.gitkraken/" \
  --exclude="/home/*/.local/share/Trash/*" \
  --exclude="/home/*/.local/share/nvim/" \
  --exclude="/home/*/.local/share/qutebrowser-back*" \
  --exclude="/home/*/.node-gyp/" \
  --exclude="/home/*/.nodian/" \
  --exclude="/home/*/.npm/" \
  --exclude="/home/*/.nvm/" \
  --exclude="/home/*/.ohoy/" \
  --exclude="/home/*/.stack/" \
  --exclude="/home/*/.yarn/" \
  --exclude="/home/*/code/*" \
  --exclude="/home/*/download/*" \
  --exclude="/home/*/media/*" \
  --exclude="/lost+found" \
  --exclude="/media/*" \
  --exclude="/mnt/*" \
  --exclude="/proc/*" \
  --exclude="/run/*" \
  --exclude="/srv/*" \
  --exclude="/swapfile" \
  --exclude="/sys/*" \
  --exclude="/tmp/*" \
  / "$2"
