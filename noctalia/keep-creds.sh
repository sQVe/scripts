#!/usr/bin/env bash

#  ╻┏ ┏━╸┏━╸┏━┓   ┏━╸┏━┓┏━╸╺┳┓┏━┓
#  ┣┻┓┣╸ ┣╸ ┣━┛╺━╸┃  ┣┳┛┣╸  ┃┃┗━┓
#  ╹ ╹┗━╸┗━╸╹     ┗━╸╹┗╸┗━╸╺┻┛┗━┛
# Toggles extended credential caching (24h GPG/sudo timeout that survives
# screen lock).

set -euo pipefail

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

# Signs locally through the agent, so a GitHub outage cannot fail the check.
sign_with_ssh_key() {
  echo "test" | ssh-keygen -Y sign -f "$1" -n file > /dev/null 2>&1
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

    gpg_key="$(git config --get user.signingkey 2> /dev/null || true)"
    if [[ -z "${gpg_key}" ]]; then
      fail "GPG signing key not configured"
    fi

    if ! echo "test" | gpg --sign -u "${gpg_key}" > /dev/null 2>&1; then
      fail "GPG signing failed"
    fi

    if ! { echo "test" | gpg -e --default-recipient-self | gpg -d; } > /dev/null 2>&1; then
      fail "GPG encryption failed"
    fi

    ssh_public_key="$(mktemp)"
    trap 'rm -f "${ssh_public_key}"' EXIT
    if ! ssh-add -L 2> /dev/null | head -n 1 > "${ssh_public_key}"; then
      fail "No SSH key in agent"
    fi

    if ! "${SCRIPTS}/ssh-unlock.sh" 2> /dev/null; then
      fail "SSH key unlock from pass failed"
    fi

    if ! sign_with_ssh_key "${ssh_public_key}"; then
      fail "SSH signing failed"
    fi

    notify-send -a "Credentials" -i "${icon_ok}" "Credentials extended" "24h cache, survives lock"
    ;;
  off)
    ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${gpg_agent_conf}"
    gpg-connect-agent reloadagent /bye > /dev/null
    notify-send -a "Credentials" -i "${icon_off}" "Credentials reset" "Lock clears cache again"
    ;;
  toggle)
    # A second click while the first still waits on a prompt would see the
    # extended config and switch it off again.
    exec {lock_fd}> "${XDG_RUNTIME_DIR}/keep-creds.lock"
    if ! flock --nonblock "${lock_fd}"; then
      exit 0
    fi

    if [[ "$(readlink "${gpg_agent_conf}")" == *extended* ]]; then
      "$0" off
    else
      "$0" on
    fi
    ;;
esac
