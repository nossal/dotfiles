return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    "BufReadPre */ob-vault/*.md",
    "BufNewFile */ob-vault/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "second brain",
        path = "~/vaults/ob-vault",
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    ui = { enable = false },
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
}
