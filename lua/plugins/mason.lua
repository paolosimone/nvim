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
      -- Automatically call vim.lsp.enable() for every server installed via mason
      -- (also right after a server is installed during the session).
      automatic_enable = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Filetype -> mason package to install on demand (instead of ensure_installed),
      -- so only the tools relevant to the project you open get downloaded.
      -- rust_analyzer is intentionally absent: install it with rustup.
      local packages = {
        lua = "lua-language-server",
        python = "ty",
        elixir = "expert",
        php = "intelephense",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(packages),
        callback = function(args)
          local registry = require("mason-registry")
          -- Registry must be loaded before querying packages; refresh is async-safe.
          registry.refresh(function()
            local ok, pkg = pcall(registry.get_package, packages[args.match])
            if ok and not pkg:is_installed() and not pkg:is_installing() then
              pkg:install()
            end
          end)
        end,
      })
    end,
  },
}
