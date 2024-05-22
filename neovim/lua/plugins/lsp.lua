return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",

    -- Additional lua configuration, makes nvim stuff amazing!
    { "folke/neodev.nvim", opts = {} },
    "mfussenegger/nvim-jdtls",
  },
  config = function()
    require("neodev").setup({})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = {
      valueSet = { 1 },
    }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" },
    }

    local lspconfig = require("lspconfig")

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

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

    -- vim.cmd([[au CursorHold  * lua vim.diagnostic.open_float()]])
    -- vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
    -- vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

    -- local border = {
    -- 	{ "🭽", "FloatBorder" },
    -- 	{ "▔", "FloatBorder" },
    -- 	{ "🭾", "FloatBorder" },
    -- 	{ "▕", "FloatBorder" },
    -- 	{ "🭿", "FloatBorder" },
    -- 	{ "▁", "FloatBorder" },
    -- 	{ "🭼", "FloatBorder" },
    -- 	{ "▏", "FloatBorder" },
    -- }
    local border = {
      { "╭", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╮", "FloatBorder" },
      { "│", "FloatBorder" },
      { "╯", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╰", "FloatBorder" },
      { "│", "FloatBorder" },
    }

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local codes = {
      no_matching_function = {
        message = " Can't find a matching function",
        "redundant-parameter",
        "ovl_no_viable_function_in_call",
      },
      empty_block = {
        message = "󰂕 That shouldn't be empty here",
        "empty-block",
      },
      missing_symbol = {
        message = "󰍉 Here should be a symbol",
        "miss-symbol",
      },
      expected_semi_colon = {
        message = " Remember the `;` or `,`",
        "expected_semi_declaration",
        "miss-sep-in-table",
        "invalid_token_after_toplevel_declarator",
      },
      redefinition = {
        message = "󰁡 That variable was defined before",
        "redefinition",
        "redefined-local",
      },
      no_matching_variable = {
        message = " Can't find that variable",
        "undefined-global",
        "reportUndefinedVariable",
      },
      trailing_whitespace = {
        message = " Remove trailing whitespace",
        "trailing-whitespace",
        "trailing-space",
      },
      unused_variable = {
        message = "󰂭 Don't define variables you don't use",
        "unused-local",
      },
      unused_function = {
        message = "󰂭 Don't define functions you don't use",
        "unused-function",
      },
      useless_symbols = {
        message = " Remove that useless symbols",
        "unknown-symbol",
      },
      wrong_type = {
        message = "󰉺 Try to use the correct types",
        "init_conversion_failed",
      },
      undeclared_variable = {
        message = " Have you delcared that variable somewhere?",
        "undeclared_var_use",
      },
      lowercase_global = {
        message = " Should that be a global? (if so make it uppercase)",
        "lowercase-global",
      },
    }

    vim.diagnostic.config({
      float = {
        focusable = false,
        border = border,
        scope = "cursor",
        -- source = true,
        format = function(diagnostic)
          local code = diagnostic.user_data.lsp.code
          print("diagnostic:")
          dump(diagnostic)
          for _, table in pairs(codes) do
            if vim.tbl_contains(table, code) then
              return table.message
            end
          end
          return diagnostic.message
        end,
        header = { "Cursor Diagnostics:", "DiagnosticHeader" },
        pos = 1,
        prefix = function(diagnostic, i, total)
          local icon, highlight
          if diagnostic.severity == 1 then
            icon = "󰅙"
            highlight = "DiagnosticError"
          elseif diagnostic.severity == 2 then
            icon = ""
            highlight = "DiagnosticWarn"
          elseif diagnostic.severity == 3 then
            icon = ""
            highlight = "DiagnosticInfo"
          elseif diagnostic.severity == 4 then
            icon = ""
            highlight = "DiagnosticHint"
          end
          return i .. "/" .. total .. " " .. icon .. "  ", highlight
        end,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      virtual_text = true,
      severity_sort = true,
    })

    local servers = {
      "yamlls",
      "cssls",
      "emmet_ls",
      "html",
      "lua_ls",
      "clojure_lsp",
      "rust_analyzer",
      "tsserver",
      "biome",
      "pyright",
      "bashls",
    }
    for _, value in ipairs(servers) do
      lspconfig[value].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end

    -- Java jdtls
    -- ------------------------------------
    local get_java_home = function (version)
      return vim.fn.system("mise where java@" .. version):gsub("%s+", "")
    end

    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    local status, jdtls = pcall(require, "jdtls")
    if not status then
      print("jdtls pcall status fail")
      return
    end
    local extendedClientCapabilities = jdtls.extendedClientCapabilities

    -- calculate workspace dir
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
    os.execute("mkdir " .. workspace_dir)

    -- get the mason install path
    local mason_jdtls_path = require("mason-registry").get_package("jdtls"):get_install_path()

    local java_home = get_java_home("17")

    -- get the current OS
    local systems = {
      ["Darwin"] = "mac",
      ["Linux"] = "linux",
      ["Windows"] = "win"
    }
    local os = systems[vim.loop.os_uname().sysname] or "linux"

    local bundles = {}
    local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
    vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
    vim.list_extend(
      bundles,
      vim.split(
        vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
        "\n"
      )
    )

    lspconfig.jdtls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = {
        "" .. java_home .. "/bin/java",
        -- "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. mason_jdtls_path .. "/lombok.jar",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(mason_jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        mason_jdtls_path .. "/config_" .. os,
        "-data",
        workspace_dir,
      },
      root_dir = function()
        return root_dir
      end,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = {
              {
                name = "JavaSE-1.8",
                path = get_java_home("8")
              },
              {
                name = "JavaSE-17",
                path = get_java_home("17")
              },
              {
                name = "JavaSE-21",
                path = get_java_home("lts")
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
              enabled = "all", -- literals, all, none
            },
          },
          format = {
            enabled = false,
          },
        },
        signatureHelp = { enabled = true },
        extendedClientCapabilities = extendedClientCapabilities,
      },
      init_options = {
        bundles = bundles,
      },
    })

    vim.api.nvim_create_autocmd("Filetype", {
      pattern = "java", -- autocmd to start jdtls
      callback = function()
        if opts.root_dir and opts.root_dir ~= "" then
          local _, _ = pcall(vim.lsp.codelens.refresh)

          local local_jdtls = require("jdtls")
          local_jdtls.start_or_attach(opts)

          local_jdtls.setup_dap({ hotcodereplace = "auto" })
          local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
          if status_ok then
            jdtls_dap.setup_dap_main_class_configs()
          end
        end

        keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
        keymap.set(
          "n",
          "<leader>crv",
          "<Cmd>lua require('jdtls').extract_variable()<CR>",
          { desc = "Extract Variable" }
        )
        keymap.set(
          "v",
          "<leader>crv",
          "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
          { desc = "Extract Variable" }
        )
        keymap.set(
          "n",
          "<leader>crc",
          "<Cmd>lua require('jdtls').extract_constant()<CR>",
          { desc = "Extract Constant" }
        )
        keymap.set(
          "v",
          "<leader>crc",
          "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
          { desc = "Extract Constant" }
        )
        keymap.set(
          "v",
          "<leader>crm",
          "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
          { desc = "Extract Method" }
        )
      end,
    })
  end,
}
