#!/usr/bin/env bash

set -euo pipefail

#  ╺┳┓┏━╸┏━╸┏━┓╻ ╻╻  ╺┳╸   ┏┓╻┏━┓╺┳┓┏━╸   ╻ ╻┏━╸┏━┓┏━┓╻┏━┓┏┓╻
#   ┃┃┣╸ ┣╸ ┣━┫┃ ┃┃   ┃    ┃┗┫┃ ┃ ┃┃┣╸    ┃┏┛┣╸ ┣┳┛┗━┓┃┃ ┃┃┗┫
#  ╺┻┛┗━╸╹  ╹ ╹┗━┛┗━╸ ╹    ╹ ╹┗━┛╺┻┛┗━╸   ┗┛ ┗━╸╹┗╸┗━┛╹┗━┛╹ ╹

shopt -s nullglob

base_path="${NVM_DIR}/versions/node"
default_version=$(< "${NVM_DIR}/alias/default")
versions=("${base_path}"/v*)
version=""

if [[ -n "${default_version}" ]]; then
  default_version_path="${base_path}/${default_version}"
  if [[ -d "${default_version_path}" ]]; then
    version="${default_version}"
  fi
fi

if [[ -z "${version}" ]]; then
  if [[ ${#versions[@]} -eq 0 ]]; then
    printf "No node versions found in %s\n" "${base_path}" >&2
    exit 1
  fi

  version=$(basename "${versions[-1]}")
fi

printf "%s/%s/bin\n" "${base_path}" "${version}"
