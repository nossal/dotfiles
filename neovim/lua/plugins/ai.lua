return {
  {
    "github/copilot.vim",
    event = "BufReadPost",
    config = function()
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["copilot-chat"] = false,
      }
      vim.g.copilot_no_tab_map = true -- Disable default tab mapping
      vim.api.nvim_set_keymap(
        "i",
        "<C-j>",
        'copilot#Accept("<CR>")',
        { expr = true, silent = true, noremap = true }
      )
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      local ui = vim.api.nvim_list_uis()[1]
      local width = 50
      local opts = {
        window = {
          layout = "float",
          width = width,
          height = ui.height - 3,
          row = 2,
          col = math.floor(ui.width * 0.98) - width,
          border = "rounded", -- 'single', 'double', 'rounded', 'solid'
          title = " AI Assistant",
          zindex = 99, -- Ensure window stays on top
        },

        headers = {
          user = " You: ",
          assistant = " Copilot: ",
          tool = " Tool: ",
        },
        separator = "━━",
        show_folds = false, -- Disable folding for cleaner look
      }

      require("CopilotChat").setup(opts)

    end,
  },
  {
    "ggml-org/llama.vim",
    enabled = false,
    init = function()
      vim.g.llama_config = {
        show_info = false,
      }
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<Right>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
    },
  },
}
