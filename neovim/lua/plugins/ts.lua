return {
  {
    "nvim-mini/mini.ai",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    init = function()
      local ensureInstalled = {
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
      }
      local alreadyInstalled = require("nvim-treesitter.config").get_installed()
      local parsersToInstall = vim
        .iter(ensureInstalled)
        :filter(function(parser)
          return not vim.tbl_contains(alreadyInstalled, parser)
        end)
        :totable()
      require("nvim-treesitter").install(parsersToInstall)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
