return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	config = function()
	    local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup({
		    capabilities = capabilities
        })
		lspconfig.clojure_lsp.setup({
		    capabilities = capabilities
        })
		lspconfig.rust_analyzer.setup({
		    capabilities = capabilities
        })

		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

	end,
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "rust_analyzer", "clojure_lsp" },
				})
			end,
		},
		"jay-babu/mason-nvim-dap.nvim",

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",

		"mfussenegger/nvim-jdtls",
	},
	--    {
	--        "mfussenegger/nvim-jdtls",
	--        config = function()
	--            local config = {
	--                cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
	--                root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
	--            }
	--            require("jdtls").start_or_attach(config)
	--        end
	--    }
}
