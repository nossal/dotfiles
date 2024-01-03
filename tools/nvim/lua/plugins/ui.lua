return {
	{
		"stevearc/dressing.nvim",
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
		"mrded/nvim-lsp-notify",
	},
}
