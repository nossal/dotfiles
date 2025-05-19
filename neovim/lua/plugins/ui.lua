return {
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
        sections = {
          { section = "terminal", cmd = "cat ~/.dotfiles/neovim/neo.txt", height = 8, padding = 1 },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      input = {},
      indent = {
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
      image = {},
    },
  },
  { "nvim-tree/nvim-web-devicons" },
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
          enabled = false,
        },
        signature = {
          enabled = false,
        },
        documentation = {
          enabled = false,
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
      -- add any options here
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
    opts = {
      -- options
    },
  },
}
