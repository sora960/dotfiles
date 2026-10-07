#!/usr/bin/env bash

# Dynamic status queries
AUDIO_MUTE=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q '\[MUTED\]' && echo "MUTED" || echo "ACTIVE")
CURRENT_SRC=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk -F' = ' '/node.description/ {gsub(/"/, "", $2); print $2; exit}')
FILTER_STATE=$(pw-dump Node 2>/dev/null | jq -r '.[] | select(.info.props."node.name" == "echo-cancel-source") | .id' | head -n1)
IS_FILTER_ON=$([ "$FILTER_STATE" = "$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk -F': ' '/id/ {gsub(/,/, "", $2); print $2; exit}')" ] && echo "ON" || echo "OFF")
NET_STATE=$(nmcli -t -f TYPE,STATE dev | grep -q '^ethernet:connected' && echo "Ethernet" || echo "Wi-Fi")

OPTIONS="1. 󰍬 Mic Live Monitor (Visual VU Meter)
2. 󰍬 Toggle Mic Mute [State: $AUDIO_MUTE]
3. 󰒋 Toggle Denoise/Filter [State: $IS_FILTER_ON]
4. 󰋋 Switch Audio Source / Mic (Rofi)
5. 󰄀 Test Camera Preview (mpv)
6. 󰖩 Wi-Fi Network Picker
7. 󰈀 Network Connections (nmtui)
8. 󰮐 Run Full Hardware Audit (sysfs)"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Peripheral Hub" -theme-str 'window {width: 420px;}')

case "$CHOSEN" in
    *"Mic Live Monitor"*)
        ~/.config/waybar/staging/mic-check.sh
        ;;
    *"Toggle Mic Mute"*)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    *"Toggle Denoise/Filter"*)
        ~/.config/waybar/scripts/toggle-mic-filter.sh
        ;;
    *"Switch Audio Source"*)
        ~/.config/waybar/scripts/mic-select-rofi.sh
        ;;
    *"Test Camera Preview"*)
        ~/.config/waybar/staging/cam-preview.sh
        ;;
    *"Wi-Fi Network Picker"*)
        ~/.config/waybar/scripts/wifi-select-rofi.sh
        ;;
    *"Network Connections"*)
        kitty --class float-term -e nmtui
        ;;
    *"Full Hardware Audit"*)
        kitty --class float-term --hold bash -c "~/check-peripherals.sh"
        ;;
esac
