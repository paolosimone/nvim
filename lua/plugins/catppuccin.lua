return {
 "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins
  opts = {
    flavour = "mocha",
  },
  init = function()
    vim.cmd.colorscheme("catppuccin-mocha")
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#b4befe", bg = "NONE" })
  end,
}
