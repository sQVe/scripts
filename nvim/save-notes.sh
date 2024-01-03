#!/usr/bin/env bash

# ┏━┓┏━┓╻ ╻┏━╸   ┏┓╻┏━┓╺┳╸┏━╸┏━┓
# ┗━┓┣━┫┃┏┛┣╸    ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓
# ┗━┛╹ ╹┗┛ ┗━╸   ╹ ╹┗━┛ ╹ ┗━╸┗━┛

set -euo pipefail

cd "${NOTES}" || exit

commit_message_prompt="Write short commit message based on given diff output. Subject line should be 50 characters or less."

identity_count=$(ssh-add -l | wc -l)
status_count=$(git status --short | wc -l)

if [[ identity_count -eq 0 ]]; then
  echo "No SSH identities found. Exiting."
  exit
elif [[ status_count -eq 0 ]]; then
  echo "No file changes. Exiting."
  exit
fi

# Ensure that the branch is up-to-date.
git fetch && git merge --ff-only

# Add all new files.
git add .

commit_message=$(git diff --no-ext-diff --cached | sgpt "${commit_message_prompt}")

if [[ -z "${commit_message}" ]]; then
  echo "No commit message. Exiting."
  git checkout -- .
  exit
fi

git commit --no-gpg-sign --all --message "${commit_message}"
git push
git merge --ff-only

notify-send 'Notes saved'
