return {
  -- Theme inspired by Atom
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'tokyonight'
    require("tokyonight").setup({
      style = "storm"
    })
  end,
}
