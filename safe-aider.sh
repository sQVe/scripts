#!/usr/bin/env bash

# ┏━┓┏━┓┏━╸┏━╸   ┏━┓╻╺┳┓┏━╸┏━┓
# ┗━┓┣━┫┣╸ ┣╸    ┣━┫┃ ┃┃┣╸ ┣┳┛
# ┗━┛╹ ╹╹  ┗━╸   ╹ ╹╹╺┻┛┗━╸╹┗╸
# Ensure that aider is only run from a git repository.

# Check if the current directory is within a git repository.

if git rev-parse --is-inside-work-tree &> /dev/null; then
  aider "$@"
else
  echo "Cannot run aider from outside a git repository."
fi
