local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("BufferLineFill",                { bg = c.ui_dark })
  hi("BufferLineBackground",          { fg = c.comment,  bg = c.ui_dark })
  hi("BufferLineSelected",            { fg = c.fg,       bg = c.bg,      bold = true })
  hi("BufferLineIndicatorSelected",   { fg = c.keyword,  bg = c.bg })
  hi("BufferLineSeparator",           { fg = c.ui_mid,   bg = c.ui_dark })
  hi("BufferLineSeparatorSelected",   { fg = c.ui_mid,   bg = c.bg })
  hi("BufferLineModified",            { fg = c.warning,  bg = c.ui_dark })
  hi("BufferLineModifiedSelected",    { fg = c.warning,  bg = c.bg })
  hi("BufferLineCloseButton",         { fg = c.comment,  bg = c.ui_dark })
  hi("BufferLineCloseButtonSelected", { fg = c.error,    bg = c.bg })
end

return M
