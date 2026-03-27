local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("MiniIconsGreen",  { fg = c.hint })       -- forest green
  hi("MiniIconsRed",    { fg = c.error })      -- muted brick
  hi("MiniIconsOrange", { fg = c.warning })    -- warm amber
  hi("MiniIconsYellow", { fg = c.string })     -- camel / golden
  hi("MiniIconsGrey",   { fg = c.comment })    -- dusty olive
  hi("MiniIconsAzure",  { fg = "#7a9e9e" })    -- muted teal (no azure in palette)
  hi("MiniIconsBlue",   { fg = "#788fa0" })    -- slate (no blue in palette)
  hi("MiniIconsCyan",   { fg = "#8aada8" })    -- sage-teal (no cyan in palette)
  hi("MiniIconsPurple", { fg = "#9e8a7a" })    -- warm mauve (no purple in palette)
end

return M
