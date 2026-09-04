hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user restart xdg-desktop-portal")

	hl.exec_cmd("uwsm app -- /usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,pki")

	hl.exec_cmd("uwsm app -- sh -c  'sleep 3 && awww-daemon'")
	hl.exec_cmd("uwsm app -- waybar")
	hl.exec_cmd("uwsm app -- mako")

	--unused
	-- hl.exec_cmd("uwsm app -- quickshell")
end)
