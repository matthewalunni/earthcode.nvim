local M = {}

-- Backgrounds
M.bg          = "#000000"  -- Black — main editor background
M.cursorline  = "#111111"  -- Neutral dark — no hue conflict with syntax
M.visual      = "#414833"  -- Ebony — visual selection
M.float_bg    = "#414833"  -- Ebony — float window background (same hue as visual by design)
M.diff_del_bg = "#582f0e"  -- Dark Walnut — diff delete background
M.diff_add_bg = "#0a1a0a"  -- Blended dark green — diff add background
M.diff_chg_bg = "#1a1209"  -- Blended dark amber — diff change background
M.ui_dark     = "#333d29"  -- Charcoal Brown — statusline, indent lines
M.code_bg     = "#111111"  -- Near black — code block background
M.ui_mid      = "#414833"  -- Ebony — separators, context indent (same hue as visual by design)

-- Foreground / syntax
M.fg          = "#c2c5aa"  -- Dry Sage (light) — main text, identifiers
M.func        = "#dcb872"  -- Goldenrod — functions and methods
M.keyword     = "#be8b58"  -- Toffee Brown (lightened for 7:1 contrast) — keywords
M.string      = "#a8b878"  -- Olive Green — strings
M.type        = "#8fb3a0"  -- Lichen — types, constants, numbers
M.parameter   = "#a4ac86"  -- Dry Sage (mid) — parameters
M.punctuation = "#af6d32"  -- Saddle Brown (lightened for 5:1 contrast) — punctuation, operators
M.comment     = "#7f895c"  -- Dusty Olive (lightened for 5.5:1 contrast) — comments

-- Accent colors (outside base palette)
M.error       = "#ba5a5a"  -- Muted brick red (lightened for 4.7:1 contrast)
M.warning     = "#b5803a"  -- Warm amber
M.hint        = "#7e9d7e"  -- Forest green (lightened for 7:1 contrast)

return M
