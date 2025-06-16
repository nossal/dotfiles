local h = require("core.helpers")

return {
  -- https://github.com/wojciech-kulik/xcodebuild.nvim/wiki
  {
    "wojciech-kulik/xcodebuild.nvim",
    lazy = true,
    cond = function()
      local root = vim.fn.getcwd()
      local files = {
        "*.xcodeproj",
        "*.xcworkspace",
        "Podfile",
        "ios/Runner.xcodeproj",
        "ios/Info.plist",
      }
      return h.is_project(root, files)
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("xcodebuild").setup({
        -- put some options here or leave it empty to use default settings
      })
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
    end,
  },
}
