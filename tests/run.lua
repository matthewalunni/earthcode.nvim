local failures = {}
local passes = 0

local function fail(msg)
  table.insert(failures, "FAIL: " .. msg)
end

local function ok(label)
  passes = passes + 1
  -- uncomment to see passing tests: print("PASS: " .. label)
end

local function assert_eq(label, got, expected)
  if got ~= expected then
    fail(label .. ": expected " .. tostring(expected) .. ", got " .. tostring(got))
  else
    ok(label)
  end
end

local function assert_not_nil(label, v)
  if v == nil then
    fail(label .. ": expected non-nil value")
  else
    ok(label)
  end
end

local function assert_hl_set(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if vim.tbl_isempty(hl) then
    fail("highlight group not set: " .. name)
  else
    ok("hl:" .. name)
  end
end

-- ── tests go here ────────────────────────────────────────────────────
-- palette
local palette_ok, c = pcall(require, "earthcode.palette")
if not palette_ok then
  fail("could not load earthcode.palette: " .. tostring(c))
else
  local required_keys = {
    "bg", "cursorline", "visual", "diff_del_bg", "ui_dark", "ui_mid",
    "fg", "keyword", "string", "type", "parameter", "punctuation",
    "comment", "error", "warning", "hint",
  }
  for _, key in ipairs(required_keys) do
    assert_not_nil("palette." .. key, c[key])
  end
  assert_eq("palette.bg",      c.bg,      "#000000")
  assert_eq("palette.fg",      c.fg,      "#c2c5aa")
  assert_eq("palette.keyword", c.keyword, "#936639")
  assert_eq("palette.string",  c.string,  "#a68a64")
  assert_eq("palette.error",   c.error,   "#8b3a3a")
  assert_eq("palette.warning", c.warning, "#b5803a")
  assert_eq("palette.hint",    c.hint,    "#6b8c6b")
end

-- init: load() runs without error
local init_ok, init_err = pcall(function()
  require("earthcode").load()
end)
if not init_ok then
  fail("earthcode.load() raised an error: " .. tostring(init_err))
else
  ok("earthcode.load() runs without error")
end

-- base UI groups
local base_groups = {
  "Normal", "NormalFloat", "NormalNC", "CursorLine", "CursorLineNr",
  "Visual", "Search", "IncSearch", "StatusLine", "StatusLineNC",
  "WinSeparator", "VertSplit", "LineNr", "SignColumn",
  "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
  "Folded", "TabLine", "TabLineSel", "TabLineFill",
}
for _, name in ipairs(base_groups) do
  assert_hl_set(name)
end

-- syntax + treesitter groups
local syntax_groups = {
  "Comment", "Keyword", "Statement", "Conditional", "Repeat",
  "String", "Character", "Identifier", "Function", "Type",
  "Constant", "Number", "Boolean", "Operator", "Delimiter", "Special",
  "@keyword", "@string", "@comment", "@variable", "@function",
  "@parameter", "@type", "@number", "@boolean", "@operator",
  "@punctuation.bracket", "@punctuation.delimiter",
}
for _, name in ipairs(syntax_groups) do
  assert_hl_set(name)
end

-- LSP, diagnostics, diff
local lsp_groups = {
  "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
  "DiagnosticUnderlineError", "DiagnosticUnderlineWarn",
  "DiagnosticUnderlineInfo", "DiagnosticUnderlineHint",
  "LspReferenceText", "LspReferenceRead", "LspReferenceWrite",
  "DiffAdd", "DiffChange", "DiffDelete", "DiffText",
  "@lsp.type.keyword", "@lsp.type.string", "@lsp.type.comment",
  "@lsp.type.variable", "@lsp.type.function", "@lsp.type.method",
  "@lsp.type.parameter", "@lsp.type.type", "@lsp.type.class",
  "@lsp.type.interface", "@lsp.type.namespace", "@lsp.type.property",
  "@lsp.type.number", "@lsp.type.operator",
  "@lsp.type.enum", "@lsp.type.enumMember",
  "@lsp.type.decorator", "@lsp.type.macro",
}
for _, name in ipairs(lsp_groups) do
  assert_hl_set(name)
end

-- telescope
local telescope_groups = {
  "TelescopeBorder", "TelescopeNormal",
  "TelescopePromptNormal", "TelescopePromptBorder", "TelescopePromptTitle",
  "TelescopeResultsBorder", "TelescopeResultsTitle",
  "TelescopePreviewBorder", "TelescopePreviewTitle",
  "TelescopeSelection", "TelescopeSelectionCaret", "TelescopeMatching",
}
for _, name in ipairs(telescope_groups) do
  assert_hl_set(name)
end

-- lualine: theme table structure
local lualine_ok, lualine_mod = pcall(require, "earthcode.integrations.lualine")
if not lualine_ok then
  fail("could not load lualine integration: " .. tostring(lualine_mod))
else
  local theme_ok, theme = pcall(lualine_mod.theme)
  if not theme_ok then
    fail("lualine.theme() raised an error: " .. tostring(theme))
  else
    local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
    for _, mode in ipairs(modes) do
      assert_not_nil("lualine.theme." .. mode,            theme[mode])
      assert_not_nil("lualine.theme." .. mode .. ".a",    theme[mode] and theme[mode].a)
      assert_not_nil("lualine.theme." .. mode .. ".a.fg", theme[mode] and theme[mode].a and theme[mode].a.fg)
      assert_not_nil("lualine.theme." .. mode .. ".a.bg", theme[mode] and theme[mode].a and theme[mode].a.bg)
    end
  end
end

-- bufferline
local bufferline_groups = {
  "BufferLineFill", "BufferLineBackground", "BufferLineSelected",
  "BufferLineIndicatorSelected", "BufferLineSeparator",
  "BufferLineSeparatorSelected", "BufferLineModified",
  "BufferLineModifiedSelected", "BufferLineCloseButton",
  "BufferLineCloseButtonSelected",
}
for _, name in ipairs(bufferline_groups) do
  assert_hl_set(name)
end

-- nvim-tree
local nvimtree_groups = {
  "NvimTreeNormal", "NvimTreeEndOfBuffer", "NvimTreeFolderIcon",
  "NvimTreeFolderName", "NvimTreeOpenedFolderName", "NvimTreeRootFolder",
  "NvimTreeIndentMarker", "NvimTreeGitDirty", "NvimTreeGitNew",
  "NvimTreeGitDeleted", "NvimTreeSpecialFile", "NvimTreeExecFile",
}
for _, name in ipairs(nvimtree_groups) do
  assert_hl_set(name)
end

-- ── report ───────────────────────────────────────────────────────────
if #failures > 0 then
  for _, msg in ipairs(failures) do print(msg) end
  print(string.format("\n%d passed, %d failed", passes, #failures))
  vim.cmd("cq 1")
else
  print(string.format("All %d tests passed.", passes))
  vim.cmd("q!")
end
