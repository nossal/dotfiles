return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local helpers = require("core.helpers")

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
        self.absolute_path = vim.api.nvim_buf_get_name(0)
        self.file_extension = vim.fn.fnamemodify(self.absolute_path, ":e")
        self.filename = vim.fn.fnamemodify(self.absolute_path, ":.")
      end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
      init = function(self)
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ":e")

        self.icon = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = "#888888" }
      end,
    }

    local FileName = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = self.filename
        if filename == "" then
          return "[No Name]"
        end

        local function java_package_from(filepath)
          local package_path = filepath:match("src/main/java/(.+)")
          return package_path and package_path:gsub("/", ".") or ""
        end

        if self.file_extension == "java" then
          -- path to package
          local path = vim.fn.fnamemodify(filename, ":h")
          local name = vim.fn.fnamemodify(filename, ":t")
          local package = java_package_from(path)

          return package .. "/" .. name
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
        hl = { fg = "#dd9944" },
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
        local languages = require("core.lsp").all_lsp_servers
        setmetatable(languages, {
          __index = function(table, key)
            return { name = key }
          end,
        })

        local names = {}
        local ai = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          local cfg = languages[server.name]
          if cfg.ai then
            table.insert(ai, cfg.name)
          else
            table.insert(names, cfg.name)
          end
        end
        self.names = names
        self.ai = ai
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
            .. table.concat(self.names, " ")
            .. ""
      end,
      hl = { fg = "green", bold = true },
    }

    local LSAPAi = {
      condition = function(self)
        return #self.ai > 0
      end,
      provider = function(self)
        -- return " " .. table.concat(self.ai, " ") .. " "
        return " "
      end,
      hl = { fg = "#4488dd", bg = "#232323", italic = true },
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

    LSPBlock = utils.insert(LSPBlock, LSPActive, { provider = " "}, LSAPAi, PyEnv)

    -- I personally use it only to display progress messages!
    -- See lsp-status/README.md for configuration options.

    -- local LSPMessages = {
    -- 	provider = require("lsp-status").status,
    -- 	hl = { fg = "gray" },
    -- }

    local signs = require("core.ui").diagnostic_icons
    local Diagnostics = {
      condition = conditions.has_diagnostics,

      static = {
        error_icon = signs.Error,
        warn_icon = signs.Warn,
        hint_icon = signs.Hint,
        info_icon = signs.Info,
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

    local get_project_name = helpers.memoize(function(cwd)
      return vim.trim(vim.fn.system({ "git", "-C", cwd, "repo-name" }))
    end)

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.project_name = get_project_name(vim.fn.getcwd())
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { fg = "#FF5D30" },

      {
        provider = function(self)
          return self.project_name .. "  "
        end,
        hl = { fg = "#0022ee" },
      },

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
      -- { SearchCount },
      { Git },
      { Space },
      { FileNameBlock },
      { Space },
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
