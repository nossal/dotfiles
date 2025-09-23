local lsp_servers = {
  svelte = {
    name = "svelte",
    install = true,
    setup = {
      filetypes = { "svelte", "typescript.svelte", "svelte.ts" },
    },
  },
  sourcekit = {
    name = "iOS",
    setup = {
      cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
    },
  },
  -- ltex = {
  --   name = "gram",
  --   install = true,
  --   setup = {
  --     settings = {
  --       ltex = {
  --         enabled = { "markdown", "restructuredtext" },
  --         checkFrequency = "save",
  --         language = "en-US",
  --         checkSpelling = true,
  --         diagnosticSeverity = "information",
  --         sentenceCacheSize = 5000,
  --         additionalRules = {
  --           enablePickyRules = true,
  --           motherTongue = "pt-BR",
  --           enableSpellingCheck = true,
  --         },
  --       },
  --     },
  --   },
  --   on_attach = function(client, bufnr)
  --     require("ltex_extra").setup({
  --       load_langs = { "pt-BR", "en-US" },
  --       init_check = true,
  --       path = vim.fn.expand("~") .. "/.dotfiles/neovim/spell",
  --     })
  --   end,
  -- }, -- TODO: https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
  clangd = { name = "C", install = true },
  cssls = { name = "css", install = true },
  tailwindcss = { name = "tailwind", install = true },
  emmet_ls = { name = "emmet", install = true },
  superhtml = { name = "HTML", install = true },
  lua_ls = {
    name = "lua",
    install = true,
    setup = {
      settings = {
        Lua = {
          codeLens = {
            enable = true,
          },
        },
      },
    },
  },
  clojure_lsp = { name = "clojure", install = true },
  rust_analyzer = {
    name = "rust",
    install = true,
    root_markers = { "Cargo.toml" },
    setup = {
      cargo = { all_features = true },
      check = {
        command = "clippy",
      },
      checkOnSave = true,
    },
  },
  ts_ls = {
    name = "JS",
    install = true,
    setup = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "typescript.vue",
      },
    },
  },
  biome = { name = "biome", install = true },
  basedpyright = {
    name = "python",
    install = true,
    setup = {
      settings = {
        basedpyright = {
          typeCheckingMode = "standard",
        },
      },
    },
  },
  bashls = { name = "bash", install = true },
  gradle_ls = { name = "gradle", install = true },
  terraformls = { name = "terraform", install = true },
  yamlls = {
    name = "yaml",
    install = true,
    setup = {
      filetypes = { "yaml", "yaml.butane", "yaml.cloudinit", "yaml.ansible", "yaml.docker-compose", "yaml.gitlab" },
      settings = {
        yaml = {
          schemas = {
            kubernetes = "{k8s-,kube}*/**/*.{yml,yaml}",
            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
            ["https://raw.githubusercontent.com/Relativ-IT/Butane-Schemas/Release/Butane-Schema.json"] = ".bu",
          },
        },
      },
    },
  },
}

local other_lsp_servers = {
  ["GitHub Copilot"] = { name = "copilot", ai = true },
  ["sonarlint.nvim"] = { name = "sonar" },
  jdtls = {
    install = true,
    name = "java",
    root_markers = { "build.gradle", "pom.xml" },
  },
}

local all_lsp_server = vim.tbl_extend("force", lsp_servers, other_lsp_servers)

local on_attach = function(client, bufnr)
  local wk = require("which-key")
  wk.add({
    { "gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
    -- { "gd", vim.lsp.buf.definition, desc = "Show LSP definitions" },
    {
      "gd",
      function()
        require("fzf-lua").lsp_definitions({
          jump1 = true,
          winopts = {
            height = 0.35,
            width = 0.50,
            title = " Definitions ",
            title_flags = false,
            backdrop = 95,
            preview = {
              -- hidden = true,
              vertical = "down:55%",
              layout = "vertical",
              -- border = "none",
              title = false,
              title_pos = "left",
            },
          },
        })
      end,
      desc = "Show LSP definitions",
    },
    { "K", vim.lsp.buf.hover, desc = "Show documentation under cursor" },
    { "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename" },
    { "gR", "<cmd>FzfLua lsp_references<CR>", desc = "Show LSP references" },
    { "gt", "<cmd>FzfLua lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
    { "<leader>fs", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Find Workspace Symbol" },
    { "<leader>D", "<cmd>FzfLua diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
    { "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics" },
    { "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP" },
    {
      "<leader>ca",
      function()
        require("fzf-lua").lsp_code_actions({
          prompt = "ca>",
          winopts = {
            height = 0.55,
            width = 0.50,
            preview = {
              hidden = true,
              vertical = "down:55%",
              layout = "vertical",
              -- border = "none",
              title = false,
              title_pos = "left",
            },
          },
        })
      end,
      desc = "See the Code Actions",
      mode = { "n", "v" },
    },
    -- { "<leader>ca", vim.lsp.buf.code_action,                desc = "See available code actions", mode = { "n", "v" } },
    -- { "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>",     desc = "See available code actions", mode ={ "n", "v" } },
    -- { "<leader>gf", vim.lsp.buf.format,                     desc = "Format buffer" },

    -- { "gK", function ()
    --   local new_config = not vim.diagnostic.config().virtual_lines
    --   vim.diagnostic.config({ virtual_lines = new_config })
    -- end, desc = "Toggle diagnostic virtual_lines" },

    { "<leader>S", vim.lsp.buf.signature_help, desc = "[S]ignature Help" },

    -- Workspaces
    { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "[W]orkspace [A]dd Folder" },
    { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "[W]orkspace [R]emove Folder" },
    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      desc = "[W]orkspace [L]ist Folders",
    },
  })
end

local capabilities = function()
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

  return capbs
end

return {
  on_attach = on_attach,
  capabilities = capabilities,
  lsp_servers = lsp_servers,
  other_lsp_servers = other_lsp_servers,
  all_lsp_servers = all_lsp_server,
}
