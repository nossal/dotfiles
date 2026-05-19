return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      user_default_options = {
        names = false,
        hsl_fn = true,
        css_fn = true,
        mode = "virtualtext",
        virtualtext = " ",
      },
    },
  },
  { "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
  {
    "uga-rosa/ccc.nvim",
    config = function()
      local ccc = require("ccc")
      ccc.setup({
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_oklch,
          ccc.picker.css_oklab,
        },
        -- recognize = {
        --   input = true,
        --   output = true,:
        --   pattern = {
        --     [ccc.picker.css_oklch] = { ccc.input.oklch, ccc.output.css_oklch },
        --   },
        -- },
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  },
}
