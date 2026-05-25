-- treesitter.lua
-- Syntax highlighting and code understanding via AST parsing.
--
-- Pinned to nvim-treesitter master (v1). The v2 rewrite on the `main` branch
-- isn't stable enough yet — parser registry doesn't populate reliably and
-- textobjects compatibility is in flux. Revisit v2 once it lands a release.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build  = ":TSUpdate",
    lazy   = false,                              -- must be on runtimepath before any buffer opens
    main   = "nvim-treesitter.configs",          -- v1 setup module
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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

      -- Install missing parsers automatically when a new filetype opens
      auto_install = true,

      -- ── Highlighting ──────────────────────────────────────
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- ── Indentation ───────────────────────────────────────
      indent = { enable = true },

      -- ── Text Objects ──────────────────────────────────────
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
          },
        },

        move = {
          enable    = true,
          set_jumps = true,
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

        swap = {
          enable = true,
          swap_next     = { ["<leader>sa"] = "@parameter.inner" },
          swap_previous = { ["<leader>sA"] = "@parameter.inner" },
        },
      },
    },
  },
}
