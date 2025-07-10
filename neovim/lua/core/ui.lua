local M = {}

-- Array         = '󰅪 ', --  󰅪 󰅨 󱃶
-- Boolean       = '󰨙 ', --  ◩ 󰔡 󱃙 󰟡 󰨙
-- Class         = '󰌗 ', --  󰌗 󰠱 𝓒
-- Codeium       = '󰘦 ', -- 󰘦
-- Collapsed     = ' ', -- 
-- Color         = '󰏘 ', -- 󰸌 󰏘
-- Constant      = '󰏿 ', --   󰏿
-- Constructor   = ' ', --  󰆧   
-- Control       = ' ', -- 
-- Copilot       = ' ', --  
-- Enum          = '󰕘 ', --  󰕘  ℰ 
-- EnumMember    = ' ', --  
-- Event         = ' ', --  
-- Field         = ' ', --  󰄶  󰆨  󰀻 󰃒 
-- File          = ' ', --    󰈔 󰈙
-- Folder        = ' ', --   󰉋
-- Function      = '󰊕 ', --  󰊕 
-- Interface     = ' ', --    
-- Key           = ' ', -- 
-- Keyword       = ' ', --   󰌋 
-- Method        = '󰊕 ', --  󰆧 󰊕 ƒ
-- Module        = ' ', --   󰅩 󰆧 󰏗
-- Namespace     = '󰦮 ', -- 󰦮   󰅩
-- Null          = ' ', --  󰟢
-- Number        = '󰎠 ', --  󰎠 
-- Object        = ' ', --   󰅩
-- Operator      = '󰃬 ', --  󰃬 󰆕 +
-- Package       = ' ', --   󰏖 󰏗 󰆧
-- Property      = ' ', --   󰜢   󰖷
-- Reference     = '󰈝 ', --  󰈝 󰈇
-- Snippet       = ' ', --  󰘌 ⮡   
-- String        = ' ', --   󰅳
-- Struct        = '󰆼 ', -- 󰆼   𝓢 󰙅 󱏒
-- TabNine       = '󰏚 ', -- 󰏚
-- Text          = ' ', --   󰉿 𝓐
-- TypeParameter = ' ', --  󰊄 𝙏
-- Unit          = ' ', --   󰑭 
-- Value         = ' ', --   󰀬 󰎠
-- Variable      = ' ', --   󰀫 

-- Class = " ",
-- Color = " ",
-- Constant = " ",
-- Constructor = " ",
-- Enum = " ",
-- EnumMember = " ",
-- Field = "󰄶 ",
-- File = " ",
-- Folder = " ",
-- Function = " ",
-- Interface = "󰜰",
-- Keyword = "󰌆 ",
-- Method = "ƒ ",
-- Module = "󰏗 ",
-- Property = " ",
-- Snippet = "󰘍 ",
-- Struct = " ",
-- Text = " ",
-- Unit = " ",
-- Value = "󰎠 ",
-- Variable = " ",

local icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = " ",
  -- Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}
local diagnostic_icons = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

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

return {
  border = border,
  diagnostic_icons = diagnostic_icons,
  kind_icon = function (kind)
    return icons[kind] or ""
  end,
  kind_label = function(kind)
    local icon = icons[kind] or ""
    return " " .. icon .. " " .. kind
  end
}
