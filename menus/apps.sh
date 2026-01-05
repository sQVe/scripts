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
  "chrome-float"
  "lazydocker"
  "onshape"
  "slack"
  "spotify"
  "steam"
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
  "pavucontrol"
  "qbittorrent"
  "wdisplays"
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
  chrome-float)
    quickmarks_file="${XDG_CONFIG_HOME:-$HOME/.config}/qutebrowser/quickmarks"
    name=$(cut -d' ' -f1 "${quickmarks_file}" | rofi -dmenu -p 'quickmark')

    if [[ -n "${name}" ]]; then
      url=$(grep "^${name} " "${quickmarks_file}" | cut -d' ' -f2-)
      if [[ -n "${url}" ]]; then
        "${SCRIPTS}/qutebrowser/chrome-float.sh" "${url}"
      fi
    fi
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
