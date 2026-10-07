#!/usr/bin/env bash

# 1. Get currently active default audio source ID
CURRENT_DEF=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk -F': ' '/id/ {gsub(/,/, "", $2); print $2; exit}')

# 2. Extract both physical and virtual Audio Sources, excluding monitors
SOURCES_RAW=$(pw-dump Node 2>/dev/null | jq -r '
  .[] 
  | select(.info.props."media.class" | strings | startswith("Audio/Source"))
  | select(.info.props."node.name" | strings | test("monitor"; "i") | not)
  | "\(.id)\t\(.info.props."node.description" // .info.props."node.name")"
')

[ -z "$SOURCES_RAW" ] && exit 0

MENU_ENTRIES=()
while IFS=$'\t' read -r NODE_ID DEV_NAME; do
    [ -z "$NODE_ID" ] && continue

    # Clean up display name for WebRTC echo-cancel
    if [[ "$DEV_NAME" =~ echo-cancel|clean_mic|Echo-Cancel ]]; then
        DEV_NAME="Clean Mic (WebRTC Denoise)"
    fi

    if [ "$NODE_ID" = "$CURRENT_DEF" ]; then
        MENU_ENTRIES+=("● $DEV_NAME [$NODE_ID] (ACTIVE)")
    else
        MENU_ENTRIES+=("○ $DEV_NAME [$NODE_ID]")
    fi
done <<< "$SOURCES_RAW"

# 3. Present in Rofi
SELECTED=$(printf '%s\n' "${MENU_ENTRIES[@]}" | rofi -dmenu -p "Select Microphone" -i)

# 4. Set selected default
if [ -n "$SELECTED" ]; then
    TARGET_ID=$(echo "$SELECTED" | grep -oP '(?<=\[)\d+(?=\])')
    if [ -n "$TARGET_ID" ]; then
        wpctl set-default "$TARGET_ID"
    fi
fi
