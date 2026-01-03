#!/usr/bin/env bash

set -euo pipefail

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority apps.
apps=(
  "qutebrowser"
  "yazi"
  "term"
  "nvim"
)

# Medium priority apps.
apps+=(
  "btop"
  "chrome"
  "lazydocker"
  "onshape"
  "pavucontrol"
  "slack"
  "spotify"
  "steam"
  "wdisplays"
  "zathura"

  # Ordered by frequency of use.
  "screenshot gui"
  "screenshot window"
  "screenshot screen"
)

# Low priority apps.
apps+=(
  "art"
  "aws vpn client"
  "bc"
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

)

choice="$(printf '%s\n' "${apps[@]}" | rofi -dmenu -p 'app')"

case "${choice}" in
  bc)
    term --class bc --detach bc
    ;;
  btop | lazydocker | node | nvim | yazi)
    term --title "${choice}" "${choice}"
    ;;
  beekeeper)
    /opt/Beekeeper\ Studio/beekeeper-studio
    ;;
  chrome)
    google-chrome-stable
    ;;
  mullvad)
    mullvad-vpn
    ;;
  onshape)
    google-chrome-stable --app="https://cad.onshape.com"
    ;;
  screenshot\ screen)
    niri msg action screenshot-screen
    ;;
  screenshot\ gui)
    niri msg action screenshot
    ;;
  screenshot\ window)
    niri msg action screenshot-window
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  *)
    "${choice}"
    ;;
esac
