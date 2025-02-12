require("core.diagnostics")

local keymap = require("core.helpers").map
local border = require("core.ui").border

local get_java_home = function(version)
  return vim.fn.system("mise where java@" .. version):gsub("%s+", "")
end

local lsp_servers = {
  yamlls = {
    type = "lsp",
    setup = {
      filetypes = { "yaml", "bu", "yaml.docker-compose", "yaml.gitlab" },
    },
  },
  cssls = {
    type = "lsp",
  },
  emmet_ls = {
    type = "lsp",
  },
  html = {
    type = "lsp",
  },
  lua_ls = {
    type = "lsp",
  },
  clojure_lsp = {
    type = "lsp",
  },
  rust_analyzer = {
    type = "lsp",
  },
  ts_ls = {
    type = "lsp",
  },
  biome = {
    type = "lsp",
  },
  basedpyright = {
    type = "lsp",
  },
  bashls = {
    type = "lsp",
  },
  gradle_ls = {
    type = "lsp",
  },
  terraformls = {
    type = "lsp",
  },
  jdtls = {
    setup = {
      handlers = {
        -- By assigning an empty function, you can remove the notifications
        -- printed to the cmd
        ["$/progress"] = function(_, result, ctx) end,
      },
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-1.8",
                path = get_java_home("8"),
              },
              {
                name = "JavaSE-17",
                path = get_java_home("17"),
              },
              {
                name = "JavaSE-21",
                path = get_java_home("lts"),
              },
            },
          },
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "none", -- literals, all, none
            },
          },
          format = {
            enabled = false,
          },
        },
        signatureHelp = { enabled = true },
      },
    },
  },
}

return {
  {
    "folke/lazydev.nvim",
    -- enabled = false,
    ft = "lua", -- only load on lua files
    dependencies =
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types",      mods = { "wezterm" } },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    -- lazy = true,
    opts = {
      ui = {
        border = border,
        height = 0.7,
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
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason.nvim",
      -- "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")

      local only_lsp = {}
      for key, val in pairs(lsp_servers) do
        if val.type == "lsp" then
          table.insert(only_lsp, key)
        end
      end

      require("mason").setup()

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = only_lsp,
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true, -- not the same as ensure_installed
      })

      mason_tool_installer.setup({
        run_on_start = false,
        ensure_installed = {
          "stylua",       -- lua formatter
          "luacheck",     -- lua linter
          "ruff",         -- python formatter
          "biome",        -- javascript formatter
          "stylelint",    -- css linter
          "shellcheck",   -- shell linter
          "shfmt",        -- shell formatter
          "markdownlint", -- markdown linter
          "yamllint",     -- yaml linter
          "jsonlint",     -- json linter
        },
      })
    end,
  },
  {
    "nvim-java/nvim-java",
    -- dependencies = {
    --   "williamboman/mason-lspconfig.nvim",
    --   opts = {
    --     handlers = {
    --       ["jdtls"] = function()
    --         require("java").setup({
    --           jdk = { auto_install = false },
    --           -- java_debug_adapter = { enable = false },
    --           java_test = { enable = false },
    --           notifications = { dap = false },
    --         })
    --       end,
    --     },
    --   },
    -- },
    event = { "BufEnter *.java" },
    config = function()
      require("java").setup({
        jdk = { auto_install = false },
        -- java_debug_adapter = { enable = false },
        java_test = { enable = false },
        notifications = { dap = false },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      -- { "nvim-java/nvim-java" },
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
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

      local lspconfig = require("lspconfig")

      local opts = { noremap = true, silent = true }
      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        keymap("n", "gR", "<cmd>FzfLua lsp_references<CR>", "Show LSP references", opts)
        keymap("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration", opts)
        keymap("n", "gd", vim.lsp.buf.definition, "Show LSP definitions", opts)
        keymap("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", "Show LSP implementations", opts)
        keymap("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", "Show LSP type definitions", opts)
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions", opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename", opts)
        keymap("n", "<leader>D", "<cmd>FzfLua diagnostics bufnr=0<CR>", "Show buffer diagnostics", opts)
        keymap("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics", opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic", opts)
        keymap("n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic", opts)
        keymap("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor", opts)
        keymap("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP", opts)

        -- Lesser used LSP functionality
        keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        keymap("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
      end

      for key, value in pairs(lsp_servers) do
        local setup = value.setup or {}
        local caps = require("blink.cmp").get_lsp_capabilities(capabilities)
        setup.capabilities = caps
        setup.on_attach = on_attach
        -- setup.inlay_hint = { enabled = true }

        lspconfig[key].setup(setup)
      end
    end,
  },
}
