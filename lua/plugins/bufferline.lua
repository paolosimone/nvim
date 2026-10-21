return {
  -- bufferline.nvim: a tab line. In "tabs" mode it lists Neovim tab pages
  -- (not buffers), so each tab shows up as one entry.
  "akinsho/bufferline.nvim",
  version = "*", -- use release tags
  dependencies = { "catppuccin" }, -- needed to load the theme highlights below
  event = "VeryLazy",

  -- Keymaps live here because they are specific to this plugin's tab handling.
  keys = {
    { "<M-]>", "<cmd>tabnext<CR>", desc = "Next tab" },
    { "<M-[>", "<cmd>tabprevious<CR>", desc = "Previous tab" },
    { "<M-t>", "<cmd>tabnew<CR>", desc = "New tab" },
    { "<leader>tt", "<cmd>tabclose<CR>", desc = "Close tab" },
    { "<leader>to", "<cmd>tabonly<CR>", desc = "Close other tabs" },
    { "<leader>t>", "<cmd>tabmove +1<CR>", desc = "Move tab right" },
    { "<leader>t<", "<cmd>tabmove -1<CR>", desc = "Move tab left" },
    { "<leader>tp", "<cmd>BufferLinePick<CR>", desc = "Pick tab by letter" },

    -- <M-1..9> jump straight to the n-th tab
    unpack((function()
      local jumps = {}
      for i = 1, 9 do
        jumps[i] = { "<M-" .. i .. ">", i .. "gt", desc = "Go to tab " .. i }
      end
      return jumps
    end)()),
  },

  opts = function()
    return {
      options = {
        mode = "tabs", -- show tab pages instead of buffers
        numbers = "ordinal", -- show the position, matching <leader>1..9
        diagnostics = "nvim_lsp", -- show LSP error/warning counts per tab
        always_show_bufferline = false, -- hide the bar while only one tab is open
        show_close_icon = false, -- hide the global close button on the right
        show_buffer_close_icons = false, -- hide per-tab close buttons (use <leader>tc)
        separator_style = "thin",
        offsets = {
          -- keep the tab line clear of the file explorer sidebar
          { filetype = "neo-tree", text = "File Explorer", highlight = "Directory", text_align = "left" },
        },
      },
      -- match the catppuccin colorscheme
      highlights = require("catppuccin.special.bufferline").get_theme(),
    }
  end,
}
