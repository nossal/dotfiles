return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    event = "InsertEnter",
    cmd = "Copilot",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-j>",
          accept_word = "<Tab>",
          accept_line = "J",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
          -- toggle_auto_trigger = false,
        },
        nes = {
          enabled = true,
        },
      },
    },
  },
  {
    "ggml-org/llama.vim",
    enabled = true,
    init = function()
      vim.g.llama_config = {
        show_info = false,
        profiles = {
          localhost = "http://127.0.0.1:8012",
          ryzen = "http://192.168.1.100:8012",
        }
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
