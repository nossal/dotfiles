return {
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
          colors.bg = "#121119"
          colors.bg_float = "#121119"
        end,
        on_highlights = function(hl, c)
          -- hl.GitConflictCurrent = {
          --   bg =
          -- }
          -- hl.GitConflictIncoming
          -- hl.GitConflictAncestor
          -- hl.GitConflictCurrentLabel
          -- hl.GitConflictIncomingLabel
          -- hl.GitConflictAncestorLabel

          hl.EndOfBuffer = {
            fg = util.lighten("#000000", 0.93),
            -- bg = util.lighten("#000000", 0.95),
          }
          hl.ColorColumn = { bg = util.lighten(c.bg, 0.99) }
          hl.ErrorMsg = { bg = c.red500, fg = "#cccccc" }

          hl.Whitespace = { fg = "#424250" }
          hl.StatusLine = {
            bg = "#1B1D1C",
            fg = "#757575",
          }
          hl.Constant = { fg = c.green }
          hl.String = { fg = c.green }

          hl.LineNr = { fg = "#42352f" }
          hl.CursorLineNr = { fg = "#aa4400" }
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
