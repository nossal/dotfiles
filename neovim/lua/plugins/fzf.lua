return {
  "ibhagwan/fzf-lua",
  -- optional = true,
  keys = {
    {
      "<leader>fd",
      function()
        require("fzf-lua").files({
          cwd = "~/.dotfiles",
          prompt = "Files❯ ",
          winopts = {
            preview = { hidden = true },
            height = 0.35,
            width = 0.50,
            title = " ~ dotfies ~ ",
            title_flags = false,
            backdrop = 95,
          },
        })
      end,
      desc = "Find Dotfiles",
    },
    {
      ",,",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>/",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Find Text",
    },
    {
      ",.",
      function()
        require("fzf-lua").lsp_live_workspace_symbols()
      end,
      desc = "Find Workspace Symbol",
    },
  },
  opts = {
    previewers = {
      builtin = {
        -- disable treesitter for files bigger than 100KB
        syntax_limit_b = 1024 * 100, -- 100KB
      },
    },

    oldfiles = {
      cwd_only = true,
      stat_file = true,
      include_current_session = true,
    },
    winopts = {
      preview = {
        delay = 10,
      },
    },
    keymap = {
      fzf = {
        ["ctrl-e"] = "up",
        ["ctrl-n"] = "down",
      },
    },
  },
}
