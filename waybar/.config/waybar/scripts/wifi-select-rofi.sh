#!/usr/bin/env bash

# Ensure Wi-Fi radio is turned on
if [ "$(nmcli radio wifi)" != "enabled" ]; then
    nmcli radio wifi on
    sleep 1
fi

# Rescan and get unique SSIDs with security indicators
LIST=$(nmcli --fields "IN-USE,SSID,SECURITY,BARS" dev wifi list | sed 1d | grep -v -- "^--")

[ -z "$LIST" ] && exit 0

CHOSEN_ENTRY=$(echo "$LIST" | rofi -dmenu -p "Select Wi-Fi Network" -i)

[ -z "$CHOSEN_ENTRY" ] && exit 0

# Parse SSID (handle in-use indicator '* ')
SSID=$(echo "$CHOSEN_ENTRY" | sed -E 's/^\*?[[:space:]]*//' | awk '{print $1}')

# Check if connection already exists in NetworkManager
if nmcli connection show "$SSID" >/dev/null 2>&1; then
    nmcli connection up "$SSID"
else
    # Check if network requires security
    if echo "$CHOSEN_ENTRY" | grep -qiE "WPA|WEP"; then
        PASS=$(rofi -dmenu -password -p "Password for $SSID")
        [ -n "$PASS" ] && nmcli dev wifi connect "$SSID" password "$PASS"
    else
        nmcli dev wifi connect "$SSID"
    fi
fi
