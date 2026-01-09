#!/usr/bin/env bash

#  ╻┏ ┏━╸┏━╸┏━┓   ┏━╸┏━┓┏━╸╺┳┓┏━┓
#  ┣┻┓┣╸ ┣╸ ┣━┛╺━╸┃  ┣┳┛┣╸  ┃┃┗━┓
#  ╹ ╹┗━╸┗━╸╹     ┗━╸╹┗╸┗━╸╺┻┛┗━┛
# Toggles extended credential caching (24h GPG/sudo timeout that survives
# screen lock).

set -euo pipefail

flag="${XDG_RUNTIME_DIR}/keep-creds"
gpg_agent_conf="${HOME}/.gnupg/gpg-agent.conf"

case "${1:-}" in
  on)
    rm -f "${gpg_agent_conf}"
    ln -sf "${DOTFILES}/gnupg/gpg-agent-extended.conf" "${gpg_agent_conf}"
    touch "${flag}"
    gpg-connect-agent reloadagent /bye > /dev/null
    notify-send -i /usr/share/icons/Papirus/48x48/status/changes-allow.svg "Creds extended" "24h cache, survives lock"
    ;;
  off)
    ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${gpg_agent_conf}"
    rm -f "${flag}"
    gpg-connect-agent reloadagent /bye > /dev/null
    notify-send -i /usr/share/icons/Papirus/48x48/status/changes-prevent.svg "Creds normal" "Lock clears cache again"
    ;;
  toggle)
    if [[ -f "${flag}" ]]; then
      "$0" off
    else
      "$0" on
    fi
    ;;
  json)
    if [[ -f "${flag}" ]]; then
      echo '{"icon": "shield", "tooltip": "Keep creds: on"}'
    else
      echo '{"icon": "shield-off", "tooltip": "Keep creds: off"}'
    fi
    ;;
esac
