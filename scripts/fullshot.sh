#!/bin/sh
# Task: Fullscreen capture
NAME="Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

if [ "$1" = "copy" ]; then
    grim - | wl-copy
else
    grim - | tee "$HOME/Pictures/$NAME" | wl-copy
fi
