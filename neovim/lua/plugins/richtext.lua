return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { blink = { enabled = true } },
      code = { width = "block" , position = "right", left_pad = 1 , right_pad = 1, language_pad = 1 },
      bullet = {
        right_pad = 1 },
    },
  },
}
