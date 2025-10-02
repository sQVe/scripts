#!/usr/bin/env bash

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
  "arandr"
  "helium"
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "lazydocker"
  "onshape"
  "pavucontrol"
  "slack"
  "spotify"
)

# Low priority apps.
apps+=(
  "art"
  "aws vpn client"
  "bruno"
  "dbeaver"
  "discord"
  "easyeffects"
  "gimp"
  "inkscape"
  "kicad"
  "menu calculator"
  "menu emoji"
  "menu exit"
  "menu notebox"
  "menu passwords"
  "menu projects"
  "menu run"
  "menu windows"
  "meshlab"
  "mullvad"
  "qbittorrent"
  "simplescreenrecorder"
  "steam"
  "virt-manager"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -dmenu -p 'app')"

case "${choice}" in
  "aws vpn client")
    /opt/awsvpnclient/AWS\ VPN\ Client
    ;;
  btop | lazydocker | node | nvim | yazi)
    term --title "${choice}" "${choice}"
    ;;
  helium | slack | spotify | steam | qutebrowser)
    "open-${choice}"
    ;;
  flameshot*)
    if [[ "${choice##* }" == "gui" ]]; then
      ${choice}
    else
      ${choice} --path "${DOWNLOAD}"
    fi
    ;;
  menu*)
    "${HOME}/scripts/menus/${choice/#menu /}.sh"
    ;;
  mullvad)
    mullvad-vpn
    ;;
  onshape)
    open-helium --app="https://cad.onshape.com"
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  *)
    ${choice}
    ;;
esac
