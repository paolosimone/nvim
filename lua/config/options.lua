-- Behaviour
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Without a native clipboard tool (SSH, devcontainers) copy via OSC 52 escape sequences,
-- which the host terminal turns into a clipboard write (needs nvim >= 0.10 and terminal support)
local native = { "pbcopy", "wl-copy", "xclip", "xsel", "win32yank.exe" }
local has_native = false
for _, tool in ipairs(native) do
  if vim.fn.executable(tool) == 1 then has_native = true end
end
if vim.env.SSH_TTY or not has_native then
  local osc52 = require("vim.ui.clipboard.osc52")
  -- Pasting via OSC 52 often hangs or is blocked, so paste from nvim's own register instead
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

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
vim.opt.wrap = false
vim.opt.laststatus = 3 -- One global statusline 
vim.o.winborder = "rounded" -- Options: "single", "double", "rounded", "solid", "shadow"

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true


