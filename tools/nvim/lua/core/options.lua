local g = vim.g
local o = vim.o
local opt = vim.opt
local fn = vim.fn

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

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

-- Sets how neovim will display certain whitespace characters in the editor.
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.fillchars:append({
  eob = "█"
})

-- turn off swapfile
opt.swapfile = false

-- opt.foldmethod = "expr"
-- -- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldtext = "v:lua.vim.treesitter.foldtext()"

opt.encoding = "utf-8"

opt.title = true

-- opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.conceallevel = 2
opt.breakindent = true

opt.showmode = false -- Do not show -- MODE -- in cmdline--
opt.showcmd = true
opt.showtabline = 0
opt.cmdheight = 0
o.cmdheight = 0


opt.laststatus = 3

opt.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Decrease mapped sequence wait time; Displays which-key popup sooner

vim.g.have_nerd_font = true

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Folding
-- o.foldmethod = "expr"
-- o.foldexpr = "nvim_treesitter#foldexpr()"
-- function CustomFoldText()
--     return fn.getline(vim.v.foldstart) .. " ... " .. fn.getline(vim.v.foldend):gsub("^%s*", "")
-- end
--
-- -- opt.foldtext = "v:lua.CustomFoldText()"
-- opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- o.termguicolors = true -- enable gui colors for terminal
-- g.vimsyn_embed = "lPr"
-- g.tex_flavor = "latex"
-- o.encoding = "utf-8"
-- o.modeline = true
-- o.mouse = "a" -- enable mouse for all modes
-- o.mousescroll = "ver:1,hor:1"
-- o.errorbells = false -- remove all errors
-- o.visualbell = false
-- o.history = 1000 -- remember more commands and search history
-- o.undolevels = 1000 -- use many muchos levels of undo
-- o.title = true -- change the terminal's title
-- o.backup = false -- no backup file
-- o.swapfile = false -- don't write .swp files
-- o.undofile = true -- default `undodir = ~/.local/share/nvim/undo/`
-- o.wrap = false -- don't wrap lines
-- o.tabstop = 4 -- a tab is four spaces
-- o.shiftwidth = o.tabstop -- number of spaces to use for autoindenting
-- o.shiftround = true -- use multiple of shiftwidth when indenting with '<' and '>'
-- o.expandtab = true -- expand tab to count tabstop n° of spaces
-- o.backspace = "indent,eol,start" -- allow backspacing over everything in insert mode
-- o.autoindent = true
-- o.copyindent = true -- copy the previous indentation on autoindenting
-- o.number = true -- always show line numbers
-- o.relativenumber = true
-- o.showmatch = true -- show matching parenthesis with a quick jump
-- o.ignorecase = true -- ignore case when searching with / or ?
-- o.smartcase = true -- ignore case if search pattern is all lowercase, case-sensitive otherwise
-- o.smarttab = true -- insert tabs on the start of a line according to shiftwidth, not tabstop
-- o.hlsearch = true -- highlight search terms
-- o.incsearch = true -- show search matches as you type
-- o.hidden = true -- allow modified buffers to be hidden
-- o.wildignore = "*.swp,*.bak,*.pyc,*.class"
-- o.wildmode = "longest,full" -- set the behavior of the completion menu
-- o.wildmenu = true -- diplay command completion listing and choice menu
-- opt.wildoptions:append({ "pum" })
-- o.wildcharm = 26 -- trigger completion in macros
-- o.wildignorecase = true -- ignore case command completion menu
-- -- o.clipboard = "unnamed"         -- send yanks to system clipboard (buggy with v-block)
-- o.showcmd = true -- show key spressed in lower-right corner
-- o.sidescroll = 1 -- smooth side scrolling
-- -- o.scrolloff = 16 -- minimal number of lines above/below cursor (see autocommands)
-- o.splitkeep = "screen"
-- o.conceallevel = 2 -- conceal marked text
-- o.completeopt = "menuone,noinsert,noselect"
-- o.pumheight = 15 -- set menu max height
-- o.maxmempattern = 5000

-- opt.fillchars:append({
-- 	fold = " ",
-- 	horiz = "━", -- '▃',--'═', --'─',
-- 	horizup = "┻", --'╩',-- '┴',
-- 	horizdown = "┳", --'╦', --'┬',
-- 	vert = "┃", --'▐', --'║', --'┃',
-- 	vertleft = "┨", --'╣', --'┤',
-- 	vertright = "┣", --'╠', --'├',
-- 	verthoriz = "╋", --'╬',--'┼','
-- })

-- opt.fillchars:append({ foldopen = "▾", foldsep = "│", foldclose = "▸" })
-- opt.fillchars:append({ diff = "╲" })

-- o.inccommand = "nosplit" -- real time preview of substitution commands
-- o.showmode = false -- Do not show -- MODE -- in cmdline--
-- o.cmdheight = 1 -- Height of the command line
-- o.updatetime = 300 -- time required to update CursorHold hook
-- opt.shortmess:append({ c = true })
-- -- -- o.printdevice       = "OLIVETTI_d_COPIA4500MF_plus__2_"
-- o.showbreak = "↪ "
-- o.listchars = "tab:|.,trail:_,extends:>,precedes:<,nbsp:~,eol:¬"
-- o.signcolumn = "yes"
-- o.splitbelow = true
-- o.splitright = true
-- o.foldenable = false
-- opt.jumpoptions:append({ "view" })

-- o.dictionary = "/usr/share/dict/words"
-- o.spelloptions = "noplainbuffer"
-- opt.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50"

--[[ function CustomFoldText()
	return fn.getline(vim.v.foldstart) .. " ... " .. fn.getline(vim.v.foldend):gsub("^%s*", "")
end

opt.foldtext = "v:lua.CustomFoldText()" ]]


