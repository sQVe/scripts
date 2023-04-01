#!/usr/bin/env bash

#  ╺┳┓┏━╸┏━╸┏━┓╻ ╻╻  ╺┳╸   ┏┓╻┏━┓╺┳┓┏━╸   ╻ ╻┏━╸┏━┓┏━┓╻┏━┓┏┓╻
#   ┃┃┣╸ ┣╸ ┣━┫┃ ┃┃   ┃    ┃┗┫┃ ┃ ┃┃┣╸    ┃┏┛┣╸ ┣┳┛┗━┓┃┃ ┃┃┗┫
#  ╺┻┛┗━╸╹  ╹ ╹┗━┛┗━╸ ╹    ╹ ╹┗━┛╺┻┛┗━╸   ┗┛ ┗━╸╹┗╸┗━┛╹┗━┛╹ ╹

base_path="${NVM_DIR}/versions/node"
default_version=$(< "${NVM_DIR}/alias/default")
versions=("${base_path}"/v*)

if [[ -n "${default_version}" ]]; then
  default_version_path="${base_path}/${default_version}"
  if [[ -d "${default_version_path}" ]]; then
    version="${default_version}"
  fi
fi

if [[ -z "${version}" ]]; then
  version=$(basename "${versions[-1]}")
fi

printf "%s/%s/bin\n" "${base_path}" "${version}"
