return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      "BufReadPre " .. vim.fn.expand("~") .. "/Documents/Notes/*",
      "BufNewFile " .. vim.fn.expand("~") .. "/Documents/Notes/*",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = vim.fn.expand("~/Documents/Notes"),
        },
        -- {
        --   name = "work",
        --   path = "~/vaults/work",
        -- },
      },
      -- ui = { enable = false },
      completion = {
        blink = {
          enabled = true,
          obsidian = { score_offset = 10 },
          obsidian_tags = {
            score_offset = 10,
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind = 10
              end
              return items
            end,
          },
        },
        nvum_cmp = false,
        min_chars = 2,
      },
      picker = {
        name = "fzf-lua",
        mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
      },
    },
  },
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "nvim-orgmode/org-bullets.nvim",
      "danilshvalov/org-modern.nvim",
      "nvim-orgmode/org-bullets.nvim",
      "saghen/blink.cmp",
    },
    event = "VeryLazy",
    config = function()
      require("org-bullets").setup()

      local Menu = require("org-modern.menu")
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
        ui = {
          menu = {
            handler = function(data)
              Menu:new():open(data)
            end,
          },
        },
      })

      require("blink.cmp").setup({
        sources = {
          per_filetype = {
            org = { "orgmode" },
          },
          providers = {
            orgmode = {
              name = "Orgmode",
              module = "orgmode.org.autocompletion.blink",
              fallbacks = { "buffer" },
            },
          },
        },
      })

      -- vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
      -- vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
      -- vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
    end,
  },
}
