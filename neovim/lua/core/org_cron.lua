local orgmode = vim.fn.stdpath("data") .. "/lazy/orgmode"
vim.opt.runtimepath:append(orgmode)

local notes_dir = vim.fn.expand("~/Documents/Notes")
-- Run the orgmode cron
require("orgmode").cron({
  org_agenda_files = notes_dir .. "/org/**/*",
  org_default_notes_file = notes_dir .. "/org/notes.org",
  notifications = {
    enabled = true,
    reminder_time = { 0, 5, 10 },
  },
})
