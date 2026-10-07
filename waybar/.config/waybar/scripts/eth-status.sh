#!/usr/bin/env bash

IFACE="enp5s0"

if [ ! -d "/sys/class/net/$IFACE" ]; then
    echo '{"text": "ETH: N/A", "tooltip": "Hardware not found", "class": "down"}'
    exit 0
fi

CARRIER=$(cat "/sys/class/net/$IFACE/carrier" 2>/dev/null || echo "0")
STATE=$(nmcli -t -f DEVICE,STATE dev status | awk -F: -v dev="$IFACE" '$1 == dev {print $2}')

if [ "$CARRIER" = "1" ] && [ "$STATE" = "connected" ]; then
    SPEED=$(cat "/sys/class/net/$IFACE/speed" 2>/dev/null || echo "?")
    IP=$(ip -4 addr show "$IFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
    echo "{\"text\": \"ETH: ${SPEED}M\", \"tooltip\": \"Interface: $IFACE\\nIP: ${IP:-No IP}\", \"class\": \"connected\"}"
elif [ "$CARRIER" = "1" ]; then
    echo '{"text": "ETH: DOWN", "tooltip": "Interface disabled (Cable connected)", "class": "disconnected"}'
else
    echo '{"text": "ETH: DOWN", "tooltip": "Cable disconnected", "class": "disconnected"}'
fi
