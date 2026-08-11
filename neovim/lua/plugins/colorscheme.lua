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
          floats = "dark",
        },
        ---@param colors ColorScheme
        on_colors = function(colors)
          colors.green = "#0aaf27"
          colors.bg = "#121119"
          colors.bg_float = "#121119"
          colors.fg_float = "#42352f"
        end,
        ---@param hls Highlights
        ---@param colors ColorScheme
        on_highlights = function(hls, colors)
          hls.FloatBorder = { fg = colors.fg_float }

          hls.SnacksIndent = { fg = util.brighten(colors.bg, 0.03) }
          -- hl.GitConflictCurrent = {
          --   bg =
          -- }
          -- hl.GitConflictIncoming
          -- hl.GitConflictAncestor
          -- hl.GitConflictCurrentLabel
          -- hl.GitConflictIncomingLabel
          -- hl.GitConflictAncestorLabel
          hls.LspCodeLens = { fg = util.brighten(colors.bg, 0.15) }

          hls.GitSignsAdd = { fg = "#219500" }
          hls.GitSignsChange = { fg = "#ff6600" }
          hls.GitSignsDelete = { fg = colors.red500 }
          hls.GitSignsCurrentLineBlame = {
            fg = util.brighten(colors.bg, 0.2),
            italic = true,
          }

          hls.llama_hl_fim_hint = { bg = "#000000", fg = "#666666" }

          hls.EndOfBuffer = {
            fg = util.brighten("#000000", 0.05),
            -- bg = util.lighten("#000000", 0.95),
          }
          hls.ColorColumn = { bg = util.brighten(colors.bg, 0.01) }
          hls.ErrorMsg = { bg = colors.red500, fg = "#cccccc" }

          hls.Whitespace = { fg = "#424250" }
          hls.StatusLine = {
            bg = "#121212",
            fg = "#444444",
          }
          hls.Constant = { fg = colors.green }
          hls.String = { fg = colors.green }

          hls.LineNr = { fg = "#4b4c4e" }
          hls.CursorLineNr = { fg = "#aa4400" }
          hls.CursorLine = {
            -- bg = util.darken(c.bg, 0.1),
            bg = util.brighten(colors.bg, 0.03),
          }
          hls.BlinkCmpMenu = {
            bg = util.brighten(colors.bg, 0.05),
            fg = colors.fg,
          }
          hls.BlinkCmpMenuSelection = {
            bg = util.brighten(colors.bg, 0.15),
          }
          hls.BlinkCmpSignatureHelpActiveParameter = {
            bg = util.brighten(colors.bg, 0.1),
            underline = true,
          }
        end,
      })
      vim.cmd([[colorscheme solarized-osaka]])
    end,
  },
}





