#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸┏┳┓┏━┓ ┏┓╻
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣╸ ┃┃┃┃ ┃  ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸╹ ╹┗━┛┗━┛╹

theme="$(echo /usr/lib/python3.*/site-packages/picker/contrib/grid.rasi)"

rofimoji --action clipboard --skin-tone neutral --max-recent 0 --selector-args="-theme ${theme} -kb-row-left Left -kb-row-right Right -kb-move-char-back Control+b -kb-move-char-forward Control+f" --hidden-descriptions
