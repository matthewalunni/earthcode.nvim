local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("NvimTreeNormal",           { fg = c.fg,      bg = c.bg })
  hi("NvimTreeEndOfBuffer",      { fg = c.bg })
  hi("NvimTreeFolderIcon",       { fg = c.keyword })
  hi("NvimTreeFolderName",       { fg = c.fg })
  hi("NvimTreeOpenedFolderName", { fg = c.keyword, bold = true })
  hi("NvimTreeRootFolder",       { fg = c.warning, bold = true })
  hi("NvimTreeIndentMarker",     { fg = c.ui_mid })
  hi("NvimTreeGitDirty",         { fg = c.warning })
  hi("NvimTreeGitNew",           { fg = c.hint })
  hi("NvimTreeGitDeleted",       { fg = c.error })
  hi("NvimTreeSpecialFile",      { fg = c.parameter, underline = true })
  hi("NvimTreeExecFile",         { fg = c.hint,      bold = true })
end

return M
