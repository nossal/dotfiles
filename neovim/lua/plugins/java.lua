return {
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },
  {
    "JavaHello/spring-boot.nvim",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "ibhagwan/fzf-lua",
    },
    config = false,
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    config = function()
      require("java-deps").setup({})
    end,
  },
}
