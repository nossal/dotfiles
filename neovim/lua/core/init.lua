require("core.options")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf ---@type number
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- vim.notify("it's inlay hint capable?")
      vim.keymap.set("n", "<leader>i", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { buffer = bufnr })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require("persistence").load()
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java", "kotlin", "groovy" }, -- for build.gradle
  callback = function()
    local java = require("core.java")
    -- -- local is_java_project = vim.fn.exists("pom.xml") > 0 or vim.fn.exists("build.gradle") > 0
    -- -- if is_java_project then
    java.config.capabilities = require("core.lsp").capabilities()
    require("jdtls").start_or_attach(java.config, {
      dap = { config_overrides = {}, hotcodereplace = "auto" },
    })

    require("core.diagnostics")
    require("core.lsp").on_attach(nil, 0)
    require("ufo").setup()
    -- local sc = java.spring_boot_config
    -- require("spring_boot.launch").start(sc)
    -- -- end
  end,
})
