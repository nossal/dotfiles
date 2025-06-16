return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "Avante" },
      completions = { blink = { enabled = true } },
      code = { width = "block", position = "right", left_pad = 1, right_pad = 1, language_pad = 1 },
      heading = {
        width = "block",
        right_pad = 1,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      pipe_table = { preset = "round" },
      bullet = {
        right_pad = 1,
        left_pad = 2,
      },
      checkbox = {
        custom = {
          todo = { raw = "[+]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
          follow = { raw = "[>]", rendered = "󰥔 ", highlight = "RenderMarkdownFollow", scope_highlight = nil },
          canceled = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownCancelled", scope_highlight = nil },
        },
      },
    },
  },
}
