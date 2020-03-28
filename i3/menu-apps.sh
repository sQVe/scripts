#!/usr/bin/env bash

#  ┏┳┓┏━╸┏┓╻╻ ╻   ┏━┓┏━┓┏━┓┏━┓
#  ┃┃┃┣╸ ┃┗┫┃ ┃   ┣━┫┣━┛┣━┛┗━┓
#  ╹ ╹┗━╸╹ ╹┗━┛   ╹ ╹╹  ╹  ┗━┛

apps=(
  "chrome"
  "ctop"
  "flameshot full"
  "flameshot gui"
  "flameshot screen"
  "htop"
  "insomnia"
  "krita"
  "menu-bluetooth"
  "menu-calculator"
  "menu-clipboard"
  "menu-exit"
  "menu-notes"
  "menu-passwords"
  "menu-projects"
  "menu-run"
  "menu-windows"
  "neomutt"
  "node"
  "nvim"
  "qutebrowser"
  "rtv"
  "scrcpy"
  "slack"
  "spotify"
  "term"
  "twitch"
  "vifm"
  "virt-manager"
  "weechat"
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
  "scaled-$choice"
  ;;
twitch)
  streamlink-twitch-gui
  ;;
neomutt | weechat)
  term --instance "$choice" --title "$choice" "$choice"
  ;;
*)
  $choice
  ;;
esac
