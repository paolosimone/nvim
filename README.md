# nvim

Personal Neovim configuration, built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Install

```sh
git clone https://github.com/paolosimone/nvim ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself and installs the plugins on first launch.

## Structure

- `init.lua` – entry point: loads keymaps, options, then lazy.nvim
- `lua/config/` – `keymaps.lua`, `options.lua`, `lazy.lua` (plugin manager bootstrap)
- `lua/plugins/` – one spec file per plugin, auto-imported by lazy.nvim
- `lazy-lock.json` – pinned plugin versions

## Plugins

| Plugin        | Purpose                                  |
|---------------|------------------------------------------|
| catppuccin    | Color scheme                             |
| blink.cmp     | Autocompletion                           |
| fugitive      | Git commands inside Neovim               |
| gitsigns      | Git change signs in the gutter           |
| guess-indent  | Automatic indentation detection          |
| lspconfig     | Language server configuration            |
| mason         | Install and manage LSP servers and tools |
| neo-tree      | File explorer sidebar                    |
| telescope     | Fuzzy finder for files, text and more    |
| window-picker | Pick a window by letter                  |

The leader key is `<Space>`.
