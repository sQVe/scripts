#!/usr/bin/env bash

set -euo pipefail

#  ┏━┓┏━┓╻ ╻   ┏━┓┏━┓┏━┓┏━┓   ┏━┓┏━╸╺┳╸┏━┓╻ ╻
#  ┗━┓┗━┓┣━┫╺━╸┣━┛┣━┫┗━┓┗━┓╺━╸┣┳┛┣╸  ┃ ┣┳┛┗┳┛
#  ┗━┛┗━┛╹ ╹   ╹  ╹ ╹┗━┛┗━┛   ╹┗╸┗━╸ ╹ ╹┗╸ ╹
# GIT_SSH_COMMAND: unlocks the SSH key from pass, then runs ssh. Failures show
# as notifications, because git often runs where no terminal shows its errors.

# ssh exits 255 for its own errors, such as failed authentication. Any other
# status comes from the remote side: GitHub's `ssh -T` exits 1 after a
# successful login because it gives no shell.
ssh_error=255

icon_warn="/usr/share/icons/Papirus/48x48/status/dialog-warning.svg"

targets_github() {
  [[ "$*" == *github.com* ]]
}

github_git_degraded() {
  local git_status
  git_status="$(curl --silent --fail --max-time 5 https://www.githubstatus.com/api/v2/summary.json \
    | jq -r '.components[] | select(.name == "Git Operations") | .status' 2> /dev/null || true)"
  [[ -n "${git_status}" && "${git_status}" != "operational" ]]
}

# A failed unlock leaves ssh to ask through pinentry instead.
"${SCRIPTS}/ssh-unlock.sh" || true

status=0
ssh "$@" || status=$?

if [[ "${status}" -eq "${ssh_error}" ]]; then
  if targets_github "$@" && github_git_degraded; then
    notify-send -a "SSH" -i "${icon_warn}" "GitHub Git operations degraded" "See https://www.githubstatus.com"
  else
    notify-send -a "SSH" -i "${icon_warn}" "SSH failed" "ssh $*"
  fi
fi

exit "${status}"
