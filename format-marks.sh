#!/usr/bin/env bash

#  ┏━╸┏━┓┏━┓┏┳┓┏━┓╺┳╸   ┏┳┓┏━┓┏━┓╻┏ ┏━┓
#  ┣╸ ┃ ┃┣┳┛┃┃┃┣━┫ ┃    ┃┃┃┣━┫┣┳┛┣┻┓┗━┓
#  ╹  ┗━┛╹┗╸╹ ╹╹ ╹ ╹    ╹ ╹╹ ╹╹┗╸╹ ╹┗━┛

bookmarks="$HOME/.dotfiles/config/qutebrowser/bookmarks/urls"
quickmarks="$HOME/.dotfiles/config/qutebrowser/quickmarks"

command nvim "$bookmarks" "+ %sort /\v^.{-}\s+/ u | %EasyAlign \ " "+wq"
command nvim "$quickmarks" "+%sort u | %EasyAlign \ " "+wq"
