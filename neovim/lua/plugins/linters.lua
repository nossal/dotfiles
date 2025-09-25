local helpers = require("core.helpers")
return {
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    opts = {
      linters = {
        selene = {
          condition = function(ctx)
            local root = vim.uv.cwd()
            local var = vim.fs.find({ "selene.toml" }, { path = root, upward = true })

            vim.notify(table.concat(var, ", "))
            return var[1]
          end,
        },
      },
    },
    config = function(opts)
      local lint = require("lint")

      lint.linters_by_ft = {
        markdown = { "vale" },
        shell = { "shellcheck" },
        python = { "ruff" },
        css = { "stylelint" },
        lua = { "selene" },
        javascript = { "biomejs" },
        yaml = { "yamllint" },
        rust = { "clippy" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          -- require("lint").try_lint("selene", opts)
          require("lint").try_lint()

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require("lint").try_lint("cspell")
        end,
      })
    end,
  },
  {
    "iamkarasik/sonarqube.nvim",
    enabled = true,
    event = "BufReadPost",
    config = function()
      local java = helpers.get_java_home(17) .. "/bin/java"
      local extension_path = helpers.get_mason_package("sonarlint-language-server") .. "/extension"
      local analyzers_path = extension_path .. "/analyzers"

      require("sonarqube").setup({
        lsp = {
          cmd = {
            java,
            "-jar",
            extension_path .. "/server/sonarlint-ls.jar",
            "-stdio",
            "-analyzers",
            analyzers_path .. "/sonarjava.jar",
            analyzers_path .. "/sonarjavasymbolicexecution.jar",
            analyzers_path .. "/sonarpython.jar",
            analyzers_path .. "/sonargo.jar",
            analyzers_path .. "/sonarjs.jar",
            analyzers_path .. "/sonarhtml.jar",
            analyzers_path .. "/sonariac.jar",
            analyzers_path .. "/sonartext.jar",
            analyzers_path .. "/sonarxml.jar",
          },
          capabilities = vim.lsp.protocol.make_client_capabilities(),
        },
        rules = {
          enabled = true,
        },
        java = {
          enabled = true,
          await_jdtls = true,
        },
      })
    end,
  },
}
