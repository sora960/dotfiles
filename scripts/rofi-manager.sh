#!/usr/bin/env bash

USER_APPS="$HOME/.local/share/applications"
SYS_APPS="/usr/share/applications"
TAG="# Managed by rofi-app-toggle"

mkdir -p "$USER_APPS"
declare -A APP_FILES

# Scan system desktop entries
for file in "$SYS_APPS"/*.desktop; do
    [ -f "$file" ] || continue
    base=$(basename "$file")
    
    # Extract Human-readable Name
    name=$(grep -m 1 "^Name=" "$file" | cut -d'=' -f2-)
    [ -z "$name" ] && name="${base%.desktop}"

    # Determine status:
    # It is hidden if an override exists containing NoDisplay=true
    if [ -f "$USER_APPS/$base" ] && grep -qi "^NoDisplay=true" "$USER_APPS/$base"; then
        status="[HIDDEN]"
    else
        status="[SHOWN] "
    fi

    label="$status $name ($base)"
    APP_FILES["$label"]="$base"
done

# Show in Rofi
chosen=$(printf '%s\n' "${!APP_FILES[@]}" | sort | rofi -dmenu -i -p "Toggle Menu Visibility")

# Exit if cancelled
[ -z "$chosen" ] && exit 0

target_file="${APP_FILES["$chosen"]}"
target_path="$USER_APPS/$target_file"
sys_path="$SYS_APPS/$target_file"

# --- TOGGLE LOGIC ---

if [ -f "$target_path" ] && grep -qi "^NoDisplay=true" "$target_path"; then
    # Unhide action: ONLY delete if this script created the file
    if grep -q "$TAG" "$target_path"; then
        rm -f "$target_path"
        notify-send "App Menu" "Restored to menu: $target_file"
    else
        # It's a user file not created by this script; flip NoDisplay to false rather than deleting
        sed -i 's/^NoDisplay=true/NoDisplay=false/I' "$target_path"
        notify-send "App Menu" "Set NoDisplay=false: $target_file"
    fi
else
    # Hide action: Copy full metadata to preserve mime/exec/wmclass, then insert hide tag under [Desktop Entry]
    if [ -f "$sys_path" ]; then
        cp "$sys_path" "$target_path"
        sed -i "/^\[Desktop Entry\]/a ${TAG}\nNoDisplay=true" "$target_path"
        notify-send "App Menu" "Hidden from menu: $target_file"
    fi
fi
