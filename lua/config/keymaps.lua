-- Global
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Windows
vim.keymap.set('n', '<M-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<M-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<M-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<M-l>', '<C-w>l', { silent = true })

vim.keymap.set('n', '<M-s>', ':write<CR>')
vim.keymap.set('n', '<C-S-s>', ':wa<CR>')
vim.keymap.set('n', '<M-w>', '<Nop>', { remap = false }) -- clear default window navigation bindings
vim.keymap.set('n', '<M-w>', ':quit<CR>')
vim.keymap.set('n', '<M-S-w>', ':only<CR>')

vim.keymap.set('n', '<leader>S', ':split<CR>')
vim.keymap.set('n', '<leader>s', ':vsplit<CR>')

vim.keymap.set('n', '<M-S-k>', ':resize +2<CR>')
vim.keymap.set('n', '<M-S-j>', ':resize -2<CR>')
vim.keymap.set('n', '<M-S-h>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<M-S-l>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>w', function()
  -- the picker ignores neo-tree and terminals by default (right for choosing where to open a file);
  -- here we want to focus any window, so override the ignored filetypes/buftypes for this call only
  local picked_window_id = require('window-picker').pick_window({
    filter_rules = { bo = { filetype = { 'notify', 'snacks_notif' }, buftype = {} } },
  })
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end, { desc = "Window: pick and focus" })

-- Tabs
vim.keymap.set('n', '<M-]>', '<cmd>tabnext<CR>', { desc = 'Tab: next' })
vim.keymap.set('n', '<M-[>', '<cmd>tabprevious<CR>', { desc = 'Tab: previous' })
vim.keymap.set('n', '<M-t>', '<cmd>tabnew<CR>', { desc = 'Tab: new' })
vim.keymap.set('n', '<leader>tt', '<cmd>tabclose<CR>', { desc = 'Tab: close' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Tab: close others' })
vim.keymap.set('n', '<leader>t>', '<cmd>tabmove +1<CR>', { desc = 'Tab: move right' })
vim.keymap.set('n', '<leader>t<', '<cmd>tabmove -1<CR>', { desc = 'Tab: move left' })
for i = 1, 9 do
  -- <M-1..9> jump straight to the n-th tab
  vim.keymap.set('n', '<M-' .. i .. '>', i .. 'gt', { desc = 'Tab: go to ' .. i })
end

-- Navigation
vim.keymap.set("n", "J", "<C-d>zz")
vim.keymap.set("n", "K", "<C-u>zz")

vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'File: explorer' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

vim.keymap.set("n", "<leader>o", function()
  vim.ui.open(vim.fn.expand("<cfile>"))
end, { desc = "Edit: open link under cursor" })

-- Editing
vim.keymap.set({'n', 'v'}, '_', 'J', { desc = 'Edit: join lines' })

vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = 'Edit: toggle comment line' })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true, desc = 'Edit: toggle comment selection' })

vim.keymap.set("x", "p", "P") -- Yank in visual selection without replacing the registry

-- Copy "relative/path:line" (or "path:start-end" for a visual selection) to the clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>y', function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local first, last = vim.fn.line('.'), vim.fn.line('.')
  if vim.fn.mode():match('^[vV\22]') then
    first, last = vim.fn.line('v'), vim.fn.line('.')
    if first > last then first, last = last, first end
  end
  local ref = path .. ':' .. first .. (last ~= first and ('-' .. last) or '')
  vim.fn.setreg('+', ref)
  vim.fn.setreg('"', ref)
  if vim.fn.mode() ~= 'n' then
    -- 'x' executes the Esc immediately, so the notification isn't wiped by the mode change
    vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'nx', false)
  end
  vim.notify('Copied ' .. ref)
end, { desc = 'File: copy relative path and line(s)' })

-- Terminal
vim.keymap.set('n', '<leader>;', ':botright split | terminal<CR>', { desc = 'Terminal: open at bottom' })
vim.keymap.set('n', '<leader>:', ':tab terminal<CR>', { desc = 'Terminal: open in new tab' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal: exit mode' })
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = "startinsert" })

-- Diff navigation: J/K are mapped buffer-locally only while a window is in diff mode
local function sync_diff_keymaps(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local in_diff = vim.wo[win].diff
  local mapped = vim.b[buf].diff_keymaps
  if in_diff and not mapped then
    -- expr fallback keeps the global scroll mappings if a stale mapping outlives diff mode (e.g. :diffoff)
    vim.keymap.set('n', 'J', function() return vim.wo.diff and ']c' or '<C-d>zz' end, { buffer = buf, expr = true, desc = 'Diff: next' })
    vim.keymap.set('n', 'K', function() return vim.wo.diff and '[c' or '<C-u>zz' end, { buffer = buf, expr = true, desc = 'Diff: previous' })
    vim.b[buf].diff_keymaps = true
  elseif not in_diff and mapped then
    pcall(vim.keymap.del, 'n', 'J', { buffer = buf })
    pcall(vim.keymap.del, 'n', 'K', { buffer = buf })
    vim.b[buf].diff_keymaps = false
  end
end
-- OptionSet alone misses :diffsplit/:diffthis, so DiffUpdated and window events also resync
vim.api.nvim_create_autocmd({ 'OptionSet', 'WinEnter', 'BufWinEnter', 'DiffUpdated' }, {
  callback = function(ev)
    if ev.event == 'OptionSet' and ev.match ~= 'diff' then return end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      sync_diff_keymaps(win)
    end
  end,
})
