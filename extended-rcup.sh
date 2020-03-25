#!/usr/bin/env bash

#  ┏━╸╻ ╻╺┳╸┏━╸┏┓╻╺┳┓┏━╸╺┳┓   ┏━┓┏━╸╻ ╻┏━┓
#  ┣╸ ┏╋┛ ┃ ┣╸ ┃┗┫ ┃┃┣╸  ┃┃   ┣┳┛┃  ┃ ┃┣━┛
#  ┗━╸╹ ╹ ╹ ┗━╸╹ ╹╺┻┛┗━╸╺┻┛   ╹┗╸┗━╸┗━┛╹

# This script is needed due to rcm not supporting moving dotted files.

rcup "$@"

# Only create custom symlinks when script has no arguments.
if [[ -z "$*" ]]; then
  ln -s "$DOTFILES/config/zsh/zimrc" "$XDG_CONFIG_HOME/zsh/.zimrc"
  ln -s "$DOTFILES/config/zsh/zshenv" "$XDG_CONFIG_HOME/zsh/.zshenv"
  ln -s "$DOTFILES/config/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"

fi
