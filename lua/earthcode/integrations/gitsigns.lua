local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  -- Sign column glyphs
  hi("GitSignsAdd",      { fg = c.hint })
  hi("GitSignsChange",   { fg = c.warning })
  hi("GitSignsDelete",   { fg = c.error })
  -- Number column
  hi("GitSignsAddNr",    { fg = c.hint })
  hi("GitSignsChangeNr", { fg = c.warning })
  hi("GitSignsDeleteNr", { fg = c.error })
  -- Line highlights (bg is a blended hex — no opacity support in Neovim)
  hi("GitSignsAddLn",    { fg = c.hint,    bg = c.diff_add_bg })
  hi("GitSignsChangeLn", { fg = c.warning, bg = c.diff_chg_bg })
  hi("GitSignsDeleteLn", { fg = c.error,   bg = c.diff_del_bg })
end

return M
