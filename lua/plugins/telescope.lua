return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x", -- stable release branch
  dependencies = {
    "nvim-lua/plenary.nvim", -- required utility library
    {
      -- Native C implementation of the fzf sorter: much faster fuzzy matching.
      -- Needs `make` to compile; `cond` skips it if make is unavailable.
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    -- Makes vim.ui.select (e.g. LSP code actions) use a Telescope dropdown.
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons", -- file icons in results
  },

  -- Lazy-load on first use of any of these keys (`desc` shows up in which-key / :map).
  -- Live grep and file search rely on ripgrep (`rg`) being installed.
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fa", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end, desc = "Find all files (hidden + ignored)" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep in project" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, mode = { "n", "v" }, desc = "Grep word under cursor / selection" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Open buffers" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
    { "<leader>fu", function() require("telescope.builtin").resume() end, desc = "Resume last picker" },
    { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Commands" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols (LSP)" },
    { "<leader>fS", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols (LSP)" },
    { "<leader>fm", function() require("telescope.builtin").marks() end, desc = "Marks" },
    { "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "Open buffers" },
    { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy find in current buffer" },
  },

  -- Using `config` (not `opts`) because we must call load_extension after setup.
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "  ", -- icon shown before the search input
        selection_caret = "> ", -- marker for the highlighted result
        entry_prefix = "  ", -- padding for non-selected rows; must be the same width as selection_caret or rows shift
        path_display = { "truncate" }, -- shorten long paths with "..." instead of overflowing
        sorting_strategy = "ascending", -- best match at the top, next to the prompt
        layout_config = {
          prompt_position = "top", -- prompt at the top (pairs with ascending sorting)
          horizontal = { preview_width = 0.55 },
        },
        file_ignore_patterns = {
          "^.git/",
          "node_modules/",
          "%.lock$",
          ".venv/",
        }, -- never list these (Lua patterns)

        -- ripgrep arguments used by live_grep / grep_string
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case", -- case-insensitive unless the query has capitals
          "--hidden", -- search dotfiles too...
          "--glob=!.git/", -- ...but skip the .git directory
        },

        -- Keymaps active inside the Telescope prompt
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next, -- same hjkl feel as window navigation
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next, -- browse previous searches
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist, -- send results to quickfix list
            ["<C-s>"] = actions.select_vertical, -- open selection in a vertical split
            ["<C-x>"] = actions.select_horizontal, -- open selection in a horizontal split
            ["<C-u>"] = false, -- free <C-u> so it clears the prompt instead of scrolling the preview
          },
          n = {
            ["q"] = actions.close, -- quit quickly
            ["s"] = actions.select_vertical,
            ["S"] = actions.select_horizontal,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true, -- include dotfiles in file search
        },

        buffers = {
          sort_mru = true, -- most recently used first
          ignore_current_buffer = true, -- don't list the buffer you're already in
          mappings = {
            -- close a buffer from the list (Tab for selection)
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["d"] = actions.delete_buffer },
          },
        },
      },

      extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown(), -- compact dropdown look
      },
    })

    -- Extensions must be loaded explicitly; pcall avoids errors if fzf-native isn't built.
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
