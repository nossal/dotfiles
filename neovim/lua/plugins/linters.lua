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
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>gf",
        function()
          require("conform").format({ async = true }, function(err)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end
            end
          end)
        end,
        mode = "",
        desc = "Format Code",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "biome" },
          json = { "biome" },
          css = { "biome" },
          yaml = { "yamlfmt" },
          python = { "ruff_format" },
          java = { "clang-format" },
          shell = { "shfmt" },
          rust = { "rustfmt" },
          html = { "superhtml", lsp_format = "fallback" },
        },
        formatters = {
          biome = {
            args = { "format", "--config-path", vim.fn.expand("$HOME/.dotfiles"), "--stdin-file-path", "$FILENAME" },
          },
        },
      })
    end,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
