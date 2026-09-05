#!/bin/bash

if pgrep -f "gpu-screen-recorder" >/dev/null; then
    pkill -INT -f "gpu-screen-recorder"
    paplay /usr/share/sounds/freedesktop/stereo/message-new-instant.oga 2>/dev/null
    notify-send "Screen Recorder" "Recording saved." -i video-display
    exit 0
fi

SAVE_DIR="$HOME/Videos"
FILENAME="$SAVE_DIR/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"

MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga 2>/dev/null
notify-send "Screen Recorder" "Recording $MONITOR..." -i video-display

gpu-screen-recorder -w "$MONITOR" \
    -c mp4 \
    -k hevc \
    -q medium \
    -f 60 \
    -a default_output \
    -o "$FILENAME" > /dev/null 2>&1 &
