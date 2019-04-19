#!/usr/bin/env bash

#  ┏┓╻┏━┓╺┳╸┏━╸┏━┓   ┏━┓┏━╸┏┓╻╺┳┓
#  ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓   ┗━┓┣╸ ┃┗┫ ┃┃
#  ╹ ╹┗━┛ ╹ ┗━╸┗━┛   ┗━┛┗━╸╹ ╹╺┻┛

message="Automatic update ($(hostname))"

identity_count=$(ssh-add -l | wc -l)
status_count=$(git status --short | wc -l)
unpushed_commit_count="$(git diff --name-status origin/master..HEAD | wc -l)"

latest_commit_date="$(git log -1 --format=%ci | awk '{print $1}')"
latest_commit_status="$(git log -1 --format=%s)"
system_date="$(timedatectl | rg 'Universal time' | awk '{print $4}')"

if [[ identity_count -eq 0 ]]; then
  echo "No SSH identities found. Exiting."
  exit
elif [[ status_count -eq 0 ]] && [[ unpushed_commit_count -eq 0 ]]; then
  echo "No file changes or unpushed commits. Exiting."
  exit
fi

# Ensure that the branch is up-to-date.
git fetch && git merge --ff-only

if [[ "$latest_commit_status" != "$message" ]] ||
   [[ "$latest_commit_date" != "$system_date" ]]; then
  # New daily commit.
  git commit --all --message "$message"
  git push
else
  # Amend to existing daily commit.
  git commit --all --amend --allow-empty --reuse-message HEAD
  git push --force
fi

git merge --ff-only
