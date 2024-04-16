return {
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = true,
			float = {
				-- Padding around the floating window
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				override = function(conf)
					return conf
				end,
			},
		},
		keys = {
			{ "<Leader>e", vim.cmd.Oil },
		},
	},
	-- "nvim-tree/nvim-tree.lua",
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	--  enable = false,
	-- config = function()
	-- 	require("nvim-tree").setup({
	--      update_focused_file = {
	--        enable = true,
	--      },
	-- 		view = {
	-- 			side = "right",
	-- 		},
	-- 	})
	-- end,
}
