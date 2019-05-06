#!/usr/bin/env bash

#  ┏━┓┏━┓┏━┓╺┳╸   ┏┳┓┏┓ ┏━┓╻ ╻┏┓╻┏━╸
#  ┣━┛┃ ┃┗━┓ ┃    ┃┃┃┣┻┓┗━┓┗┳┛┃┗┫┃
#  ╹  ┗━┛┗━┛ ╹    ╹ ╹┗━┛┗━┛ ╹ ╹ ╹┗━╸

mail_directory="$HOME/.local/share/mail"
new_mail_directories=("$mail_directory"/*/Inbox/new)
timestamp="$mail_directory/sync-timestamp"

decode() {
  perl -C -MEncode -E 'print decode("MIME-Header", <>)' <<< "$1"
}

# Set initial timestamp.
if [[ ! -e "$timestamp" ]]; then
  touch "$timestamp"
fi

new_mails=$(find "${new_mail_directories[@]}" -type f -newer "$timestamp" 2> /dev/null)
new_mail_count=$(echo "$new_mails" | wc -l)

# Handle new mail.
if [[ $new_mail_count -gt 0 ]]; then
  for mail in $new_mails; do
    from=$(rg '^From:' < "$mail" | sed -r 's/From: (.+?)\s*<.+/\1/' | sed -r 's/"//g')
    subject=$(rg '^Subject:' < "$mail" | cut -d ' ' -f 2-)

    notify-send -i evolution-mail "Mail from $(decode "${from:-Unknown}")" "$(decode "$subject")"
  done

  # Trigger mail blocklet rerender.
  pkill -RTMIN+12 i3blocks

  # Update timestamp.
  touch "$timestamp"

  # Update local mail database.
  notmuch new &> /dev/null
fi
