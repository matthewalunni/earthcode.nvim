local M = {}

-- Targets indent-blankline v3 API (IblIndent / IblScope).
-- v2 groups (IndentBlanklineChar, IndentBlanklineContextChar) are not set.
function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("IblIndent", { fg = c.ui_dark })
  hi("IblScope",  { fg = c.ui_mid })
end

return M
