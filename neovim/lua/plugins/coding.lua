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
    opts = {}
  }
}
