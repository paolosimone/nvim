return {
  -- multicursor.nvim: edit several places at once with multiple cursors.
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  -- config runs after load; setup() must be called before using the cursor API
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip a cursor on the line above/below (n = normal, x = visual)
    set({ "n", "x" }, "<M-C-k>", function() mc.lineAddCursor(-1) end, { desc = "Edit: add cursor above" })
    set({ "n", "x" }, "<M-C-j>", function() mc.lineAddCursor(1) end, { desc = "Edit: add cursor below" })

    -- Add a cursor on the next/previous match of the word under cursor (or selection)
    set({ "n", "x" }, "<M-d>", function() mc.matchAddCursor(1) end, { desc = "Edit: add cursor on next match" })
    set({ "n", "x" }, "<M-S-d>", function() mc.matchAddCursor(-1) end, { desc = "Edit: add cursor on previous match" })

    -- Add a cursor to every match of the word/selection in the buffer
    set({ "n", "x" }, "<leader>dd", mc.matchAllAddCursors, { desc = "Edit: add cursors on all matches" })

    -- Place cursors by hand: first press drops a cursor here and freezes all cursors, so you can
    -- move around freely; press again elsewhere to drop another; <Esc> re-enables them to edit together.
    -- Pressing it on an existing cursor removes it.
    set({ "n", "x" }, "<leader>da", mc.toggleCursor, { desc = "Edit: toggle cursor" })

    -- Keymaps only active while multiple cursors exist
    mc.addKeymapLayer(function(layerSet)
      -- Cycle through cursors
      layerSet({ "n", "x" }, "<leader>dh", mc.prevCursor, { desc = "Edit: previous cursor" })
      layerSet({ "n", "x" }, "<leader>dl", mc.nextCursor, { desc = "Edit: next cursor" })

      -- Delete the current cursor
      layerSet({ "n", "x" }, "<leader>dx", mc.deleteCursor, { desc = "Edit: delete cursor" })

      -- <Esc>: re-enable cursors if disabled, otherwise clear them all
      layerSet("n", "<Esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Edit: clear cursors" })
    end)

    -- Highlight groups for cursors, linked to existing ones so they follow the colorscheme
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
