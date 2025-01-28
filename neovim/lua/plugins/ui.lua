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
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
        documentation = {
          enabled = false,
        }
      },
      cmdline = {
        format = {
          cmdline = { pattern = "^:", icon = " ", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = " ", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " ", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
          input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          render = "wrapped-compact",
          max_height = 6,
          max_width = 60,
          stages = "fade",
          fps = 60,
        },
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    enabled = true,
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
            ft_icon and { " ", ft_icon, " ", guifg = ft_color, guibg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "italic" or "bold" },
            " ",
            guibg = "#1c1b27",
          }
        end,
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        hide = {
          only_win = true,
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
