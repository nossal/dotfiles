local wezterm = require("wezterm")
local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.front_end = 'OpenGL'
-- for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
-- 	if gpu.backend == "Vulkan" then
-- 		config.webgpu_preferred_adapter = gpu
-- 		break
-- 	end
-- end

config.keys = {
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

local tmux_bin = "tmux"
if wezterm.target_triple:find("apple") then
	tmux_bin = "/usr/local/bin/tmux"
end

config.default_prog = { tmux_bin, "new", "-A", "-s", "work" }

if wezterm.target_triple:find("windows") then
	config.wsl_domains = {
		{
			name = "wsl",
			distribution = "fedora",
			default_cwd = "~",
			default_prog = config.default_prog,
		},
	}
	config.default_domain = "wsl"
end

config.color_schemes = {
	["nossal"] = {
		background = "#1e1e1e",
		foreground = "#C3C5C9",
		cursor_bg = "#d10069",
		cursor_fg = "#C3C3C3",
		ansi = {
			"#434859",
			"#DC3C3C",
			"#04BA1D",
			"#CC9C57",
			"#055F9C",
			"#AB358F",
			"#067F80",
			"#B3B4BA",
		},
		brights = {
			"#626878", -- black
			"#DB5151", -- red
			"#32E830", -- green
			"#D9B172", -- yellow
			"#4E78B3", -- blue
			"#C85EAF", -- magenta
			"#4E78B3", -- cyan
			"#CBCED4", -- white
		},
	},
}
config.color_scheme = "nossal"

config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

config.font = wezterm.font_with_fallback({ "MesloLGM Nerd Font Propo", "Symbols Nerd Font Mono" })
config.bold_brightens_ansi_colors = true
config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({ family = "Maple Mono NF", weight = "Bold", style = "Italic" }),
	},
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font({ family = "Maple Mono NF", weight = "DemiBold", style = "Italic" }),
	},
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font({ family = "Maple Mono NF", style = "Italic" }),
	},
}
config.font_size = 11
config.line_height = 1.2

if wezterm.target_triple:find("apple") then
	config.font_size = 16
	config.underline_position = -12
end

config.cursor_thickness = 2
config.underline_thickness = 2
config.underline_position = -6

config.term = "xterm-256color"

config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 75,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 75,
	target = "CursorColor",
}
config.cursor_blink_rate = 300
config.cursor_blink_ease_in = "EaseIn"
config.cursor_blink_ease_out = "EaseOut"
config.animation_fps = 60
config.default_cursor_style = "BlinkingBar"

config.macos_window_background_blur = 50
config.window_background_opacity = 0.97
config.win32_system_backdrop = 'Tabbed'
config.window_decorations = "RESIZE"
--
config.window_background_gradient = {
	colors = { "#131122", "#121119" },
	noise = 70,
	orientation = {
	-- Specifices a Linear gradient starting in the top left corner.
		-- Linear = { angle = -45.0 },
		Radial = { cx = 0.75, cy = 0.75, radius = 0.8 },
	},
}

-- config.window_frame = {
--   border_left_width = '0.5cell',
--   border_right_width = '0.5cell',
--   border_bottom_height = '0.25cell',
--   border_top_height = '0.25cell',
--   border_left_color = 'purple',
--   border_right_color = 'purple',
--   border_bottom_color = 'purple',
--   border_top_color = 'purple',
-- }
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().active
	local tab, pane, window = mux.spawn_window(cmd or {
		width = 150,
		height = 50,
	})
	local top = 16
	local width_ratio = 0.7
	local ratio = screen.width / screen.height

	local line_height = math.floor((config.font_size * 1.819)) * config.line_height
	local line_width = 9
	local hgap = -line_height + 30

	local height = (screen.height / line_height - 3) * line_height - hgap
	if ratio < 2 then
		top = (screen.height - height) / 2
		width_ratio = 0.97
	end

	local gui = window:gui_window()
	local width = math.floor((width_ratio * screen.width) / line_width) * line_width

	gui:set_inner_size(width, height)
	gui:set_position((screen.width - width) / 2, top)
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

-- and finally, return the configuration to wezterm
return config
