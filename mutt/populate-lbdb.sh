#!/usr/bin/env bash

#  ┏━┓┏━┓┏━┓╻ ╻┏━┓╻  ┏━┓╺┳╸┏━╸   ╻  ┏┓ ╺┳┓┏┓
#  ┣━┛┃ ┃┣━┛┃ ┃┣━┛┃  ┣━┫ ┃ ┣╸    ┃  ┣┻┓ ┃┃┣┻┓
#  ╹  ┗━┛╹  ┗━┛╹  ┗━╸╹ ╹ ╹ ┗━╸   ┗━╸┗━┛╺┻┛┗━┛

contacts_db="$HOME/.lbdb/m_inmail.utf-8"
mail_directory="$HOME/.local/share/mail"
mails=$(fd --type f --changed-within "3 months" . "$mail_directory")

while read -r mail; do
  echo "Parsing $mail..."
  lbdb-fetchaddr -d "%Y-%m-%d" <"$mail"
done <<<"$mails"

sort -o "$contacts_db" -u "$contacts_db"
