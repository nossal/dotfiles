-- local h = require("core.helpers")

return {
  -- https://github.com/wojciech-kulik/xcodebuild.nvim/wiki
  -- {
  --   "wojciech-kulik/xcodebuild.nvim",
  --   lazy = true,
  --   enabled = function()
  --     local root = vim.fn.getcwd()
  --     local root_markers = {
  --       "*.xcodeproj",
  --       "*.xcworkspace",
  --       "Podfile",
  --       "ios/Runner.xcodeproj",
  --       "ios/Info.plist",
  --     }
  --     -- Use the optimized version (Option 2 recommended)
  --     return h.is_project(root, root_markers)
  --   end,
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   config = function()
  --     require("xcodebuild").setup({
  --       -- put some options here or leave it empty to use default settings
  --     })
  --   end,
  -- },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        name = "crates.nvim",
        completion = true,
        hover = true,
      },
    },
    keys = {
      { "<leader>rc", "<cmd>Crates reload<cr>", desc = "Reload crates" },
      { "<leader>rv", "<cmd>Crates show-version<cr>", desc = "Show crate version" },
      { "<leader>rf", "<cmd>Crates show-features<cr>", desc = "Show crate features" },
      { "<leader>rd", "<cmd>Crates show-dependencies<cr>", desc = "Show crate dependencies" },
      { "<leader>ru", "<cmd>Crates update_crate<cr>", desc = "Update crate" },
      { "<leader>rU", "<cmd>Crates upgrade_crate<cr>", desc = "Upgrade crate" },
      { "<leader>ra", "<cmd>Crates update-all<cr>", desc = "Update all crates" },
      { "<leader>ro", "<cmd>Crates open<cr>", desc = "Open crate page" },
      { "<leader>rD", "<cmd>Crates delete<cr>", desc = "Delete crate" },
    },
  }
}
