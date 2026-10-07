#!/usr/bin/env bash

TEST_FILE="/tmp/waybar_mic_test.wav"
PID_FILE="/tmp/waybar_mic_record.pid"

case "$1" in
    record)
        # If currently recording, stop it
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            kill "$(cat "$PID_FILE")" 2>/dev/null
            rm -f "$PID_FILE"
            notify-send -t 1500 -u low "Mic Test" "Recording stopped."
        else
            # Start background recording
            pw-record "$TEST_FILE" &
            echo $! > "$PID_FILE"
            notify-send -t 2000 -u low "Mic Test" "Recording started... Click again to stop."
        fi
        ;;
    play)
        if [ -f "$TEST_FILE" ]; then
            notify-send -t 1500 -u low "Mic Test" "Playing test recording..."
            pw-play "$TEST_FILE"
        else
            notify-send -t 1500 -u low "Mic Test" "No test recording found."
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo '{"text": "REC", "class": "recording", "tooltip": "Left-click: Stop | Right-click: Play"}'
        else
            echo '{"text": "TEST", "class": "idle", "tooltip": "Left-click: Record | Right-click: Play"}'
        fi
        ;;
esac
