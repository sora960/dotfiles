#!/usr/bin/env bash

# Check physical presence
if [ ! -d "/sys/class/video4linux/video0" ]; then
    echo '{"text": "CAM: OFF", "tooltip": "Webcam Unplugged", "class": "unplugged"}'
    exit 0
fi

# Check if any process has /dev/video0 open (fuser check)
if fuser /dev/video0 >/dev/null 2>&1; then
    echo '{"text": "CAM: ON", "tooltip": "Camera in use (Streaming)", "class": "recording"}'
else
    echo '{"text": "CAM: IDLE", "tooltip": "Camera ready (Idle)", "class": "ready"}'
fi
