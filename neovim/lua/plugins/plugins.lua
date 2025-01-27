return {
  {
    "chipsenkbeil/distant.nvim",
    enabled = false,
    cmd = { "DistantConnect", "DistantLaunch", "DistantInstall", "DistantOpen" },
    branch = "v0.3",
    config = function()
      require("distant"):setup({
        ["network.private"] = true,
        ["network.unix_socket"] = "/tmp/distant.sock",
      })
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
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
