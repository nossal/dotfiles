return {
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "▏" },
        scope = {
          char = "▏",
          show_end = false,
          show_start = false,
        },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- import comment plugin safely
      local comment = require("Comment")
      -- comment.setup()

      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      -- enable comment
      comment.setup({
        -- for commenting tsx and jsx files
        pre_hook = ts_context_commentstring.create_pre_hook(),
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local illu = require("illuminate")
      illu.configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        filetypes_denylist = {
          "oil",
          "markdown",
          "text",
          "dirbuf",
          "dirvish",
          "fugitive",
          "lazy",
          "NeogitStatus",
          "NeogitCommitView",
          "TelescopePrompt",
          "Trouble",
          "DiffviewFiles",
          "DiffviewFileHistory"
        },
      })
      vim.keymap.set("n", "<C-n>", require("illuminate").goto_next_reference, { desc = "Move to next reference" })
      vim.keymap.set("n", "<C-p>", require("illuminate").goto_prev_reference, { desc = "Move to previous reference" })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- #990000 Red blue hsl(120deg 75% 25%)
      require("colorizer").setup({
        user_default_options = {
          names = false,
          hsl_fn = true,
          css_fn = true,
          mode = "virtualtext",
          virtualtext = " ",
        },
      })
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    opts = {
      is_insert_mode = false,
    },
    cmd = "Spectre",
    keys = {
      {
        mode = "n",
        "<leader>S",
        '<cmd>lua require("spectre").toggle()<CR>',
        desc = "Toggle Spectre",
      },
      {
        mode = "n",
        "<leader>sw",
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        desc = "Search current word",
      },
      {
        mode = "v",
        "<leader>sw",
        '<esc><cmd>lua require("spectre").open_visual()<CR>',
        desc = "Search current word",
      },
      {
        mode = "n",
        "<leader>sp",
        '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        desc = "Search on current file",
      },
    },
  },
}
