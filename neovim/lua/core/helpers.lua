local M = {}

M.nmap = function(keys, func, desc)
  M.map("n", keys, func, { buffer = bufnr, desc = desc })
end

M.map = function(mode, keys, func, desc, opts)
  if opts == nil then opts = {} end

  opts.desc = desc

  vim.keymap.set(mode, keys, func, opts)
end

return M
