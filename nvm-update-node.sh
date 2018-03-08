#!/usr/bin/env bash

source /usr/share/nvm/nvm.sh --no-use

current_version=$(nvm current)
nvm install node --reinstall-packages-from="$current_version"
nvm uninstall "$current_version"
