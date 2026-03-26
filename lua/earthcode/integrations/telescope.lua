local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("TelescopeBorder",         { fg = c.ui_mid,     bg = c.bg })
  hi("TelescopeNormal",         { fg = c.fg,         bg = c.bg })
  hi("TelescopePromptNormal",   { fg = c.fg,         bg = c.cursorline })
  hi("TelescopePromptBorder",   { fg = c.cursorline, bg = c.cursorline })
  hi("TelescopePromptTitle",    { fg = c.bg,         bg = c.keyword })
  hi("TelescopeResultsBorder",  { fg = c.ui_dark,    bg = c.bg })
  hi("TelescopeResultsTitle",   { fg = c.comment })
  hi("TelescopePreviewBorder",  { fg = c.ui_dark,    bg = c.bg })
  hi("TelescopePreviewTitle",   { fg = c.bg,         bg = c.hint })
  hi("TelescopeSelection",      { bg = c.cursorline })
  hi("TelescopeSelectionCaret", { fg = c.keyword,    bg = c.cursorline })
  hi("TelescopeMatching",       { fg = c.warning,    bold = true })
end

return M
