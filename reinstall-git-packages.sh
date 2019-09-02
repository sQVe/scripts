#!/usr/bin/env bash

#  ┏━┓┏━╸╻┏┓╻┏━┓╺┳╸┏━┓╻  ╻     ┏━╸╻╺┳╸   ┏━┓┏━┓┏━╸╻┏ ┏━┓┏━╸┏━╸┏━┓
#  ┣┳┛┣╸ ┃┃┗┫┗━┓ ┃ ┣━┫┃  ┃     ┃╺┓┃ ┃    ┣━┛┣━┫┃  ┣┻┓┣━┫┃╺┓┣╸ ┗━┓
#  ╹┗╸┗━╸╹╹ ╹┗━┛ ╹ ╹ ╹┗━╸┗━╸   ┗━┛╹ ╹    ╹  ╹ ╹┗━╸╹ ╹╹ ╹┗━┛┗━╸┗━┛

# shellcheck disable=SC2046
# Do not warn about word splitting.

yay -S $(yay -Qqs git | rg '\w+\-git$')
