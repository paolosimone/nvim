return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins
  opts = {
    flavour = "mocha",
  },
  init = function()
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
