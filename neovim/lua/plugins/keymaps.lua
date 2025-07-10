return {
  "folke/which-key.nvim",
  -- event = "VeryLazy",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  init = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>f", group = "file/find", icon = "󰈞" },
      { "<leader>h", group = "Git" },
      { "<leader>e", group = "Explorer Oil", icon = "󰙅" },

      { "<leader>L", ":Lazy<CR>", desc = "Lazy" },
      { "<leader>M", ":Mason<CR>", desc = "Mason" },

      { "<leader>lw", ":set wrap!<CR>", desc = "Toggle Line Wrap" },

      -- { "<leader>ch", ":nohl<CR>", desc = "Clear Search Highlights" },

      { "<leader>sv", "<C-w>v", desc = "Split window vertically" },
      { "<leader>sh", "<C-w>s", desc = "Split window horizontally" },
      { "<leader>se", "<C-w>=", desc = "Make splits equal size" },
      { "<leader>sx", "<cmd>close<CR>", desc = "Close current split" },

      { "lp", ":normal o<ESC>p==", desc = "Paste After current line" },
      { "lP", ":normal O<ESC>p==", desc = "Past Before current line" },

      --  FZF --
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find Buffers" },
      { "<leader>ft", "<cmd>FzfLua live_grep<CR>", desc = "Find Text" },
      { "<leader>fs", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Find Workspace Symbol" },
      {
        "<leader>fd",
        function()
          require("fzf-lua").files({
            prompt = "dotfiles❯ ",
            cwd = "~/.dotfiles",
            winopts = {
              preview = { hidden = true },
              height = 0.35,
              width = 0.50,
              title = " ~ dotfiles ~ ",
              title_flags = false,
              backdrop = 95,
            },
          })
        end,
        desc = "Find Dotfiles",
      },
      {
        "<leader>ca",
        function()
          require("fzf-lua").lsp_code_actions({
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
        mode = { "n", "v" },
      },
    })
  end,
  opts = {
    preset = "helix",
    delay = 1500,
  },
}
