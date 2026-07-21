-- Default system applications wrapped with UWSM

-- ~/.config/hypr/programs.lua
return {
	terminal = "uwsm app -- kitty",
	fileManager = "uwsm app -- thunar",
	menu = [[uwsm app -- fuzzel --launch-prefix="uwsm app --"]],
	browser = "uwsm app -- firefox",
}
