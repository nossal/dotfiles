return {
  "huggingface/llm.nvim",
  enabled = false,
  opts = {
    backend = "ollama",
    url = "http://192.168.1.236:11434",
    tokens_to_clear = { "<EOT>" },
    fim = {
      enabled = true,
      prefix = "<PRE> ",
      middle = " <MID>",
      suffix = " <SUF>",
    },
    model = "codellama:7b-code",
    context_window = 4096,
    tokenizer = {
      repository = "codellama/CodeLlama-7b-hf",
    },
  },
}
