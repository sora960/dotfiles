#!/usr/bin/env bash

PID_FILE="/tmp/cam-preview.pid"

# 1. Toggle OFF if already running via PID
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PID_FILE"
        exit 0
    fi
    rm -f "$PID_FILE"
fi

# Fallback: kill any lingering preview instance by window title
if pgrep -f "window_title cam-preview" >/dev/null 2>&1; then
    pkill -f "window_title cam-preview"
    exit 0
fi

DEV_NAME="/dev/video0"
[ -e "$DEV_NAME" ] || exit 1

# 2. Toggle ON: Launch ffplay with floating window title
ffplay -f v4l2 \
    -input_format mjpeg \
    -video_size 1280x720 \
    -vf "hflip" \
    -window_title "cam-preview" \
    -noborder \
    "$DEV_NAME" >/dev/null 2>&1 &

echo $! > "$PID_FILE"
