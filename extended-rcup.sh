#!/usr/bin/env bash

set -euo pipefail

#  ┏━╸╻ ╻╺┳╸┏━╸┏┓╻╺┳┓┏━╸╺┳┓   ┏━┓┏━╸╻ ╻┏━┓
#  ┣╸ ┏╋┛ ┃ ┣╸ ┃┗┫ ┃┃┣╸  ┃┃   ┣┳┛┃  ┃ ┃┣━┛
#  ┗━╸╹ ╹ ╹ ┗━╸╹ ╹╺┻┛┗━╸╺┻┛   ╹┗╸┗━╸┗━┛╹

# This script is needed due to rcm not supporting moving dotted files.

rcup "$@"

# Only create custom symlinks when script has no arguments.
if [[ $# -eq 0 ]]; then
  ln -sf "${DOTFILES}/config/zsh/zimrc" "${XDG_CONFIG_HOME}/zsh/.zimrc"
  ln -sf "${DOTFILES}/config/zsh/zshenv" "${XDG_CONFIG_HOME}/zsh/.zshenv"
  ln -sf "${DOTFILES}/config/zsh/zshrc" "${XDG_CONFIG_HOME}/zsh/.zshrc"
fi
