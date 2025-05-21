return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
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
  {
    "folke/zen-mode.nvim",
    enabled = false,
    -- ft = { "markdown" },
    config = function()
      local opts = {
        window = {
          width = 88,
        },
      }

      require("zen-mode").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.defer_fn(function()
            vim.cmd("ZenMode")
          end, 100) -- 100ms delay
        end,
      })
    end,
  },
}
