

#  ╻┏┳┓┏━┓┏━┓   ┏━┓┏━┓┏━┓╺┳╸   ┏━┓╻ ╻┏┓╻┏━╸
#  ┃┃┃┃┣━┫┣━┛   ┣━┛┃ ┃┗━┓ ┃    ┗━┓┗┳┛┃┗┫┃
#  ╹╹ ╹╹ ╹╹     ╹  ┗━┛┗━┛ ╹    ┗━┛ ╹ ╹ ╹┗━╸

timestamp="/tmp/imap-post-sync-timestamp"
mail_directory="$HOME/.mail/$1/Inbox/new"

decode() {
  perl -C -MEncode -E 'print decode("MIME-Header", <>)' <<< "$1"
}

# Set initial timestamp.
if [[ ! -e "$timestamp" ]]; then
  touch "$timestamp"
fi

mails=$(find "$mail_directory" -type f -newer "$timestamp" 2> /dev/null)
mail_count=$(echo "$mails" | wc -l)


if [[ $mail_count -gt 0 ]]; then
  for mail in $mails; do
    echo "$mail"
    from=$(ag '^From:' < "$mail" | sed -r 's/From: (.+?)\s*<.+/\1/' | sed -r 's/"//g')
    subject=$(ag '^Subject:' < "$mail" | cut -d ' ' -f 2-)

    notify-send -i evolution-mail "Mail from $(decode "${from:-Unkown}")" "$subject" &
  done

  # Trigger i3block mail rerender.
  pkill -RTMIN+12 i3blocks

  # Update timestamp.
  touch "$timestamp"

  # Update mail database.
  notmuch new &
fi
