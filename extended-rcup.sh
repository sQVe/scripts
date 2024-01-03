#!/usr/bin/env bash

#  ┏━╸╻ ╻╺┳╸┏━╸┏┓╻╺┳┓┏━╸╺┳┓   ┏━┓┏━╸╻ ╻┏━┓
#  ┣╸ ┏╋┛ ┃ ┣╸ ┃┗┫ ┃┃┣╸  ┃┃   ┣┳┛┃  ┃ ┃┣━┛
#  ┗━╸╹ ╹ ╹ ┗━╸╹ ╹╺┻┛┗━╸╺┻┛   ╹┗╸┗━╸┗━┛╹

# This script is needed due to rcm not supporting moving dotted files.

rcup "$@"

# Only create custom symlinks when script has no arguments.
if [[ $# -eq 0 ]]; then
  ln -s "$DOTFILES/config/zsh/zimrc" "$XDG_CONFIG_HOME/zsh/.zimrc"
  ln -s "$DOTFILES/config/zsh/zshenv" "$XDG_CONFIG_HOME/zsh/.zshenv"
  ln -s "$DOTFILES/config/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"

  ln -s "$DOTFILES/notes/.obsidian/app.json" "$NOTES/.obsidian/app.json"
  ln -s "$DOTFILES/notes/.obsidian/appearance.json" "$NOTES/.obsidian/appearance.json"
  ln -s "$DOTFILES/notes/.obsidian/backlink.json" "$NOTES/.obsidian/backlink.json"
  ln -s "$DOTFILES/notes/.obsidian/community-plugins.json" "$NOTES/.obsidian/community-plugins.json"
  ln -s "$DOTFILES/notes/.obsidian/core-plugins.json" "$NOTES/.obsidian/core-plugins.json"
  ln -s "$DOTFILES/notes/.obsidian/templates.json" "$NOTES/.obsidian/templates.json"
  ln -s "$DOTFILES/notes/.obsidian/zk-prefixer.json" "$NOTES/.obsidian/zk-prefixer.json"
fi
