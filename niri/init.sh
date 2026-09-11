#!/usr/bin/env bash

#  ╻┏┓╻╻╺┳╸
#  ┃┃┗┫┃ ┃
#  ╹╹ ╹╹ ╹
# One-shot tasks run at niri session start.

set -euo pipefail

# Cursor settings.
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface cursor-size "24"

# Extended credential caching is a per-session opt-in, but the symlink it flips
# outlives the cache it represents, so a reboot leaves the bar claiming "on".
ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
gpg-connect-agent reloadagent /bye > /dev/null 2>&1 || true

# Reset playground.
if [[ -d "${HOME}/code/personal/playground" ]]; then
  git -C "${HOME}/code/personal/playground" checkout -- src
fi
