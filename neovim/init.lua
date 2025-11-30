require("core")

local core_ui = require("core.ui")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  checker = {
    enabled = true,
    frequency = 604800,
  },
  ui = {
    border = core_ui.border,
    size = { width = 0.5, height = 0.8 },
    backdrop = 95,
    title = " Lazy Plugin Manager ",
    title_pos = "left",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("fzf-lua").register_ui_select(function(opts, items)
  local min_h, max_h = 0.15, 0.45
  local h = (#items + 4) / vim.o.lines
  if h < min_h then
    h = min_h
  elseif h > max_h then
    h = max_h
  end
  opts.title = opts.title or "Select"

  return { winopts = { title = opts.title, height = h, width = 0.40, row = 0.40 } }
end)
