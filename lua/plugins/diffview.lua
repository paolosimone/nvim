return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },

  keys = {
    -- Working tree vs index; during a merge/rebase the panel lists conflicted files with a 3-way merge view
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git: diff view (changes / merge conflicts)" },
    { "<leader>gD", "<cmd>DiffviewOpen master<CR>", desc = "Git: diff view vs master" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git: history of current file" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Git: history of repo" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Git: close diff view" },
  },

  -- `config` (not `opts` alone) because we also define a highlight after setup
  config = function(_, opts)
    require("diffview").setup(opts)

    -- The history panel hardcodes relative dates for recent commits and has no option to change it,
    -- so show every commit's absolute date, to the minute, in local time (iso_date is also used for old commits).
    -- Diffview stores time shifted by the commit's tz offset, so add it back to get the real epoch.
    local GitCommit = require("diffview.vcs.adapters.git.commit").GitCommit
    local init = GitCommit.init
    GitCommit.init = function(self, opt)
      init(self, opt)
      self.iso_date = os.date("%Y-%m-%d %H:%M", self.time + self.time_offset)
      self.rel_date = self.iso_date
    end

    -- Filler lines (where the other side has extra lines) get a subtle background shade instead of dashes;
    -- re-applied on ColorScheme since colorschemes reset highlights
    local function set_filler_hl()
      vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { link = "CursorLine" })
    end
    set_filler_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_filler_hl })
  end,

  opts = {
    hooks = {
      -- Blank out the filler character (default "-") in diff windows
      diff_buf_win_enter = function(bufnr, winid, ctx)
        vim.wo[winid].fillchars = "diff: "

        -- Added files have an empty "null" buffer on the left: collapse that window so only the right side shows.
        -- Closing it would make diffview rebuild the layout, so shrink it instead (and restore it for other files).
        if ctx.symbol == "a" and ctx.layout_name:match("^diff2") then
          local is_null = vim.api.nvim_buf_get_name(bufnr) == "diffview://null"
          vim.wo[winid].winfixwidth = is_null
          if is_null then
            vim.api.nvim_win_set_width(winid, 1)
          else
            vim.cmd("wincmd =")
          end
        end
      end,
    },
    enhanced_diff_hl = true, -- better highlighting of changed words within lines
    keymaps = {
      -- File panel staging
      file_panel = {
        { "n", "a", function() require("diffview.actions").toggle_stage_entry() end, { desc = "Git: stage / unstage file" } },
        -- Visual mode: stage / unstage every file or directory in the selected lines
        -- (the default action only looks at the cursor line and ignores the selection)
        {
          "x",
          "a",
          function()
            local view = require("diffview.lib").get_current_view()
            local panel = view.panel
            local first, last = vim.fn.line("v"), vim.fn.line(".")
            if first > last then first, last = last, first end

            -- Collect paths per kind: unstaged ("working"/"conflicting") are added, "staged" are reset
            local to_add, to_reset = {}, {}
            for line = first, last do
              local comp = panel.components.comp:get_comp_on_line(line)
              local item
              if comp and comp.name == "file" then
                item = comp.context
              elseif comp and comp.name == "dir_name" then
                item = comp.parent.context
              end
              if item then
                table.insert(item.kind == "staged" and to_reset or to_add, item.path)
              end
            end

            if #to_add > 0 then view.adapter:add_files(to_add) end
            if #to_reset > 0 then view.adapter:reset_files(to_reset) end

            vim.cmd("normal! \27") -- leave visual mode
            view:update_files()
          end,
          { desc = "Git: stage / unstage selected files" },
        },
        { "n", "A", function() require("diffview.actions").stage_all() end, { desc = "Git: stage all files" } },
        { "n", "U", function() require("diffview.actions").unstage_all() end, { desc = "Git: unstage all files" } },
        { "n", "r", function() require("diffview.actions").restore_entry() end, { desc = "Git: discard changes to file" } },
        { "n", "g?", function() require("diffview.actions").help("file_panel")() end, { desc = "Git: show keymap help" } },
        { "n", "t", function() require("diffview.actions").goto_file_tab() end, { desc = "Git: open file in previous tab" } },
      },
      file_history_panel = {
        { "n", "t", function() require("diffview.actions").goto_file_tab() end, { desc = "Git: open file in previous tab" } },
      },
      -- diff1 keymaps only apply to the single-buffer layout, i.e. the merge tool above;
      -- J/K navigate conflicts there, mirroring their hunk navigation in regular diffs
      diff1 = {
        { "n", "J", function() require("diffview.actions").next_conflict() end, { desc = "Git: next conflict" } },
        { "n", "K", function() require("diffview.actions").prev_conflict() end, { desc = "Git: previous conflict" } },
      },
    },
    view = {
      -- Merge conflicts: single editable buffer with highlighted conflict markers (VSCode style)
      -- instead of the 3-way split. Inside it: ]x / [x jump between conflicts,
      -- <leader>co = keep ours, <leader>ct = keep theirs, <leader>cb = keep both, <leader>ca = keep base, dx = delete both
      merge_tool = { layout = "diff1_plain" },
    },
  },
}
