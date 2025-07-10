local wk = require("which-key")

local on_attach = function(_, bufnr)
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
    { "<leader>D", "<cmd>FzfLua diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
    { "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics" },
    { "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP" },
    -- { "<leader>ca", vim.lsp.buf.code_action,                desc = "See available code actions", mode = { "n", "v" } },
    -- { "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>",     desc = "See available code actions", mode ={ "n", "v" } },
    -- { "<leader>gf", vim.lsp.buf.format,                     desc = "Format buffer" },

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
}
