local M = {}

function M.get_pyenv()
  return os.getenv("VIRTUAL_ENV")
end

local function get_ini_prop(file_path, prop)
  for line in assert(io.open(file_path)):lines() do
    local key, value = line:match("^([%w_]+)%s-=%s-(.+)$")
    if key == prop then
      return vim.trim(value)
    end
  end
end

function M.get_env(env_path)
  local path = env_path .. "/pyvenv.cfg"
  return get_ini_prop(path, "version_info"), get_ini_prop(path, "prompt")
end

--- @type VenvChangedHook
function M.hook(_, venv_python)
  -- local client = (vim.lsp.get_clients or vim.lsp.get_active_clients)({ name = "basedpyright" })[1]
  local client = vim.lsp.get_clients({ name = "pyrefly" })[1]
  vim.notify("Setting Python path to: " .. venv_python, vim.log.levels.INFO, { title = "LSP" })
  if client.settings then
    client.settings = vim.tbl_deep_extend("force", client.settings, { python = { pythonPath = venv_python } })
  else
    client.config.settings =
      vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = venv_python } })
  end
  client.notify("workspace/didChangeConfiguration", { settings = nil })
end

return M
