-- lsp/init.lua
-- Lazy plugin specs for the entire LSP layer
-- Imported by lazy.lua via { import = "user.lsp" }
--
-- Structure:
--   lsp/init.lua       ← you are here (plugin specs only, no logic)
--   lsp/handlers.lua   ← capabilities, on_attach, diagnostics display
--   lsp/mason.lua      ← server list + setup loop
--   lsp/completion.lua ← nvim-cmp config
--   lsp/formatting.lua ← conform (format on save) + nvim-lint
--   lsp/settings/      ← one file per language server

return {

  -- ── LSP Core ────────────────────────────────────────────────
  -- lspconfig connects neovim to running language servers
  -- mason installs and manages those servers
  -- loads on BufReadPre so startup is never blocked
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim", -- auto-installs formatters + linters
      "hrsh7th/cmp-nvim-lsp",              -- lets handlers.lua build capabilities
      "b0o/schemastore.nvim",              -- JSON/YAML schema catalog for jsonls/yamlls
      { "j-hui/fidget.nvim", opts = {} },  -- unobtrusive LSP progress in the corner
    },
    config = function()
      -- diagnostics display must be configured before any server attaches
      require("user.lsp.handlers").setup()
      -- mason installs servers, lspconfig wires them up
      require("user.lsp.mason")
    end,
  },

  -- ── Completion ──────────────────────────────────────────────
  -- nvim-cmp shows completion menu as you type
  -- InsertEnter means zero startup cost — only loads when you start typing
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",        -- LSP completions
      "hrsh7th/cmp-buffer",          -- words from open buffers
      "hrsh7th/cmp-path",            -- file system paths
      "hrsh7th/cmp-cmdline",         -- completions in : and / bars
      "saadparwaiz1/cmp_luasnip",    -- bridge between cmp and luasnip
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          -- load VS Code style snippets from friendly-snippets
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      require("user.lsp.completion")
    end,
  },

  -- ── Formatting ──────────────────────────────────────────────
  -- conform runs formatters before each save (BufWritePre)
  -- much faster than null-ls, cleaner config, actively maintained
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("user.lsp.formatting").setup_conform()
    end,
  },

  -- ── Linting ─────────────────────────────────────────────────
  -- nvim-lint runs linters after save and feeds results into vim.diagnostic
  -- same sign column and virtual text as LSP errors — consistent look
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost" },
    config = function()
      require("user.lsp.formatting").setup_lint()
    end,
  },
}
