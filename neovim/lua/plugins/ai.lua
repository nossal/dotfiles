return {
  {
    "supermaven-inc/supermaven-nvim",
    enabled = true,
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
      tokens_to_clear = { "<|file_sep|>" },
      fim = {
        enabled = true,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      -- request_body = {
      --   options = {
      --     num_predict = 128,
      --     temperature = 0,
      --     top_p = 0.9,
      --   },
      -- },
      model = "qwen2.5-coder:1.5b",
      -- model = "codegemma:2b-code",
      -- model = "llama3",
      -- model = "codellama:7b-code",
      -- context_window = 4096,
      tokenizer = {
        -- repository = "google/codegemma-1.1-2b",
        repository = "Qwen/Qwen2.5-Coder-1.5b",
        --   repository = "codellama/CodeLlama-7b-hf",
      },
    },
  },
}
