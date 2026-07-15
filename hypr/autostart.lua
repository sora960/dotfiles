-- Centralized autostart commands for Hyprland

hl.on("hyprland.start", function ()
    -- 1. Initialize the wallpaper background daemon
    hl.exec_cmd("awww-daemon &")
    
    -- 2. Brief pause for socket initialization, then load Lucy
    hl.exec_cmd("sleep 0.5 && awww img /home/lucy/wallpaper/lucy.jpg &")
    
    -- 3. Launch your Quickshell layout
    hl.exec_cmd("qs &")
end)
