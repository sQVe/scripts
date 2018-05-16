#!/usr/bin/env bash

#  ┏━┓┏━┓┏━╸┏━╸   ╻  ┏━┓┏━┓╺┳┓   ┏━┓┏━╸╺┳┓┏━┓╻ ╻╻┏━╸╺┳╸
#  ┗━┓┣━┫┣╸ ┣╸    ┃  ┃ ┃┣━┫ ┃┃   ┣┳┛┣╸  ┃┃┗━┓┣━┫┃┣╸  ┃
#  ┗━┛╹ ╹╹  ┗━╸   ┗━╸┗━┛╹ ╹╺┻┛   ╹┗╸┗━╸╺┻┛┗━┛╹ ╹╹╹   ╹

if [[ $(pidof redshift | wc -w) = 0 ]]; then
  redshift -m randr:preserve=1 && pkill -RTMIN+2 i3blocks
fi
