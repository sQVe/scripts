#!/usr/bin/env bash

#  ┏━╸╻╺┳╸   ╻ ╻┏━┓┏━╸┏━┓┏━┓
#  ┃╺┓┃ ┃    ┃ ┃┗━┓┣╸ ┣┳┛┗━┓
#  ┗━┛╹ ╹    ┗━┛┗━┛┗━╸╹┗╸┗━┛

#  This script assumes that there is a config file in $HOME named
#  .gitusers with the following format:
#
#  keyword
#    name: John Doe
#    email: johndoe@example.com

#  ------------------------------------------------------------------

#  To automatically run the script on PWD change add the following to
#  your bashrc/zshrc:
#
#  function chpwd() {
#    emulate -L zsh
#    $HOME/gitusers.sh
#  }

gitusers="$HOME/.gitusers"

get_credentials() {
  echo "$data" | grep "$1:" | cut -d ':'  -f2- | sed -e 's/^\s*//'
}

# Escape if no .gitusers file found.
if [[ ! -f $gitusers ]]; then
  echo "No .gitusers file found in \`$HOME\`"
  exit 1
fi

# Escape if we're not in a git repo.
if [[ -z $(git rev-parse --git-dir 2> /dev/null) ]]; then
  exit 0
fi

# Grab user keywords only.
mapfile -t keywords < <(grep '^\w\+' "$gitusers" )

for keyword in "${keywords[@]}"; do
  # Check if PWD matches one of our keywords.
  if [[ $PWD =~ /$keyword/ ]]; then
    data=$(grep -A 2 "^$keyword" "$gitusers")
    name=$(get_credentials "name")
    email=$(get_credentials "email")

    # Only set the user credentials if they are available.
    if [[ -n $name && -n $email ]]; then
      git config user.name "$name"
      git config user.email "$email"
    fi

    exit 0
  fi
done
