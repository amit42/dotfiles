-- lsp/mason.lua
-- Installs language servers via mason and configures each with the new
-- vim.lsp.config API (lspconfig v3+, Neovim 0.11+)
--
-- Adding a new server (two steps):
--   1. Add its mason-lspconfig name to the servers list below
--   2. Optionally create lsp/settings/<servername>.lua returning a config table
--      Mason auto-installs it. The loop auto-configures it.
--
-- Server names must match mason-lspconfig's registry:
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
    providers = {
      "mason.providers.registry-api",
      "mason.providers.client",
    },
    icons  = {
      package_installed   = "✓",
      package_pending     = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- mason-lspconfig installs servers listed in ensure_installed
-- automatic_installation picks up any server added later without a manual :MasonInstall
require("mason-lspconfig").setup({
  ensure_installed       = servers,
  automatic_installation = true,
})

-- ── Tool installer ───────────────────────────────────────────
-- Keeps formatters and linters installed automatically alongside LSP servers
-- so a fresh clone works out of the box with no manual :MasonInstall calls
-- Names here are mason's registry names (may differ from conform/nvim-lint names)
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Formatters
    "stylua",             -- Lua
    "black",              -- Python
    "isort",              -- Python imports
    "goimports",          -- Go (also adds missing imports)
    -- gofmt ships with Go toolchain, not a Mason package
    -- rustfmt ships with Rust toolchain (rustup), not a Mason package
    "google-java-format", -- Java
    "clang-format",       -- C / C++
    "prettier",           -- JS, TS, JSON, YAML, Markdown
    "shfmt",              -- Shell / Zsh

    -- Linters
    "ruff",               -- Python (faster flake8 replacement)
    "golangci-lint",      -- Go
    "shellcheck",         -- Bash / Zsh
    "hadolint",           -- Dockerfile
  },
  auto_update  = false, -- don't silently update tools on every startup
  run_on_start = true,  -- install any missing tools when nvim starts
})

-- ── Global LSP defaults ──────────────────────────────────────
-- vim.lsp.config("*") sets a baseline applied to every server before
-- per-server config is merged. Replaces the old lspconfig[server].setup() loop.
local handlers = require("user.lsp.handlers")

vim.lsp.config("*", {
  on_attach    = handlers.on_attach,
  capabilities = handlers.capabilities(),
})

-- ── Per-server settings ──────────────────────────────────────
-- If lsp/settings/<server>.lua exists its table is merged on top of the global defaults
-- pcall so a bad settings file doesn't break all other servers
for _, server in ipairs(servers) do
  local ok, overrides = pcall(require, "user.lsp.settings." .. server)
  if ok then
    vim.lsp.config(server, overrides)
  end
end

-- ── Enable ───────────────────────────────────────────────────
-- Registers each server so neovim attaches it when the right filetype opens
vim.lsp.enable(servers)
