return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()
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

      local function kind_label(k)
        local icon = icons[k] or ""
        return " " .. icon .. " " .. k
      end

      cmp.setup({
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          native_menu = false,
          ghost_text = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          -- Add tab support
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),
        }),
        -- Installed sources:
        sources = cmp.config.sources({
          { name = "luasnip", keyword_length = 3 },
          { name = "path" }, -- file paths
          { name = "nvim_lsp", keyword_length = 1 }, -- from language server
          { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized

          { name = "nvim_lua", keyword_length = 1 }, -- complete neovim's Lua runtime API such vim.lsp.*
          { name = "buffer", keyword_length = 4 }, -- source current buffer
        }),
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "menu", "abbr", "kind" },
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = "λ",
              luasnip = "⋗",
              buffer = "Ω",
              path = "",
            }
            item.menu = menu_icon[entry.source.name]
            item.kind = kind_label(item.kind)
            return item
          end,
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        formatting = {
          fields = { "menu", "abbr" },
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
}
