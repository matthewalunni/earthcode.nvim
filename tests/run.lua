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

-- ── report ───────────────────────────────────────────────────────────
if #failures > 0 then
  for _, msg in ipairs(failures) do print(msg) end
  print(string.format("\n%d passed, %d failed", passes, #failures))
  vim.cmd("cq 1")
else
  print(string.format("All %d tests passed.", passes))
  vim.cmd("q!")
end
