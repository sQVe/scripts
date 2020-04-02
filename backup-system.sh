#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ┏━┓╻ ╻┏━┓╺┳╸┏━╸┏┳┓
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┗━┓┗┳┛┗━┓ ┃ ┣╸ ┃┃┃
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ┗━┛ ╹ ┗━┛ ╹ ┗━╸╹ ╹

if [[ -z "$1" ]]; then
  echo "No drive specified. Exiting."
  exit 1
fi

current_date=$(timedatectl | head -n 1 | rg -o '\d+-\d+-\d+')
path="$1/systems/$(hostname)/$current_date"

sudo mkdir -p "$path"
sudo rsync -aAXv --delete --delete-excluded \
  --exclude="/dev/*" \
  --exclude="/home/*/.builds/*" \
  --exclude="/home/*/.cache/*" \
  --exclude="/home/*/.config/google-chrome-back*" \
  --exclude="/home/*/.local/share/Steam" \
  --exclude="/home/*/.local/share/TabNine" \
  --exclude="/home/*/.local/share/Trash/*" \
  --exclude="/home/*/.local/share/mail/" \
  --exclude="/home/*/.local/share/nvim/" \
  --exclude="/home/*/.local/share/nvm/" \
  --exclude="/home/*/.local/share/qutebrowser-back*" \
  --exclude="/home/*/.node-gyp/" \
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
  / "$path"

echo "Successfully created system backup at: $path."
