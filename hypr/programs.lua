-- Default system applications wrapped with UWSM

-- ~/.config/hypr/programs.lua
return {
	terminal = "uwsm app -- kitty",
	fileManager = "uwsm app -- thunar",
	menu = "qs ipc call applauncher toggle",
	browser = "uwsm app -- firefox",
}
