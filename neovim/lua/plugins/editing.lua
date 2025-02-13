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
          "DiffviewFileHistory",
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
      -- local c = hsl(20, 20, 20)

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
