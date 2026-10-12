return {
  { "nvim-tree/nvim-web-devicons" },
  { "yorickpeterse/nvim-pqf" },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      styles = {
        input = {
          title_pos = "left",
          relative = "cursor",
          row = -3,
          col = 0,
          width = 30,
        },
        ccompact = {
          title_pos = "right",
        },
      },
      dashboard = {
        width = 68,
        sections = {
          { section = "terminal", cmd = "cat ~/.dotfiles/neovim/neo.txt", height = 9, padding = 0 },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          -- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      input = { enabled = true },
      indent = {
        enabled = true,
        animate = {
          duration = {
            total = 300,
          },
        },
        -- chunk = {
        --   enabled = true,
        -- }
      },
      notifier = {
        style = function(buf, notif, ctx)
          local title = vim.trim(notif.icon .. " " .. (notif.title or ""))
          if title ~= "" then
            ctx.opts.title = { { " " .. title .. " ", ctx.hl.title } }
            ctx.opts.title_pos = "right"
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
        end,
      },
      image = { enabled = true },
      bigfile = {
        notify = true,
        size = 2 * 1024 * 1024,
      },
      words = { enabled = true },
      toggle = {
        enabled = true,
        animate = {
          duration = {
            total = 300,
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
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
          enabled = true,
          silent = true, -- set to true to not have a hover popup show when lsp returns an error
        },
        signature = {
          enabled = false,
        },
        documentation = {
          enabled = true,
          view = "hover",
          ---@type NoiceViewOptions
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
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
      presets = {
        lsp_doc_border = true, -- add a border to hover docs and signature help
        long_message_to_split = true, -- long messages will be sent to a split
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- {

      --   "rcarriga/nvim-notify",
      --   opts = {
      --     render = "wrapped-compact",
      --     max_height = 6,
      --     max_width = 60,
      --     stages = "fade",
      --     fps = 60,
      --   },
      -- },
    },
  },
  {
    "j-hui/fidget.nvim",
    enabled = true,
    opts = {},
  },
  {
    "nossal/pane-resizer.nvim",
    -- dir = "~/workspace/pane-resizer.nvim",
    -- enabled = false,
    config = function()
      require("pane_resizer").setup({
        FOCUSED_WIDTH_PERCENTAGE = 0.6, -- Optional: focused window width (default: 0.7)
      })
    end,
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      local a = vim.api

      require("incline").setup({
        render = function(props)
          local buf_focused = props.buf == a.nvim_get_current_buf()
          local modified = vim.bo[props.buf].modified
          -- local diag_disabled = vim.diagnostic.is_disabled(props.buf)
          -- local has_error = not diag_disabled
          --   and #vim.diagnostic.get(props.buf, {
          --       severity = vim.diagnostic.severity.ERROR,
          --     })
          --     > 0
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
  },
}
