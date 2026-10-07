#!/usr/bin/env bash

CLEAN_ID=$(pw-dump Node 2>/dev/null | jq -r '.[] | select(.info.props."node.name" == "echo-cancel-source") | .id' | head -n1)
RAW_ID=$(pw-dump Node 2>/dev/null | jq -r '.[] | select(.info.props."node.name" == "alsa_input.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-mono") | .id' | head -n1)

CURRENT_ID=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk -F': ' '/id/ {gsub(/,/, "", $2); print $2; exit}')

if [ "$CURRENT_ID" = "$CLEAN_ID" ] && [ -n "$RAW_ID" ]; then
    wpctl set-default "$RAW_ID"
    notify-send -t 1500 -u low "Microphone" "Raw Mic (Denoise OFF)"
else
    if [ -n "$CLEAN_ID" ]; then
        wpctl set-default "$CLEAN_ID"
        notify-send -t 1500 -u low "Microphone" "Clean Mic (Denoise ON)"
    fi
fi
