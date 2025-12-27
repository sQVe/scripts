#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority apps.
apps=(
  "qutebrowser"
  "nvim"
  "term"
  "yazi"
  "btop"
)

# Medium priority apps.
apps+=(
  "chrome"
  "flameshot screen"
  "lazydocker"
  "onshape"
  "pavucontrol"
  "slack"
  "spotify"
  "wdisplays"
)

# Low priority apps.
apps+=(
  "art"
  "aws vpn client"
  "beekeeper"
  "bruno"
  "discord"
  "easyeffects"
  "gimp"
  "inkscape"
  "kicad"
  "meshlab"
  "mullvad"
  "qbittorrent"
  "steam"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -dmenu -p 'app')"

case "${choice}" in
  btop | lazydocker | node | nvim | yazi)
    term --title "${choice}" "${choice}"
    ;;
  beekeeper)
    /opt/Beekeeper\ Studio/beekeeper-studio
    ;;
  mullvad)
    mullvad-vpn
    ;;
  onshape)
    google-chrome-stable --app="https://cad.onshape.com"
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  *)
    "${choice}"
    ;;
esac
