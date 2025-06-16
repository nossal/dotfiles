return {
  {
    "yetone/avante.nvim",
    -- enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "claude",
      -- use_absolute_path = true,
      providers = {
        ollama = {
          endpoint = "http://localhost:11434",
          model = "qwen2.5-coder:7b",
          -- model = "deepseek-coder-v2:latest",
          -- model = "hf.co/bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:Q5_K_S",
          -- model = "hf.co/bartowski/Qwen2.5.1-Coder-7B-Instruct-GGUF:Q5_K_S",
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 4096,
          },
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "ggml-org/llama.vim",
    init = function()
      vim.g.llama_config = {
        show_info = false,
      }
    end,
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
}
