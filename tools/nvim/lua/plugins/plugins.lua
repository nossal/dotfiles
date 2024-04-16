return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function()
      require("distant"):setup({
        ["network.private"] = true,
        ["network.unix_socket"] = "/tmp/distant.sock",
      })
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
