local notes_dir = vim.fn.expand("~/Documents/Notes")

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    event = {
      "BufReadPre " .. notes_dir .. "/**/*",
      "BufNewFile " .. notes_dir .. "/**/*",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hamidi-dev/org-list.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = notes_dir,
        },
        -- {
        --   name = "work",
        --   path = "~/vaults/work",
        -- },
      },
      legacy_commands = false,
      -- ui = { enable = false },
      completion = {
        blonk = true,
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
      "danilshvalov/org-modern.nvim",
      "nvim-orgmode/org-bullets.nvim",
      "hamidi-dev/org-list.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("org-bullets").setup()

      local Menu = require("org-modern.menu")
      require("orgmode").setup({
        org_agenda_files = notes_dir .. "/org/**/*",
        org_default_notes_file = notes_dir .. "/org/refile.org",
        ui = {
          menu = {
            handler = function(data)
              Menu:new():open(data)
            end,
          },
        },
      })

      -- vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
      -- vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
      -- vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
    end,
  },
  {
    "hamidi-dev/org-list.nvim",
    dependencies = {
      "tpope/vim-repeat", -- for repeatable actions with '.'
    },
    opts = {
      mapping = {
        key = "<leader>lt", -- nvim-orgmode users: you might want to change this to <leader>olt
        desc = "Toggle: Cycle through list types",
      },
      checkbox_toggle = {
        enabled = true,
        -- NOTE: for nvim-orgmode users, you should change the following mapping OR change the one from orgmode.
        -- If both mapping stay the same, the one from nvim-orgmode will "win"
        key = "<leader>lc",
        desc = "Toggle checkbox state",
        filetypes = { "org", "markdown" }, -- Add more filetypes as needed
      },
    },
  },
}
