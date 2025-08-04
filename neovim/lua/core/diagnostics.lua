local ui = require("core.ui")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.max_width = 70
  opts.max_height = 15
  opts.border = opts.border or ui.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local codes = {
  no_matching_function = {
    message = "  Can't find a matching function",
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
    message = "  Remember the `;` or `,`",
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
    message = "  Can't find that variable",
    "undefined-global",
    "reportUndefinedVariable",
  },
  trailing_whitespace = {
    message = " Remove trailing whitespace",
    "trailing-whitespace",
    "trailing-space",
  },
  unused_variable = {
    message = "󰂭  Don't define variables you don't use",
    "unused-local",
  },
  unused_function = {
    message = "󰂭  Don't define functions you don't use",
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
local highlights = {
  { icon = ui.diagnostic_icons.Error, highlight = "DiagnosticError" },
  { icon = ui.diagnostic_icons.Warn, highlight = "DiagnosticWarn" },
  { icon = ui.diagnostic_icons.Info, highlight = "DiagnosticInfo" },
  { icon = ui.diagnostic_icons.Hint, highlight = "DiagnosticHint" },
}

local setup = function()
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ui.diagnostic_icons.Error,
        [vim.diagnostic.severity.WARN] = ui.diagnostic_icons.Warn,
        [vim.diagnostic.severity.HINT] = ui.diagnostic_icons.Hint,
        [vim.diagnostic.severity.INFO] = ui.diagnostic_icons.Info,
      },
    },
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text = {
    --   spacing = 4,
    --   source = "if_many",
    --   prefix = " ●",
    -- },
    virtual_lines = {
      severity = vim.diagnostic.severity.ERROR,
      current_line = true,
    },
    severity_sort = true,
    float = {
      source = false,
      format = function(diagnostic)
        local code = diagnostic and diagnostic.user_data and diagnostic.user_data.lsp.code

        if not diagnostic.source or not code then
          return string.format("%s", diagnostic.message)
        end

        if diagnostic.source == "eslint" then
          for _, table in pairs(codes) do
            if vim.tbl_contains(table, code) then
              return string.format("%s [%s]", table.icon .. diagnostic.message, code)
            end
          end

          return string.format("%s [%s]", diagnostic.message, code)
        end

        for _, table in pairs(codes) do
          if vim.tbl_contains(table, code) then
            return table.message
          end
        end

        return string.format("%s [%s]", diagnostic.message, diagnostic.source)
      end,
      header = { "Diagnostics:", "DiagnosticHeader" },
      prefix = function(diagnostic, i, total)
        local h = highlights[diagnostic.severity]

        return i .. "/" .. total .. " " .. h.icon .. "  ", h.highlight
      end,
    },
  })
end

-- vim.cmd([[au CursorHold  * lua vim.diagnostic.open_float()]])
return {
  setup = setup,
}
