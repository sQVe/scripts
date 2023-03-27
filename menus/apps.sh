#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority apps.
apps=(
  "chrome"
  "btop"
  "nvim"
  "qutebrowser"
  "slack"
  "spotify"
  "term"
  "vifm"
  "weechat"
)

# Medium priority apps.
apps+=(
  "art"
  "discord"
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "gimp"
  "mullvad"
  "scrcpy"
  "telegram"
)

# Low priority apps.
apps+=(
  "arandr"
  "easyeffects"
  "menu calculator"
  "menu emoji"
  "menu exit"
  "menu notes"
  "menu passwords"
  "menu projects"
  "menu run"
  "menu windows"
  "pavucontrol"
  "qbittorrent"
  "simplescreenrecorder"
)

# Work apps.
if [[ ${HOSTNAME} == 'calcifer' ]]; then
  apps+=(
    "pritunl"
    "zoom"
  )
fi

choice="$(printf '%s\n' "${apps[@]}" | rofi -dmenu -p 'app')"

case "${choice}" in
  chrome)
    google-chrome-stable
    ;;
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
  spotify | qutebrowser)
    "open-${choice}"
    ;;
  pritunl)
    pritunl-client-electron
    ;;
  telegram)
    telegram-desktop
    ;;
  weechat)
    term --instance "${choice}" --title "${choice}" "${choice}"
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  zoom)
    pkill zoom
    zoom
    ;;
  *)
    ${choice}
    ;;
esac