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
          colors.fg_float = "#42352f"
        end,
        on_highlights = function(hl, c)
          hl.FloatBorder = { fg = c.fg_float }

          hl.SnacksIndent= { fg = util.lighten(c.bg, 0.97) }
          -- hl.GitConflictCurrent = {
          --   bg =
          -- }
          -- hl.GitConflictIncoming
          -- hl.GitConflictAncestor
          -- hl.GitConflictCurrentLabel
          -- hl.GitConflictIncomingLabel
          -- hl.GitConflictAncestorLabel
          hl.GitSignsAdd    = { fg = "#219500" }
          hl.GitSignsChange = { fg = "#ff6600"}
          hl.GitSignsDelete = { fg = c.red500 }

          hl.llama_hl_hint = { bg = "#000000", fg = "#666666" }

          hl.EndOfBuffer = {
            fg = util.lighten("#000000", 0.93),
            -- bg = util.lighten("#000000", 0.95),
          }
          hl.ColorColumn = { bg = util.lighten(c.bg, 0.99) }
          hl.ErrorMsg = { bg = c.red500, fg = "#cccccc" }

          hl.Whitespace = { fg = "#424250" }
          hl.StatusLine = {
            bg = "#121212",
            fg = "#444444",
          }
          hl.Constant = { fg = c.green }
          hl.String = { fg = c.green }

          hl.LineNr = { fg = "#4b4c4e" }
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
          hl.BlinkCmpSignatureHelpActiveParameter = {
            bg = util.lighten(c.bg, 0.9),
            underline = true,
          }
        end,
      })
      vim.cmd([[colorscheme solarized-osaka]])
    end,
  },
}
