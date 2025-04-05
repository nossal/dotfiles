return {
  { "sindrets/diffview.nvim", lazy = true },
  { "akinsho/git-conflict.nvim", lazy = true, version = "*", config = true },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 400,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local wk = require("which-key")
          wk.add({
            -- Navigation
            { "]c",
              function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk()
                end)
                return "<Ignore>"
              end,
              desc = "Next Hunk",
            },
            { "[c",
              function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk()
                end)
                return "<Ignore>"
              end,
              desc = "Prev Hunk"
            },
            -- Actions
            { "<leader>hs", gs.stage_hunk, desc = "Stage Hunk" },
            { "<leader>hr", gs.reset_hunk, desc = "Reset Hunk" },
            { "<leader>hs",
              function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end,
              desc = "Stage Hunk", mode = "v",
            },
            { "<leader>hr",
              function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end,
              desc = "Reset Hunk", mode = "v",
            },
            { "<leader>hS", gs.stage_buffer, desc = "Stage Buffer" },
            { "<leader>hu", gs.undo_stage_hunk, desc = "Undo Staged Hunk" },
            { "<leader>hR", gs.reset_buffer, desc = "Reset Buffer" },
            { "<leader>hp", gs.preview_hunk, desc = "Preview Hunk" },
            { "<leader>hb",
              function()
                gs.blame_line({ full = true })
              end,
              desc = "Toggle Blame",
            },
            { "<leader>tb", gs.toggle_current_line_blame, desc = "Toggle Current Blame" },
            { "<leader>hd", gs.diffthis, desc = "Diff This" },
            { "<leader>hD",
              function()
                gs.diffthis("~")
              end,
              desc = "Diff All",
            },
            { "<leader>td", gs.toggle_deleted, desc = "Toggle deleted" },
            -- Text object
            { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk", mode = "x" },
          })
        end,
      })
    end,
  },
}
