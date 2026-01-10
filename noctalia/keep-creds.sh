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

case "${1:-}" in
  on)
    extended_conf="${DOTFILES}/gnupg/gpg-agent-extended.conf"
    if [[ ! -f "${extended_conf}" ]]; then
      notify-send -i "${icon_warn}" "Credential caching failed" "Config not found: ${extended_conf}"
      exit 1
    fi

    ln -sf "${extended_conf}" "${gpg_agent_conf}"
    if ! gpg-connect-agent reloadagent /bye > /dev/null 2>&1; then
      notify-send -i "${icon_warn}" "Credential caching failed" "GPG agent reload failed"
      exit 1
    fi
    touch "${flag}"

    # Cache credentials (track failures)
    failures=()

    # GPG signing key from git config
    gpg_key="$(git config --get user.signingkey 2>/dev/null || true)"
    if [[ -n "${gpg_key}" ]]; then
      if ! echo "test" | gpg --sign -u "${gpg_key}" > /dev/null 2>&1; then
        failures+=("GPG")
      fi
    else
      failures+=("GPG (no key configured)")
    fi

    # SSH authentication key (check output, not exit code - GitHub exits 1 on success)
    ssh_output=$("${SCRIPTS}/ssh-pass-retry.sh" -T git@github.com 2>&1 || true)
    if [[ ! "${ssh_output}" =~ "successfully authenticated" ]]; then
      failures+=("SSH")
    fi

    if [[ ${#failures[@]} -eq 0 ]]; then
      notify-send -i "${icon_ok}" "Credentials extended" "24h cache, survives lock"
    else
      notify-send -i "${icon_warn}" "Credentials partially extended" "Failed: ${failures[*]}"
    fi
    ;;
  off)
    ln -sf "${DOTFILES}/gnupg/gpg-agent.conf" "${gpg_agent_conf}"
    rm -f "${flag}"
    gpg-connect-agent reloadagent /bye > /dev/null
    notify-send -i "${icon_off}" "Credentials reset" "Lock clears cache again"
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
