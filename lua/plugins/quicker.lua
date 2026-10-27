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
    { "<leader>q", function() require("quicker").toggle() end, desc = "Quickfix: toggle" },
  },
  opts = {
    keys = {
      -- Expand/collapse N lines of context around each result
      { ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end, desc = "Quickfix: expand context" },
      { "<", function() require("quicker").collapse() end, desc = "Quickfix: collapse context" },
    },
  },
}
