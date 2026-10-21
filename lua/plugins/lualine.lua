return {
  -- lualine.nvim: a fast, configurable statusline (mode, branch, diff,
  -- diagnostics, filename, encoding, position...).
  "nvim-lualine/lualine.nvim",
  -- catppuccin: make sure the theme exists before lualine loads;
  -- nvim-web-devicons: provides the file type icons shown on tabs
  dependencies = { "catppuccin", "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",

  opts = function()
    -- Icon for special tabs, keyed by filetype or buftype (checked in this order)
    local special_icons = {
      terminal = "",
      help = "󰋖",
      fugitive = "",
      git = "",
      gitcommit = "",
      DiffviewFiles = "",
      DiffviewFileHistory = "",
      ["neo-tree"] = "",
    }

    -- Prefix a tab label with an icon based on its focused buffer.
    -- `tab` is lualine's tab object (it exposes filetype, buftype and file).
    -- File path of the focused buffer of the given tab page
    local function tab_file(tabnr)
      local buflist = vim.fn.tabpagebuflist(tabnr)
      return vim.api.nvim_buf_get_name(buflist[vim.fn.tabpagewinnr(tabnr)])
    end

    -- When several tabs show files with the same name, prepend the parent directory
    local function disambiguate(name, tab)
      if name ~= vim.fn.fnamemodify(tab.file, ":t") then return name end -- not a plain file label
      for i = 1, vim.fn.tabpagenr("$") do
        local other = tab_file(i)
        if i ~= tab.tabnr and other ~= "" and other ~= tab.file and vim.fn.fnamemodify(other, ":t") == name then
          return vim.fn.fnamemodify(tab.file, ":h:t") .. "/" .. name
        end
      end
      return name
    end

    local function tab_icon(name, tab)
      name = disambiguate(name, tab)
      local icon = special_icons[tab.filetype] or special_icons[tab.buftype]
      if not icon then
        local devicons = require("nvim-web-devicons")
        icon = devicons.get_icon(vim.fn.fnamemodify(tab.file, ":t"), vim.fn.fnamemodify(tab.file, ":e"), { default = true })
      end
      return icon .. " " .. name
    end

    -- Blame of the cursor line, read from the buffer variable gitsigns fills in.
    local function git_blame()
      local blame = vim.b.gitsigns_blame_line_dict
      if not blame then return "" end
      if not blame.author_time then return blame.author or "" end
      return string.format("%s, %s - %s", blame.author, os.date("%Y-%m-%d", blame.author_time), blame.summary or "")
    end

    -- Remote tracking state of the current branch, cached per directory because
    -- git is queried asynchronously (statusline functions must return instantly).
    -- Only compares with the last fetched remote state; it never fetches.
    local upstream_cache = {}
    local function update_upstream()
      local cwd = vim.fn.getcwd()
      vim.system(
        { "git", "rev-list", "--left-right", "--count", "@{upstream}...HEAD" },
        { cwd = cwd, text = true },
        function(res)
          local behind, ahead = (res.stdout or ""):match("(%d+)%s+(%d+)")
          -- a failure means no upstream is configured: the branch is local only
          upstream_cache[cwd] = res.code == 0 and { behind = tonumber(behind), ahead = tonumber(ahead) } or false
          vim.schedule(function() require("lualine").refresh() end)
        end
      )
    end
    -- re-check when entering a buffer, regaining focus, or after git/shell commands
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "ShellCmdPost", "TermClose", "User" }, {
      callback = function(ev)
        if ev.event ~= "User" or ev.match == "FugitiveChanged" then update_upstream() end
      end,
    })

    local function git_upstream()
      local state = upstream_cache[vim.fn.getcwd()]
      if state == nil then return "" end
      if state == false then return "" end -- laptop icon: branch exists only locally
      local parts = {}
      if state.ahead > 0 then table.insert(parts, "↑" .. state.ahead) end
      if state.behind > 0 then table.insert(parts, "↓" .. state.behind) end
      return table.concat(parts, " ") -- empty when in sync with the remote
    end

    return {
      options = {
        theme = "catppuccin-mocha", -- match the colorscheme (themes are named per flavour)
        globalstatus = true, -- one statusline for all windows, matching laststatus = 3
        always_show_tabline = false, -- hide the tab line while only one tab is open
        disabled_filetypes = { statusline = { "neo-tree" } }, -- no statusline noise in the sidebar
      },
      sections = {
        -- default section with the remote state next to the branch name
        lualine_b = {
          "branch",
          { git_upstream, cond = function() return vim.b.gitsigns_head ~= nil end },
          "diff",
          "diagnostics",
        },
        -- default section plus git blame; the component is hidden when there is no blame data
        lualine_c = {
          { "filename", path = 1 }, -- path relative to the cwd, so same-named files are told apart
          { git_blame, cond = function() return vim.b.gitsigns_blame_line_dict ~= nil end },
        },
      },
      -- tab line: lists Neovim tab pages (replaces bufferline.nvim)
      tabline = {
        lualine_a = {
          {
            "tabs",
            mode = 2, -- show tab number and name of the focused buffer
            max_length = function() return vim.o.columns end, -- use the full width
            show_modified_status = true, -- "●" on tabs with unsaved buffers
            fmt = tab_icon, -- add a file type icon before the tab name
          },
        },
      },
    }
  end,
}
