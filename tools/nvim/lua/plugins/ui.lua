local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

return {
  { "nvim-tree/nvim-web-devicons" },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        render = "compact",
        stages = "fade",
        fps = 60,
      })
      vim.notify = notify
    end,
  },
  -- {
  -- 	"mrded/nvim-lsp-notify",
  -- 	config = function()
  -- 		require("lsp-notify").setup({})
  -- 	end,
  -- },
}
