#!/usr/bin/env bash

#  ┏━┓┏━┓┏━┓╺┳╸   ┏┳┓┏┓ ┏━┓╻ ╻┏┓╻┏━╸
#  ┣━┛┃ ┃┗━┓ ┃    ┃┃┃┣┻┓┗━┓┗┳┛┃┗┫┃
#  ╹  ┗━┛┗━┛ ╹    ╹ ╹┗━┛┗━┛ ╹ ╹ ╹┗━╸

contacts_db="$HOME/.lbdb/m_inmail.utf-8"
mail_directory="$XDG_DATA_HOME/mail"
mailboxes=("$mail_directory"/*)
new_mailboxes=("$mail_directory"/*/Inbox/new)
timestamp="$mail_directory/sync-timestamp"

function find() {
  command find "$@" -type f \( ! -iname ".*" \) -newer "$timestamp" 2>/dev/null
}

function decode() {
  perl -C -MEncode -E 'print decode("MIME-Header", <>)' <<<"$1"
}

# Set initial timestamp.
if [[ ! -e "$timestamp" ]]; then
  touch "$timestamp"
fi

# New mails since last sync.
new_mails=$(find "${new_mailboxes[@]}")
new_mail_count=$(echo "$new_mails" | wc -l)

# Mails since last sync.
mails=$(find "${mailboxes[@]}")
mail_count=$(echo "$mails" | wc -l)

# Update timestamp.
touch "$timestamp"

# Handle new mail.
if [[ $new_mail_count -gt 0 ]]; then
  for mail in $new_mails; do
    if [[ -e "$mail" ]]; then
      from=$(rg '^From:' <"$mail" | sed -r 's/From: (.+?)\s*<.+/\1/' | sed -r 's/"//g')
      subject=$(rg '^Subject:' <"$mail" | cut -d ' ' -f 2-)

      notify-send -i evolution-mail "Mail from $(decode "${from:-Unknown}")" "$(decode "$subject")"
    fi
  done

  # Trigger mail blocklet rerender.
  pkill -RTMIN+12 i3blocks
fi

# Handle mail since last sync.
if [[ $mail_count -gt 0 ]]; then
  while read -r mail; do
    if [[ -e "$mail" ]]; then
      lbdb-fetchaddr -d "%Y-%m-%d" <"$mail"
    fi
  done <<<"$mails"

  # Update local mail database.
  notmuch new &>/dev/null

  # Sort and trim contacts database.
  sort -u "$contacts_db" -o "$contacts_db"
fi
