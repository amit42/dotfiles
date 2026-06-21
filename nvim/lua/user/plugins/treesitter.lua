-- treesitter.lua
-- Syntax highlighting and code understanding via AST parsing.
--
-- nvim-treesitter v2 (main branch) — required for Neovim 0.12+. The legacy
-- master (v1) calls node:range() which was removed in 0.12 and breaks every
-- treesitter parse globally (including render-markdown). v2 also moves the
-- setup module to the top-level "nvim-treesitter" and drops highlight/indent
-- opts — Neovim core handles those once parsers are on runtimepath.

local PARSERS = {
  -- Systems / Embedded
  "c", "cpp", "cmake", "make",
  -- Backend
  "go", "python", "rust", "java", "javascript", "typescript",
  -- DevOps
  "dockerfile", "yaml", "json", "hcl", "bash",
  -- Nvim config
  "lua", "vim", "vimdoc",
  -- Markup
  "markdown", "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy   = false,
    build  = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(PARSERS)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
