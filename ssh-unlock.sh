#!/usr/bin/env bash

# Unlocks the SSH keys in gpg-agent with the passphrase from pass, so ssh does
# not prompt for it. Decrypting the pass entry prompts for the GPG passphrase
# only when gpg-agent has not cached it.
#
# Writes nothing to stdout: git runs this before ssh and reads its protocol
# from stdout.

set -euo pipefail

gpg_agent_conf="${GNUPGHOME:-${HOME}/.gnupg}/gpg-agent.conf"
pass_entry="ssh/$(uname -n)"

uncached_ssh_keygrips() {
  gpg-connect-agent 'keyinfo --ssh-list' /bye \
    | awk '$2 == "KEYINFO" && $7 != "1" { print $3 }'
}

# gpg-agent never expires a preset passphrase, so a timer clears it after the
# longest SSH cache time the active config allows.
schedule_clear() {
  local keygrip="$1"
  local pid_file="${XDG_RUNTIME_DIR}/ssh-unlock-${keygrip}.pid"
  local ttl

  ttl="$(awk '$1 == "max-cache-ttl-ssh" { print $2 }' "${gpg_agent_conf}")"
  # gpg-agent's own default for max-cache-ttl-ssh.
  ttl="${ttl:-7200}"

  # Stopping only the timer's shell would leave its sleep running.
  if [[ -f "${pid_file}" ]]; then
    pkill --parent "$(< "${pid_file}")" 2> /dev/null || :
    kill "$(< "${pid_file}")" 2> /dev/null || :
  fi

  (sleep "${ttl}" && gpg-connect-agent "CLEAR_PASSPHRASE --mode=ssh ${keygrip}" /bye) > /dev/null 2>&1 < /dev/null &
  echo $! > "${pid_file}"
}

mapfile -t keygrips < <(uncached_ssh_keygrips)
if [[ ${#keygrips[@]} -eq 0 ]]; then
  exit 0
fi

passphrase_hex="$(pass show "${pass_entry}" | sed -n 1p | tr -d '\n' | od -An -tx1 | tr -d ' \n')"
if [[ -z "${passphrase_hex}" ]]; then
  echo "ssh-unlock: ${pass_entry} has an empty first line" >&2
  exit 1
fi

for keygrip in "${keygrips[@]}"; do
  response="$(printf 'PRESET_PASSPHRASE %s -1 %s\n' "${keygrip}" "${passphrase_hex}" | gpg-connect-agent)"
  if [[ "${response}" != OK* ]]; then
    echo "ssh-unlock: gpg-agent refused the passphrase: ${response}" >&2
    exit 1
  fi

  schedule_clear "${keygrip}"
done
