return {
  {
    "rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("solarized-osaka").setup({
        transparent = true,
        styles = {
          dim_inactive = true,
        },
        on_colors = function(colors)
          colors.green = "#0aaf27"
        end,
      })
      vim.cmd([[colorscheme solarized-osaka-night]])
    end,
  },
}
