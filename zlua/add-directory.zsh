#!/usr/bin/env zsh

#  ┏━┓╺┳┓╺┳┓   ╺┳┓╻┏━┓┏━╸┏━╸╺┳╸┏━┓┏━┓╻ ╻
#  ┣━┫ ┃┃ ┃┃    ┃┃┃┣┳┛┣╸ ┃   ┃ ┃ ┃┣┳┛┗┳┛
#  ╹ ╹╺┻┛╺┻┛   ╺┻┛╹╹┗╸┗━╸┗━╸ ╹ ┗━┛╹┗╸ ╹

eval "$(lua $ZIM_HOME/modules/z.lua/z.lua --init zsh)"

z --add $@
