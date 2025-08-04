local helpers = require("core.helpers")
local mason, _ = pcall(require, "mason-registry")

local function get_workspace_path()
  local project_path = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h")
  local project_path_hash = string.gsub(project_path, "[/\\:+-]", "_")

  local nvim_cache_path = vim.fn.stdpath("cache")
  return table.concat({ nvim_cache_path, "jdtls", "workspaces", project_path_hash })
end

local function get_jdtls_config_path()
  return table.concat({ vim.fn.stdpath("cache"), "jdtls", "config" })
end

local function get_package(name)
  return vim.fn.expand("$MASON/packages/" .. name)
end

local function get_jdtls_path()
  return get_package("jdtls")
end

local function get_lombok_jar()
  local jdtls_path = get_jdtls_path()
  return jdtls_path .. "/lombok.jar"
end

local function java_home()
  return helpers.get_java_home(21)
end

local function root_dir()
  return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
end

local function jdtls_launcher()
  local jdtls_config = nil
  if helpers.os_type() == helpers.Mac then
    jdtls_config = "/config_mac"
  elseif helpers.os_type() == helpers.Linux then
    jdtls_config = "/config_linux"
  elseif helpers.os_type() == helpers.Windows then
    jdtls_config = "/config_win"
  else
    vim.notify("jdtls: unknown os", vim.log.levels.ERROR)
    return nil
  end

  local lombok_jar = get_lombok_jar()
  local jdtls_path = get_jdtls_path()
  local jdtls_java = java_home() .. "/bin/java"

  local cmd = {
    jdtls_java,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. vim.fn.glob(jdtls_path .. jdtls_config),
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "-XX:+UseZGC",
    "--enable-native-access=ALL-UNNAMED",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "--add-opens",
    "java.base/sun.nio.fs=ALL-UNNAMED",
  }
  if lombok_jar ~= nil then
    table.insert(cmd, "-javaagent:" .. lombok_jar)
  end
  table.insert(cmd, "-jar")
  table.insert(cmd, vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"))

  table.insert(cmd, "-configuration")
  table.insert(cmd, get_jdtls_config_path())

  table.insert(cmd, "-data")
  table.insert(cmd, get_workspace_path())

  return cmd
end


local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = jdtls_launcher(),
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
      -- format = {
      --   settings = fmt_config(),
      -- },
      autobuild = { enabled = false },
      maxConcurrentBuilds = 1,
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
      configuration = {
        -- maven = {
        --   -- userSettings = maven.get_maven_settings(),
        --   -- globalSettings = maven.get_maven_settings(),
        -- },
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = helpers.get_java_home("8"),
          },
          {
            name = "JavaSE-17",
            path = helpers.get_java_home("17"),
          },
          {
            name = "JavaSE-21",
            path = helpers.get_java_home("21"),
            default = true,
          },
          {
            name = "JavaSE-24",
            path = helpers.get_java_home("24"),
          },
        },
      },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  -- init_options = {
  --   bundles = {
  --     vim.fn.glob("/opt/software/lsp/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.35.0.jar")
  --   },
  --   workspace = workspace_dir
  -- },
}
local function ls_path()
  local path = vim.env["JDTLS_SPRING_TOOLS_PATH"]
  if path == nil or path == "" then
    return nil
  end
  return require("spring_boot").get_boot_ls(path .. "/language-server")
end

local function bootls_user_command(buf)
  local create_command = vim.api.nvim_buf_create_user_command
  local commands = {
    Annotations = {
      symbol = "@",
      prompt = "show all Spring annotations in the code",
    },
    Beans = {
      symbol = "@+",
      prompt = "show all defined beans",
    },
    RequestMappings = {
      symbol = "@/",
      prompt = "show all defined request mappings",
    },
    Prototype = {
      symbol = "@>",
      prompt = "show all functions (prototype implementation)",
    },
  }
  local commands_name = {}
  for key, _ in pairs(commands) do
    table.insert(commands_name, key)
  end

  create_command(buf, "SpringBoot", function(opt)
    local on_choice = function(choice)
      vim.lsp.buf.workspace_symbol(commands[choice].symbol)
    end
    if opt.args and opt.args ~= "" then
      on_choice(opt.args)
    else
      vim.ui.select(commands_name, {
        prompt = "Spring Symbol:",
        format_item = function(item)
          return commands[item].prompt
        end,
      }, on_choice)
    end
  end, {
    desc = "Spring Boot",
    nargs = "?",
    range = false,
    complete = function()
      return commands_name
    end,
  })
end

local function spring_boot_config()
  local lspath = ls_path()
  if lspath == nil then
    return nil
  end

  return require("spring_boot.launch").update_ls_config(require("spring_boot").setup({
    ls_path = lspath,
    server = {
      on_attach = function(client, bufnr)
        require("core.lsp").on_attach(client, bufnr)
        bootls_user_command(bufnr)
      end,
      on_init = function(client, ctx)
        client.server_capabilities.documentHighlightProvider = false
      end,
      capabilities = require("core.lsp").capabilities(),
    },
    autocmd = false,
  }))
end

local function setup()
  -- -- local is_java_project = vim.fn.exists("pom.xml") > 0 or vim.fn.exists("build.gradle") > 0
  -- -- if is_java_project then
  local lsp = require("core.lsp")

  config.capabilities = lsp.capabilities()

  require("jdtls").start_or_attach(config, {
    dap = { config_overrides = {}, hotcodereplace = "auto" },
  })

  lsp.on_attach(nil, 0)

  require("core.diagnostics")
  require("ufo").setup()
  -- local sc = java.spring_boot_config
  -- require("spring_boot.launch").start(sc)
  -- -- end
end

return {
  spring_boot_config = spring_boot_config(),
  config = config,
  setup = setup,
}
