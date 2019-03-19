#!/usr/bin/env bash

#  ┏┳┓╻ ╻╺┳╸╺┳╸   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┃ ┃ ┃  ┃    ┣━┛┣━┫┗━┓┗━┓
#  ╹ ╹┗━┛ ╹  ╹    ╹  ╹ ╹┗━┛┗━┛

password=$(pass show "$1")

echo "set smtp_pass=\"$password\""
echo "set imap_pass=\"$password\""
