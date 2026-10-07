#!/usr/bin/env bash

WIFI_STATE=$(nmcli radio wifi)

if [ "$WIFI_STATE" = "enabled" ]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
