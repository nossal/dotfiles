require("core.diagnostics")

local border = require("core.ui").border
local lsp_servers = require("core.configs").lsp_servers

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      {
        "nvim-java/nvim-java",
        event = { "BufEnter *.java" },
        config = function()
          require("java").setup({
            jdk = { auto_install = false },
            notifications = { dap = false },
            java_test = { version = "0.43.0" },
            spring_boot_tools = { version = "1.56.0" },
            -- java_debug_adapter = { version = "0.58.2"},
          })
        end,
      },
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local completionItem = capabilities.textDocument.completion.completionItem
      completionItem.preselectSupport = true
      completionItem.insertReplaceSupport = true
      completionItem.labelDetailsSupport = true
      completionItem.deprecatedSupport = true
      completionItem.commitCharactersSupport = true
      completionItem.tagSupport = { valueSet = { 1 } }
      completionItem.snippetSupport = true
      completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      }

      local capbs = require("blink.cmp").get_lsp_capabilities(capabilities)

      local wk = require("which-key")
      local on_attach = function(_, bufnr)
        wk.add({
          { "gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
          { "gd", vim.lsp.buf.definition, desc = "Show LSP definitions" },
          { "K", vim.lsp.buf.hover, desc = "Show documentation under cursor" },
          { "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename" },
          { "gR", "<cmd>FzfLua lsp_references<CR>", desc = "Show LSP references" },
          { "gt", "<cmd>FzfLua lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
          { "<leader>D", "<cmd>FzfLua diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
          { "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics" },
          { "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
          { "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
          { "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP" },
          -- { "<leader>ca", vim.lsp.buf.code_action,                desc = "See available code actions", mode = { "n", "v" } },
          -- { "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>",     desc = "See available code actions", mode ={ "n", "v" } },
          -- { "<leader>gf", vim.lsp.buf.format,                     desc = "Format buffer" },

          -- Workspaces
          { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "[W]orkspace [A]dd Folder" },
          { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "[W]orkspace [R]emove Folder" },
          { "<leader>wl",
            function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "[W]orkspace [L]ist Folders",
          },
        })
      end

      local lspconfig = require("lspconfig")

      for key, value in pairs(lsp_servers) do
        local setup = value.setup or {}
        setup.capabilities = capbs
        setup.on_attach = function(client, bufnr)
          if value.on_attach then
            value.on_attach(client, bufnr)
          end
          on_attach(client, bufnr)
        end
        -- setup.inlay_hint = { enabled = true }

        lspconfig[key].setup(setup)
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
    "williamboman/mason.nvim",
    lazy = true,
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
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
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

      require("mason").setup()

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = to_install,
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true, -- not the same as ensure_installed
      })

      mason_tool_installer.setup({
        run_on_start = false,
        ensure_installed = {
          "clang-format", -- java formatter
          "shfmt", -- shell formatter
          "stylua", -- lua formatter
          "ruff", -- python formatter/linter
          "biome", -- javascript, json formatter/linter
          "yamlfmt",b-- YAML formatteer
          "superhtml", -- HTML formatter/linter

          -- "luacheck",     -- lua linter
          -- "stylelint", -- css linter
          "selene", -- Lua linter
          "shellcheck", -- shell linter
          "markdownlint", -- markdown linter
          "vale", -- markdown linter
          "yamllint", -- yaml linter

          -- "ast_grep", -- linter/formater
        },
      })
    end,
  },
}
