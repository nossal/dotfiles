local M = {}

-- List of unicode chars to remove
local codes = {
  0x200B, 0x200C, 0x200D, 0xFEFF, 0x2060,
  0x2061, 0x2062, 0x2063, 0x2064,
  0x200E, 0x200F, 0x202A, 0x202B, 0x202C, 0x202D, 0x202E,
  0x2066, 0x2067, 0x2068, 0x2069,
  0x206A, 0x206B, 0x206C, 0x206D, 0x206E, 0x206F,
  0x00A0, 0x2000, 0x2001, 0x2002, 0x2003, 0x2004, 0x2005, 0x2006,
  0x2007, 0x2008, 0x2009, 0x200A, 0x180E, 0x2028, 0x2029, 0x205F, 0x3000,
  0x2800, 0x3164, 0x1160, 0x115F, 0xFFA0,
  0x00AD, 0x034F, 0x061C, 0x17B4, 0x17B5,
  0xFE00, 0xFE01, 0xFE02, 0xFE03, 0xFE04, 0xFE05, 0xFE06, 0xFE07,
  0xFE08, 0xFE09, 0xFE0A, 0xFE0B, 0xFE0C, 0xFE0D, 0xFE0E, 0xFE0F
}

-- Build pattern
local chars = {}
for _, c in ipairs(codes) do
  table.insert(chars, vim.fn.nr2char(c))
end
local INVISIBLE_PATTERN = "[" .. table.concat(chars, "") .. "]"

---@param text string
---@return string
local function clean_text(text)
  -- remove malicious/invisible characters
  text = text:gsub(INVISIBLE_PATTERN, "")
  -- normalize punctuation
  text = text
    :gsub("[\u{201C}\u{201D}]", '"')
    :gsub("[\u{2018}\u{2019}]", "'")
    :gsub("[\u{2013}\u{2014}]", "-")
    :gsub("\u{2026}", "...")
  return text
end

function M.clean()
  local bufnr = vim.api.nvim_get_current_buf()

  local cleaned = M.format(bufnr)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, cleaned)
  vim.notify("Text cleaned: invisible and typographic chars removed!", vim.log.levels.INFO)
end

-- Conform formatter entrypoint
-- (input, callback)
function M.format(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    lines[i] = clean_text(line)
  end
  return lines
end


vim.api.nvim_create_user_command("CleanUnicode", M.clean, {
  desc = "Remove invisible/malicious Unicode characters from buffer",
})

return M
