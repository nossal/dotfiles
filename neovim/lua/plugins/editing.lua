return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<C-n>", "<cmd>lua require('illuminate').goto_next_reference{wrap=true}<CR>", desc = "Move to next reference" },
      { "<C-p>", "<cmd>lua require('illuminate').goto_prev_reference{wrap=true}<CR>", desc = "Move to previous reference" },
    },
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        filetypes_denylist = {
          "oil",
          "markdown",
          "text",
          "dirbuf",
          "dirvish",
          "fugitive",
          "lazy",
          "NeogitStatus",
          "NeogitCommitView",
          "TelescopePrompt",
          "Trouble",
          "DiffviewFiles",
          "DiffviewFileHistory",
        },
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
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
}
