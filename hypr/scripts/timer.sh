#!/usr/bin/env bash

STATE_FILE="/tmp/study_timer.state"
PID_FILE="/tmp/study_timer.pid"

update_ui() {
    pkill -RTMIN+8 waybar
}

# The background worker that waits and triggers the alarm
timer_daemon() {
    local end_time=$1
    local now=$(date +%s)
    local diff=$((end_time - now))
    
    if [ "$diff" -gt 0 ]; then
        sleep "$diff"
    fi
    
    if [ "$(awk -F'|' '{print $1}' "$STATE_FILE")" = "RUNNING" ]; then
        pw-play /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
        
        local action
        action=$(notify-send -u critical \
            -a "Study Timer" \
            --action="break=Start 5m Break" \
            --action="dismiss=Dismiss" \
            "Study Timer" "Session complete! Take a break.")
            
        case "$action" in
            break)
                start_timer 5
                ;;
            *)
                rm -f "$STATE_FILE" "$PID_FILE"
                update_ui
                ;;
        esac
    fi
}

start_timer() {
    local mins=$1
    local secs=$((mins * 60))
    local end_time=$(( $(date +%s) + secs ))
    
    echo "RUNNING|$end_time|$secs" > "$STATE_FILE"
    
    # Kill any existing daemon before starting a new one
    kill $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null
    timer_daemon "$end_time" &
    echo $! > "$PID_FILE"
    update_ui
}

pause_timer() {
    if [ ! -f "$STATE_FILE" ]; then return; fi
    IFS='|' read -r status end_time remaining < "$STATE_FILE"
    
    if [ "$status" = "RUNNING" ]; then
        local now=$(date +%s)
        local diff=$((end_time - now))
        echo "PAUSED|$end_time|$diff" > "$STATE_FILE"
        kill $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null
        update_ui
    fi
}

resume_timer() {
    if [ ! -f "$STATE_FILE" ]; then return; fi
    IFS='|' read -r status old_end remaining < "$STATE_FILE"
    
    if [ "$status" = "PAUSED" ]; then
        local end_time=$(( $(date +%s) + remaining ))
        echo "RUNNING|$end_time|$remaining" > "$STATE_FILE"
        
        kill $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null
        timer_daemon "$end_time" &
        echo $! > "$PID_FILE"
        update_ui
    fi
}

stop_timer() {
    kill $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null
    rm -f "$STATE_FILE" "$PID_FILE"
    update_ui
}

# The Interactive Rofi Menu
menu() {
    if [ ! -f "$STATE_FILE" ]; then
        choice=$(printf "25m Focus\n45m Deep Work\n60m Session\n5m Break" | rofi -dmenu -p "Start Timer")
        case "$choice" in
            "25m Focus") start_timer 25 ;;
            "45m Deep Work") start_timer 45 ;;
            "60m Session") start_timer 60 ;;
            "5m Break") start_timer 5 ;;
        esac
    else
        IFS='|' read -r status end_time remaining < "$STATE_FILE"
        if [ "$status" = "RUNNING" ]; then
            choice=$(printf "Pause\nStop" | rofi -dmenu -p "Timer Running")
            case "$choice" in
                "Pause") pause_timer ;;
                "Stop") stop_timer ;;
            esac
        else
            choice=$(printf "Resume\nStop" | rofi -dmenu -p "Timer Paused")
            case "$choice" in
                "Resume") resume_timer ;;
                "Stop") stop_timer ;;
            esac
        fi
    fi
}

# The Waybar Status Output
status() {
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"text": " Study", "tooltip": "Click to open timer menu", "class": "stopped"}'
        return
    fi
    
    IFS='|' read -r status end_time remaining < "$STATE_FILE"
    
    if [ "$status" = "PAUSED" ]; then
        local mins=$((remaining / 60))
        local secs=$((remaining % 60))
        printf '{"text": "%02d:%02d", "tooltip": "Paused - Click to resume/stop", "class": "paused"}\n' "$mins" "$secs"
    else
        local now=$(date +%s)
        local diff=$((end_time - now))
        if [ "$diff" -le 0 ]; then
            echo '{"text": "00:00", "class": "finished"}'
        else
            local mins=$((diff / 60))
            local secs=$((diff % 60))
            printf '{"text": "%02d:%02d", "tooltip": "Running - Click to pause/stop", "class": "running"}\n' "$mins" "$secs"
        fi
    fi
}

case "$1" in
    menu) menu ;;
    status) status ;;
esac
