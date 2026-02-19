return {
  {
    "nossal/cleantext.nvim",
    dir = "~/workspace/cleantext.nvim",
    cmd = { "CleanText", "CleanTextAnalyze" },
  },
  { "barreiroleo/ltex_extra.nvim", lazy = true },
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    lazy = true,
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })

      vim.keymap.set("n", "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<M-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<M-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  {
    "eandrju/cellular-automaton.nvim",
    enabled = false,
  },
}
