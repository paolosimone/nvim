return {
  -- mason.nvim: a package manager for external tools (LSP servers, formatters...).
  -- It downloads binaries into stdpath("data")/mason so you don't install them by hand.
  -- Open the UI with :Mason
  { "mason-org/mason.nvim", opts = {} },

  -- mason-lspconfig.nvim: bridges mason and the LSP configs.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- Servers that mason installs automatically if missing.
      -- rust_analyzer is intentionally absent: install it with
      ensure_installed = { "lua_ls", "basedpyright", "elixirls", "intelephense" },

      -- Automatically call vim.lsp.enable() for every server installed via mason.
      automatic_enable = true,
    },
  },
}
