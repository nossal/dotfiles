local g = vim.g
local o = vim.o
local opt = vim.opt

local function list(items, sep)
  return table.concat(items, sep or ",")
end

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.have_nerd_font = true

-- line numbers
opt.relativenumber = false -- show relative line numbers
opt.number = false         -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

o.modeline = true
-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true    -- ignore case when searching
opt.smartcase = true     -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = true      -- highlight search terms
opt.inccommand = "split" -- real time preview of substitution commands

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

o.mousescroll = "ver:1,hor:1"
o.mouse = "a"

opt.sessionoptions = list({
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
})
opt.diffopt = list({
  "algorithm:histogram",
  "internal",
  "indent-heuristic",
  "filler",
  "closeoff",
  "iwhite",
  "vertical",
  "linematch:100",
})
opt.pyxversion = 3
opt.shada = list({
  "!",
  "'10",
  "/100",
  ":100",
  "<0",
  "@1",
  "f1",
  "h",
  "s1",
})
-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
-- opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.listchars = list({
  "tab: ──",
  "lead:·",
  "trail:•",
  "nbsp:␣",
  -- "eol:↵",
  "precedes:«",
  "extends:»",
})
opt.fillchars = list({
  -- "vert:▏",
  "vert:│",
  "diff:╱",
  "foldclose:",
  "foldopen:",
  "fold: ",
  "msgsep:─",
  -- "eob:█",
})
opt.showbreak = "⤷ "

-- turn off swapfile
opt.swapfile = false

opt.encoding = "utf-8"

opt.title = true

opt.conceallevel = 2
opt.breakindent = true

opt.showmode = false -- Do not show -- MODE -- in cmdline--
opt.showcmd = true
opt.showtabline = 0
opt.cmdheight = 0
o.cmdheight = 0
opt.pumheight = 10

opt.laststatus = 3

opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time; Displays which-key popup sooner

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
opt.rtp:prepend(lazypath)

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
          "gitcommit",
          "diff",
          "git_rebase",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        indent = { enable = true },
        highlight = { enable = true },
      })
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },
  { "rebelot/kanagawa.nvim" },
}, {
  checker = {
    enabled = false,
    frequency = 86400,
  },
  ui = {
    border = border,
    title = " Lazy Plugin Manager ",
    title_pos = "left",
  },
})

vim.cmd.colorscheme("kanagawa-dragon")
