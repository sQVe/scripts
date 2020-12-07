#!/usr/bin/env bash

#  ┏┓ ┏━┓┏━╸╻┏ ╻ ╻┏━┓   ┏┓ ┏━┓┏━┓╻┏ ┏━┓
#  ┣┻┓┣━┫┃  ┣┻┓┃ ┃┣━┛   ┣┻┓┃ ┃┃ ┃┣┻┓┗━┓
#  ┗━┛╹ ╹┗━╸╹ ╹┗━┛╹     ┗━┛┗━┛┗━┛╹ ╹┗━┛

sudo rsync -rlptDv --delete "$BOOKS"/* /mnt/shishigami/media/books
