return {
  {
    "chipsenkbeil/distant.nvim",
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

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      -- vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      -- vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  --[[ "smoka7/hop.nvim",
	version = "*",
	config = function()
		-- place this in one of your configuration file(s)
		local hop = require("hop")
		local directions = require("hop.hint").HintDirection
		vim.keymap.set("", "f", function()
			hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
		end, { remap = true })
		vim.keymap.set("", "F", function()
			hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
		end, { remap = true })
		vim.keymap.set("", "t", function()
			hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
		end, { remap = true })
		vim.keymap.set("", "T", function()
			hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
		end, { remap = true })
	end, ]]
}
