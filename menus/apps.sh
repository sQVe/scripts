#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority apps.
apps=(
  "qutebrowser"
  "nvim"
  "term"
  "vifm"
  "btop"
)

# Medium priority apps.
apps+=(
  "arandr"
  "chrome"
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "pavucontrol"
)

# Low priority apps.
apps+=(
  "art"
  "discord"
  "easyeffects"
  "gimp"
  "menu calculator"
  "menu emoji"
  "menu exit"
  "menu notes"
  "menu passwords"
  "menu projects"
  "menu run"
  "menu windows"
  "mullvad"
  "qbittorrent"
  "simplescreenrecorder"
  "slack"
  "spotify"
  "steam"
)

choice="$(printf '%s\n' "${apps[@]}" | rofi -dmenu -p 'app')"

case "${choice}" in
  flameshot*)
    if [[ "${choice##* }" == "gui" ]]; then
      ${choice}
    else
      ${choice} --path "${DOWNLOAD}"
    fi
    ;;
  btop | node | nvim | vifm)
    term --title "${choice}" "${choice}"
    ;;
  menu*)
    "${HOME}/scripts/menus/${choice/#menu /}.sh"
    ;;
  mullvad)
    mullvad-vpn
    ;;
  chrome | spotify | steam | qutebrowser)
    "open-${choice}"
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  *)
    ${choice}
    ;;
esac
