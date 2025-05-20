local OLLAMA_API_URL = "http://ai.local:11434/api"
-- local OLLAMA_API_URL = "http://localhost:11434/api"

return {
  {
    "ggml-org/llama.vim",
    init = function()
      vim.g.llama_config = {
        show_info = false,
      }
    end,
  },
  {
    "meeehdi-dev/bropilot.nvim",
    enabled = false,
    event = "VeryLazy", -- preload model on start
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
    },
    config = function()
      require("bropilot").setup({
        auto_suggest = true,
        excluded_filetypes = {},
        model = "qwen2.5-coder:0.5b-base",
        model_params = {
          num_ctx = 32768,
        },
        preset = true,
        debounce = 500,
        keymap = {
          accept_word = "<C-Right>",
          accept_line = "<S-Right>",
          accept_block = "<Tab>",
          suggest = "<C-Down>",
        },
        ollama_url = OLLAMA_API_URL,
      })
    end,
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      -- add any opts here
      provider = "ollama",
      auto_suggestions_provider = "ollama",
      use_absolute_path = true,
      vendors = {
        ---@type AvanteProvider
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://ai.local:11434/v1",
          -- model = "hf.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:Q5_K_S",
          model = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q5_K_S",
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    config = function()
      require("supermaven-nvim").setup({})
    end,
    opts = {
      disable_inline_completion = true, -- disables inline completion for use with cmp
      disable_keymaps = true, -- disables built in keymaps for more manual control
    },
  },
  {
    "huggingface/llm.nvim",
    enabled = false,
    opts = {
      backend = "ollama",
      url = "http://ai.local:11434",
      -- url = "http://localhost:11434",
      -- tokens_to_clear = { "<|file_sep|>" },
      tokens_to_clear = { "<|fim_pad|>", "<|endoftext|>" },
      fim = {
        enabled = true,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      request_body = {
        options = {
          num_predict = -2,
          temperature = 0.2,
          top_p = 0.95,
        },
      },
      model = "qwen2.5-coder:1.5b-base",
      -- model = "qwen2.5-coder:0.5b-base",
      -- model = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q5_K_S",
      -- model = "codegemma:2b-code",
      -- model = "llama3",
      -- model = "codellama:7b-code",
      -- context_window = 4096,
      -- tokenizer = {
      --   -- repository = "google/codegemma-1.1-2b",
      --   repository = "Qwen/Qwen2.5-Coder-1.5b",
      --   --   repository = "codellama/CodeLlama-7b-hf",
      -- },
    },
  },
}
