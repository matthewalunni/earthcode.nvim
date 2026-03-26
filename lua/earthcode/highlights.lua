local M = {}

local function hi(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

function M.load(c)
  -- ── Base UI ────────────────────────────────────────────────────────
  hi("Normal",        { fg = c.fg,      bg = c.bg })
  hi("NormalFloat",   { fg = c.fg,      bg = c.visual })
  hi("NormalNC",      { fg = c.fg,      bg = c.bg })
  hi("CursorLine",    { bg = c.cursorline })
  hi("CursorLineNr",  { fg = c.keyword, bg = c.cursorline })
  hi("Visual",        { bg = c.visual })
  hi("Search",        { fg = c.bg,      bg = c.warning })
  hi("IncSearch",     { fg = c.bg,      bg = c.keyword })
  hi("StatusLine",    { fg = c.fg,      bg = c.ui_dark })
  hi("StatusLineNC",  { fg = c.comment, bg = c.ui_dark })
  hi("WinSeparator",  { fg = c.ui_mid })
  hi("VertSplit",     { fg = c.ui_mid })
  hi("LineNr",        { fg = c.comment })
  hi("SignColumn",    { bg = c.bg })
  hi("Pmenu",         { fg = c.fg,      bg = c.ui_dark })
  hi("PmenuSel",      { fg = c.bg,      bg = c.keyword })
  hi("PmenuSbar",     { bg = c.ui_mid })
  hi("PmenuThumb",    { bg = c.fg })
  hi("Folded",        { fg = c.comment, bg = c.cursorline })
  hi("TabLine",       { fg = c.comment, bg = c.ui_dark })
  hi("TabLineSel",    { fg = c.fg,      bg = c.bg })
  hi("TabLineFill",   { bg = c.ui_dark })
end

return M
