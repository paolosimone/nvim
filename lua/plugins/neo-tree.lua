return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false, -- neo-tree will lazily load itself

  opts = {
    -- Global
    enable_cursor_hijack = true,
    close_if_last_window = true,
    use_libuv_file_watcher = true,
    enabled = true,          -- Focuses the file in the tree every time you switch buffers
    leave_dirs_open = false, -- Closes directories that auto-expanded when leaving them

    sources = {
      "filesystem",
      "git_status",
    },

    source_selector = {
      winbar = false, -- toggle to show selector on winbar
      statusline = true, -- toggle to show selector on statusline

      sources = {
        { source = "filesystem" },
        { source = "git_status" },
      },
    },

    window = {
      width = 30,
      mappings = {
        ["?"] = "show_help",
        ["q"] = "close_window",
        ["<"] = "prev_source",
        [">"] = "next_source",

        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = { "toggle_node", nowait = true },
        ["z"] = "close_all_nodes",

        ["<cr>"] = {
          "toggle_preview",
          config = {
            use_float = true,
            use_snacks_image = true,
            use_image_nvim = true,
            title = "Preview",
          }
        },
        ["K"] = { "scroll_preview", config = {direction = 10} },
        ["J"] = { "scroll_preview", config = {direction = -10} },

        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",

        ["R"] = "refresh",
        ["<Tab>"] = "select",
        ["a"] = { "add", config = { show_path = "none" } }, -- "none", "relative", "absolute"
        ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
        ["d"] = "delete",
        ["r"] = "rename",
        ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options

        ["Y"] = "copy_to_clipboard", -- absolute_path
        ["y"] = function(state) -- relative_path
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local relative_path = vim.fn.fnamemodify(filepath, ":.")
          vim.fn.setreg("+", relative_path)
          vim.notify("Copied relative path: " .. relative_path)
        end,
      },
    },

    filesystem = {
      window = {
        mappings = {
          ["."] = "set_root",
          ["h"] = "navigate_up",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<esc>"] = "noop", -- use normal mode
          {
            -- normal mode mappings
            n = {
              ["j"] = "move_cursor_down",
              ["k"] = "move_cursor_up",
              ["<esc>"] = "close",
            }
          }
        },

        filtered_items = {
          visible = true,

          never_show_by_pattern = {
            --".null-ls_*",
          },
        }
      },
    },

    git_status = {
      window = {
        mappings = {
          ["a"] = "git_toggle_file_stage",
          ["A"] = "git_add_all",
          ["x"] = "git_revert_file",
          ["c"] = "git_commit",
          ["p"] = "git_pull",
          ["P"] = "git_push",
          ["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
        },
      },
    },
  },
}
