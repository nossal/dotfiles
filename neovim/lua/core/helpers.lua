local M = {}

M.nmap = function(keys, func, desc)
  M.map("n", keys, func, { buffer = bufnr, desc = desc })
end

M.map = function(mode, keys, func, desc, opts)
  if opts == nil then
    opts = {}
  end

  opts.desc = desc

  vim.keymap.set(mode, keys, func, opts)
end

M.get_java_home = function(version)
  return vim.fn.system("mise where java@" .. version):gsub("%s+", "")
end

M.is_project = function(root, root_markers)
  for _, pattern in ipairs(root_markers) do
    local match = vim.fs.find(pattern, { path = root, type = "file", upward = false })
    if #match > 0 then
      return true
    end
  end
  return false
end

local function tprint(tbl, indent)
  if not indent then
    indent = 0
  end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if type(k) == "number" then
      toprint = toprint .. "[" .. k .. "] = "
    elseif type(k) == "string" then
      toprint = toprint .. k .. "= "
    end
    if type(v) == "number" then
      toprint = toprint .. v .. ",\r\n"
    elseif type(v) == "string" then
      toprint = toprint .. '"' .. v .. '",\r\n'
    elseif type(v) == "table" then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. '"' .. tostring(v) .. '",\r\n'
    end
  end
  toprint = toprint .. string.rep(" ", indent - 2) .. "}"
  return toprint
end

return M
