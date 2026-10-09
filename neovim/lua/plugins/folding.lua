local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    lazy = true,
    dependencies = "kevinhwang91/promise-async",
    opts = {
      close_fold_kinds_for_ft = { default = { "imports" } },
      fold_virt_text_handler = handler,
    },
  },
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- required even when using default config
    config = function()
      require("origami").setup({
        foldtext = {
          enabled = true,
          padding = {
            character = " ",
            width = 3, ---@type number|fun(win: number, foldstart: number, currentVirtualTextLength: number): number
            hlgroup = nil,
          },
          lineCount = {
            template = "󰘖 %d",
            hlgroup = "Comment",
          },
       },
        autoFold = {
          enabled = true,
          kinds = { "imports" }, ---@type lsp.FoldingRangeKind[]
        },
     })
    end,
  },
}
