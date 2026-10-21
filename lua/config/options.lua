-- Behaviour
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.o.timeout = true -- Combination timeout
vim.o.timeoutlen = 1000
vim.opt.autoread = true -- Enable auto-read when a file is changed from the outside
vim.opt.autowriteall = true -- Write buffers

-- Eagerly save modified buffers: autowriteall alone misses plugin-driven switches (diffview, fugitive, tabs)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "WinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    -- Only real, modifiable, named file buffers (skip terminals, plugin UIs, unnamed buffers)
    if vim.bo[buf].buftype == "" and vim.bo[buf].modifiable and vim.bo[buf].modified
        and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function() vim.cmd("silent! update") end)
    end
  end,
})

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.laststatus = 3 -- One global statusline 
vim.o.winborder = "rounded" -- Options: "single", "double", "rounded", "solid", "shadow"

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true


