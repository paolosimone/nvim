return {
  -- blink.cmp: autocompletion engine. It consumes completion items from LSP
  -- servers (plus path, snippets and buffer words) and shows them in a popup.
  "saghen/blink.cmp",
  version = "1.*", -- use release tags so a prebuilt fuzzy-matching binary is downloaded
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module 'blink.cmp'
  opts = {
    -- Like the "default" preset, but with Meta (Alt) instead of Ctrl:
    keymap = {
      preset = "none",
      ["<M-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<M-n>"] = { "select_next", "fallback_to_mappings" },
      ["<M-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<tab>"] = { "select_and_accept", "fallback" },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = { documentation = { auto_show = true } },
  },
}
