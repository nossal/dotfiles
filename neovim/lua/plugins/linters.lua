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
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    -- enabled = false,
    event = "BufReadPost",
    config = function()
      require("sonarlint").setup({
        server = {
          cmd = {
            "sonarlint-language-server",
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
          "java",
        },
      })
    end,
  },
}
