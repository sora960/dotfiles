-- Default system applications wrapped with UWSM

-- ~/.config/hypr/programs.lua
return {
	terminal = "uwsm app -- kitty",
	fileManager = "uwsm app -- thunar",
	menu = "uwsm app -- rofi -modes drun -show drun -show-icons",
	browser = "uwsm app -- firefox",
}
