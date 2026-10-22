-- Called by markdown-preview with the preview URL (see mkdp_browserfunc below)
local function open_preview(url)
  if vim.env.TERM_PROGRAM == "ghostty" and vim.fn.executable("terminal-browser") == 1 then
    -- terminal-browser draws with the kitty graphics protocol, which nvim's :terminal can't show,
    -- so it opens its own Ghostty split pane instead
    vim.system(
      { "terminal-browser", "open", "--split", "right", url },
      { detach = true, env = { TERMINAL_BROWSER_NO_TELEMETRY = "1" } }
    )
  else
    vim.ui.open(url) -- fallback: system browser
  end
end

return {
  -- markdown-preview.nvim: live markdown preview served from a local web server
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },

  -- Download the prebuilt server binary. Run the plugin's script synchronously because
  -- mkdp#util#install is async and needs the plugin loaded
  build = function(plugin)
    vim.system({ "bash", plugin.dir .. "/app/install.sh" }):wait()
  end,

  -- mkdp reads its g: variables when it loads, so they are set in `init`
  init = function()
    vim.g.mkdp_theme = "dark" -- matches catppuccin mocha
    -- mkdp only accepts the name of a Vimscript function, so wrap the Lua handler in one
    vim.g.mkdp_browserfunc = "MkdpOpenPreviewVim"
    _G.MkdpOpenPreview = open_preview -- v:lua can only call global functions
    vim.cmd([[function! MkdpOpenPreviewVim(url)
      call v:lua.MkdpOpenPreview(a:url)
    endfunction]])
  end,

  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown: toggle preview" },
  },
}
