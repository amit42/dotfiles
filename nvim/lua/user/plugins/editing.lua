-- editing.lua
-- Small editing quality-of-life plugins: autopairs, comments, surround,
-- indent detection, motion, references, undo history.

return {

  -- ── Autopairs ─────────────────────────────────────────
  -- Auto close brackets, quotes, etc
  -- type ( → get ()  with cursor inside
  -- type " → get ""  with cursor inside
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",             -- only load when entering insert mode
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,               -- use treesitter to check context
        ts_config = {
          lua  = { "string" },
          javascript = { "string", "template_string" },
        },
        fast_wrap = {
          map = "<M-e>",
        },
        map_cr = false,                -- cmp owns <CR> for completion confirm
                                       -- autopairs pairs via on_confirm_done
      })
    end,
  },

  -- ── Comments ──────────────────────────────────────────
  -- gcc = toggle line comment
  -- gc  = toggle comment on selection
  -- Works for every language automatically
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },  -- load when opening a file
    config = function()
      require("Comment").setup()
    end,
  },

  -- ── Sleuth ────────────────────────────────────────────
  -- Automatically detects tabstop and shiftwidth from the file being edited
  -- No config needed — opens a Go file and it uses tabs; opens a JS file and
  -- it uses 2 spaces. Useful when working across projects with different styles.
  { "tpope/vim-sleuth" },

  -- ── Surround ──────────────────────────────────────────
  -- Add / change / delete surrounding chars and tags.
  -- ys{motion}{char}  add:    ysiw"  →  "word"
  -- cs{old}{new}      change: cs"'   →  'word'
  -- ds{char}          delete: ds"    →  word
  {
    "kylechui/nvim-surround",
    event  = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- ── Undotree ──────────────────────────────────────────
  -- Visual undo history — see every branch of your edit history as a tree
  -- Combines with undofile=true (options.lua) for persistent history across sessions
  -- <leader>u to toggle the panel
  {
    "mbbill/undotree",
    cmd  = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },

  -- ── Illuminate ────────────────────────────────────────
  -- Highlights all other occurrences of the word under the cursor
  -- Uses LSP references when available, falls back to regex
  -- ]] / [[ to jump between occurrences
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay            = 200,     -- ms before highlights appear
        large_file_cutoff = 2000,   -- disable on files > 2000 lines (performance)
        providers        = { "lsp", "treesitter", "regex" },  -- priority order
      })

      local map = vim.keymap.set
      -- Jump between highlighted references of the word under cursor
      map("n", "]]", function() require("illuminate").goto_next_reference() end,
        { noremap = true, silent = true, desc = "Next reference" })
      map("n", "[[", function() require("illuminate").goto_prev_reference() end,
        { noremap = true, silent = true, desc = "Prev reference" })
    end,
  },

  -- ── Better Buffer Delete ───────────────────────────────
  -- :Bdelete closes the buffer without destroying the window layout
  -- Built-in :bdelete closes the window too, which is disruptive in splits
  -- <leader>x is mapped to :Bdelete in keymaps.lua
  {
    "moll/vim-bbye",
    cmd = { "Bdelete", "Bwipeout" },  -- load only when command is used
  },

  -- ── Flash — jump anywhere on screen ───────────────────────
  -- Press s + 2 chars → labels appear on every match → one more key lands
  -- the cursor there. S uses treesitter nodes for structural selection.
  -- (S stays visual-mode-free: nvim-surround owns S in visual for
  -- "surround selection".)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {
      modes = {
        -- Don't hijack f/t/F/T or / search — only explicit s/S jumps
        char   = { enabled = false },
        search = { enabled = false },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
      { "S", mode = { "n", "o" },      function() require("flash").treesitter() end, desc = "Flash treesitter select" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote flash (operator)" },
    },
  },

  -- ── TODO comments ─────────────────────────────────────────
  -- Highlights TODO/FIXME/HACK/NOTE/PERF in code and makes them jumpable
  -- and searchable.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>tt", ":TodoTelescope<CR>",                                desc = "Search TODOs" },
    },
  },

  -- ── Smooth scrolling ──────────────────────────────────────
  -- Ctrl-d/u/f/b and zz/zt/zb glide instead of jumping — easier to keep
  -- visual context while moving.
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts  = {
      mappings  = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      duration_multiplier = 0.7,   -- snappier than default
      easing    = "quadratic",
    },
  },
}
