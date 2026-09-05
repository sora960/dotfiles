#!/usr/bin/env bash

# Check if quickshell is running hyprquickpaper
if pgrep -f "hyprquickpaper" > /dev/null; then
    pkill -f "hyprquickpaper"
else
    uwsm app -- quickshell -c "$HOME/.config/quickshell/hyprquickpaper"
fi
