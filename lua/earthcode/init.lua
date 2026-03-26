local M = {}

function M.load()
  local c = require("earthcode.palette")
  require("earthcode.highlights").load(c)
  require("earthcode.integrations.telescope").load(c)
  require("earthcode.integrations.lualine").load(c)
  require("earthcode.integrations.bufferline").load(c)
  require("earthcode.integrations.nvim_tree").load(c)
  require("earthcode.integrations.gitsigns").load(c)
  require("earthcode.integrations.indent_blankline").load(c)
end

return M
