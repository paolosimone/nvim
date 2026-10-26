return {
  "kylechui/nvim-surround",
  -- Load lazily on first buffer open
  event = "VeryLazy",
  -- Defaults: ys{motion}{char} add, ds{char} delete, cs{old}{new} change
  -- (e.g. ysiw" wraps word, cs"' swaps quotes, ds( removes parens);
  -- S{char} in visual mode surrounds the selection
  opts = {},
}
