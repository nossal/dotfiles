local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local tmux_bin = "tmux"
if wezterm.target_triple:find("apple") then
  tmux_bin = "/opt/homebrew/bin/tmux"
end

config.default_prog = { tmux_bin, "new", "-A", "-s", "work" }

local Profile = {
  RYZEN = "RYZEN",
  XONE = "XONE",
  MACPRO = "MACPRO",
  FEDORA = "FEDORA",
}

local PROFILES = {
  XONE = {
    config = {
      font_size = 13,
      underline_position = -6,
      enable_wayland = true,
      window_decorations = "NONE",
    },
    win_presets = {
      normal = {
        width = 2837,
        height = 1699,
      },
      mdev = {
        width = 1937,
        height = 1699,
      },
      video = {
        width = 1437,
        height = 1699,
      },
    },
  },
  RYZEN = {
    config = {
      underline_position = -3,
      window_decorations = "RESIZE",
      wsl_domains = {
        {
          name = "wsl",
          distribution = "fedora",
          default_cwd = "~",
          default_prog = config.default_prog,
        },
      },
      default_domain = "wsl",
    },
    win_presets = {
      normal = {
        width = 1790,
        height = 1002,
        top = 10,
        left = 350,
      },
      mdev = {
        width = 1700,
        height = 1026,
        top = 5,
        left = 505,
      },
      video = {
        width = 1600,
        height = 1026,
        top = 5,
        left = 10,
      },
    },
  },
  MACPRO = {
    config = {
      font_size = 16,
      underline_position = -6,
    },
    win_presets = {
      normal = {
        width = 2980,
        height = 1833,
        top = 90,
        left = 25,
      },
      mdev = {
        width = 1939,
        height = 1833,
        top = 90,
        left = 1065,
      },
    },
  },
  FEDORA = {
    config = {
      underline_position = -3,
      window_decorations = "NONE",
    },
    win_presets = {
      normal = {
        width = 1790,
        height = 1032,
      },
      mdev = {
        width = 1700,
        height = 1032,
      },
      video = {
        width = 1600,
        height = 1032,
      },
    },
  },
}

local function get_profile_name()
  local hostname = wezterm.hostname():lower()

  if string.find(hostname, "ryzenbox") then
    return Profile.RYZEN
  end
  if string.find(hostname, "ryzen") then
    return Profile.FEDORA
  end
  if string.find(hostname, "one") then
    return Profile.XONE
  end
  return Profile.MACPRO
end

local function update_config(original, updates)
  for key, value in pairs(updates) do
    original[key] = value
  end
end

-- for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
--   if gpu.backend == "Vulkan" then
--     config.webgpu_preferred_adapter = gpu
--     break
--   end
-- end
-- config.front_end = "WebGpu"
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

config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.term = "xterm-256color"
config.bold_brightens_ansi_colors = true

config.font = wezterm.font_with_fallback({
  { family = "0xProto Nerd Font Propo", weight = "Regular", harfbuzz_features = { "zero", "ss01", "cv05" } },
  "Fira Code",
})

local font_family = "Maple Mono NF"
config.font_rules = {
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font({ family = font_family, weight = "Bold", style = "Italic" }),
  },
  {
    intensity = "Normal",
    italic = true,
    font = wezterm.font({ family = font_family, style = "Italic" }),
  },
  {
    intensity = "Half",
    italic = true,
    font = wezterm.font({ family = font_family, weight = "Thin", style = "Italic" }),
  },
}
config.font_size = 12
config.line_height = 1.2

config.underline_thickness = 2
config.underline_position = -2

config.cursor_thickness = 2
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "EaseIn"

config.animation_fps = 60
-- config.max_fps = 120

-- config.visual_bell = {
--   fade_in_function = "EaseIn",
--   fade_in_duration_ms = 75,
--   fade_out_function = "EaseOut",
--   fade_out_duration_ms = 75,
--   target = "CursorColor",
-- }

-- config.win32_system_backdrop = "Tabbed"
config.window_decorations = "RESIZE"

config.window_background_gradient = {
  colors = { "#131122", "#121119" },
  noise = 70,
  orientation = {
    -- Specifices a Linear gradient starting in the top left corner.
    -- Linear = { angle = -45.0 },
    Radial = { cx = 0.75, cy = 0.75, radius = 0.8 },
  },
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local function window_to_size(preset)
  local gui = wezterm.gui.gui_windows()[1]

  gui:set_inner_size(preset.width, preset.height)
  if preset.top then
    gui:set_position(preset.left, preset.top)
  end
end

local function to_size(name)
  local preset = PROFILES[get_profile_name()].win_presets[name]
  window_to_size(preset)
end

wezterm.on("gui-startup", function(cmd)
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
    key = "m",
    mods = "LEADER",
    action = wezterm.action_callback(function(win, pane)
      to_size("mdev")
    end),
  },
  { key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
}

update_config(config, PROFILES[get_profile_name()].config)

return config
