-- Curated git subcommands shown by the <leader>gg picker. Add entries as needed.
local commands = {
  { "status", "Show working tree status" },
  { "commit -m ", "Commit staged changes", "message" },
  { "commit --amend --no-edit", "Amend the last commit" },
  { "push", "Push to remote" },
  { "push --force-with-lease", "Force push (safe)" },
  { "pull --rebase", "Pull with rebase" },
  { "fetch --prune", "Fetch and prune deleted remote branches" },
  { "rebase -i HEAD~10", "Interactive rebase last 10 commits" },
  { "rebase -i ", "Interactive rebase onto branch", "branch" },
  { "rebase --continue", "Continue rebase" },
  { "rebase --abort", "Abort rebase" },
  { "checkout -b ", "Create and switch to new branch" },
  { "switch ", "Switch branch", "local_branch" },
  { "stash -u", "Stash changes" },
  { "stash pop", "Apply and drop latest stash" },
  { "reset --soft ", "Reset to commit, keep changes staged", "commit" },
  { "reset --hard ", "Reset to commit, discard changes", "commit" },
  { "log --oneline --graph --decorate", "Commit graph" },
  { "blame", "Blame current file" },
}

-- Lists refs for the branch picker; "local_branch" kind maps remote refs to local names
-- (so `git switch` auto-creates the tracking branch).
local function list_branches(kind)
  local function refs(namespace)
    return vim.fn.systemlist({ "git", "for-each-ref", "--sort=-committerdate", "--format=%(refname:short)", namespace })
  end

  local result, seen = {}, {}
  local function add(name)
    if name ~= "" and name ~= "HEAD" and not name:match("/HEAD$") and not seen[name] then
      seen[name] = true
      table.insert(result, name)
    end
  end

  for _, name in ipairs(refs("refs/heads")) do
    add(name)
  end
  for _, name in ipairs(refs("refs/remotes")) do
    add(kind == "local_branch" and (name:gsub("^[^/]+/", "", 1)) or name)
  end
  return result
end

-- Recent commits, newest first, as { hash, subject } pairs.
local function list_commits()
  local result = {}
  for _, line in ipairs(vim.fn.systemlist({ "git", "log", "-n", "50", "--format=%h %s" })) do
    local hash, subject = line:match("^(%S+) (.*)$")
    if hash then
      table.insert(result, { hash, subject })
    end
  end
  return result
end

local function pick_branch(prefix, kind)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new(require("telescope.themes").get_dropdown(), {
      prompt_title = "git " .. vim.trim(prefix) .. (kind == "commit" and " <commit>" or " <branch>"),
      finder = kind == "commit"
          and finders.new_table({
            results = list_commits(),
            entry_maker = function(entry)
              return { value = entry[1], display = entry[1] .. " " .. entry[2], ordinal = entry[1] .. " " .. entry[2] }
            end,
          })
        or finders.new_table({ results = list_branches(kind) }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            vim.schedule(function()
              vim.cmd("Git " .. prefix .. (selection.value or selection[1]))
            end)
          end
        end)
        return true
      end,
    })
    :find()
end

local function pick_git_command()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new(require("telescope.themes").get_dropdown(), {
      prompt_title = "Git commands",
      finder = finders.new_table({
        results = commands,
        entry_maker = function(entry)
          return {
            value = entry[1],
            kind = entry[3],
            display = string.format("%-36s %s", entry[1], entry[2]),
            ordinal = entry[1] .. " " .. entry[2],
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        -- Run the command; branch entries open a branch picker, other entries ending with a space are pre-filled.
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if not selection then
            return
          end
          vim.schedule(function()
            if selection.kind == "message" then
              -- Ask for the commit message first; empty/cancelled input aborts. `true` also escapes %, # and ! for the cmdline.
              vim.ui.input({ prompt = "Commit message: " }, function(msg)
                if msg and vim.trim(msg) ~= "" then
                  vim.cmd("Git " .. selection.value .. vim.fn.shellescape(msg, true))
                end
              end)
            elseif selection.kind then
              pick_branch(selection.value, selection.kind)
            elseif selection.value:sub(-1) == " " then
              vim.api.nvim_feedkeys(":Git " .. selection.value, "n", false)
            else
              vim.cmd("Git " .. selection.value)
            end
          end)
        end)
        return true
      end,
    })
    :find()
end

-- Copies a GitHub permalink (pinned to HEAD's commit) for the cursor line or visual selection.
local function copy_permalink()
  local function git(dir, ...)
    local out = vim.fn.systemlist({ "git", "-C", dir, ... })
    return vim.v.shell_error == 0 and out[1] or nil
  end

  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(file, ":h")
  local root, sha, remote = git(dir, "rev-parse", "--show-toplevel"), git(dir, "rev-parse", "HEAD"), git(dir, "remote", "get-url", "origin")
  if not (root and sha and remote) then
    return vim.notify("Not a git file with an 'origin' remote", vim.log.levels.WARN)
  end

  local base = remote:gsub("^git@([^:]+):", "https://%1/"):gsub("^ssh://git@", "https://"):gsub("%.git$", "")
  local path = file:sub(#root + 2)
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local lines = first == last and ("#L" .. first) or ("#L" .. first .. "-L" .. last)

  local url = string.format("%s/blob/%s/%s%s", base, sha, path, lines)
  vim.fn.setreg("+", url)
  vim.notify("Copied " .. url)
end

return {
  "tpope/vim-fugitive",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "Git", "G", "Gread", "Gwrite", "GMove", "GDelete", "GBrowse", "Gclog" },
  keys = {
    { "<leader>gg", pick_git_command, desc = "Git: commands (picker)" },
    { "<leader>gy", copy_permalink, mode = { "n", "v" }, desc = "Git: copy GitHub permalink" },
  },
}
