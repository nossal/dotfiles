return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
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
        title_flags = false,
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

    keymap("n", "<leader>ff", "<cmd>FzfLua files<CR>", "Find Files")
    keymap("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", "Find Buffers")
    keymap("n", "<leader>ft", "<cmd>FzfLua live_grep<CR>", "Find Text")
    keymap("n", "<leader>fs", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", "Find Workspace Symbol")

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
