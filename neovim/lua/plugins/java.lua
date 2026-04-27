return {
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yml", "yaml", "jproperties", "properties" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    ---@type bootls.Config
    opts = {},
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    opts = {},
  },
}
