return {
 "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins
  opts = {
    flavour = "mocha",
    -- Catppuccin's Visual is bold; drop the bold
    custom_highlights = function(colors)
      return {
        Visual = { bg = colors.surface1, style = {} },
      }
    end,
  },
  -- config (not init) so setup() runs with opts before the colorscheme is applied
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-mocha")
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#b4befe", bg = "NONE" })
  end,
}
