local window_opacity = 1.0

-- 1. Global Window Behavior
local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- 2. Application Opacity
hl.window_rule({
	name = "opacity-apps",
	match = {
		class = "^(kitty|codium|firefox|gimp|Godot|mpv|ONLYOFFICE|Thunar|xdg-desktop-portal-gtk)$",
	},
	opacity = window_opacity .. " override " .. window_opacity .. " override 1.0 override",
})

-- 3. Layer Rules
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.15,
})

-- 4. Floating & Positioning Rules
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "float-pavucontrol",
	match = { class = "^(pavucontrol)$" },
	float = true,
})

hl.window_rule({
	name = "float-nm-connection-editor",
	match = { class = "^(nm-connection-editor)$" },
	float = true,
})

hl.window_rule({
	name = "float-blueman-manager",
	match = { class = "^(blueman-manager)$" },
	float = true,
})

hl.window_rule({
	name = "float-open-file",
	match = { title = "^(Open File)$" },
	float = true,
})

hl.window_rule({
	name = "float-save-file",
	match = { title = "^(Save File)$" },
	float = true,
})

-- Auto-float and size Zathura PDF reader
hl.window_rule({
	name = "float-zathura",
	match = { class = "^(org.pwmt.zathura)$" },
	float = true,
	size = "900 1100",
	center = true,
})

-- Auto-float and size dedicated Floating Notes window
hl.window_rule({
	name = "float-notes",
	match = { class = "^(floating-notes)$" },
	float = true,
	size = "700 850",
	center = true,
})

-- Study Timer HUD
hl.window_rule({
	name = "float-study-hud",
	match = { class = "^(study-hud)$" },
	float = true,
	pin = true,
	size = "460 180",
	move = "100%-470 35",
})

-- Floating utility terminal (e.g. nmtui)
hl.window_rule({
	name = "float-term",
	match = { class = "^(float-term)$" },
	float = true,
	size = "750 500",
	center = true,
})
