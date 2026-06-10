local helpers = require("core.helpers")
-- local mason, _ = pcall(require, "mason-registry")

local function root_dir()
  return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
end

local function get_workspace_path()
  local project_path = helpers.get_project_name(vim.fn.getcwd())
  local project_path_hash = string.gsub(project_path, "[/\\:+-]", "_")

  local nvim_cache_path = vim.fn.stdpath("cache")
  local data_dir = table.concat({ nvim_cache_path, "jdtls", "workspaces", project_path_hash }, "/")
  local c_root_dir = root_dir()

  if c_root_dir then
    data_dir = data_dir .. "/" .. vim.fn.fnamemodify(c_root_dir, ":p:h:t")
  end
  return data_dir
end

local function get_jdtls_path()
  return helpers.get_mason_package("jdtls")
end

local function get_lombok_jar()
  local jdtls_path = get_jdtls_path()
  return jdtls_path .. "/lombok.jar"
end

local function java_home()
  return helpers.get_java_home("lts")
end

local lombok_jar = get_lombok_jar()
local config = {
  cmd = {
    "jdtls",
    "-data", get_workspace_path(),
    "--java-executable", java_home() .. "/bin/java",
    "--jvm-arg=-javaagent:" .. lombok_jar,
  },
  filetypes = { "java" },
  root_dir = root_dir(),
  handlers = {
    -- By assigning an empty function, you can remove the notifications
    ["$/progress"] = function(_, result, ctx) end,
  },

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      autobuild = { enabled = true },
      maxConcurrentBuilds = 2,
      home = java_home(),
      project = {
        encoding = "UTF-8",
        outputPath = vim.fn.stdpath("cache") .. "/jdtls/output",
      },
      foldingRange = { enabled = true },
      selectionRange = { enabled = true },
      import = {
        gradle = { enabled = true },
        maven = { enabled = true },
        exclusions = {
          "**/node_modules/**",
          "**/.metadata/**",
          "**/archetype-resources/**",
          "**/META-INF/maven/**",
          "**/.git/**",
        },
      },
      inlayhints = {
        parameterNames = { enabled = "ALL" },
      },
      referenceCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      references = {
        includeDecompiledSources = true,
      },
      templates = {
        typeComment = {
          "/**",
          " * ${type_name}.",
          " *",
          " * @author ${user}",
          " */",
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },
      signatureHelp = {
        enabled = true,
        description = {
          enabled = true,
        },
      },
      contentProvider = { preferred = "fernflower" },
      saveActions = {
        organizeImports = true,
      },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.assertj.core.api.Assertions.assertThat",
          "org.assertj.core.api.Assertions.assertThatThrownBy",
          "org.assertj.core.api.Assertions.assertThatExceptionOfType",
          "org.assertj.core.api.Assertions.catchThrowable",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "org.graalvm.*",
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "java",
          "jakarta",
          "javax",
          "org",
          "com",
          "br.com",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.expand("~/.dotfiles") .. "/java-format.xml",
          profile = "CustomJavaStyle",
        },
      },

      on_type_formatting = {
        enabled = true,
      },
      configuration = {
        -- maven = {
        --   -- userSettings = maven.get_maven_settings(),
        --   -- globalSettings = maven.get_maven_settings(),
        -- },
        runtimes = {
          {
            name = "JavaSE-11",
            path = helpers.get_java_home("11"),
          },
          {
            name = "JavaSE-17",
            path = helpers.get_java_home("17"),
          },
          {
            name = "JavaSE-25",
            path = helpers.get_java_home("25"),
          },
        },
      },
    },
  },
  -- init_options = {
  --   bundles = require("spring_boot").java_extensions(),
  -- },
}

local function setup()
  local lsp = require("core.lsp")
  config.capabilities = lsp.capabilities()

  require("jdtls").start_or_attach(config, {
    dap = { config_overrides = {}, hotcodereplace = "auto" },
  })

  lsp.on_attach(nil, 0)
end

local function on_attach(client, bufnr)
  -- require("spring_boot").init_lsp_commands()
  if client.name == "jdtls" then
    -- require("spring_boot.launch").start({}) -- with default config
    -- require('spring_boot').init_lsp_commands()

    -- require("jdtls").setup_dap({ hotcodereplace = "auto" })
    -- require("jdtls").setup_dap_main_class_configs()
    -- require("jdtls").setup_additional_commands()
    -- bootls_user_command(bufnr)
  end
end

return {
  on_attach = on_attach,
  config = config,
  setup = setup,
}
