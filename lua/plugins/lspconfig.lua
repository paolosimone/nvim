return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    -- Advertise blink's completion capabilities to every LSP server ("*" = all),
    -- so servers know the client supports e.g. snippets and resolve requests.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- Per-server overrides are merged on top of the defaults from nvim-lspconfig.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } }, -- avoid "undefined global" warnings
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
        },
      },
    })

    -- rust_analyzer is not installed via mason,
    -- requires `rustup component add rust-analyzer`
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

        -- Remove the default LSP mapping
        pcall(vim.keymap.del, 'n', 'K', { buf = event.buf })

        map("<leader>kk", vim.lsp.buf.definition, "Go to definition")
        map("<leader>kl", vim.lsp.buf.references, "List references")
        map("<leader>ki", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>kd", vim.diagnostic.open_float, "Line diagnostics")
        map("<leader>kr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>k.", vim.lsp.buf.code_action, "Code action")
      end,
    })
  end,
}
