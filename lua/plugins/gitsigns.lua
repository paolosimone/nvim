return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    current_line_blame = false, -- toggle with <leader>gb
    current_line_blame_opts = { delay = 300 },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d %H:%M> - <summary>",
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Hunk navigation (falls back to native diff motions in diff mode)
      map("n", "<leader>gn", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
      end, "Git next hunk")
      map("n", "<leader>gN", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
      end, "Git previous hunk")

      -- Hunk actions
      map("n", "<leader>ga", gs.stage_hunk, "Git stage/unstage hunk")
      map("v", "<leader>ga", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git stage/unstage selection")
      map("n", "<leader>gr", gs.reset_hunk, "Git reset hunk")
      map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git reset selection")
      map("n", "<leader>gA", gs.stage_buffer, "Git stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Git reset buffer")
      map("n", "<leader>gk", gs.preview_hunk, "Git preview hunk")
      map("n", "<leader>gb", gs.toggle_current_line_blame, "Git toggle line blame")
    end,
  },
}
