return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>f", group = "file/find", icon = "󰈞" },
      { "<leader>h", group = "Git" },
      { "<leader>e", group = "Explorer Oil", icon = "󰙅" },

      { "<leader>L", ":Lazy<CR>", desc = "Lazy" },
      { "<leader>M", ":Mason<CR>", desc = "Mason" },

      { "<leader>lw", ":set wrap!<CR>", desc = "Toggle Line Wrap" },

      { "<leader>ch", ":nohl<CR>", desc = "Clear Search Highlights" },

      { "<leader>sv", "<C-w>v", desc = "Split window vertically" },
      { "<leader>sh", "<C-w>s", desc = "Split window horizontally" },
      { "<leader>se", "<C-w>=", desc = "Make splits equal size" },
      { "<leader>sx", "<cmd>close<CR>", desc = "Close current split" },

      { "lp", ":normal o<ESC>p==", desc = "Paste After current line" },
      { "lP", ":normal O<ESC>p==", desc = "Past Before current line" },
    })
  end,
  opts = {
    preset = "helix",
    delay = 1500,
  },
}
