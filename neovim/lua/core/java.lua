local helpers = require("core.helpers")
-- local mason, _ = pcall(require, "mason-registry")

local function get_workspace_path()
  local project_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h")
  local project_path_hash = string.gsub(project_path, "[/\\:+-]", "_")

  local nvim_cache_path = vim.fn.stdpath("cache")
  return table.concat({ nvim_cache_path, "jdtls", "workspaces", project_path_hash })
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

local function root_dir()
  return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
end

local lombok_jar = get_lombok_jar()
local config = {
  cmd = function(dispatchers, config)
    local data_dir = get_workspace_path()
    if config.root_dir then
      data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
    end

    local config_cmd = {
      "jdtls",
      "-data",
      data_dir,
      "--java-executable",
      java_home() .. "/bin/java",
      "--jvm-arg=-javaagent:" .. lombok_jar,
    }

    return vim.lsp.rpc.start(config_cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
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
    init_options = {
      bundles = require("spring_boot").java_extensions(),
    },
  },
}

local function setup()
  local lsp = require("core.lsp")
  config.capabilities = lsp.capabilities()

  require("jdtls").start_or_attach(config, {
    dap = { config_overrides = {}, hotcodereplace = "auto" },
  })

  lsp.on_attach(nil, 0)

  -- require("core.diagnostics")
  -- require("ufo").setup()
  -- local sc = java.spring_boot_config
  -- require("spring_boot.launch").start(sc)
  -- -- end
end

local function on_attach(client, bufnr)
  require("spring_boot").init_lsp_commands()
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
