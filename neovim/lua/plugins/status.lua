return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = "N",
          no = "N?",
          nov = "N?",
          noV = "N?",
          ["no\22"] = "N?",
          niI = "Ni",
          niR = "Nr",
          niV = "Nv",
          nt = "Nt",
          v = "V",
          vs = "Vs",
          V = "V_",
          Vs = "Vs",
          ["\22"] = "^V",
          ["\22s"] = "^V",
          s = "S",
          S = "S_",
          ["\19"] = "^S",
          i = "I",
          ic = "Ic",
          ix = "Ix",
          R = "R",
          Rc = "Rc",
          Rx = "Rx",
          Rv = "Rv",
          Rvc = "Rv",
          Rvx = "Rv",
          c = "C",
          cv = "Ex",
          r = "...",
          rm = "M",
          ["r?"] = "?",
          ["!"] = "!",
          t = "T",
        },
        mode_colors = {
          n = "red",
          i = "green",
          v = "cyan",
          V = "cyan",
          ["\22"] = "cyan",
          c = "orange",
          s = "purple",
          S = "purple",
          ["\19"] = "purple",
          R = "orange",
          r = "orange",
          ["!"] = "red",
          t = "red",
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        return " %2(" .. self.mode_names[self.mode] .. "%)"
      end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local FileNameBlock = {
      -- let's first set up some attributes needed by this component and it's children
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return "[No Name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.10) then
          filename = vim.fn.pathshorten(filename, 3)
        end
        return filename
      end,
      hl = { fg = "#888888", italic = true },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " 󰳼",
        hl = { fg = "blue" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
      },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { fg = "cyan", bold = true, force = true }
        end
      end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      -- utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
      FileName,
      FileFlags,
      { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    -- We're getting minimalists here!
    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = "%7(%l/%L%):%2c %P",
    }
    -- I take no credits for this! :lion:
    local ScrollBar = {
      static = {
        -- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        -- Another variant, because the more choice the better.
        sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = "#454545", bg = "black" },
    }

    local LSPBlock = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      init = function(self)
        local langs = require("core.configs")
        local languages = vim.tbl_extend("force", langs.lsp_servers, langs.other_lsp_servers)
        setmetatable(languages, {
          __index = function(table, key)
            return { name = key }
          end,
        })

        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, languages[server.name].name)
        end
        self.names = names
      end,
    }

    local LSPActive = {
      provider = function(self)
        return
          -- " "
          -- " "
          -- " "
          -- "󱠡 "
          "󱠢 "
          .. table.concat(self.names, " ") .. ""
      end,
      hl = { fg = "green", bold = true },
    }

    local PyEnv = {
      condition = function(self)
        return vim.tbl_contains(self.names, "python")
      end,
      provider = function()
        local py = require("core.python")
        local version, name = py.get_env(py.get_pyenv())
        return " " .. name .. ":" .. version
      end,
    }

    LSPBlock = utils.insert(LSPBlock, LSPActive, PyEnv)

    -- I personally use it only to display progress messages!
    -- See lsp-status/README.md for configuration options.

    -- local LSPMessages = {
    -- 	provider = require("lsp-status").status,
    -- 	hl = { fg = "gray" },
    -- }
    local Diagnostics = {
      condition = conditions.has_diagnostics,

      static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      },

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update = { "DiagnosticChanged", "BufEnter" },

      {
        provider = " ",
      },
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "red" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "orange" },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = "blue" },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "green" },
      },
      {
        provider = " ",
      },
    }

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = "orange" },

      { -- git branch name
        provider = function(self)
          return "󰘬 " .. self.status_dict.head
        end,
        -- hl = { bold = true },
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      -- {
      --   condition = function(self)
      --     return self.has_changes
      --   end,
      --   provider = "(",
      -- },
      -- {
      --   provider = function(self)
      --     local count = self.status_dict.added or 0
      --     return count > 0 and ("+" .. count)
      --   end,
      --   hl = { fg = "green" },
      -- },
      -- {
      --   provider = function(self)
      --     local count = self.status_dict.removed or 0
      --     return count > 0 and ("-" .. count)
      --   end,
      --   hl = { fg = "red" },
      -- },
      -- {
      --   provider = function(self)
      --     local count = self.status_dict.changed or 0
      --     return count > 0 and ("~" .. count)
      --   end,
      --   hl = { fg = "orange" },
      -- },
      -- {
      --   condition = function(self)
      --     return self.has_changes
      --   end,
      --   provider = ")",
      -- },
    }

    local SearchCount = {
      condition = function()
        return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
      end,
      init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
          self.search = search
        end
      end,
      provider = function(self)
        local search = self.search
        return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
      end,
    }

    local MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
      end,
      provider = " ",
      hl = { fg = "orange", bold = true },
      utils.surround({ "[", "]" }, nil, {
        provider = function()
          return vim.fn.reg_recording()
        end,
        hl = { fg = "green", bold = true },
      }),
      update = {
        "RecordingEnter",
        "RecordingLeave",
      },
      { provider = " " },
    }

    -- vim.opt.showcmdloc = "statusline"
    local ShowCmd = {
      condition = function()
        return vim.o.cmdheight == 0
      end,
      provider = ":%3.5(%S%)",
      -- hl = function(self)
      -- 	return { bold = true, fg = self:mode_color() }
      -- end,
    }

    local Align = { provider = "%=" }
    local Space = { provider = "  " }

    ViMode = utils.surround({ "", "" }, "black", { MacroRec, ViMode, ShowCmd })

    local FileType = {
      provider = function()
        local tabchar = "Tab Size"
        if vim.bo.expandtab then
          tabchar = "Spaces"
        end
        local tabstop = tabchar .. " " .. vim.opt.tabstop:get()
        local eol = string.upper(vim.bo.fileformat)
        local filetype = vim.bo.filetype
        local encoding = string.upper(vim.bo.fileencoding)

        return filetype .. " " .. encoding .. " " .. tabstop .. " " .. eol
      end,
    }

    local StatusLine = {
      { ViMode },
      { Space },
      -- { SearchCount },
      { FileNameBlock },
      { Space },
      { Git },
      { provider = "%<" },
      { Align },
      { Diagnostics },
      { Space },
      { FileIcon },
      { FileType },
      { Space },
      { LSPBlock },
      -- { LSPActive },
      -- { PyEnv },
      { Space },
      { Ruler },
      { ScrollBar },
    }

    local Sign = { provider = "%s" }
    local Number = {
      provider = "%=%4{v:virtnum ? '' : &nu ? (&rnu && v:relnum ? v:relnum : v:lnum) . ' ' : ''}",
    }
    local Fold = { provider = "%{% &fdc ? '%C ' : '' %}" }

    local StatusColumn = {
      { Sign },
      { Number },
      { Fold },
    }
    -- local Winbar = {}
    -- local Tabline = {}

    require("heirline").setup({
      statusline = StatusLine,
      -- statuscolumn = StatusColumn,
      -- winbar = Winbar,
      -- tabline = Tabline,
      opts = {},
    })
    -- vim.o.statuscolumn = require("heirline").eval_statuscolumn()
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
