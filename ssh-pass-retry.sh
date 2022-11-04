#!/usr/bin/env bash

#  ┏━┓┏━┓╻ ╻   ┏━┓┏━┓┏━┓┏━┓   ┏━┓┏━╸╺┳╸┏━┓╻ ╻
#  ┗━┓┗━┓┣━┫╺━╸┣━┛┣━┫┗━┓┗━┓╺━╸┣┳┛┣╸  ┃ ┣┳┛┗┳┛
#  ┗━┛┗━┛╹ ╹   ╹  ╹ ╹┗━┛┗━┛   ╹┗╸┗━╸ ╹ ╹┗╸ ╹

if ! ssh "$@" 2> /dev/null; then
  "${SCRIPTS}/menus/passwords.sh" ssh &> /dev/null
  ssh "$@"
fi
