require("core.diagnostics")

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
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "williamboman/mason.nvim",
    lazy = true,
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
          "stylua", -- lua formatter
          "luacheck", -- lua linter
          "ruff", -- python formatter
          "biome", -- javascript formatter
          "stylelint", -- css linter
          "shellcheck", -- shell linter
          "shfmt", -- shell formatter
          "markdownlint", -- markdown linter
          "yamllint", -- yaml linter
          "jsonlint", -- json linter
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
    -- event = { "BufReadPre", "BufNewFile" },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      { "nvim-java/nvim-java" },
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
      local keymap = vim.keymap -- for conciseness

      local opts = { noremap = true, silent = true }
      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
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
