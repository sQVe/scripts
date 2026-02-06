#!/usr/bin/env bash

#  ╻┏ ┏━╸┏━╸┏━┓   ┏━╸┏━┓┏━╸╺┳┓┏━┓
#  ┣┻┓┣╸ ┣╸ ┣━┛╺━╸┃  ┣┳┛┣╸  ┃┃┗━┓
#  ╹ ╹┗━╸┗━╸╹     ┗━╸╹┗╸┗━╸╺┻┛┗━┛
# Toggles extended credential caching (24h GPG/sudo timeout that survives
# screen lock).

set -euo pipefail

flag="${XDG_RUNTIME_DIR}/keep-creds"
gpg_agent_conf="${HOME}/.gnupg/gpg-agent.conf"

icon_ok="/usr/share/icons/Papirus/48x48/status/changes-allow.svg"
icon_warn="/usr/share/icons/Papirus/48x48/status/dialog-warning.svg"
icon_off="/usr/share/icons/Papirus/48x48/status/changes-prevent.svg"

revert() {
  ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${gpg_agent_conf}"
  gpg-connect-agent reloadagent /bye > /dev/null 2>&1 || true
}

fail() {
  revert
  notify-send -a "Credentials" -i "${icon_warn}" "Credential caching failed" "$1"
  exit 1
}

case "${1:-}" in
  on)
    extended_conf="${DOTFILES}/gnupg/gpg-agent-extended.conf"
    if [[ ! -f "${extended_conf}" ]]; then
      notify-send -a "Credentials" -i "${icon_warn}" "Credential caching failed" "Config not found: ${extended_conf}"
      exit 1
    fi

    ln -sf "${extended_conf}" "${gpg_agent_conf}"
    if ! gpg-connect-agent reloadagent /bye > /dev/null 2>&1; then
      fail "GPG agent reload failed"
    fi

    gpg_key="$(git config --get user.signingkey 2>/dev/null || true)"
    if [[ -z "${gpg_key}" ]]; then
      fail "GPG signing key not configured"
    fi

    if ! echo "test" | gpg --sign -u "${gpg_key}" > /dev/null 2>&1; then
      fail "GPG signing failed"
    fi

    if ! { echo "test" | gpg -e --default-recipient-self | gpg -d; } >/dev/null 2>&1; then
      fail "GPG encryption failed"
    fi

    ssh_output=$("${SCRIPTS}/ssh-pass-retry.sh" -T git@github.com 2>&1 || true)
    if [[ ! "${ssh_output}" =~ "successfully authenticated" ]]; then
      fail "SSH authentication failed"
    fi

    touch "${flag}"
    notify-send -a "Credentials" -i "${icon_ok}" "Credentials extended" "24h cache, survives lock"
    ;;
  off)
    ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${gpg_agent_conf}"
    rm -f "${flag}"
    gpg-connect-agent reloadagent /bye > /dev/null
    notify-send -a "Credentials" -i "${icon_off}" "Credentials reset" "Lock clears cache again"
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
      echo '{"icon": "shield", "tooltip": "Keep credentials: on"}'
    else
      echo '{"icon": "shield-off", "tooltip": "Keep credentials: off"}'
    fi
    ;;
esac
