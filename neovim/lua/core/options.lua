local g = vim.g
local o = vim.o
local opt = vim.opt
local fn = vim.fn

local function list(items, sep)
  return table.concat(items, sep or ",")
end

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

g.have_nerd_font = true

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

o.modeline = true
-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = true -- highlight search terms
opt.inccommand = "split" -- real time preview of substitution commands

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

o.mousescroll = "ver:1,hor:1"
o.mouse = "a"

opt.sessionoptions = list {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize"
}
opt.diffopt = list {
  "algorithm:histogram",
  "internal",
  "indent-heuristic",
  "filler",
  "closeoff",
  "iwhite",
  "vertical",
  "linematch:100",
}
opt.pyxversion = 3
opt.shada = list {
  "!",
  "'10",
  "/100",
  ":100",
  "<0",
  "@1",
  "f1",
  "h",
  "s1"
}
-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
-- opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.listchars = list {
  "tab: ──",
  "lead:·",
  "trail:•",
  "nbsp:␣",
  -- "eol:↵",
  "precedes:«",
  "extends:»"
}
opt.fillchars = list {
  -- "vert:▏",
  "vert:│",
  "diff:╱",
  "foldclose:",
  "foldopen:",
  "fold: ",
  "msgsep:─",
  "eob:█",
}
opt.showbreak = "⤷ "

-- turn off swapfile
opt.swapfile = false

-- opt.foldmethod = "expr"
-- -- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- opt.guicursor = list {
--   "n-v-c-sm:block-Cursor/lCursor",
--   "i-ci-ve:ver25-Cursor/lCursor",
--   "r-cr-o:hor20",
-- }

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

-- Undercurl
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- if os.getenv 'SSH_CLIENT' ~= nil or os.getenv 'SSH_TTY' ~= nil then
--   local function paste()
--     return {
--       vim.split(vim.fn.getreg '', '\n'),
--       vim.fn.getregtype '',
--     }
--   end
--   vim.g.clipboard = {
--     name = 'OSC 52',
--     copy = {
--       ['+'] = require('vim.ui.clipboard.osc52').copy '+',
--       ['*'] = require('vim.ui.clipboard.osc52').copy '*',
--     },
--     paste = {
--       ['+'] = paste,
--       ['*'] = paste,
--     },
--   }
-- end
