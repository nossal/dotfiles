return {
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.biome,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.yamlfmt,
          -- null_ls.builtins.diagnostics.eslint,
          -- null_ls.builtins.completion.spll,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
  {
    "danarth/sonarlint.nvim",
    enabled = false,
    config = function()
      local get_java_home = function(version)
        return vim.fn.system("mise where java@" .. version):gsub("%s+", "")
      end
      require("sonarlint").setup({
        server = {
          cmd = {
            "" .. get_java_home("17") .. "/bin/java",
            "-jar",
            vim.fn.expand("$MASON/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar"),
            -- Ensure that sonarlint-language-server uses stdio channel
            "-stdio",
            "-analyzers",
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
          },
          -- All settings are optional
          settings = {
            -- The default for sonarlint is {}, this is just an example
            sonarlint = {
              rules = {
                ["typescript:S101"] = { level = "on", parameters = { format = "^[A-Z][a-zA-Z0-9]*$" } },
                ["typescript:S103"] = { level = "on", parameters = { maximumLineLength = 180 } },
                ["typescript:S106"] = { level = "on" },
                ["typescript:S107"] = { level = "on", parameters = { maximumFunctionParameters = 2 } },
              },
            },
          },
        },
        filetypes = {
          "python",
          "javascript",
          -- Requires nvim-jdtls, otherwise an error message will be printed
          "java",
        },
      })
    end,
  },
}
