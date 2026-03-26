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
