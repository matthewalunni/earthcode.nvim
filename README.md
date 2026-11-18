# earthcode.nvim

A dark Neovim colorscheme built on an earth-tone palette.

<!-- Screenshot: replace this comment with an actual image once available -->

## About

earthcode.nvim is a pure-Lua Neovim colorscheme with a black primary background and earth-tone syntax colors. No bright primaries. No runtime dependencies.

### Palette

#### Base Colors

| Role | Hex | Description |
|---|---|---|
| Background | `#000000` | Black — main editor background |
| Cursor line | `#111111` | Neutral dark |
| Visual / border / float bg | `#414833` | Ebony |
| Diff delete bg | `#3d1418` | Dark red |
| Diff add bg | `#1a2a1a` | Dark forest |
| Diff change bg | `#262014` | Dark amber |
| Diff changed-text bg | `#4a3a1e` | Amber |
| UI chrome dark | `#333d29` | Charcoal Brown |
| UI chrome mid | `#414833` | Ebony |
| Foreground / identifiers | `#c2c5aa` | Dry Sage (light) |
| Functions / methods | `#dcb872` | Goldenrod |
| Keywords | `#be8b58` | Toffee Brown |
| Strings | `#a8b878` | Olive Green |
| Types / classes / constants / numbers | `#8fb3a0` | Lichen |
| Parameters | `#a4ac86` | Dry Sage (mid) |
| Punctuation / operators | `#af6d32` | Saddle Brown |
| Comments | `#7f895c` | Dusty Olive |

#### Accent Colors

| Role | Hex | Description |
|---|---|---|
| Error | `#ba5a5a` | Muted brick red |
| Warning | `#b5803a` | Warm amber |
| Hint / info | `#7e9d7e` | Forest green |

## Features

- Pure Lua, no runtime dependencies
- Requires Neovim 0.9+
- Treesitter highlight groups (`@` namespace)
- LSP semantic token groups (`@lsp.type.*`)
- Diagnostic highlights — error, warn, info, hint (virtual text + underline)
- 6 plugin integrations: telescope.nvim, lualine.nvim, bufferline.nvim, nvim-tree.lua, gitsigns.nvim, indent-blankline.nvim (v3)

## Installation

<details>
<summary>lazy.nvim</summary>

```lua
{
  "matthewalunni/earthcode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("earthcode")
  end,
}
```

</details>

<details>
<summary>packer.nvim</summary>

```lua
use {
  "matthewalunni/earthcode.nvim",
  config = function()
    vim.cmd.colorscheme("earthcode")
  end,
}
```

</details>

<details>
<summary>vim-plug</summary>

```vim
Plug 'matthewalunni/earthcode.nvim'
```

Then in your config:

```vim
colorscheme earthcode
```

</details>

All integrations except lualine load automatically when the colorscheme is set.

## Integrations

The following integrations load automatically — no additional config required:

- **telescope.nvim**
- **bufferline.nvim**
- **nvim-tree.lua**
- **gitsigns.nvim**
- **indent-blankline.nvim** (v3)

### lualine.nvim

lualine manages its own highlight groups and requires manual wiring:

```lua
require("lualine").setup({
  options = {
    theme = require("earthcode.integrations.lualine").theme()
  }
})
```

Call `theme()` after the colorscheme is loaded.

## License

MIT
