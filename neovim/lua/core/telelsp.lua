local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local icons = require("core.icons_symbols")

local function lsp_picker(items, opts)
  opts = opts or {}
  -- local me = make_entry.gen_from_quickfix(opts)
  pickers
    .new(opts, {
      prompt_title = "GREAT LSP",
      finder = finders.new_table({
        results = items,
        entry_maker = function(entry)
          return {
            path = entry.filename,
            lnum = entry.lnum,
            col = entry.col,
            value = entry,
            display = string.format("%s - %s -- %s", icons.kind_label(entry.kind), entry.text, entry.filename),
            ordinal = entry.text,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

function M.find_symbols()
  local sources = {
    {
      name = "workspace/symbol",
      params = { query = "" },
    },
    {
      name = "textDocument/typeDefinition",
      params = { query = "" },
    },
    {
      name = "textDocument/documentSymbol",
      params = vim.lsp.util.make_position_params(vim.api.nvim_get_current_win()),
    },
  }

  ITEMS = setmetatable({}, {
    __add = function(mytable, newtable)
      for i = 1, table.maxn(newtable) do
        table.insert(mytable, table.maxn(mytable) + 1, newtable[i])
      end
      return mytable
    end,
  })

  local process_results = function(res, idx)
    -- vim.notify("before call: " .. idx .. " len: " .. #ITEMS .. " res: " .. #res)

    local data = ITEMS + res
    ITEMS = data

    -- vim.notify("call: " .. idx .. " len: " .. #ITEMS .. " res: " .. #res)
    if idx >= #sources then
      lsp_picker(data)
    end
  end

  local currbuf = vim.api.nvim_get_current_buf()

  for idx, source in ipairs(sources) do
    vim.lsp.buf_request(currbuf, source.name, source.params, function(err, result, context, _)
      if err then
        vim.api.nvim_err_writeln("Error when finding symbols: " .. err.message)
        return
      end

      local locations = vim.lsp.util.symbols_to_items(result or {}, context.bufnr) or {}
      vim.notify("locations: " .. #locations)
      process_results(locations, idx)
    end)
  end
end

return M
