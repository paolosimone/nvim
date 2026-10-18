return {
  -- blink.cmp: autocompletion engine. It consumes completion items from LSP
  -- servers (plus path, snippets and buffer words) and shows them in a popup.
  "saghen/blink.cmp",
  version = "1.*", -- use release tags so a prebuilt fuzzy-matching binary is downloaded
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module 'blink.cmp'
  opts = {
    -- "default": <C-space> open menu, <C-n>/<C-p> select, <C-y> accept, <C-e> close.
    keymap = { preset = "default" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = { documentation = { auto_show = true } },
  },
}
