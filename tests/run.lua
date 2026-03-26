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
