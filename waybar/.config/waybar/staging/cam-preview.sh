#!/usr/bin/env bash

if [ ! -e "/dev/video0" ]; then
    notify-send -u critical "Webcam" "No camera device found at /dev/video0"
    exit 1
fi

# Run low-latency preview with mpv in a floating window
mpv --demuxer-lavf-format=video4linux2 \
    --demuxer-lavf-o-set=input_format=mjpeg \
    --profile=low-latency \
    --untimed \
    --title="Webcam Preview" \
    --geometry=640x360-30-50 \
    av://v4l2:/dev/video0
