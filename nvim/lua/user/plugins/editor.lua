-- editor.lua
-- Editing experience plugins

return {

    -- ── Telescope ─────────────────────────────────────────
    -- Fuzzy finder for everything
    -- files, text, git commits, buffers, keymaps, etc
    {
      "nvim-telescope/telescope.nvim",
      tag = "v0.2.2",  -- latest stable; includes standalone treesitter implementation
      dependencies = {
        "nvim-lua/plenary.nvim",          -- utility functions, required by many plugins
        "DrKJeff16/project.nvim",        -- project detection, enables Telescope projects
        "nvim-telescope/telescope-file-browser.nvim",  -- file browser picker
        "nvim-telescope/telescope-ui-select.nvim",    -- code actions in telescope dropdown
        {
          "nvim-telescope/telescope-fzf-native.nvim",  -- faster fuzzy sorting
          build = "make",                 -- compiles fzf in C on install
        },
      },
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
  
        telescope.setup({
          extensions = {
            -- ui-select replaces vim.ui.select globally
            -- dropdown theme fits code action lists better than the default popup
            ["ui-select"] = {
              require("telescope.themes").get_dropdown(),
            },
          },
          defaults = {
            prompt_prefix = " ",         -- search icon in prompt
            selection_caret = " ",       -- arrow on selected item
            path_display = { "smart" },   -- smart path shortening
            file_ignore_patterns = {      -- never show these in results
              "node_modules",
              ".git/",
              "*.o",                      -- compiled objects (embedded)
              "*.elf",                    -- embedded binaries
              "build/",
            },
            mappings = {
              i = {
                -- inside telescope input
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<Esc>"] = actions.close,
              },
            },
          },
          pickers = {
            find_files = {
              hidden = true,             -- show hidden files (dotfiles)
            },
          },
        })
  
        -- Load fzf extension for faster sorting
        telescope.load_extension("fzf")
        -- Load project.nvim extension for the projects picker
        telescope.load_extension("projects")
        -- Load file browser extension
        telescope.load_extension("file_browser")
        -- Replace vim.ui.select with telescope dropdown
        -- Makes code actions, LSP rename, etc. use telescope UI
        telescope.load_extension("ui-select")

        -- ── Telescope Keymaps ──────────────────────────────
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        map("n", "<leader>f", ":Telescope find_files<CR>",    opts)  -- find files
        map("n", "<leader>g", ":Telescope live_grep<CR>",     opts)  -- search text
        map("n", "<leader>b", ":Telescope buffers<CR>",       opts)  -- open buffers
        map("n", "<leader>h", ":Telescope help_tags<CR>",     opts)  -- help tags
        map("n", "<leader>r", ":Telescope oldfiles<CR>",      opts)  -- recent files
        map("n", "<leader>c", ":Telescope git_commits<CR>",   opts)  -- git commits
        map("n", "<leader>p", ":Telescope projects<CR>",      opts)  -- projects
        -- file browser opens at the directory of the current file
        map("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)
      end,
    },
  
    -- ── File Explorer ──────────────────────────────────────
    -- nvim-tree — sidebar file browser
    -- toggle with Space+e
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        -- Disable netrw — nvim's built in file browser
        -- must be done before nvim-tree loads
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
  
        require("nvim-tree").setup({
          view = {
            width = 30,                  -- sidebar width
            side = "left",
          },
          renderer = {
            group_empty = true,          -- group empty folders
            icons = {
              show = {
                file = true,
                folder = true,
                git = true,              -- show git status icons
              },
            },
          },
          filters = {
            dotfiles = false,            -- show dotfiles
          },
          git = {
            enable = true,               -- show git status in tree
          },
          filesystem_watchers = {
            enable = true,               -- auto-refresh when files change on disk
          },
          actions = {
            refresh = {
              enable = true,
            },
          },
          on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            -- load all default mappings first
            api.config.mappings.default_on_attach(bufnr)
            -- explicit refresh binding in case watcher misses something
            vim.keymap.set("n", "R",
              api.tree.reload,
              { buffer = bufnr, noremap = true, silent = true, desc = "Refresh tree" })
          end,
        })
  
        -- Toggle file explorer
        vim.keymap.set("n", "<leader>e",
          ":NvimTreeToggle<CR>",
          { noremap = true, silent = true })
      end,
    },
  
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
  
    -- ── Git Signs ─────────────────────────────────────────
    -- Shows git changes in the sign column (left gutter)
    -- + = added line
    -- ~ = changed line
    -- - = deleted line
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("gitsigns").setup({
          signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
          },
          current_line_blame = false,    -- show git blame on current line
                                         -- toggle with Space+tb
          on_attach = function(bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, noremap = true, silent = true }
  
            -- Navigate between git hunks (changes)
            map("n", "]h", ":Gitsigns next_hunk<CR>", opts)   -- next change
            map("n", "[h", ":Gitsigns prev_hunk<CR>", opts)   -- prev change
  
            -- Stage/reset individual hunks
            map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
            map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
  
            -- Toggle line blame
            map("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>", opts)
          end,
        })
      end,
    },
  
    -- ── Which Key ─────────────────────────────────────────
    -- Shows available keymaps as you type
    -- Press Space and wait → see all Space+? options
    -- Helps you discover and remember keymaps
    {
      "folke/which-key.nvim",
      event = "VeryLazy",                -- load after everything else
      config = function()
        require("which-key").setup({
          delay = 300,                   -- ms before popup appears
          icons = {
            mappings = true,
          },
        })
  
        -- Register keymap groups
        -- So which-key shows group names not just keys
        require("which-key").add({
          { "<leader>f", desc = "Find files" },
          { "<leader>g", desc = "Live grep" },
          { "<leader>b", desc = "Buffers" },
          { "<leader>e", desc = "Explorer" },
          { "<leader>w", desc = "Save" },
          { "<leader>q", desc = "Quit" },
          { "<leader>l", desc = "Lazy" },
          { "<leader>h", desc = "Help" },
          { "<leader>r", desc = "Recent files" },
          { "<leader>c", desc = "Git commits" },
          { "<leader>p",  desc = "Projects" },
          { "<leader>S",  desc = "Restore session" },
          { "<leader>fb", desc = "File browser" },
          { "<leader>g",  group = "Git" },
          { "<leader>gs", desc = "Git status (fugitive)" },
          { "<leader>gd", desc = "Git diff split" },
          { "<leader>l",  group = "LSP" },
          { "<leader>lq", desc = "Buffer diagnostics (trouble)" },
          { "<leader>lt", desc = "Workspace diagnostics (trouble)" },
          { "<leader>t",  group = "Toggle" },
          { "<leader>tb", desc = "Toggle blame" },
        })
      end,
    },
  
    -- ── Sleuth ────────────────────────────────────────────
    -- Automatically detects tabstop and shiftwidth from the file being edited
    -- No config needed — opens a Go file and it uses tabs; opens a JS file and
    -- it uses 2 spaces. Useful when working across projects with different styles.
    { "tpope/vim-sleuth" },

    -- ── Fugitive ──────────────────────────────────────────
    -- Full Git integration inside neovim
    -- :Git opens the interactive status buffer (stage, commit, diff, push)
    -- Richer than gitsigns alone — gitsigns handles the gutter, fugitive
    -- handles full Git operations
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "Gvdiffsplit", "Gread", "Gwrite" },  -- load only when used
      config = function()
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }

        -- Interactive status window — stage, unstage, commit, push from here
        map("n", "<leader>gs", ":Git<CR>",           opts)
        -- Vertical diff split — current file vs HEAD
        map("n", "<leader>gd", ":Gvdiffsplit<CR>",   opts)
      end,
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

    -- ── Trouble ───────────────────────────────────────────
    -- Diagnostics panel — a proper list of errors/warnings across the project
    -- Better than the quickfix list: grouped by file, filterable, navigable
    -- <leader>lq = current buffer   <leader>lt = whole workspace
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      cmd = "Trouble",   -- lazy load — only opens when first invoked
      config = function()
        require("trouble").setup({
          -- Modes define what gets shown when opened
          -- "diagnostics" is the most useful default
          modes = {
            diagnostics = {
              auto_close  = true,   -- close panel when no diagnostics remain
              auto_preview = true,  -- preview the error location as you navigate
            },
          },
          icons = {
            indent = {
              fold_open  = " ",
              fold_closed = " ",
            },
          },
        })
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

    -- ── Projects ──────────────────────────────────────────
    -- Detects project roots automatically (by .git, go.mod, Cargo.toml etc.)
    -- Integrates with telescope via :Telescope projects (Space+p)
    -- Also changes cwd to the project root when you open a file inside one
    {
      "DrKJeff16/project.nvim",
      -- event = "VeryLazy" would be too late — needs to register roots before
      -- telescope picker is opened, so load immediately but it's very fast
      config = function()
        require("project").setup({
          -- lsp.enabled=true tries LSP root first, falls back to pattern search
          lsp      = { enabled = true },
          -- Root markers — add any build system files your projects use
          patterns = { ".git", "Makefile", "go.mod", "Cargo.toml", "package.json", "pyproject.toml" },
          -- Silently change cwd to project root when opening a file
          silent_chdir = true,
          show_hidden  = false,
        })
      end,
    },

    -- ── Sessions ──────────────────────────────────────────
    -- persistence.nvim saves and restores your buffer/window layout per directory
    -- "s" on the dashboard restores the last session for the current directory
    -- Useful when returning to a project — reopens all your files where you left off
    {
      "folke/persistence.nvim",
      event = "BufReadPre",  -- must load before the first buffer opens to record it
      config = function()
        require("persistence").setup({
          -- Store sessions under nvim's state dir, not config dir
          dir     = vim.fn.stdpath("state") .. "/sessions/",
          -- What to save: open buffers, cwd, tab layout, window sizes
          options = { "buffers", "curdir", "tabpages", "winsize" },
        })

        -- Space+S to manually restore the session for the current directory
        -- (the dashboard "s" button does the same thing)
        vim.keymap.set("n", "<leader>S",
          function() require("persistence").load() end,
          { silent = true, desc = "Restore session" }
        )
      end,
    },

    -- ── Terminal ──────────────────────────────────────────
    -- Floating terminal inside nvim
    -- Press Ctrl+\ to toggle
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          size = 15,                     -- height of terminal
          open_mapping = [[<C-\>]],      -- Ctrl+\ to toggle
          shade_terminals = true,
          direction = "float",           -- float, horizontal, vertical, tab
          float_opts = {
            border = "curved",
          },
        })
      end,
    },

    -- ── Render Markdown ───────────────────────────────────────
    -- Renders markdown in-buffer: headings, code blocks, tables, checkboxes
    -- No browser needed — live preview inside nvim itself
    -- Requires treesitter markdown parser (already in treesitter.lua)
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft           = { "markdown" },
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
      opts = {
        -- Heading levels get progressively indented and colored
        heading = { enabled = true },
        -- Code blocks get a background highlight and the language label
        code = { enabled = true, style = "full" },
        -- Render - [ ] and - [x] as unicode checkboxes
        checkbox = { enabled = true },
        -- Tables rendered with proper border characters
        pipe_table = { enabled = true },
        -- Bullet list markers replaced with unicode symbols
        bullet = { enabled = true },
      },
    },

  }