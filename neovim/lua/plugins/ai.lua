
return {
  "huggingface/llm.nvim",
  enabled = false,
  opts = {
    backend = "ollama",
    url = "http://ai.local:11434",
    tokens_to_clear = { "<|file_separator|>" },
    fim = {
      enabled = true,
      prefix = "<|fim_prefix|> ",
      middle = " <|fim_middle|>",
      suffix = " <|fim_suffix|>",
    },
    request_body = {
      options = {
        num_predict = 128,
        temperature =  0,
        top_p =  0.9,
      },
    },
    model = "codegemma:2b-code",
    -- model = "llama3",
    -- model = "codellama:7b-code",
    -- context_window = 4096,
    tokenizer = {
      repository = "google/codegemma-1.1-2b"
    --   repository = "codellama/CodeLlama-7b-hf",
    },
  },
}
