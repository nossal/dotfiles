return {
  "rmagatti/auto-session",
  config = function()
    local function file_exists(name)
      local f = io.open(name, "r")
      if f ~= nil then
        io.close(f)
        return true
      else
        return false
      end
    end

    local undo_file_tpl = vim.fn.expand("~") .. "/.local/share/nvim/auto_session/hist-%s.undo"

    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_enable_last_session = true,
      pre_save_cmds = {
        function()
          return [["tabdo NvimTreeClose"]]
        end,
        function()
          local undo_file = string.format(undo_file_tpl, require("auto-session.lib").current_session_name())
          require("notify")("Undo write: " .. undo_file)

          vim.cmd("wundo " .. undo_file)
        end,
      },
      post_restore_cmds = {
        function()
          local undo_file = string.format(undo_file_tpl, require("auto-session.lib").current_session_name())
          -- require("notify")("Session: " .. undo_file)

          if file_exists(undo_file) then
            vim.cmd("rundo " .. undo_file)
          end
        end,
      },
    })
    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
  end,
}
