#!/usr/bin/env bash

#  ┏┓╻╻ ╻┏┳┓   ╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
#  ┃┗┫┃┏┛┃┃┃╺━╸┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
#  ╹ ╹┗┛ ╹ ╹   ╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

# Ensure that nvm is loaded.
source /usr/share/nvm/nvm.sh --no-use

g='\033[0;32m'
p='\033[0;35m'
c='\033[0m'

gist_id="69cc6046233317c6199cca35a41dee1e"

get_installed_versions() {
  [[ -z $versions ]] && versions=$(nvm ls | rg -v 'N/A' | rg -o 'v[0-9\.]*' | sort -uV)
  rg "v$1" <<< "$versions"
}

get_latest_installed_version() {
  get_installed_versions "$1" | rg "$1" | tail -n 1
}

get_major_version() {
  sed -r 's/v?([0-9]+).*/\1/' <<< "$1"
}

check_answer() {
  if [[ -n "$1" ]] && [[ ! "$1" =~ ^[Yy](es)?$ ]]; then
    return 1;
  fi
}

help() {
  echo "Usage: $(basename "$0") [OPTION]... [VERSION]"
  echo "NVM handler that installs latest major VERSION and uninstalls prior versions."
  echo ""
  echo "  -b, --backup          Backup globally installed dependencies to Gist"
  echo "  -c, --clean           Install without dependency reinstall"
  echo "  -h, --help            Display this help"
  echo "  -r, --restore         Restore dependencies from Gist backup"
  echo "  -s, --solo            Uninstall all but latest"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") 9      Solo install latest major 9 release."
  echo ""
}

backup() {
  nvm use "$major_version"
  npm list -g --depth=0 | rg -o '\S+@\S+$' | sort | gist -f global-npm-packages.txt -u "$gist_id"
}

install() {
  echo -en "Installing latest major ${p}$1${c} release"

  if [[ -z "$2" ]]; then
    echo ""
    nvm install "$1"
  else
    echo -e ", reinstalling packages from ${g}$2${c}"
    nvm install "$1" --reinstall-packages-from="$2" 2> /dev/null || echo -e "Skipping: ${g}$2${c} is the latest major ${p}$1${c} release"
  fi
}

solo() {
  if [[ "$(get_installed_versions "$major_version" | wc -l )" -gt 1 ]]; then
    echo -en "Do you want to uninstall all major ${p}$major_version${c} releases, except ${g}$(get_latest_installed_version "$major_version")${c}? [Y/n] "
    read -r answer

    if check_answer "$answer"; then
      nvm use "$major_version" &> /dev/null
      for installation in $(get_installed_versions "$major_version" | head -n -1); do nvm uninstall "$installation"; done
    fi
  fi
}

restore() {
  for dependency in $(gist -r "$gist_id"); do
    echo -e "Installing dependency ${p}$dependency${c}..."
    npm install -g "$dependency" > /dev/null
  done
}

# Read options.
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -b | --backup ) option="backup" ;;
    -c | --clean ) option="clean" ;;
    -h | --help ) help; exit ;;
    -s | --solo ) option="solo" ;;
    -r | --restore ) option="restore" ;;
    * ) version="$1"; break ;;
  esac
  shift
done

[[ -z "$version" ]] && version=$(nvm current)
major_version=$(get_major_version "$version")
latest_installed_version=$(get_latest_installed_version "$major_version")

# Run option command and exit if successful.
[[ -n "$option" ]] && eval "$option" 2> /dev/null && exit

# Install new major version.
if [[ "$major_version" != "$latest_installed_version" ]]; then
  if [[ "$option" == "clean" ]]; then install "$major_version"
  else install "$major_version" "$latest_installed_version"
  fi

  solo
fi
