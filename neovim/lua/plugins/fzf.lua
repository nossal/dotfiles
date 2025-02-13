return {
  "ibhagwan/fzf-lua",
  -- optional = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- keys = {
  --   {
  --     ",,",
  --     function()
  --       require("fzf-lua").files()
  --     end,
  --     desc = "Find Files",
  --   },
  --   {
  --     "<leader>fb",
  --     function()
  --       require("fzf-lua").buffers()
  --     end,
  --     desc = "Find Buffers",
  --   },
  --   {
  --     "<leader>/",
  --     function()
  --       require("fzf-lua").live_grep()
  --     end,
  --     desc = "Find Text",
  --   },
  --   {
  --     ",.",
  --     function()
  --       require("fzf-lua").lsp_live_workspace_symbols()
  --     end,
  --     desc = "Find Workspace Symbol",
  --   },
  -- },
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup({
      -- require("fzf-lua").setup({
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
        backdrop = 95,
        preview = {
          delay = 10,
        },
      },
      lsp = {
        code_actions = {
          prompt = "ca>",
          preview = {
            vertical = "down:45%",
            layout = "vertical",
          },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-e"] = "up",
          ["ctrl-n"] = "down",
        },
      },
    })

    local keymap = require("core.helpers").map

    keymap("n", "<leader>fd", function()
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
    end, "Find Dotfiles")

    keymap({ "n", "v" }, "<leader>ca", function()
      fzf.lsp_code_actions({
        prompt = "ca>",
        winopts = {
          height = 0.55,
          width = 0.50,
          preview = {
            hidden = true,
            vertical = "down:55%",
            layout = "vertical",
            -- border = "none",
            title = false,
            title_pos = "left",
          },
        },
      })
    end, "See the Code Actions")
  end,
}
