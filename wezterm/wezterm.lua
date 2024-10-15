local wezterm = require("wezterm")
local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" then
		config.webgpu_preferred_adapter = gpu
		break
	end
end
config.front_end = "WebGpu"

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

config.cursor_thickness = 2
config.underline_thickness = 1
config.underline_position = -2

if wezterm.target_triple:find("apple") then
	config.font_size = 16
	config.underline_position = -12
end

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

config.win32_system_backdrop = "Tabbed"
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

local win_size_presets = {
	uwide = {
		normal = {
			width = 1791,
			height = 1002,
			top = 10,
			left = 350,
		},
		mdev = {
			width = 1701,
			height = 1026,
			top = 5,
			left = 505,
		},
		video = {
			width = 1449,
			height = 1026,
			top = 5,
			left = 10,
		},
	},
}

local function get_display_profile_name()
	local screen = wezterm.gui.screens().active
	local ratio = screen.width / screen.height

	if ratio > 2 then
		return "uwide"
	end
	return "macbpro"
end

local function window_to_size(preset)
	local gui = wezterm.gui.gui_windows()[1]

	gui:set_position(preset.left, preset.top)
	gui:set_inner_size(preset.width, preset.height)
end

local function to_size(name)
	local profile = win_size_presets[get_display_profile_name()][name]
	window_to_size(profile)
end

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local win = window:gui_window()

  to_size("normal")
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			to_size("video")
		end),
	},
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			to_size("normal")
		end),
	},
	{
		key = "d",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			to_size("mdev")
		end),
	},
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
}
-- and finally, return the configuration to wezterm
return config
