#!/usr/bin/env bash

# Check if Kitty is installed, launch a small floating window with live visual audio monitor
kitty --class float-term --title "Microphone Input Monitor" -o initial_window_width=60c -o initial_window_height=12c bash -c '
    echo -e "\033[1;36m=== Live Microphone Signal Monitor ===\033[0m"
    echo -e "Testing default source. Speak into your mic...\nPress Ctrl+C to close.\n"
    
    # Run a live ASCII VU meter via parec / sox or pw-record
    if command -v ffmpeg >/dev/null 2>&1; then
        ffmpeg -loglevel panic -f pulse -i default -filter_complex "astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level" -f null - 2>&1 | \
        awk -F'=' '/lavfi.astats.Overall.RMS_level/ {
            db = $2 + 0;
            if (db < -60) pct = 0;
            else if (db >= 0) pct = 100;
            else pct = int((db + 60) * (100 / 60));
            
            bars = int(pct / 4);
            bar_str = "";
            for (i=0; i<bars; i++) bar_str = bar_str "█";
            for (i=bars; i<25; i++) bar_str = bar_str "░";
            
            printf "\r\033[KSignal: [%-25s] %3d%% (%.1f dB)", bar_str, pct, db;
            fflush();
        }'
    else
        # Fallback to pw-top if ffmpeg is unavailable
        pw-top
    fi
'
