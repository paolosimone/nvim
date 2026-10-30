-- Editable quickfix: edit the text in the quickfix buffer and `:w` to apply the
-- changes to the real files. Find & replace workflow with Telescope:
--   1. telescope live grep and type the search
--   2. telescope send all results to quickfix list
--   3. In the quickfix window edit the lines, e.g. `:%s/old/new/g`, then `:w`
return {
  "stevearc/quicker.nvim",
  event = "FileType qf", -- load when a quickfix/location list opens
  keys = {
    -- Toggle the quickfix list
    { "<leader>qq", function() require("quicker").toggle() end, desc = "Quickfix: toggle" },
    -- Navigate entries from any window (`:cnext` errors at the ends, so wrap with pcall)
    { "]q", function() if not pcall(vim.cmd, "cnext") then vim.cmd("cfirst") end end, desc = "Quickfix: next entry" },
    { "[q", function() if not pcall(vim.cmd, "cprevious") then vim.cmd("clast") end end, desc = "Quickfix: previous entry" },
  },
  opts = {
    keys = {
      -- Open the entry under the cursor (<CR> already opens it in the previous window)
      { "<leader>qS", "<C-w><CR>", desc = "Quickfix: open in horizontal split" }, -- <C-w><CR> splits and jumps to the entry
      { "<leader>qs", "<C-w><CR><C-w>H", desc = "Quickfix: open in vertical split" }, -- <C-w>H moves the new window to the far left
      { "<leader>qt", "<C-w><CR><C-w>T", desc = "Quickfix: open in new tab" }, -- <C-w>T moves the new window to its own tab
      -- Expand/collapse N lines of context around each result
      { ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Quickfix: expand context" },
      { "<", function() require("quicker").collapse() end, desc = "Quickfix: collapse context" },
    },
  },
}
