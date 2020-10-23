#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

# High priority.
apps=(
  "chrome"
  "htop"
  "neomutt"
  "nvim"
  "qutebrowser"
  "slack"
  "spotify"
  "term"
  "vifm"
  "weechat"
)

# Medium priority.
apps+=(
  "ctop"
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "krita"
  "scrcpy"
  "twitch"
  "virt-manager"
)

# Low priority.
apps+=(
  "arandr"
  "calibre"
  "menu-bluetooth"
  "menu-calculator"
  "menu-clipboard"
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

choice="$(printf '%s\n' "${apps[@]}" | rofi -kb-accept-entry "Return" -dmenu -theme-str 'inputbar { children: [prompt, entry]; }' -p 'app: ')"

case "$choice" in
chrome)
  google-chrome-stable
  ;;
ctop)
  term sudo ctop
  ;;
flameshot*)
  if [[ "${choice##* }" == "gui" ]]; then
    $choice
  else
    $choice --path "$DOWNLOAD"
  fi
  ;;
htop | node | nvim | vifm | rtv)
  term --title "$choice" "$choice"
  ;;
menu-*)
  "$HOME/scripts/i3/$choice.sh"
  ;;
spotify | qutebrowser)
  "open-$choice"
  ;;
twitch)
  streamlink-twitch-gui
  ;;
neomutt | weechat)
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
