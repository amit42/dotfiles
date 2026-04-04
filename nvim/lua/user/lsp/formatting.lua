-- lsp/formatting.lua
-- Formatting (conform.nvim) and linting (nvim-lint)
-- Each is set up by its own function, called from lsp/init.lua config blocks.
--
-- conform  → runs formatters synchronously before each save (BufWritePre)
-- nvim-lint → runs linters after save and on open (BufWritePost, BufReadPost)
--
-- Formatters and linters are external tools — install them via Mason or your
-- system package manager. :Mason shows what's available.
--
-- To add a formatter:
--   1. Add it to formatters_by_ft below
--   2. Install it: :MasonInstall <name>  (or add to mason-tool-installer)
--
-- To add a linter:
--   1. Add it to linters_by_ft below
--   2. Install it the same way

local M = {}

-- ── Formatting ───────────────────────────────────────────────
M.setup_conform = function()
  local conform = require("conform")

  conform.setup({
    -- List formatters per filetype. Multiple formatters run in sequence.
    -- To try alternatives (first available wins), use stop_after_first = true.
    formatters_by_ft = {
      lua        = { "stylua" },
      python     = { "isort", "black" },         -- isort first → black after
      go         = { "goimports", "gofmt" },     -- goimports adds missing imports
      rust       = { "rustfmt" },
      java       = { "google_java_format" },
      c          = { "clang_format" },
      cpp        = { "clang_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json       = { "prettier" },
      yaml       = { "prettier" },
      markdown   = { "prettier" },
      sh         = { "shfmt" },
    },

    -- Synchronous format on save with a 500ms timeout
    -- lsp_fallback = true: if no conform formatter matches, defer to the LSP server
    format_on_save = {
      timeout_ms   = 500,
      lsp_fallback = true,
    },
  })

  -- <leader>lf: format the current file (or visual selection) on demand
  -- Works for any filetype — falls back to LSP if conform has no formatter
  vim.keymap.set({ "n", "v" }, "<leader>lf",
    function()
      conform.format({ async = true, lsp_fallback = true })
    end,
    { silent = true, desc = "Format file" }
  )
end

-- ── Linting ──────────────────────────────────────────────────
M.setup_lint = function()
  local lint = require("lint")

  -- Linters feed into vim.diagnostic — same display as LSP errors
  lint.linters_by_ft = {
    python     = { "ruff" },        -- ruff replaces flake8: same rules, much faster
    go         = { "golangcilint" },
    sh         = { "shellcheck" },
    dockerfile = { "hadolint" },
  }

  -- Re-lint on write, on open, and when leaving insert mode
  -- InsertLeave catches edits that don't trigger a save
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group    = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
