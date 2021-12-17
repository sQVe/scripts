#!/usr/bin/env bash

#  ┏━┓┏━┓╻ ╻   ┏━┓┏━┓┏━┓┏━┓   ┏━┓┏━╸╺┳╸┏━┓╻ ╻
#  ┗━┓┗━┓┣━┫╺━╸┣━┛┣━┫┗━┓┗━┓╺━╸┣┳┛┣╸  ┃ ┣┳┛┗┳┛
#  ┗━┛┗━┛╹ ╹   ╹  ╹ ╹┗━┛┗━┛   ╹┗╸┗━╸ ╹ ╹┗╸ ╹

if ! ssh "$@" 2> /dev/null; then
  "$SCRIPTS/i3/menu-passwords.sh" ssh &> /dev/null
  ssh "$@"
fi
