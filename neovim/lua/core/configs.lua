local get_java_home = require("core.helpers").get_java_home

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
  ltex = {
    name = "gram",
    install = true,
    setup = {
      settings = {
        ltex = {
          enabled = { "markdown", "restructuredtext" },
          checkFrequency = "save",
          language = "en-US",
          checkSpelling = true,
          diagnosticSeverity = "information",
          sentenceCacheSize = 5000,
          additionalRules = {
            enablePickyRules = true,
            motherTongue = "pt-BR",
            enableSpellingCheck = true,
          },
        },
      },
    },
    on_attach = function(client, bufnr)
      require("ltex_extra").setup({
        load_langs = { "pt-BR", "en-US" },
        init_check = true,
        path = vim.fn.expand("~") .. "/.dotfiles/neovim/spell",
      })
    end,
  }, -- TODO: https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
  clangd = { name = "C", install = true },
  cssls = { name = "css", install = true },
  tailwindcss = { name = "tailwind", install = true },
  emmet_ls = { name = "emmet", install = true },
  superhtml = { name = "HTML", install = true },
  lua_ls = { name = "lua", install = true },
  clojure_lsp = { name = "clojure", install = true },
  rust_analyzer = {
    name = "rust",
    install = true,
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
  basedpyright = { name = "python", install = true },
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
  jdtls = {
    name = "java",
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
                path = get_java_home("21"),
                default = true,
              },
              {
                name = "JavaSE-24",
                path = get_java_home("24"),
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

local other_lsp_servers = {
  ["sonarlint.nvim"] = { name = "sonar" },
}
return {
  lsp_servers = lsp_servers,
  other_lsp_servers = other_lsp_servers,
}
