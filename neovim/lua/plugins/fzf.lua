return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup({
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

    local wk = require("which-key")
    wk.add({
      { "<leader>ff", "<cmd>FzfLua files<CR>",                      desc = "Find Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>",                    desc = "Find Buffers" },
      { "<leader>ft", "<cmd>FzfLua live_grep<CR>",                  desc = "Find Text" },
      { "<leader>fs", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Find Workspace Symbol" },
      { "<leader>fd",
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
        desc = "Find Dotfiles" },
      { "<leader>ca",
        function()
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
        end,
        desc = "See the Code Actions",
        mode = { "n", "v" } },
    })
  end,
}
