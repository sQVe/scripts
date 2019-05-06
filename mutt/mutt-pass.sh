#!/usr/bin/env bash

#  ┏┳┓╻ ╻╺┳╸╺┳╸   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┃ ┃ ┃  ┃    ┣━┛┣━┫┗━┓┗━┓
#  ╹ ╹┗━┛ ╹  ╹    ╹  ╹ ╹┗━┛┗━┛

password=$(secret-tool lookup mutt "$1")

echo "set smtp_pass=\"$password\""
echo "set imap_pass=\"$password\""
