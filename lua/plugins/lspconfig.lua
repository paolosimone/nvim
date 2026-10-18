return {
  -- nvim-lspconfig ships default configs (cmd, filetypes, root markers) for
  -- hundreds of servers, under its lsp/ directory. Neovim 0.11+ reads them
  -- natively through vim.lsp.config / vim.lsp.enable.
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    -- Advertise blink's completion capabilities to every LSP server ("*" = all),
    -- so servers know the client supports e.g. snippets and resolve requests.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- Per-server overrides are merged on top of the defaults from nvim-lspconfig.
    -- lua_ls: tell it that `vim` is a legit global (otherwise "undefined global" warnings
    -- appear in your nvim config) and make it aware of the Neovim runtime files.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    })

    -- rust_analyzer is not installed via mason, so mason-lspconfig will not
    -- auto-enable it: enable it here (it must be on PATH).
    vim.lsp.enable("rust_analyzer")

    -- Diagnostics (errors/warnings reported by servers).
    vim.diagnostic.config({
      virtual_text = true,     -- show message at the end of the line
      severity_sort = true,    -- errors listed before warnings
      float = { border = "rounded" },
    })

    -- LspAttach fires every time a server attaches to a buffer. Keymaps are defined
    -- here, buffer-local, so they exist only where an LSP is actually available.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
      callback = function(event)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gi", vim.lsp.buf.implementation, "Go to implementation")
        map("gr", vim.lsp.buf.references, "List references")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        -- [d / ]d (previous/next diagnostic) are already built into Neovim 0.11+.
      end,
    })
  end,
}
