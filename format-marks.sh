#!/usr/bin/env bash

#  ┏━╸┏━┓┏━┓┏┳┓┏━┓╺┳╸   ┏┳┓┏━┓┏━┓╻┏ ┏━┓
#  ┣╸ ┃ ┃┣┳┛┃┃┃┣━┫ ┃    ┃┃┃┣━┫┣┳┛┣┻┓┗━┓
#  ╹  ┗━┛╹┗╸╹ ╹╹ ╹ ╹    ╹ ╹╹ ╹╹┗╸╹ ╹┗━┛

bookmarks="$DOTFILES/config/qutebrowser/bookmarks/urls"
quickmarks="$DOTFILES/config/qutebrowser/quickmarks"

command nvim "$bookmarks" "+%sort /\v^.{-}\s+/ u" "+%EasyAlign \ " "+wq"
command nvim "$quickmarks" "+%sort u" "+%EasyAlign \ " "+wq"
