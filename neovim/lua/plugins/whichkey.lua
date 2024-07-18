return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require("which-key")
    wk.add({
      { "<leader>f", group = "file" },
      { "<leader>h", group = "GitHunks" },
    })
  end,
  opts = {},
}
