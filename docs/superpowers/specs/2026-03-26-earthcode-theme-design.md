# earthcode.nvim — Theme Design Spec

**Date:** 2026-03-26

## Overview

A pure-Lua Neovim colorscheme built around an earth-tone palette with black as the primary background. No runtime dependencies. Full support for core Neovim, Treesitter, LSP diagnostics, and six plugin integrations.

---

## Color Palette

### Base Palette

| Role | Hex | Name |
|---|---|---|
| `bg` | `#000000` | Black — main editor background |
| `cursorline` | `#111111` | Neutral dark — no hue conflict with syntax |
| `visual` / border / float bg | `#414833` | Ebony |
| `diff_delete` bg | `#582f0e` | Dark Walnut |
| UI chrome (statusline, indent lines) | `#333d29` / `#414833` | Charcoal Brown / Ebony |
| `fg` / identifiers / functions | `#c2c5aa` | Dry Sage (light) |
| keywords | `#936639` | Toffee Brown |
| strings | `#a68a64` | Camel |
| types / classes / constants / numbers | `#b6ad90` | Khaki Beige |
| parameters | `#a4ac86` | Dry Sage (mid) |
| punctuation / operators | `#7f4f24` | Saddle Brown |
| comments | `#656d4a` | Dusty Olive |

### Accent Colors (outside base palette)

These three colors are introduced to handle diagnostic and diff roles that need clear semantic meaning without breaking the earthy mood.

| Role | Hex | Character |
|---|---|---|
| error / `diff_delete` fg | `#8b3a3a` | Muted brick red |
| warning / `diff_change` | `#b5803a` | Warm amber |
| hint / info / `diff_add` | `#6b8c6b` | Forest green |

---

## File Structure

```
earthcode.nvim/
├── colors/
│   └── earthcode.lua              ← entry point: sets background=dark, calls load()
├── lua/
│   └── earthcode/
│       ├── init.lua               ← load(): orchestrates all highlight calls
│       ├── palette.lua            ← all color constants, single source of truth
│       ├── highlights.lua         ← base, syntax, treesitter, LSP, diff groups
│       └── integrations/
│           ├── telescope.lua
│           ├── lualine.lua
│           ├── bufferline.lua
│           ├── nvim_tree.lua
│           ├── gitsigns.lua
│           └── indent_blankline.lua
└── README.md
```

Each integration file exports a single function `M.load(c)` where `c` is the palette table. No global state.

---

## Highlight Groups

### Tier 1 — Base UI

`Normal`, `NormalFloat`, `NormalNC`, `CursorLine`, `Visual`, `Search`, `IncSearch`, `StatusLine`, `StatusLineNC`, `WinSeparator`, `LineNr`, `CursorLineNr`, `SignColumn`, `Pmenu`, `PmenuSel`, `PmenuSbar`, `PmenuThumb`, `Folded`, `VertSplit`, `TabLine`, `TabLineSel`, `TabLineFill`

### Tier 2 — Syntax + Treesitter

Legacy vim groups (`Keyword`, `String`, `Comment`, `Identifier`, `Function`, `Type`, `Constant`, `Number`, `Boolean`, `Operator`, `Delimiter`, `Special`) plus Treesitter `@` groups (`@keyword`, `@string`, `@type`, `@variable`, `@function`, `@parameter`, `@comment`, `@operator`, `@punctuation`, etc.) linked so both legacy and Treesitter parsers produce correct colors.

### Tier 3 — LSP + Diagnostics + Diff

`DiagnosticError`, `DiagnosticWarn`, `DiagnosticInfo`, `DiagnosticHint`, `DiagnosticUnderlineError/Warn/Info/Hint`, `LspReferenceText/Read/Write`, `@lsp.type.*` semantic token groups, `DiffAdd`, `DiffChange`, `DiffDelete`, `DiffText`

---

## Integrations

### telescope.nvim
Groups: `TelescopeBorder`, `TelescopeSelection`, `TelescopeSelectionCaret`, `TelescopePromptNormal`, `TelescopePromptBorder`, `TelescopeResultsBorder`, `TelescopePreviewBorder`, `TelescopeMatching`

### lualine.nvim
Returns a lualine theme table with mode sections (normal, insert, visual, replace, command) using palette colors. Normal mode uses `#936639`/`#000000`, insert uses `#6b8c6b`/`#000000`, visual uses `#a68a64`/`#000000`.

### bufferline.nvim
Groups: `BufferLineFill`, `BufferLineBackground`, `BufferLineSelected`, `BufferLineModified`, `BufferLineSeparator`, `BufferLineIndicatorSelected`

### nvim-tree.lua
Groups: `NvimTreeNormal`, `NvimTreeEndOfBuffer`, `NvimTreeFolderIcon`, `NvimTreeFolderName`, `NvimTreeOpenedFolderName`, `NvimTreeRootFolder`, `NvimTreeGitDirty`, `NvimTreeGitNew`, `NvimTreeGitDeleted`, `NvimTreeSpecialFile`, `NvimTreeIndentMarker`

### gitsigns.nvim
Sign column: `GitSignsAdd` → `#6b8c6b`, `GitSignsChange` → `#b5803a`, `GitSignsDelete` → `#8b3a3a`. Line highlight variants (`GitSignsAddLn`, `GitSignsChangeLn`) use blended background colors (`#0a1a0a` for add, `#1a1209` for change) with the same fg colors.

### indent-blankline.nvim (v3)
Targets ibl v3 API: `IblIndent` → `#333d29`, `IblScope` → `#414833`. Legacy v2 groups (`IndentBlanklineChar`, `IndentBlanklineContextChar`) are not set.

---

## Implementation Notes

- `palette.lua` is the single source of truth — all other files receive the palette table, never hardcode hex values
- `highlights.lua` uses `vim.api.nvim_set_hl(0, name, opts)` directly, no abstractions
- `init.lua` calls each integration's `load(c)` unconditionally (no feature flags for now)
- `colors/earthcode.lua` sets `vim.g.colors_name = "earthcode"` and `vim.o.background = "dark"` before calling `require("earthcode").load()`
