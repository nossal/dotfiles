return {
  "ibhagwan/fzf-lua",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    fzf.setup({
      files = {
        path_shorten = 3,
        cwd_prompt_shorten_len = 12, -- shorten prompt beyond this length
        cwd_prompt_shorten_val = 3, -- shortened path parts length },
        cwd_prompt = true,
      },
      previewers = {
        builtin = {
          -- disable treesitter for files bigger than 100KB
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      oldfiles = {
        cwd_only = true,
        stat_file = true,
        include_current_session = true,
      },
      winopts = {
        backdrop = 95,
        title_flags = false,
        preview = {
          delay = 10,
        },
      },
      lsp = {
        code_actions = {
          prompt = "ca>",
          preview = {
            vertical = "down:45%",
            layout = "vertical",
          },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-e"] = "up",
          ["ctrl-n"] = "down",
        },
      },
    })

    fzf.register_ui_select(function(opts, items)
      local min_h, max_h = 0.15, 0.45
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      opts.title = opts.title or "Select"

      return { winopts = { title = opts.title, height = h, width = 0.40, row = 0.40 } }
    end)
  end,
}
