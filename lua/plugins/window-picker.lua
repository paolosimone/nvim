return {
  "s1n7ax/nvim-window-picker",
  lazy = true,
  opts = {
    filter_rules = {
      include_current_win = false,
      autoselect_one = true,
      -- bo = {
      --   filetype = { "neo-tree", "neo-tree-popup", "notify" },
      --   buftype = { "terminal", "quickfix" },
      -- },
    },
    highlights = {
      statusline = {
        focused = { fg = "#1e1e2e", bg = "#89b4fa", bold = true },
        unfocused = { fg = "#1e1e2e", bg = "#6c7086", bold = true },
      },
      winbar = {
        focused = { fg = "#1e1e2e", bg = "#89b4fa", bold = true },
        unfocused = { fg = "#1e1e2e", bg = "#6c7086", bold = true },
      },
    },
  },
}
