#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No backup options supplied"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No backup target supplied"
    exit 1
fi

sudo rsync "$1" --delete --delete-excluded \
  --exclude="/dev/*" \
  --exclude="/home/*/.builds/*" \
  --exclude="/home/*/.cache/*" \
  --exclude="/home/*/.local/share/Trash/*" \
  --exclude="/home/*/.npm/*" \
  --exclude="/home/*/.nvm/*" \
  --exclude="/home/*/.yarn/*" \
  --exclude="/home/*/code/*" \
  --exclude="/home/*/download/*" \
  --exclude="/home/*/media/*" \
  --exclude="/lost+found" \
  --exclude="/media/*" \
  --exclude="/mnt/*" \
  --exclude="/proc/*" \
  --exclude="/run/*" \
  --exclude="/sys/*" \
  --exclude="/tmp/*" \
  / "$2"