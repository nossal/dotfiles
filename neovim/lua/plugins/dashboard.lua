local logo = vim.split(
[[
      ___                                    ___
     /__/\          ___        ___          /__/\
     \  \:\        /__/\      /  /\        |  |::\
      \  \:\       \  \:\    /  /:/        |  |:|:\
  _____\__\:\       \  \:\  /__/::\      __|__|:|\:\
 /__/::::::::\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
 \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
  \  \:\  ~~~  \  \:\|  |:|     \__\::/  \  \:\
   \  \:\       \  \:\__|:|     /__/:/    \  \:\
    \  \:\       \__\::::/      \__\/      \  \:\
     \__\/           ~~~~                   \__\/
  ]], "\r")

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        header = logo
      },
      -- your dashboard configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
