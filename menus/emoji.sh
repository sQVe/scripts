#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━╸┏┳┓┏━┓ ┏┓╻
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣╸ ┃┃┃┃ ┃  ┃┃
#  ╹ ╹┗━╸╹ ╹┗━┛   ┗━╸╹ ╹┗━┛┗━┛╹

rofimoji --action clipboard --skin-tone neutral --max-recent 0 --selector-args="-theme /usr/lib/python3.*/site-packages/picker/contrib/grid.rasi -kb-row-left Left -kb-row-right Right -kb-move-char-back Control+b -kb-move-char-forward Control+f" --hidden-descriptions
