
local a = vim.api
local Path = require("plenary.path")
-- local incline = require("incline")

local extra_colors = {
  theme_bg = "#222032",
  fg = "#FFFFFF",
  fg_dim = "#ded4fd",
  fg_nc = "#A89CCF",
  bg = "#55456F",
  bg_nc = "NONE",
}

local colors = {}

local function relativize_path(path, base)
  local abs_base = Path:new(base):absolute()
  local abs_path = Path:new(path):absolute()
  if string.sub(abs_path, 1, #abs_base) ~= abs_base then
    return path
  end
  return string.sub(abs_path, #abs_base + 2)
end

local function shorten_path(path, opts)
  opts = opts or {}
  local short_len = opts.short_len or 1
  local tail_count = opts.tail_count or 2
  local head_max = opts.head_max or 0
  local relative = opts.relative == nil or opts.relative
  local return_table = opts.return_table or false
  if relative then
    path = relativize_path(path, vim.uv.cwd())
  end
  local components = vim.split(path, Path.path.sep)
  if #components == 1 then
    if return_table then
      return { nil, path }
    end
    return path
  end
  local tail = { unpack(components, #components - tail_count + 1) }
  local head = { unpack(components, 1, #components - tail_count) }
  if head_max > 0 and #head > head_max then
    head = { unpack(head, #head - head_max + 1) }
  end
  local head_short = #head > 0 and Path.new(unpack(head)):shorten(short_len, {}) or nil
  if head_short == "/" then
    head_short = ""
  end
  local result = {
    head_short,
    table.concat(tail, Path.path.sep),
  }
  if return_table then
    return result
  end
  return table.concat(result, Path.path.sep)
end
local function shorten_path_styled(path, opts)
  opts = opts or {}
  local head_style = opts.head_style or {}
  local tail_style = opts.tail_style or {}
  local result = shorten_path(
    path,
    vim.tbl_extend("force", opts, {
      return_table = true,
    })
  )
  return {
    result[1] and vim.list_extend(head_style, { result[1], "/" }) or "",
    vim.list_extend(tail_style, { result[2] }),
  }
end

local get_file_info = function(props)
  local bufname = a.nvim_buf_get_name(props.buf)
  if bufname == "" then
    return { fname = "[No Name]" }
  end
  local fname = shorten_path_styled(bufname, {
    short_len = 1,
    tail_count = 2,
    head_max = 4,
    head_style = { guifg = extra_colors.fg_nc },
    tail_style = { guifg = extra_colors.fg },
  })
  return { fname = fname }
end

local function git_status(props)
  if not package.loaded["gitsigns"] then
    return
  end
  local gitsigns_cache = require("gitsigns.cache").cache
  local buf_cache = gitsigns_cache[props.buf]
  if not buf_cache then
    return
  end
  local res = {}
  if buf_cache.staged_diffs and #buf_cache.staged_diffs > 0 then
    table.insert(res, { " + ", group = "GitSignsAdd" })
  end
  if buf_cache.hunks and #buf_cache.hunks > 0 then
    table.insert(res, { " ϟ ", group = "GitSignsChange" })
  end
  return res
end
local get_icon = function(props)
  local devicons = require("nvim-web-devicons")
  local bufname = a.nvim_buf_get_name(props.buf)
  local buf_focused = props.buf == a.nvim_get_current_buf()
  local ft = vim.bo[props.buf].filetype
  local icon, accent_color
  if bufname ~= "" then
    icon, accent_color = devicons.get_icon_color(bufname)
  end
  if not icon or icon == "" then
    local icon_name
    if ft ~= "" then
      icon_name = devicons.get_icon_name_by_filetype(ft)
    end
    if icon_name and icon_name ~= "" then
      icon, accent_color = require("nvim-web-devicons").get_icon_color(icon_name)
    end
  end
  icon = icon or ""
  accent_color = accent_color or extra_colors.fg
  if not props.focused and buf_focused then
    return {
      icon = icon,
      fg = accent_color,
    }
  end
  -- local contrast_color = helpers.contrast_color(accent_color, {
  --   dark = colors.bg_dark,
  --   light = colors.fg,
  -- })
  return {
    icon = icon,
    fg = colors.bg_dark,
    bg = props.focused and accent_color or extra_colors.bg_nc,
  }
end

local wrap_status = function(bg, buf_focused, props, icon, status)
  return {
    {
      {
        "",
        guifg = props.focused and icon.bg or bg,
        guibg = props.focused and extra_colors.theme_bg or extra_colors.bg_nc,
      },
      {
        icon.icon,
        " ",
        guifg = buf_focused and icon.fg or colors.deep_velvet,
        guibg = props.focused and icon.bg or bg,
      },
      status,
      {
        "",
        guifg = bg,
        guibg = props.focused and extra_colors.theme_bg or extra_colors.bg_nc,
      },
    },
  }
end

local function get_tabline()
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
          {
            i .. " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_statusline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

local function get_tabline()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(tabline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return tabline
end

local function get_status()
  local props = {
    buf = a.nvim_get_current_buf(),
    focused = a.nvim_get_current_win() == a.nvim_list_wins()[1],
  }
  local tabline = get_tabline()
  local status = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(status, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  local statusline = {}
  for i, v in ipairs(a.nvim_list_wins()) do
    if a.nvim_win_get_config(v).relative == "editor" then
      table.insert(statusline, {
        {
          {
            "",
            guifg = extra_colors.bg_nc,
            guibg = extra_colors.theme_bg,
          },
          {
            " ",
            guifg = colors.deep_velvet,
            guibg = extra_colors.theme_bg,
          },
        },
      })
    end
  end
  return statusline
end

