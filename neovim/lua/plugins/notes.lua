local notes_dir = vim.fn.expand("~/Documents/Notes")

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    event = {
      "BufReadPre " .. notes_dir .. "/**/*.md",
      "BufNewFile " .. notes_dir .. "/**/*.md",
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
    ft = { "org" },
    config = function()
      require("org-bullets").setup()

      local Menu = require("org-modern.menu")
      require("orgmode").setup({
        org_agenda_files = notes_dir .. "/org/**/*",
        org_default_notes_file = notes_dir .. "/org/refile.org",
        org_startup_folded = "overview",
        org_hide_emphasis_markers = true,
        -- org_indent_mode = "indent",
        org_ellipsis = "  ",
        org_priority_highest = 1,
        org_priority_lowest = 5,
        org_priority_default = 3,
        org_log_done = "time",
        org_capture_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  %u",
            target = notes_dir .. "/org/tasks.org",
          },
          j = {
            description = "Journal",
            template = "* %?\n  %u",
            target = notes_dir .. "/org/journal/%<%Y-%m>.org",
          },
        },
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
  {
    "hamidi-dev/org-super-agenda.nvim",
    event = "VeryLazy",
    enable = false,
    dependencies = {
      "nvim-orgmode/orgmode", -- required
      { "lukas-reineke/headlines.nvim", config = true }, -- optional nicety
    },
    config = function()
      require("org-super-agenda").setup({
        -- Where to look for .org files
        org_files = {},
        org_directories = {}, -- recurse for *.org
        exclude_files = {},
        exclude_directories = {},

        -- TODO states + their quick filter keymaps and highlighting
        todo_states = {
          {
            name = "TODO",
            keymap = "ot",
            color = "#FF5555",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "PROGRESS",
            keymap = "op",
            color = "#FFAA00",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "WAITING",
            keymap = "ow",
            color = "#BD93F9",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "DONE",
            keymap = "od",
            color = "#50FA7B",
            strike_through = true,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
        },

        -- Agenda keymaps (inline comments explain each)
        keymaps = {
          filter_reset = "oa", -- reset all filters
          toggle_other = "oo", -- toggle catch-all "Other" section
          filter = "of", -- live filter (exact text)
          filter_fuzzy = "oz", -- live filter (fuzzy)
          filter_query = "oq", -- advanced query input
          undo = "u", -- undo last change
          reschedule = "cs", -- set/change SCHEDULED
          set_deadline = "cd", -- set/change DEADLINE
          cycle_todo = "t", -- cycle TODO state
          reload = "r", -- refresh agenda
          refile = "R", -- refile via Telescope/org-telescope
          hide_item = "x", -- hide current item
          preview = "K", -- preview headline content
          reset_hidden = "X", -- clear hidden list
          toggle_duplicates = "D", -- duplicate items may appear in multiple groups
          cycle_view = "ov", -- switch view (classic/compact)
        },

        -- Window/appearance
        window = {
          width = 0.8,
          height = 0.7,
          border = "rounded",
          title = "Org Super Agenda",
          title_pos = "center",
          margin_left = 0,
          margin_right = 0,
          fullscreen_border = "none", -- border style when using fullscreen
        },

        -- Group definitions (order matters; first match wins unless allow_duplicates=true)
        groups = {
          {
            name = "📅 Today",
            matcher = function(i)
              return i.scheduled and i.scheduled:is_today()
            end,
            sort = { by = "priority", order = "desc" },
          },
          {
            name = "🗓️ Tomorrow",
            matcher = function(i)
              return i.scheduled and i.scheduled:days_from_today() == 1
            end,
          },
          {
            name = "☠️ Deadlines",
            matcher = function(i)
              return i.deadline and i.todo_state ~= "DONE" and not i:has_tag("personal")
            end,
            sort = { by = "deadline", order = "asc" },
          },
          {
            name = "⭐ Important",
            matcher = function(i)
              return i.priority == "A" and (i.deadline or i.scheduled)
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "⏳ Overdue",
            matcher = function(i)
              return i.todo_state ~= "DONE"
                and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "🏠 Personal",
            matcher = function(i)
              return i:has_tag("personal")
            end,
          },
          {
            name = "💼 Work",
            matcher = function(i)
              return i:has_tag("work")
            end,
          },
          {
            name = "📆 Upcoming",
            matcher = function(i)
              local days = require("org-super-agenda.config").get().upcoming_days or 10
              local d1 = i.deadline and i.deadline:days_from_today()
              local d2 = i.scheduled and i.scheduled:days_from_today()
              return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
        },

        -- Defaults & behavior
        upcoming_days = 10,
        hide_empty_groups = true, -- drop blank sections
        keep_order = false, -- keep original org order (rarely useful)
        allow_duplicates = false, -- if true, an item can live in multiple groups
        group_format = "* %s", -- group header format
        other_group_name = "Other",
        show_other_group = false, -- show catch-all section
        show_tags = true, -- draw tags on the right
        show_filename = true, -- include [filename]
        heading_max_length = 70,
        persist_hidden = false, -- keep hidden items across reopen
        view_mode = "classic", -- 'classic' | 'compact'

        classic = {
          heading_order = { "filename", "todo", "priority", "headline" },
          short_date_labels = false,
          inline_dates = true,
        },
        compact = { filename_min_width = 10, label_min_width = 12 },

        -- Global fallback sort for groups that omit `sort`
        group_sort = { by = "date_nearest", order = "asc" },

        debug = false,
      })
    end,
  },
}
