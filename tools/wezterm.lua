local wezterm = require("wezterm")
local mux = wezterm.mux
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

if wezterm.target_triple:find("windows") then
  config.default_prog = { "C:\\Windows\\System32\\wsl.exe", "-d", "fedora", "--cd", "~" }
end
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_schemes = {
  ["nossal"] = {
    background = "#1e1e1e",
    foreground = "#C3C5C9",
    cursor_bg = "#FF0000",
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
config.show_tabs_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.enable_tab_bar = false

config.font = wezterm.font("MesloLGM Nerd Font")
config.font_size = 11
if wezterm.target_triple:find("apple") then
  config.font_size = 16
end

config.underline_thickness = 3
config.cursor_thickness = 1
config.underline_position = -6

config.term = "xterm-256color"

-- config.animation_fps = 60

config.window_decorations = "RESIZE"
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
  top = 10,
  bottom = 0,
}

wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local tab, pane, window = mux.spawn_window(cmd or {
    width = 150,
    height = 50,
  })
  local top = 5
  local width_ratio = 0.5
  local ratio = screen.width / screen.height

  local height = 0.93 * screen.height
  if ratio < 2 then
    top = (screen.height - height) / 2 + 25
    width_ratio = 0.98
  end
  local gui = window:gui_window()
  local width = width_ratio * screen.width

  gui:set_inner_size(width, height)
  gui:set_position((screen.width - width) / 2, top)

  -- window:gui_window():maximize()
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

-- and finally, return the configuration to wezterm
return config
