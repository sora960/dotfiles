#!/usr/bin/env bash

MODE="${1:-sink}" # "sink" for speakers/headphones, "source" for microphones

if [ "$MODE" = "sink" ]; then
    MEDIA_CLASS="Audio/Sink"
    PROMPT="Select Output Device"
    CURRENT_DEF=$(wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk -F': ' '/id/ {gsub(/,/, "", $2); print $2; exit}')
else
    MEDIA_CLASS="Audio/Source"
    PROMPT="Select Microphone"
    CURRENT_DEF=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk -F': ' '/id/ {gsub(/,/, "", $2); print $2; exit}')
fi

# Query PipeWire nodes using jq, explicitly excluding:
# 1. Monitors (output loopbacks into inputs)
# 2. echo-cancel-sink (the internal debug/reference sink)
# 3. Virtual filter sinks/streams
RAW_DEVICES=$(pw-dump Node 2>/dev/null | jq -r --arg mc "$MEDIA_CLASS" '
  .[] 
  | select(.info.props."media.class" | strings | startswith($mc))
  | select(.info.props."node.name" | strings | test("echo-cancel-sink|echo-cancel-playback|monitor"; "i") | not)
  | "\(.id)\t\(.info.props."node.nick" // .info.props."node.description" // .info.props."node.name")\t\(.info.props."node.name")"
')

[ -z "$RAW_DEVICES" ] && exit 0

MENU_ENTRIES=()
while IFS=$'\t' read -r NODE_ID DEV_DESC NODE_NAME; do
    [ -z "$NODE_ID" ] && continue

    # Friendly hardware names
    if [[ "$NODE_NAME" =~ echo-cancel-source ]]; then
        DEV_NAME="󰒋 Clean Mic (WebRTC Noise Filter)"
    elif [[ "$NODE_NAME" =~ analog-stereo ]]; then
        DEV_NAME="󰋋 Motherboard Analog Audio (ALC897 / Front Jack)"
    elif [[ "$NODE_NAME" =~ hdmi|HDMI ]]; then
        DEV_NAME="󰍹 Monitor Audio (HDMI / QM240)"
    elif [[ "$NODE_NAME" =~ PCM2902 ]]; then
        DEV_NAME="󰍬 PCM2902 Audio Codec"
    elif [[ "$NODE_NAME" =~ USB.*Composite|v4l2 ]]; then
        DEV_NAME="󰍬 USB Webcam Microphone"
    else
        DEV_NAME="󰓃 $DEV_DESC"
    fi

    if [ "$NODE_ID" = "$CURRENT_DEF" ]; then
        MENU_ENTRIES+=("● $DEV_NAME  [$NODE_ID] (ACTIVE)")
    else
        MENU_ENTRIES+=("○ $DEV_NAME  [$NODE_ID]")
    fi
done <<< "$RAW_DEVICES"

SELECTED=$(printf '%s\n' "${MENU_ENTRIES[@]}" | rofi -dmenu -p "$PROMPT" -i -theme-str 'window {width: 520px;}')

if [ -n "$SELECTED" ]; then
    TARGET_ID=$(echo "$SELECTED" | grep -oP '(?<=\[)\d+(?=\])')
    if [ -n "$TARGET_ID" ]; then
        wpctl set-default "$TARGET_ID"
        notify-send -t 1500 -u low "Audio Switcher" "Switched default to ID $TARGET_ID"
    fi
fi
