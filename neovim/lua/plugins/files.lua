return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      confirmation = {
        border = "rounded",
      },
      float = {
        max_width = 0.25, -- Values are percentages relative to window size
        max_height = 32,
        border = "rounded",
        override = function(cfg)
          local ui = vim.api.nvim_list_uis()[1]
          cfg["col"] = 7
          cfg["row"] = 1
          cfg["height"] = ui.height - 4

          return cfg
        end,
        get_win_title = function()
          return "FILES"
        end,
        win_options = {
          colorcolumn = "",
          cursorcolumn = false,
        },
      },
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      }
    },
    keys = {
      { "<Leader>E", vim.cmd.Oil, desc = "Open File Explorer" },
      {
        "<Leader>e",
        function()
          require("oil").toggle_float()
        end,
        desc = "Toggle File Explorer",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        callback = function()
          -- Map <Esc> to quit after ensuring we're in normal mode
          vim.keymap.set({ "i", "n" }, "<Esc>", "<Cmd>stopinsert | bd!<CR>", { buffer = true })
        end,
      })
    end,
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
}
