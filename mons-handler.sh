#!/usr/bin/env bash
# ┏┳┓┏━┓┏┓╻┏━┓   ╻ ╻┏━┓┏┓╻╺┳┓╻  ┏━╸┏━┓
# ┃┃┃┃ ┃┃┗┫┗━┓   ┣━┫┣━┫┃┗┫ ┃┃┃  ┣╸ ┣┳┛
# ╹ ╹┗━┛╹ ╹┗━┛   ╹ ╹╹ ╹╹ ╹╺┻┛┗━╸┗━╸╹┗╸

# Setup xorg for dGPU (nvidia) only mode.
if [[ $(envycontrol --query) == "nvidia" ]]; then
  xrandr --setprovideroutputsource modesetting NVIDIA-0
fi

xrandr --auto
