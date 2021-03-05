#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority apps.
apps=(
  "chrome"
  "htop"
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
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "krita"
  "mullvad"
  "scrcpy"
  "telegram"
)

# Low priority apps.
apps+=(
  "arandr"
  "menu-calculator"
  "menu-emoji"
  "menu-exit"
  "menu-notes"
  "menu-passwords"
  "menu-projects"
  "menu-run"
  "menu-windows"
  "pavucontrol"
  "qbittorrent"
)

# Work apps.
if [[ $HOSTNAME == 'calcifer' ]]; then
  apps+=(
    "pritunl"
    "zoom"
  )
fi

choice="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'app: ')"

case "$choice" in
  chrome)
    google-chrome-stable
    ;;
  flameshot*)
    if [[ "${choice##* }" == "gui" ]]; then
      $choice
    else
      $choice --path "$DOWNLOAD"
    fi
    ;;
  htop | node | nvim | vifm)
    term --title "$choice" "$choice"
    ;;
  menu-*)
    "$HOME/scripts/i3/$choice.sh"
    ;;
  mullvad)
    mullvad-vpn
    ;;
  spotify | qutebrowser)
    "open-$choice"
    ;;
  pritunl)
    pritunl-client-electron
    ;;
  telegram)
    telegram-desktop
    ;;
  weechat)
    term --instance "$choice" --title "$choice" "$choice"
    ;;
  qbittorrent)
    mullvad connect
    qbittorrent
    ;;
  *)
    $choice
    ;;
esac
