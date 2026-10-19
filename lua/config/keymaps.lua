-- Global
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Windows
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set('n', '<C-s>', ':write<CR>')
vim.keymap.set('n', '<C-w>', ':quit<CR>')
vim.keymap.set('n', '<C-S-w>', ':only<CR>')

vim.keymap.set('n', '<leader>S', ':split<CR>')
vim.keymap.set('n', '<leader>s', ':vsplit<CR>')

vim.keymap.set('n', '<M-k>', ':resize +2<CR>')
vim.keymap.set('n', '<M-j>', ':resize -2<CR>')
vim.keymap.set('n', '<M-h>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<M-l>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>w', function()
  local picked_window_id = require('window-picker').pick_window()
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end, { desc = "Pick a window to focus" })

-- Navigation
vim.keymap.set("n", "J", "<C-d>zz")
vim.keymap.set("n", "K", "<C-u>zz")

vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>')
-- vim.keymap.set('n', '<leader>g', ' :Neotree float git_status toggle=true<CR>')

-- Editing
vim.keymap.set({'n', 'v'}, '_', 'J', { desc = 'Join lines' })

vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, desc = 'Toggle comment line' })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true, desc = 'Toggle comment selection' })

-- Terminal
vim.keymap.set('n', '<leader>tj', ':botright split | terminal<CR>', { desc = 'Open terminal at bottom' })
vim.keymap.set('n', '<leader>tt', ':tab terminal<CR>', { desc = 'Open terminal in new tab' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = "startinsert" })
