#!/bin/sh
NAME="Areashot_$(date +%Y-%m-%d_%H-%M-%S).png"
GEOM=$(slurp)
if [ -z "$GEOM" ]; then exit 1; fi

if [ "$1" = "save" ]; then
    grim -g "$GEOM" - | tee "$HOME/Pictures/$NAME" | wl-copy
else
    grim -g "$GEOM" - | wl-copy
fi
