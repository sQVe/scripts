#!/usr/bin/env bash

#  ┏┓╻┏━┓╺┳╸┏━╸┏━┓   ┏━┓┏━╸┏┓╻╺┳┓
#  ┃┗┫┃ ┃ ┃ ┣╸ ┗━┓   ┗━┓┣╸ ┃┗┫ ┃┃
#  ╹ ╹┗━┛ ╹ ┗━╸┗━┛   ┗━┛┗━╸╹ ╹╺┻┛

message="Automatic update ($(hostname))"

identity_count="$(ssh-add -l | wc -l)"
status_count="$(git status --short | wc -l)"

get_system_date() {
  timedatectl | ag 'Universal time' | awk '{print $4}'
}

get_latest_commit_date() {
  git log -1 --format=%ci | awk '{print $1}'
}

get_latest_commit_status() {
  git log -1 --format=%s
}

if [[ identity_count -eq 0 ]]; then
  echo "No SSH identities found. Exiting."
  exit
elif [[ status_count -eq 0 ]]; then
  echo "No file changes. Exiting."
  exit
fi


if [[ "$(get_latest_commit_status)" != "$message" ]] ||
   [[ "$(get_latest_commit_date)" != "$(get_system_date)" ]]; then
  git commit --all --message "$message"
  git push
else
  git commit --all --amend --reuse-message HEAD
  git push --force
fi

git fetch
