local get_java_home = require("core.helpers").get_java_home

local lsp_servers = {
  ltex = { name = "gram", type = "lsp" }, -- TODO: https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
  clangd = { name = "C", type = "lsp" },
  cssls = { name = "css", type = "lsp" },
  tailwindcss = { name = "tailwind", type = "lsp" },
  emmet_ls = { name = "emmet", type = "lsp" },
  html = { name = "HTML", type = "lsp" },
  lua_ls = { name = "lua", type = "lsp" },
  clojure_lsp = { name = "clojure", type = "lsp" },
  rust_analyzer = {
    name = "rust",
    type = "lsp",
    setup = {
      cargo = { all_features = true },
      check = {
        command = "clippy",
      },
      checkOnSave = true,
    },
  },
  ts_ls = { name = "JS", type = "lsp" },
  biome = { name = "biome", type = "lsp" },
  basedpyright = { name = "python", type = "lsp" },
  bashls = { name = "bash", type = "lsp" },
  gradle_ls = { name = "gradle", type = "lsp" },
  terraformls = { name = "terraform", type = "lsp" },
  yamlls = {
    name = "yaml",
    type = "lsp",
    setup = {
      filetypes = { "yaml", "yaml.butane", "yaml.ansible", "yaml.docker-compose", "yaml.gitlab" },
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
                path = get_java_home("zulu"),
              },
              {
                name = "JavaSE-17",
                path = get_java_home("17"),
              },
              {
                name = "JavaSE-21",
                path = get_java_home("lts"),
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

return {
  lsp_servers = lsp_servers,
}
