require("core.diagnostics")

local border = require("core.ui").border
local lsp_servers = require("core.configs").lsp_servers
local h = require("core.helpers")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = require("core.lsp").capabilities()
      local on_attach = require("core.lsp").on_attach

      local lspconfig = require("lspconfig")

      local root = vim.fn.getcwd()
      for server_name, server in pairs(lsp_servers) do
        if server.root_markers and not h.is_project(root, server.root_markers) then
          goto continue
        end

        local setup = server.setup or {}
        setup.capabilities = capabilities
        setup.on_attach = function(client, bufnr)
          if server.on_attach then
            server.on_attach(client, bufnr)
          end
          on_attach(client, bufnr)
        end
        -- setup.inlay_hint = { enabled = true }

        lspconfig[server_name].setup(setup)

        ::continue::
      end

      require("ufo").setup()
      -- vim.o.statuscolumn = require("heirline").eval_statuscolumn()
    end,
  },
  {
    "folke/lazydev.nvim",
    -- enabled = false,
    ft = "lua", -- only load on lua files
    dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    -- lazy = true,
    opts = {
      ui = {
        border = border,
        height = 0.8,
        width = 0.6,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- "mason-org/mason.nvim",
      -- "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")

      local to_install = {}
      for key, val in pairs(lsp_servers) do
        if val.install then
          table.insert(to_install, key)
        end
      end

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = to_install,
        -- auto-install configured servers (with lspconfig)
        -- automatic_installation = true, -- not the same as ensure_installed
      })

      mason_tool_installer.setup({
        run_on_start = false,
        ensure_installed = {
          "clang-format", -- java formatter
          "shfmt", -- shell formatter
          "stylua", -- lua formatter
          "ruff", -- python formatter/linter
          "biome", -- javascript, json formatter/linter
          "yamlfmt", -- YAML formatteer
          "superhtml", -- HTML formatter/linter

          -- "luacheck",     -- lua linter
          -- "stylelint", -- css linter
          "selene", -- Lua linter
          "shellcheck", -- shell linter
          "markdownlint", -- markdown linter
          "vale", -- markdown linter
          "yamllint", -- yaml linter
          "sonarlint-language-server",

          -- "ast_grep", -- linter/formater
        },
      })
    end,
  },
}
