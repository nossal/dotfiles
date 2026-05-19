return {
  {
   "nvim-mini/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
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
        "svelte",
        "vim",
        "yaml",
        "gitcommit",
        "diff",
        "git_rebase",
      },
    },
  },
}
