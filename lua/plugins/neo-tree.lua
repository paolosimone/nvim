return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    enable_cursor_hijack = true,
    close_if_last_window = true,
    use_libuv_file_watcher = true,
    enabled = true,          -- Focuses the file in the tree every time you switch buffers
    leave_dirs_open = false, -- Closes directories that auto-expanded when leaving them

    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = { "toggle_node", nowait = true },
      }
    }
  }
}
