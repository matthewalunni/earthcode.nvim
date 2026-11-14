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
M.fg          = "#c2c5aa"  -- Dry Sage (light) — main text, identifiers, functions
M.keyword     = "#be8b58"  -- Toffee Brown (lightened for 7:1 contrast) — keywords
M.string      = "#a68a64"  -- Camel — strings
M.type        = "#b6ad90"  -- Khaki Beige — types, constants, numbers
M.parameter   = "#a4ac86"  -- Dry Sage (mid) — parameters
M.punctuation = "#af6d32"  -- Saddle Brown (lightened for 5:1 contrast) — punctuation, operators
M.comment     = "#727b53"  -- Dusty Olive (lightened for 4.6:1 contrast) — comments

-- Accent colors (outside base palette)
M.error       = "#ba5a5a"  -- Muted brick red (lightened for 4.7:1 contrast)
M.warning     = "#b5803a"  -- Warm amber
M.hint        = "#6b8c6b"  -- Forest green

return M
