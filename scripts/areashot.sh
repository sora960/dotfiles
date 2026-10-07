#!/bin/sh
NAME="Areashot_$(date +%Y-%m-%d_%H-%M-%S).png"
GEOM=$(slurp)
if [ -z "$GEOM" ]; then exit 1; fi

if [ "$1" = "copy" ]; then
    grim -g "$GEOM" - | wl-copy
else
    grim -g "$GEOM" - | tee "$HOME/Pictures/$NAME" | wl-copy
fi
