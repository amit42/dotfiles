-- lsp/handlers.lua
-- Shared LSP config applied to every language server
--
-- M.capabilities()  → what neovim + cmp can handle (sent to each server at setup)
-- M.on_attach()     → runs when a server connects to a buffer, sets keymaps
-- M.setup()         → one-time diagnostic display config (signs, virtual text, floats)
--
-- Called from:
--   lsp/mason.lua  → passes capabilities + on_attach to each lspconfig.setup()
--   lsp/init.lua   → calls M.setup() once before any server attaches

local M = {}

-- ── Capabilities ────────────────────────────────────────────
-- Build capabilities by merging neovim defaults with what nvim-cmp
-- advertises. This unlocks snippet completion and other cmp features
-- that servers only enable when the client claims to support them.
M.capabilities = function()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if not ok then
    return vim.lsp.protocol.make_client_capabilities()
  end
  return cmp_lsp.default_capabilities()
end

-- ── Keymaps ─────────────────────────────────────────────────
-- All LSP keymaps are buffer-local: only active in buffers where a server
-- is attached. Using vim.keymap.set with buffer = bufnr is cleaner than
-- the legacy nvim_buf_set_keymap approach.
local function set_keymaps(bufnr)
  local map = function(keys, cmd, desc)
    vim.keymap.set("n", keys, cmd, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Jump to where a symbol is defined/declared/implemented
  map("gd",  vim.lsp.buf.definition,     "Go to definition")
  map("gD",  vim.lsp.buf.declaration,    "Go to declaration")
  map("gi",  vim.lsp.buf.implementation, "Go to implementation")
  map("gr",  vim.lsp.buf.references,     "References")

  -- Documentation
  map("K",           vim.lsp.buf.hover,          "Hover docs")
  map("<leader>ls",  vim.lsp.buf.signature_help,  "Signature help")

  -- Diagnostics — gl shows the float for the current line
  map("gl",          vim.diagnostic.open_float,                           "Show diagnostic float")
  map("<leader>lj",  vim.diagnostic.goto_next,                            "Next diagnostic")
  map("<leader>lk",  vim.diagnostic.goto_prev,                            "Prev diagnostic")
  -- Trouble: buffer diagnostics (<leader>lq) and workspace (<leader>lt)
  map("<leader>lq",  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",  "Buffer diagnostics")
  map("<leader>lt",  "<cmd>Trouble diagnostics toggle<cr>",               "Workspace diagnostics")

  -- Refactoring + actions
  map("<leader>la",  vim.lsp.buf.code_action, "Code action")
  map("<leader>lr",  vim.lsp.buf.rename,      "Rename symbol")

  -- Info
  map("<leader>li",  "<cmd>LspInfo<cr>",  "LSP info")
  map("<leader>m",   "<cmd>Mason<cr>",    "Mason server manager")

  -- <leader>lf is intentionally NOT set here
  -- formatting.lua owns it so conform + lsp_fallback covers all filetypes uniformly
end

-- ── on_attach ────────────────────────────────────────────────
-- Called by lspconfig for every buffer a server attaches to.
-- Keep this lightweight — heavy work belongs in other modules.
M.on_attach = function(client, bufnr)
  set_keymaps(bufnr)

  -- Disable LSP-based formatting for servers where conform handles it.
  -- This prevents conflicts when both try to format on <leader>lf or save.
  local conform_handles = { lua_ls = true, pyright = true, gopls = true, clangd = true }
  if conform_handles[client.name] then
    client.server_capabilities.documentFormattingProvider = false
  end
end

-- ── Diagnostics ─────────────────────────────────────────────
-- Called once from lsp/init.lua config before any server attaches.
-- Controls how errors/warnings are displayed globally.
M.setup = function()
  vim.diagnostic.config({
    -- Show error text inline at end of line with a bullet prefix
    virtual_text = {
      spacing = 4,
      prefix  = "●",
    },

    -- Sign column icons — uses the new signs.text API (Neovim 0.10+)
    -- Cleaner than the legacy vim.fn.sign_define loop
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.HINT]  = "󰌵",
        [vim.diagnostic.severity.INFO]  = "",
      },
    },

    underline        = true,
    update_in_insert = false,  -- don't flash errors mid-keystroke
    severity_sort    = true,   -- errors before warnings in sign column + quickfix

    float = {
      border = "rounded",
      source = true,  -- show which server produced the diagnostic
      header = "",
      prefix = "",
    },
  })

  -- Rounded borders on hover (K) and signature help (<leader>ls) popups
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
