return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    -- dependencies = {
    --   { "echasnovski/mini.ai", version = false },
    -- },
    build = ":TSUpdate",
    config = function()
      require("mini.ai").setup()

      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_instqlled = {
          "gitcommit",
          "diff",
          "git_rebase",
          "vim",
          "regex",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        indent = { enable = true },
        highlight = { enable = true },
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup()
    end,
  },
}
