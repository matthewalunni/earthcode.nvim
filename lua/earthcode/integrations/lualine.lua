-- Lualine integration for earthcode.nvim.
-- ARCHITECTURE NOTE: This module is unique — load() is intentionally a no-op.
-- Lualine manages its own highlight groups; wire the theme manually:
--   require("lualine").setup({ theme = require("earthcode.integrations.lualine").theme() })
-- theme() returns a snapshot of the current palette at call time (not a live table).
local M = {}

-- Returns a lualine theme table (palette snapshot — not live-updated).
function M.theme()
  local c = require("earthcode.palette")
  return {
    normal = {
      a = { fg = c.bg, bg = c.keyword,  gui = "bold" },
      b = { fg = c.fg, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
    insert = {
      a = { fg = c.bg, bg = c.hint,     gui = "bold" },
      b = { fg = c.fg, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
    visual = {
      a = { fg = c.bg, bg = c.string,   gui = "bold" },
      b = { fg = c.fg, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
    replace = {
      a = { fg = c.bg, bg = c.error,    gui = "bold" },
      b = { fg = c.fg, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
    command = {
      a = { fg = c.bg, bg = c.warning,  gui = "bold" },
      b = { fg = c.fg, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
    inactive = {
      a = { fg = c.comment, bg = c.ui_dark },
      b = { fg = c.comment, bg = c.ui_dark },
      c = { fg = c.comment, bg = c.bg },
    },
  }
end

-- No nvim_set_hl calls — lualine manages its own highlight groups.
-- Wire via: require("lualine").setup({ theme = require("earthcode.integrations.lualine").theme() })
function M.load(_c) end

return M
