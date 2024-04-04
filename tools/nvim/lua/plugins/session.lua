return {
	"rmagatti/auto-session",
	config = function()
    local hist_file = "~/.local/share/nvim/auto_session/history.undo"
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_enable_last_session = true,
      pre_save_cmds = {
        function ()
          return [["tabdo NvimTreeClose"]]
        end,
        "wundo " .. hist_file
      },
      post_restore_cmds = { "rundo " .. hist_file }
		})
		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
