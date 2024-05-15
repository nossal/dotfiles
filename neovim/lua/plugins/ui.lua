return {
  { "nvim-tree/nvim-web-devicons" },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        render = "compact",
        stages = "fade",
        fps = 60,
      })
      vim.notify = notify
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "j-hui/fidget.nvim",
    enabled = false,
    opts = {
      -- options
    },
  },
  {
    "b0o/incline.nvim",
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      local a = vim.api

      require("incline").setup({
        render = function(props)
          local buf_focused = props.buf == a.nvim_get_current_buf()
          local modified = vim.bo[props.buf].modified
          local diag_disabled = vim.diagnostic.is_disabled(props.buf)
          local has_error = not diag_disabled
            and #vim.diagnostic.get(props.buf, {
                severity = vim.diagnostic.severity.ERROR,
              })
              > 0
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end

          local ft_icon, ft_color = devicons.get_icon_color(filename)
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        hide = {
          only_win = false,
          cursorline = "focused_win",
          focused_win = true,
        },
      })
    end,
    -- Optional: Lazy load Incline
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
