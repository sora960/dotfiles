#!/usr/bin/env bash

IFACE="wlp1s0f0u1"

if [ ! -d "/sys/class/net/$IFACE" ]; then
    echo '{"text": "WIFI: UNPLUGGED", "tooltip": "Dongle not detected", "class": "unplugged"}'
    exit 0
fi

STATE=$(cat "/sys/class/net/$IFACE/operstate" 2>/dev/null || echo "down")

if [ "$STATE" = "up" ]; then
    SSID=$(iwgetid -r "$IFACE" 2>/dev/null || echo "Connected")
    echo "{\"text\": \"WIFI: $SSID\", \"tooltip\": \"Interface: $IFACE ($STATE)\", \"class\": \"connected\"}"
else
    echo '{"text": "WIFI: IDLE", "tooltip": "Dongle plugged in, interface down", "class": "idle"}'
fi
