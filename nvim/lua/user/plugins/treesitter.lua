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

      -- Skip plugin-owned buffers (telescope prompt/results, nvim-tree, etc.).
      -- Attaching treesitter there triggers on_lines while plugins are
      -- mutating the buffer, which races with their own refresh logic —
      -- notably telescope-file-browser actions crash on Neovim 0.12.
      local SKIP_FT = {
        TelescopePrompt   = true,
        TelescopeResults  = true,
        TelescopePreview  = true,
        NvimTree          = true,
        dashboard         = true,
        lazy              = true,
        mason             = true,
        notify            = true,
        ["snacks_picker_input"] = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
        callback = function(ev)
          if SKIP_FT[vim.bo[ev.buf].filetype] then return end
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  -- ── Text objects ──────────────────────────────────────────
  -- The `main` branch is the v2-compatible rewrite (the old master branch
  -- died with treesitter v1). Restores the af/if/ac/ic selections and
  -- ]f/[f motions we lost in the v2 migration.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event  = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move   = { set_jumps = true },
      })

      local sel = require("nvim-treesitter-textobjects.select")
      local function s(lhs, query, desc)
        vim.keymap.set({ "x", "o" }, lhs, function()
          sel.select_textobject(query, "textobjects")
        end, { silent = true, desc = desc })
      end
      s("af", "@function.outer",  "a function")
      s("if", "@function.inner",  "inner function")
      s("ac", "@class.outer",     "a class")
      s("ic", "@class.inner",     "inner class")
      s("aa", "@parameter.outer", "a parameter")
      s("ia", "@parameter.inner", "inner parameter")
      s("ab", "@block.outer",     "a block")
      s("ib", "@block.inner",     "inner block")

      local move = require("nvim-treesitter-textobjects.move")
      local function m(lhs, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move[fn](query, "textobjects")
        end, { silent = true, desc = desc })
      end
      m("]f", "goto_next_start",     "@function.outer", "Next function start")
      m("]c", "goto_next_start",     "@class.outer",    "Next class start")
      m("]F", "goto_next_end",       "@function.outer", "Next function end")
      m("]C", "goto_next_end",       "@class.outer",    "Next class end")
      m("[f", "goto_previous_start", "@function.outer", "Prev function start")
      m("[c", "goto_previous_start", "@class.outer",    "Prev class start")

      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sa", function()
        swap.swap_next("@parameter.inner")
      end, { silent = true, desc = "Swap parameter forward" })
      vim.keymap.set("n", "<leader>sA", function()
        swap.swap_previous("@parameter.inner")
      end, { silent = true, desc = "Swap parameter backward" })
    end,
  },
}
