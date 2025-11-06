local function list(items, sep)
  return table.concat(items, sep or ",")
end

local g = vim.g
local o = vim.o
local opt = vim.opt
local fn = vim.fn

local textwidth = 80

g.mapleader = " "
g.maplocalleader = " "

-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
-- g.tutor_is_loaded = 1

g.have_nerd_font = true
-- line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
opt.relativenumber = true -- show relative line numbers
opt.colorcolumn = tostring(textwidth) -- Show column at character 80
-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true -- Insert indents automatically

o.modeline = true

-- line wrapping
opt.wrap = false -- disable line wrapping
opt.showbreak = "⤷ "
opt.breakindent = true
opt.linebreak = true
-- opt.breakindentopt = "shift:2"
-- opt.textwidth = textwidth

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = true -- highlight search terms
opt.inccommand = "split" -- real time preview of substitution commands

-- cursor line
opt.cursorline = true -- highlight the current cursor line

opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.formatoptions = "jcroqlnt" -- Smart autoindent, comment handling, list formatting

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

opt.iskeyword:append("-") -- Treat dash as part of word

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = false -- split horizontal window to the bottom

-- mouse & scroll
opt.mousescroll = "ver:1,hor:1"
opt.mouse = "a"
opt.scrolloff = 6 -- Keep 6 lines above/below cursor when scrolling
opt.sidescrolloff = 6 -- Keep 6 columns to the sides when scrolling horizontally
opt.sidescroll = 3

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
opt.shada = list({
  "!",
  "'100", -- Remember marks for 100 files
  '"500', -- Remember 500 lines in registers
  "/100", -- 100 search patterns
  ":500", -- 500 command-line items
  "<50", -- Remember 50 buffers
  "@50", -- 50 input line history items
  "f1", -- Store file marks
  "h", -- No hlsearch when starting
  "s10", -- Item size limit 10KB
  "%", -- Save and restore the buffer list
})

-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
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
  "foldsep: ",
  "msgsep:─",
  "eob:█",
})

-- File Handling
opt.encoding = "utf-8"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = fn.stdpath("cache") .. "/undo"
opt.undolevels = 100
opt.undoreload = 100
opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time; Displays which-key popup sooner
opt.autoread = true  -- Auto reload files changed outside vim
opt.autowrite = false -- Don't auto save


-- Folding
o.foldcolumn = "0" -- '0' is not bad
o.foldlevel = 20 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 20
o.foldenable = true

-- opt.foldmethod = "expr"
-- -- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- Cursor settings
vim.api.nvim_set_hl(0, 'VisualCursor', { bg = '#ff6b6b', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'InsertCursor', { bg = '#4ecdc4', fg = '#000000' })
vim.api.nvim_set_hl(0, 'ReplaceCursor', { bg = '#ffe66d', fg = '#000000' })
vim.api.nvim_set_hl(0, 'CommandCursor', { bg = '#a8e6cf', fg = '#000000' })
vim.api.nvim_set_hl(0, 'OperatorCursor', { bg = '#ff8b94', fg = '#ffffff' })

opt.guicursor = list {
    -- Normal, Visual, Command modes
  "n:block-Cursor/lCursor",
  "v:block-VisualCursor/lVisualCursor",
  "c:ver25-CommandCursor/lCommandCursor",

  -- Insert and related modes
  "i:ver25-InsertCursor/lInsertCursor",
  "ci:ver25-InsertCursor/lInsertCursor",
  "ve:ver25-InsertCursor/lInsertCursor",

  -- Replace modes
  "r:hor20-ReplaceCursor/lReplaceCursor",
  "cr:hor20-ReplaceCursor/lReplaceCursor",

  -- Operator pending and others
  "o:hor50-OperatorCursor/lOperatorCursor",
  "sm:block-Cursor/lCursor",

  "a:blinkwait700-blinkoff150-blinkon450",
}


opt.title = true

opt.conceallevel = 2

opt.showmode = false -- Do not show -- MODE -- in cmdline--
opt.showcmd = true
opt.showtabline = 0
opt.cmdheight = 0
opt.pumheight = 10

opt.laststatus = 3

opt.pyxversion = 3

-- Performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

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
