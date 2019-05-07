#!/usr/bin/env bash

#  ┏━┓┏━┓┏━┓╻ ╻┏━┓╻  ┏━┓╺┳╸┏━╸   ╻  ┏┓ ╺┳┓┏┓
#  ┣━┛┃ ┃┣━┛┃ ┃┣━┛┃  ┣━┫ ┃ ┣╸    ┃  ┣┻┓ ┃┃┣┻┓
#  ╹  ┗━┛╹  ┗━┛╹  ┗━╸╹ ╹ ╹ ┗━╸   ┗━╸┗━┛╺┻┛┗━┛

mail_directory="$HOME/.local/share/mail"
mails=$(fd --type f --changed-within "3 months" . "$mail_directory")
db="$HOME/.lbdb/m_inmail.utf-8"

while read -r mail; do
  echo "Parsing $mail..."
  lbdb-fetchaddr -d "%Y-%m-%d" < "$mail"
done <<< "$mails"

sort -o "$db" -u "$db"
