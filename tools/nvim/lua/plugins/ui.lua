return {
	{
		"stevearc/dressing.nvim",
		opts = {},
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
}
