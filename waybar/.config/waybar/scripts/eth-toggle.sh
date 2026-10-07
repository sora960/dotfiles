#!/usr/bin/env bash

IFACE="enp5s0"
CON_NAME="Wired connection 1"

STATE=$(nmcli -t -f DEVICE,STATE dev status | awk -F: -v dev="$IFACE" '$1 == dev {print $2}')

if [ "$STATE" = "connected" ]; then
    nmcli connection down "$CON_NAME"
else
    nmcli connection up "$CON_NAME"
fi
