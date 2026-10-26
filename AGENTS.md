# AGENTS.md

Neovim configuration written in Lua, managed with lazy.nvim.

## Layout

- `init.lua`: requires `config.keymaps`, `config.options`, `config.lazy` (in this order; the leader key is set in keymaps before lazy loads).
- `lua/config/`: global keymaps, options, lazy.nvim bootstrap.
- `lua/plugins/<name>.lua`: one file per plugin, each returning a lazy.nvim spec. Files are auto-imported via `{ import = "plugins" }`; no manual registration needed.
- `lazy-lock.json`: managed by lazy.nvim; don't edit by hand.

## Conventions

- Keep the config minimal
- Add a new plugin by creating a new file in `lua/plugins/`.
- Global keymaps go in `config/keymaps.lua`; plugin-specific keymaps stay in that plugin's spec.
- Use 2-space indentation and short inline comments, matching existing files.
- Every new addition (plugin, option, keymap, autocmd, etc.) must be commented and explained; the owner uses this config to learn.
- Keymap `desc` must start with the context, e.g. `"Tab: next"`, `"Git: stage buffer"` (existing: Window, Tab, File, Edit, Terminal, Diff, Git, Find, Code, Markdown), so they read well in Telescope's keymaps list.
- Git tools: always show commit timestamps as absolute dates, never relative to now (e.g. "2 days ago").
- Keep plugins list in README.md up-to-date
- Markdown tables: pad cells so columns and separator rows are aligned.
- Markdown files must be readable without wrapping lines: keep prose lines around 80 characters long (tables and code blocks excepted).

## Validation

No test suite. Check that the config loads cleanly:

```sh
nvim --headless "+Lazy! sync" +qa
nvim --headless +checkhealth +qa
```
