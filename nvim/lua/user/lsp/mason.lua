-- lsp/mason.lua
-- Installs language servers via mason and configures each with lspconfig
--
-- Adding a new server (two steps):
--   1. Add its mason-lspconfig name to the servers list below
--   2. Optionally create lsp/settings/<servername>.lua returning a config table
--      Mason auto-installs it. The loop auto-configures it.
--
-- Server names must match mason-lspconfig's registry, not mason's:
--   https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

local servers = {
  "lua_ls",         -- Lua          (neovim config, scripts)
  "pyright",        -- Python       (type checking, imports)
  "gopls",          -- Go           (formatting, analysis, imports)
  "clangd",         -- C / C++      (embedded, systems)
  "rust_analyzer",  -- Rust
  "jdtls",          -- Java
  "bashls",         -- Bash + Zsh   (see settings/bashls.lua for zsh filetypes)
  "jsonls",         -- JSON         (schema validation via schemastore)
  "yamlls",         -- YAML         (schema validation via schemastore)
  "dockerls",       -- Dockerfile
}

-- ── Mason ────────────────────────────────────────────────────
require("mason").setup({
  ui = {
    border = "rounded",
    icons  = {
      package_installed   = "✓",
      package_pending     = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- mason-lspconfig bridges mason and lspconfig
-- ensure_installed keeps servers present, automatic_installation catches new ones
require("mason-lspconfig").setup({
  ensure_installed       = servers,
  automatic_installation = true,
})

-- ── Tool installer ───────────────────────────────────────────
-- mason-tool-installer keeps formatters and linters installed automatically
-- so you don't have to manually :MasonInstall each one after cloning dotfiles
-- Names here are mason's registry names (may differ from conform/nvim-lint names)
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Formatters
    "stylua",            -- Lua
    "black",             -- Python
    "isort",             -- Python imports
    "goimports",         -- Go (also adds missing imports)
    "gofmt",             -- Go
    "rustfmt",           -- Rust
    "google-java-format", -- Java
    "clang-format",      -- C / C++
    "prettier",          -- JS, TS, JSON, YAML, Markdown
    "shfmt",             -- Shell / Zsh

    -- Linters
    "ruff",              -- Python (replaces flake8, much faster)
    "golangci-lint",     -- Go
    "shellcheck",        -- Bash / Zsh
    "hadolint",          -- Dockerfile
  },
  auto_update  = false,  -- don't silently update tools on every startup
  run_on_start = true,   -- install missing tools when nvim starts
})

-- ── Server setup loop ────────────────────────────────────────
-- Every server gets on_attach + capabilities from handlers.lua as a baseline.
-- If lsp/settings/<server>.lua exists its table is deep-merged on top.
local lspconfig = require("lspconfig")
local handlers  = require("user.lsp.handlers")

for _, server in ipairs(servers) do
  local opts = {
    on_attach    = handlers.on_attach,
    capabilities = handlers.capabilities(),
  }

  -- pcall so a bad settings file doesn't break all servers
  local ok, overrides = pcall(require, "user.lsp.settings." .. server)
  if ok then
    opts = vim.tbl_deep_extend("force", opts, overrides)
  end

  lspconfig[server].setup(opts)
end
