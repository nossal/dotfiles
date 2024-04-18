vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Lazy neovim plugin manager" })
keymap.set("n", "<leader>M", ":Mason<CR>", { desc = "Mason LSP package manager" })

keymap.set("n", "<leader>ch", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<lcader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "lp", ":normal o<ESC>p==", { desc = "Paste text after current line" })
keymap.set("n", "lP", ":normal O<ESC>p==", { desc = "Past text before current line" })
