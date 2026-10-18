-- Global
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Windows
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set('n', '<leader>sj', ':split<CR>', { silent = true, desc = "Split window horizontally" })
vim.keymap.set('n', '<leader>sl', ':vsplit<CR>', { silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<leader>sc', ':quit<CR>', { silent = true, desc = "Close current split" })
vim.keymap.set('n', '<leader>so', ':only<CR>', { silent = true, desc = "Close all other splits" })

vim.keymap.set('n', '<M-k>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<M-j>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<M-h>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<M-l>', ':vertical resize +2<CR>', { silent = true })

-- Navigation
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })


