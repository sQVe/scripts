#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸┏━┓╻  ┏━╸╻ ╻╻  ┏━┓╺┳╸┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┃  ┣━┫┃  ┃  ┃ ┃┃  ┣━┫ ┃ ┃ ┃┣┳┛
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸╹ ╹┗━╸┗━╸┗━┛┗━╸╹ ╹ ╹ ┗━┛╹┗╸

rofi -show calc -modi calc -no-show-match -no-sort -terse -calc-command "echo -n '{result}' | xsel -ib"
