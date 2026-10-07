#!/usr/bin/env bash

VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)

if [ -z "$VOL_RAW" ]; then
    echo '{"text": "MIC: OFF", "tooltip": "No input device found", "class": "unplugged"}'
    exit 0
fi

# Extract volume as integer percentage
VOL_NUM=$(echo "$VOL_RAW" | awk '{print int($2 * 100)}')

# Inspect the active default audio source directly
INSPECT=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)

ACTIVE_NAME=$(echo "$INSPECT" | awk -F' = ' '
    /node.description/ { gsub(/"/, "", $2); name=$2; exit }
    /media.name/       { gsub(/"/, "", $2); name=$2; exit }
    /node.name/        { gsub(/"/, "", $2); name=$2; exit }
    END { print name }
')

[ -z "$ACTIVE_NAME" ] && ACTIVE_NAME="Default Source"

# Check if any ALSA capture stream is currently active/recording
STREAM_STATE=$(cat /proc/asound/card*/pcm*c/sub0/status 2>/dev/null | grep -m 1 "RUNNING")

if echo "$VOL_RAW" | grep -q '\[MUTED\]'; then
    echo "{\"text\": \"MIC: MUTE (${VOL_NUM}%)\", \"tooltip\": \"Device: $ACTIVE_NAME\\nStatus: Muted\\nLeft-click: Mute | Right-click: Switch mic | Scroll: Volume\", \"class\": \"muted\"}"
elif [ -n "$STREAM_STATE" ]; then
    echo "{\"text\": \"MIC: REC (${VOL_NUM}%)\", \"tooltip\": \"Device: $ACTIVE_NAME\\nStatus: Recording\\nLeft-click: Mute | Right-click: Switch mic | Scroll: Volume\", \"class\": \"recording\"}"
else
    echo "{\"text\": \"MIC: ${VOL_NUM}%\", \"tooltip\": \"Device: $ACTIVE_NAME\\nStatus: Ready\\nLeft-click: Mute | Right-click: Switch mic | Scroll: Volume\", \"class\": \"ready\"}"
fi
