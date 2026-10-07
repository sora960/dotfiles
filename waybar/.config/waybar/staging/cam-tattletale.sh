#!/usr/bin/env bash

# If device does not physically exist or is idle, print empty string to hide in Waybar
if [ ! -e "/dev/video0" ]; then
    echo '{"text": "", "tooltip": "No camera connected", "class": "hidden"}'
    exit 0
fi

# Check if any process holds an open file descriptor on /dev/video0
if fuser /dev/video0 >/dev/null 2>&1; then
    PROCS=$(fuser -v /dev/video0 2>&1 | awk 'NR>1 {print $3}' | sort -u | tr '\n' ' ' | xargs)
    echo "{\"text\": \"󰄀 LIVE\", \"tooltip\": \"Camera ACTIVE\\nPIDs: ${PROCS:-active}\", \"class\": \"recording\"}"
else
    # Empty text causes Waybar to hide the pill completely
    echo '{"text": "", "tooltip": "Camera idle", "class": "idle"}'
fi
