#!/usr/bin/env bash

#  ╻┏┓╻╻╺┳╸
#  ┃┃┗┫┃ ┃
#  ╹╹ ╹╹ ╹
# One-shot tasks run at niri session start.

set -euo pipefail

# Cursor settings.
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface cursor-size "24"

# Reset playground.
if [[ -d "${HOME}/code/personal/playground" ]]; then
  git -C "${HOME}/code/personal/playground" checkout -- src
fi
