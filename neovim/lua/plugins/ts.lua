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
        "lua",
        "bash",
        "java",
        "javadoc",
        "kotlin",
        "groovy",
        "ocaml",
        "ocaml_interface",
        "python",
        "rust",
        "go",
        "clojure",
        "vim",
        "javascript",
        "typescript",
        "jsdoc",
        "html",
        "css",
        "tsx",
        "svelte",
        "json",
        "yaml",
        "toml",
        "ini",
        "csv",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "terraform",
        "helm",
        "query",
        "regex",
        "tmux",
        "gitcommit",
        "gitattributes",
        "gitignore",
        "git_config",
        "git_rebase",
        "diff",
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
