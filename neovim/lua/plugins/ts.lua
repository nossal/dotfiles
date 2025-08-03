return {
  {
    "echasnovski/mini.ai",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "html",
          "java",
          "javascript",
          "css",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
          "gitcommit",
          "diff",
          "git_rebase",
        },
        auto_install = true,
        indent = { enable = true },
        highlight = { enable = true },
      })
    end,
  },
}
