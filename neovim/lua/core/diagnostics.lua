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
    focusable = true,
    -- border = border,
    scope = "cursor",
    -- source = true,
    format = function(diagnostic)
      local code = diagnostic.user_data.lsp.code
      print("diagnostic:")
      -- dump(diagnostic)
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
