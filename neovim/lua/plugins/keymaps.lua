return {
  "folke/which-key.nvim",
  -- event = "VeryLazy",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  init = function()
    local wk = require("which-key")
    wk.add({
      {
        mode = "v",
        { "<", "<gv", desc = "Indent left and reselect" },
        { ">", ">gv", desc = "Indent right and reselect" },
      },

      { "N", "Nzzzv", desc = "Previous search result (centered)" },
      { "n", "nzzzv", desc = "Next search result (centered)" },
      { "<C-d>", "<C-d>zz", desc = "Half page down (centered)" },
      { "<C-u>", "<C-u>zz", desc = "Half page up (centered)" },

      { "lp", ":normal o<ESC>p==", desc = "Paste After current line" },
      { "lP", ":normal O<ESC>p==", desc = "Past Before current line" },

      { "<leader>f", group = "file/find", icon = "󰈞" },
      { "<leader>h", group = "Git" },
      { "<leader>e", group = "Explorer Oil", icon = "󰙅" },

      { "<leader>L", ":Lazy<CR>", desc = "Lazy" },
      { "<leader>M", ":Mason<CR>", desc = "Mason" },

      { "<leader>lw", ":set wrap!<CR>", desc = "Toggle Line Wrap" },

      -- { "<leader>ch", ":nohl<CR>", desc = "Clear Search Highlights" },

      { "<leader>s", group = "Splits" },
      { "<leader>sv", "<C-w>v", desc = "Split window vertically" },
      { "<leader>sh", "<C-w>s", desc = "Split window horizontally" },
      { "<leader>se", "<C-w>=", desc = "Make splits equal size" },
      { "<leader>sx", "<cmd>close<CR>", desc = "Close current split" },

      --  FZF --
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find Buffers" },
      { "<leader>ft", "<cmd>FzfLua live_grep<CR>", desc = "Find Text" },
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
    })
  end,
  opts = {
    preset = "helix",
    delay = 1500,
  },
}
