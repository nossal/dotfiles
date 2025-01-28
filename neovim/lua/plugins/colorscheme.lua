return {
  {
    "rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    -- enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      local util = require("solarized-osaka.util")
      require("solarized-osaka").setup({
        transparent = false,
        styles = {
          dim_inactive = true,
          floats = "dark",
        },
        on_colors = function(colors)
          colors.green = "#0aaf27"
        end,
        on_highlights = function(hl, c)
          hl.CursorLine = {
            -- bg = util.darken(c.bg, 0.1),
            bg = util.lighten(c.bg, 0.97),
          }
          hl.BlinkCmpMenu = {
            bg = util.lighten(c.bg, 0.95),
            fg = c.fg,
          }
          hl.BlinkCmpMenuSelection = {
            bg = util.lighten(c.bg, 0.85),
          }
        end,
      })
      vim.cmd([[colorscheme solarized-osaka]])
    end,
  },
}
