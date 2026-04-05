-- treesitter.lua
-- Syntax highlighting and code understanding via AST parsing
--
-- nvim-treesitter v2 (the rewrite) removed nvim-treesitter.configs
-- The module is now just "nvim-treesitter" — lazy's `main` field handles setup.
-- Highlight is still managed here; Neovim core uses the installed parsers.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",   -- recompile parsers when the plugin updates
    -- No lazy loading — treesitter must be in the runtimepath before any buffer
    -- opens. Lazy-loading causes "module not found" on fresh installs.
    dependencies = {
      -- Text objects based on code structure (select/move/swap by function, class, etc.)
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    -- `main` tells lazy which module to call .setup(opts) on
    -- replaces the old require("nvim-treesitter.configs").setup() pattern
    main = "nvim-treesitter",
    opts = {

      -- ── Parsers ───────────────────────────────────────────
      ensure_installed = {
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
      },

      -- Install missing parsers automatically when a file is opened
      auto_install = true,

      -- ── Highlighting ──────────────────────────────────────
      -- Uses the installed parsers for accurate token-level highlighting
      -- additional_vim_regex_highlighting = false avoids conflicts with old regex engine
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- ── Indentation ───────────────────────────────────────
      -- Treesitter-aware indentation — smarter than Vim's default cindent
      indent = { enable = true },

      -- ── Text Objects ──────────────────────────────────────
      -- Lets you select, move, and swap code by structure rather than pattern
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,  -- jump forward to the next object if not already on one
          keymaps = {
            ["af"] = "@function.outer",   -- around function
            ["if"] = "@function.inner",   -- inside function
            ["ac"] = "@class.outer",      -- around class
            ["ic"] = "@class.inner",      -- inside class
            ["aa"] = "@parameter.outer",  -- around argument
            ["ia"] = "@parameter.inner",  -- inside argument
            ["ab"] = "@block.outer",      -- around block
            ["ib"] = "@block.inner",      -- inside block
          },
        },

        -- Jump between functions and classes with ] and [
        move = {
          enable    = true,
          set_jumps = true,  -- add positions to the jumplist so Ctrl+o works
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
        },

        -- Swap arguments / parameters with a neighbour
        swap = {
          enable = true,
          swap_next     = { ["<leader>sa"] = "@parameter.inner" },
          swap_previous = { ["<leader>sA"] = "@parameter.inner" },
        },
      },
    },
  },
}
