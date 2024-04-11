return {
	"nvimtools/none-ls.nvim",
  lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
        null_ls.builtins.formatting.biome,
        null_ls.builtins.formatting.djhtml,
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.diagnostics.eslint,
				-- null_ls.builtins.completion.spll,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
