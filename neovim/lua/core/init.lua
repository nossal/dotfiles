require("core.options")
require("core.gpg")

-- Snacks rename file on move in Oil
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

-- Enable inlay hints for LSP clients that support it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf ---@type number
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- vim.notify(client.name .. " it's inlay hint capable? - " .. bufnr, vim.log.levels.INFO, {
      --   title = "LSP Client Capabilities", timeout = 3000, })
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable Ufo folding on Orgfiles
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.org",
  callback = function()
    vim.cmd([[UfoDetach]])
    vim.cmd([[e!]])
  end,
})

-- Load persisted sessions when Neovim starts without file arguments
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require("persistence").load()
    end
  end,
  nested = true,
})
