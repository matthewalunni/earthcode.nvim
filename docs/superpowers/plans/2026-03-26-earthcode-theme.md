# earthcode.nvim Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a pure-Lua Neovim colorscheme using an earth-tone palette with black background, covering core UI, Treesitter, LSP diagnostics, and six plugin integrations.

**Architecture:** A split-module design where `palette.lua` is the single source of truth for all colors. `highlights.lua` and each integration file receive the palette table via `load(c)` — no global state, no hardcoded hex values outside `palette.lua`. The entry point `colors/earthcode.lua` wires everything together.

**Tech Stack:** Lua 5.1 (LuaJIT as shipped with Neovim), `vim.api.nvim_set_hl`, headless Neovim for testing (no external test framework).

---

## File Map

| File | Responsibility |
|---|---|
| `colors/earthcode.lua` | Entry point — sets `colors_name`, `background`, calls `load()` |
| `lua/earthcode/init.lua` | `load()` — orchestrates all highlight calls |
| `lua/earthcode/palette.lua` | All color constants, single source of truth |
| `lua/earthcode/highlights.lua` | Base UI, Syntax, Treesitter, LSP, Diff groups |
| `lua/earthcode/integrations/telescope.lua` | Telescope highlight groups |
| `lua/earthcode/integrations/lualine.lua` | Lualine theme table + `load()` stub |
| `lua/earthcode/integrations/bufferline.lua` | Bufferline highlight groups |
| `lua/earthcode/integrations/nvim_tree.lua` | nvim-tree highlight groups |
| `lua/earthcode/integrations/gitsigns.lua` | Gitsigns highlight groups |
| `lua/earthcode/integrations/indent_blankline.lua` | ibl v3 highlight groups |
| `tests/minimal_init.lua` | Headless Neovim runtimepath setup |
| `tests/run.lua` | All test assertions — run with headless Neovim |

---

## Task 1: Project Scaffold

**Files:**
- Create: `tests/minimal_init.lua`
- Create: `tests/run.lua`
- Create: `.gitignore`

- [ ] **Step 1: Create directory structure**

```bash
mkdir -p lua/earthcode/integrations colors tests
```

- [ ] **Step 2: Create `.gitignore`**

```
.superpowers/
```

- [ ] **Step 3: Create `tests/minimal_init.lua`**

```lua
-- Adds the plugin root to runtimepath so require("earthcode.*") works
vim.opt.runtimepath:prepend(vim.fn.getcwd())
```

- [ ] **Step 4: Create `tests/run.lua` — test harness (no assertions yet)**

```lua
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

-- ── report ───────────────────────────────────────────────────────────
if #failures > 0 then
  for _, msg in ipairs(failures) do print(msg) end
  print(string.format("\n%d passed, %d failed", passes, #failures))
  vim.cmd("cq 1")
else
  print(string.format("All %d tests passed.", passes))
  vim.cmd("q!")
end
```

- [ ] **Step 5: Verify the harness runs cleanly (0 tests)**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected output: `All 0 tests passed.`

- [ ] **Step 6: Commit**

```bash
git init
git add tests/minimal_init.lua tests/run.lua .gitignore
git commit -m "chore: project scaffold with test harness"
```

---

## Task 2: Palette Module

**Files:**
- Modify: `tests/run.lua` (add palette assertions)
- Create: `lua/earthcode/palette.lua`

- [ ] **Step 1: Add palette tests to `tests/run.lua`**

Add these lines in the `-- tests go here` section:

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, `FAIL: could not load earthcode.palette`

- [ ] **Step 3: Create `lua/earthcode/palette.lua`**

```lua
local M = {}

-- Backgrounds
M.bg          = "#000000"  -- Black — main editor background
M.cursorline  = "#111111"  -- Neutral dark — no hue conflict with syntax
M.visual      = "#414833"  -- Ebony — visual selection, borders, float bg
M.diff_del_bg = "#582f0e"  -- Dark Walnut — diff delete background
M.ui_dark     = "#333d29"  -- Charcoal Brown — statusline, indent lines
M.ui_mid      = "#414833"  -- Ebony — separators, context indent

-- Foreground / syntax
M.fg          = "#c2c5aa"  -- Dry Sage (light) — main text, identifiers, functions
M.keyword     = "#936639"  -- Toffee Brown — keywords
M.string      = "#a68a64"  -- Camel — strings
M.type        = "#b6ad90"  -- Khaki Beige — types, constants, numbers
M.parameter   = "#a4ac86"  -- Dry Sage (mid) — parameters
M.punctuation = "#7f4f24"  -- Saddle Brown — punctuation, operators
M.comment     = "#656d4a"  -- Dusty Olive — comments

-- Accent colors (outside base palette)
M.error       = "#8b3a3a"  -- Muted brick red
M.warning     = "#b5803a"  -- Warm amber
M.hint        = "#6b8c6b"  -- Forest green

return M
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 23 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/palette.lua tests/run.lua
git commit -m "feat: add palette module"
```

---

## Task 3: Entry Point and Init

**Files:**
- Modify: `tests/run.lua` (add load() test)
- Create: `lua/earthcode/init.lua`
- Create: `colors/earthcode.lua`

- [ ] **Step 1: Add load() test to `tests/run.lua`**

Add after the palette tests:

```lua
-- init: load() runs without error
local init_ok, init_err = pcall(function()
  require("earthcode").load()
end)
if not init_ok then
  fail("earthcode.load() raised an error: " .. tostring(init_err))
else
  ok("earthcode.load() runs without error")
end
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, `FAIL: earthcode.load() raised an error`

- [ ] **Step 3: Create `lua/earthcode/init.lua`**

```lua
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
```

- [ ] **Step 4: Create stub files for all modules `init.lua` depends on**

Create `lua/earthcode/highlights.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/telescope.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/lualine.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/bufferline.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/nvim_tree.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/gitsigns.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

Create `lua/earthcode/integrations/indent_blankline.lua`:

```lua
local M = {}
function M.load(_c) end
return M
```

- [ ] **Step 5: Create `colors/earthcode.lua`**

```lua
vim.g.colors_name = "earthcode"
vim.o.background = "dark"
require("earthcode").load()
```

- [ ] **Step 6: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 24 tests passed.`

- [ ] **Step 7: Commit**

```bash
git add lua/earthcode/init.lua colors/earthcode.lua \
  lua/earthcode/integrations/telescope.lua \
  lua/earthcode/integrations/lualine.lua \
  lua/earthcode/integrations/bufferline.lua \
  lua/earthcode/integrations/nvim_tree.lua \
  lua/earthcode/integrations/gitsigns.lua \
  lua/earthcode/integrations/indent_blankline.lua \
  tests/run.lua
git commit -m "feat: add entry point, init, and integration stubs"
```

---

## Task 4: Base UI Highlight Groups

**Files:**
- Modify: `tests/run.lua` (add base UI group assertions)
- Modify: `lua/earthcode/highlights.lua` (replace stub with implementation)

- [ ] **Step 1: Add base UI group tests to `tests/run.lua`**

Add after the init tests:

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, multiple `FAIL: highlight group not set` lines.

- [ ] **Step 3: Replace `lua/earthcode/highlights.lua` with full implementation**

```lua
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
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 46 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/highlights.lua tests/run.lua
git commit -m "feat: implement base UI highlight groups"
```

---

## Task 5: Syntax and Treesitter Highlight Groups

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/highlights.lua`

- [ ] **Step 1: Add syntax + treesitter group tests to `tests/run.lua`**

Add after base UI tests:

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, syntax groups not set.

- [ ] **Step 3: Add syntax and treesitter groups to `M.load` in `lua/earthcode/highlights.lua`**

Add inside `M.load(c)` after the base UI block:

```lua
  -- ── Legacy syntax ──────────────────────────────────────────────────
  hi("Comment",      { fg = c.comment,     italic = true })
  hi("Keyword",      { fg = c.keyword })
  hi("Statement",    { fg = c.keyword })
  hi("Conditional",  { fg = c.keyword })
  hi("Repeat",       { fg = c.keyword })
  hi("Label",        { fg = c.keyword })
  hi("Exception",    { fg = c.keyword })
  hi("String",       { fg = c.string })
  hi("Character",    { fg = c.string })
  hi("Identifier",   { fg = c.fg })
  hi("Function",     { fg = c.fg })
  hi("Type",         { fg = c.type })
  hi("StorageClass", { fg = c.type })
  hi("Structure",    { fg = c.type })
  hi("Typedef",      { fg = c.type })
  hi("Constant",     { fg = c.type })
  hi("Number",       { fg = c.type })
  hi("Boolean",      { fg = c.type })
  hi("Float",        { fg = c.type })
  hi("Operator",     { fg = c.punctuation })
  hi("Delimiter",    { fg = c.punctuation })
  hi("Special",      { fg = c.parameter })
  hi("PreProc",      { fg = c.parameter })
  hi("Include",      { fg = c.parameter })
  hi("Define",       { fg = c.parameter })
  hi("Macro",        { fg = c.parameter })

  -- ── Treesitter ─────────────────────────────────────────────────────
  hi("@keyword",               { fg = c.keyword })
  hi("@keyword.function",      { fg = c.keyword })
  hi("@keyword.return",        { fg = c.keyword })
  hi("@keyword.operator",      { fg = c.punctuation })
  hi("@string",                { fg = c.string })
  hi("@string.escape",         { fg = c.warning })
  hi("@comment",               { fg = c.comment, italic = true })
  hi("@variable",              { fg = c.fg })
  hi("@variable.builtin",      { fg = c.type })
  hi("@function",              { fg = c.fg })
  hi("@function.call",         { fg = c.fg })
  hi("@function.builtin",      { fg = c.type })
  hi("@method",                { fg = c.fg })
  hi("@method.call",           { fg = c.fg })
  hi("@parameter",             { fg = c.parameter })
  hi("@type",                  { fg = c.type })
  hi("@type.builtin",          { fg = c.type })
  hi("@field",                 { fg = c.fg })
  hi("@property",              { fg = c.fg })
  hi("@number",                { fg = c.type })
  hi("@boolean",               { fg = c.type })
  hi("@float",                 { fg = c.type })
  hi("@constant",              { fg = c.type })
  hi("@constant.builtin",      { fg = c.type })
  hi("@operator",              { fg = c.punctuation })
  hi("@punctuation.bracket",   { fg = c.punctuation })
  hi("@punctuation.delimiter", { fg = c.punctuation })
  hi("@tag",                   { fg = c.keyword })
  hi("@tag.attribute",         { fg = c.parameter })
  hi("@tag.delimiter",         { fg = c.punctuation })
  hi("@namespace",             { fg = c.type })
  hi("@constructor",           { fg = c.type })
  hi("@include",               { fg = c.parameter })
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 73 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/highlights.lua tests/run.lua
git commit -m "feat: implement syntax and treesitter highlight groups"
```

---

## Task 6: LSP, Diagnostics, and Diff Groups

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/highlights.lua`

- [ ] **Step 1: Add LSP/diagnostic/diff tests to `tests/run.lua`**

Add after syntax tests:

```lua
-- LSP, diagnostics, diff
local lsp_groups = {
  "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
  "DiagnosticUnderlineError", "DiagnosticUnderlineWarn",
  "DiagnosticUnderlineInfo", "DiagnosticUnderlineHint",
  "LspReferenceText", "LspReferenceRead", "LspReferenceWrite",
  "DiffAdd", "DiffChange", "DiffDelete", "DiffText",
}
for _, name in ipairs(lsp_groups) do
  assert_hl_set(name)
end
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, diagnostic groups not set.

- [ ] **Step 3: Add LSP/diagnostic/diff groups to `M.load` in `lua/earthcode/highlights.lua`**

Add inside `M.load(c)` after the treesitter block:

```lua
  -- ── LSP diagnostics ────────────────────────────────────────────────
  hi("DiagnosticError",          { fg = c.error })
  hi("DiagnosticWarn",           { fg = c.warning })
  hi("DiagnosticInfo",           { fg = c.hint })
  hi("DiagnosticHint",           { fg = c.hint })
  hi("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.warning })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.hint })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.hint })
  hi("LspReferenceText",         { bg = c.cursorline })
  hi("LspReferenceRead",         { bg = c.cursorline })
  hi("LspReferenceWrite",        { bg = c.cursorline })

  -- ── LSP semantic tokens ────────────────────────────────────────────
  hi("@lsp.type.keyword",    { link = "@keyword" })
  hi("@lsp.type.string",     { link = "@string" })
  hi("@lsp.type.comment",    { link = "@comment" })
  hi("@lsp.type.variable",   { link = "@variable" })
  hi("@lsp.type.function",   { link = "@function" })
  hi("@lsp.type.method",     { link = "@method" })
  hi("@lsp.type.parameter",  { link = "@parameter" })
  hi("@lsp.type.type",       { link = "@type" })
  hi("@lsp.type.class",      { link = "@type" })
  hi("@lsp.type.interface",  { link = "@type" })
  hi("@lsp.type.namespace",  { link = "@namespace" })
  hi("@lsp.type.property",   { link = "@property" })
  hi("@lsp.type.number",     { link = "@number" })
  hi("@lsp.type.operator",   { link = "@operator" })

  -- ── Diff ───────────────────────────────────────────────────────────
  hi("DiffAdd",    { fg = c.hint,    bg = "#0a1a0a" })
  hi("DiffChange", { fg = c.warning, bg = "#1a1209" })
  hi("DiffDelete", { fg = c.error,   bg = c.diff_del_bg })
  hi("DiffText",   { fg = c.fg,      bg = "#1a1209" })
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 88 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/highlights.lua tests/run.lua
git commit -m "feat: implement LSP, diagnostic, and diff highlight groups"
```

---

## Task 7: Telescope Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/telescope.lua`

- [ ] **Step 1: Add telescope group tests to `tests/run.lua`**

Add after LSP tests:

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, telescope groups not set.

- [ ] **Step 3: Replace `lua/earthcode/integrations/telescope.lua` with implementation**

```lua
local M = {}

function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("TelescopeBorder",         { fg = c.ui_mid,    bg = c.bg })
  hi("TelescopeNormal",         { fg = c.fg,        bg = c.bg })
  hi("TelescopePromptNormal",   { fg = c.fg,        bg = c.cursorline })
  hi("TelescopePromptBorder",   { fg = c.cursorline, bg = c.cursorline })
  hi("TelescopePromptTitle",    { fg = c.bg,        bg = c.keyword })
  hi("TelescopeResultsBorder",  { fg = c.ui_dark,   bg = c.bg })
  hi("TelescopeResultsTitle",   { fg = c.comment })
  hi("TelescopePreviewBorder",  { fg = c.ui_dark,   bg = c.bg })
  hi("TelescopePreviewTitle",   { fg = c.bg,        bg = c.hint })
  hi("TelescopeSelection",      { bg = c.cursorline })
  hi("TelescopeSelectionCaret", { fg = c.keyword,   bg = c.cursorline })
  hi("TelescopeMatching",       { fg = c.warning,   bold = true })
end

return M
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 100 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/integrations/telescope.lua tests/run.lua
git commit -m "feat: implement telescope integration"
```

---

## Task 8: Lualine Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/lualine.lua`

- [ ] **Step 1: Add lualine theme tests to `tests/run.lua`**

Lualine sets its own highlight groups via its plugin — we test the shape of the theme table instead:

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1, `lualine.theme() not found` or missing keys.

- [ ] **Step 3: Replace `lua/earthcode/integrations/lualine.lua` with implementation**

```lua
local M = {}

-- Returns a lualine theme table.
-- Usage in your lualine config:
--   require("lualine").setup({ theme = require("earthcode.integrations.lualine").theme() })
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
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 118 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/integrations/lualine.lua tests/run.lua
git commit -m "feat: implement lualine theme integration"
```

---

## Task 9: Bufferline Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/bufferline.lua`

- [ ] **Step 1: Add bufferline group tests to `tests/run.lua`**

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1.

- [ ] **Step 3: Replace `lua/earthcode/integrations/bufferline.lua` with implementation**

```lua
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
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 128 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/integrations/bufferline.lua tests/run.lua
git commit -m "feat: implement bufferline integration"
```

---

## Task 10: nvim-tree Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/nvim_tree.lua`

- [ ] **Step 1: Add nvim-tree group tests to `tests/run.lua`**

```lua
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
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1.

- [ ] **Step 3: Replace `lua/earthcode/integrations/nvim_tree.lua` with implementation**

```lua
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
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 140 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/integrations/nvim_tree.lua tests/run.lua
git commit -m "feat: implement nvim-tree integration"
```

---

## Task 11: Gitsigns Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/gitsigns.lua`

- [ ] **Step 1: Add gitsigns group tests to `tests/run.lua`**

```lua
-- gitsigns
local gitsigns_groups = {
  "GitSignsAdd", "GitSignsChange", "GitSignsDelete",
  "GitSignsAddNr", "GitSignsChangeNr", "GitSignsDeleteNr",
  "GitSignsAddLn", "GitSignsChangeLn", "GitSignsDeleteLn",
}
for _, name in ipairs(gitsigns_groups) do
  assert_hl_set(name)
end
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1.

- [ ] **Step 3: Replace `lua/earthcode/integrations/gitsigns.lua` with implementation**

```lua
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
  hi("GitSignsAddLn",    { fg = c.hint,    bg = "#0a1a0a" })
  hi("GitSignsChangeLn", { fg = c.warning, bg = "#1a1209" })
  hi("GitSignsDeleteLn", { fg = c.error,   bg = c.diff_del_bg })
end

return M
```

- [ ] **Step 4: Run to verify tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 149 tests passed.`

- [ ] **Step 5: Commit**

```bash
git add lua/earthcode/integrations/gitsigns.lua tests/run.lua
git commit -m "feat: implement gitsigns integration"
```

---

## Task 12: Indent-Blankline Integration

**Files:**
- Modify: `tests/run.lua`
- Modify: `lua/earthcode/integrations/indent_blankline.lua`

- [ ] **Step 1: Add ibl group tests to `tests/run.lua`**

```lua
-- indent-blankline (ibl v3)
local ibl_groups = { "IblIndent", "IblScope" }
for _, name in ipairs(ibl_groups) do
  assert_hl_set(name)
end
```

- [ ] **Step 2: Run to verify it fails**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: exit code 1.

- [ ] **Step 3: Replace `lua/earthcode/integrations/indent_blankline.lua` with implementation**

```lua
local M = {}

-- Targets indent-blankline v3 API (IblIndent / IblScope).
-- v2 groups (IndentBlanklineChar, IndentBlanklineContextChar) are not set.
function M.load(c)
  local function hi(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hi("IblIndent", { fg = c.ui_dark })
  hi("IblScope",  { fg = c.ui_mid })
end

return M
```

- [ ] **Step 4: Run to verify all tests pass**

```bash
nvim --headless -u tests/minimal_init.lua -c "luafile tests/run.lua" 2>&1
```

Expected: `All 151 tests passed.`

- [ ] **Step 5: Final commit**

```bash
git add lua/earthcode/integrations/indent_blankline.lua tests/run.lua
git commit -m "feat: implement indent-blankline integration"
```
