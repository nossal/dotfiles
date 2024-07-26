return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "kkharji/sqlite.lua",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", "build", "target" },
          layout_config = {
            vertical = { width = 0.5 },
          },
          path_display = {
            shorten = { len = 1, exclude = { 1, -1 } },
          },
          prompt_prefix = " ",
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
      telescope.load_extension("smart_open")
      telescope.load_extension("noice")

      local function edit_dotfiles()
        local opts = themes.get_dropdown({
          cwd = "~/.dotfiles/",
          prompt_title = " ~ dotfiles ~ ",

          previewer = false,
          winblend = 10,
        })

        builtin.find_files(opts)
      end

      local telelsp = require("core.telelsp")
      vim.keymap.set("n", "<leader><leader>", telelsp.find_symbols, { desc = "Power Search" })

      vim.keymap.set("n", "<leader>fd", edit_dotfiles, { desc = "Find Dotfiles" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
      vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
    end,
  },
}
