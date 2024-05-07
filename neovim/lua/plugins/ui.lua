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
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "j-hui/fidget.nvim",
    enabled = false,
    opts = {
      -- options
    },
  },
}
