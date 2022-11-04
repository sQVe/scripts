#!/usr/bin/env bash

#  ┏━┓┏━╸╻┏┓╻┏━┓╺┳╸┏━┓╻  ╻     ┏━╸╻╺┳╸   ┏━┓┏━┓┏━╸╻┏ ┏━┓┏━╸┏━╸┏━┓
#  ┣┳┛┣╸ ┃┃┗┫┗━┓ ┃ ┣━┫┃  ┃     ┃╺┓┃ ┃    ┣━┛┣━┫┃  ┣┻┓┣━┫┃╺┓┣╸ ┗━┓
#  ╹┗╸┗━╸╹╹ ╹┗━┛ ╹ ╹ ╹┗━╸┗━╸   ┗━┛╹ ╹    ╹  ╹ ╹┗━╸╹ ╹╹ ╹┗━┛┗━╸┗━┛

# shellcheck disable=SC2046
# Do not warn about word splitting.

paru -S $(paru -Qqs git | rg '\w+\-git$')
