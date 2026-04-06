#!/usr/bin/env bash
set -euo pipefail

usb="alsa_output.usb-C-Media_Electronics_Inc._USB_Advanced_Audio_Device-00.analog-stereo"
mic="alsa_input.usb-C-Media_Electronics_Inc._USB_Advanced_Audio_Device-00.analog-stereo"
ifi="alsa_output.usb-iFi__by_AMR__iFi__by_AMR__HD_USB_Audio_0000-00.analog-stereo"

cleanup() {
    pw-link -d "${usb}:monitor_FL" "${ifi}:playback_FL" 2>/dev/null
    pw-link -d "${usb}:monitor_FR" "${ifi}:playback_FR" 2>/dev/null
    pw-link -d "${mic}:capture_FL" "${ifi}:playback_FL" 2>/dev/null
    pw-link -d "${mic}:capture_FR" "${ifi}:playback_FR" 2>/dev/null
    echo "Disconnected"
}

trap cleanup EXIT

pw-link "${usb}:monitor_FL" "${ifi}:playback_FL"
pw-link "${usb}:monitor_FR" "${ifi}:playback_FR"
pw-link "${mic}:capture_FL" "${ifi}:playback_FL"
pw-link "${mic}:capture_FR" "${ifi}:playback_FR"

echo "Linked USB output + mic to iFi (Ctrl+C to stop)"
sleep infinity
