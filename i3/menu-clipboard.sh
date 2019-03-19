#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸╻  ╻┏━┓┏┓ ┏━┓┏━┓┏━┓╺┳┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃  ┃  ┃┣━┛┣┻┓┃ ┃┣━┫┣┳┛ ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸┗━╸╹╹  ┗━┛┗━┛╹ ╹╹┗╸╺┻┛

rofi -modi 'clipboard:greenclip print' -run-command '{cmd}' -show clipboard
