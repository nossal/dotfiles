return {
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = {"java", "yml", "yaml", "jproperties"},
    -- lazy = true,
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "ibhagwan/fzf-lua",
    },
    config = false,
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    opts = {},
  },
}
