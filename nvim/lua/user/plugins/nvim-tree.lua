-- nvim-tree.lua
-- File explorer — floating, centered tree.
-- Space+n toggles it, Space+e opens the telescope file browser instead.

return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",  -- loads right after UI paint — before the deferred dashboard autocmd needs NvimTreeClose
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Disable netrw — nvim's built in file browser
      -- must be done before nvim-tree loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        hijack_directories = { enable = false },  -- let VimEnter autocmd handle nvim . → dashboard
        sync_root_with_cwd        = true,         -- :cd updates the tree root
        respect_buf_cwd           = true,         -- match per-buffer cwd
        update_focused_file = {
          enable      = true,        -- highlight current buffer's file in the tree
          update_root = false,       -- don't chase the cwd around as you switch buffers
        },
        view = {
          -- Floating, centered, rounded border. Auto-closes when focus leaves.
          -- Width still auto-fits to the longest visible name within bounds.
          width = { min = 30, max = 60, padding = 2 },
          side  = "left",
          preserve_window_proportions = true,
          signcolumn = "yes",
          float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = function()
              local cols   = vim.o.columns
              local rows   = vim.o.lines - vim.o.cmdheight - 1
              local width  = math.min(90, math.max(55, math.floor(cols * 0.4)))
              local height = math.floor(rows * 0.85)
              return {
                relative = "editor",
                border   = "rounded",
                width    = width,
                height   = height,
                row      = math.floor((rows  - height) / 2),
                col      = math.floor((cols  - width)  / 2),
              }
            end,
          },
        },
        renderer = {
          group_empty           = true,
          highlight_git         = "name",
          highlight_opened_files = "name",
          add_trailing          = true,            -- foo/ instead of foo for dirs
          root_folder_label     = false,           -- hide the absolute-path header
          indent_markers = {
            enable = true,
            icons  = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
          },
          special_files  = {
            "README.md", "Makefile", "CMakeLists.txt", "package.json", "Cargo.toml",
          },
          icons = {
            git_placement = "after",
            show          = { file = true, folder = true, git = true, modified = true },
            glyphs = {
              modified = "●",
              folder   = {
                arrow_closed = "▸",
                arrow_open   = "▾",
                default      = "",
                open         = "",
                empty        = "",
                empty_open   = "",
                symlink      = "",
                symlink_open = "",
              },
              git = { unstaged = "~", staged = "+", untracked = "?", renamed = "→", deleted = "-", ignored = "·" },
            },
          },
        },
        filters     = { dotfiles = false },        -- still showing dotfiles by default
        git         = { enable = true, ignore = false },
        diagnostics = { enable = false },          -- no LSP warn/error glyphs in the tree
        modified    = { enable = true },           -- show ● on unsaved buffers in the tree
        filesystem_watchers = { enable = true },
        actions = {
          open_file = {
            resize_window = true,
            window_picker = { enable = false },    -- open in the last-active window, no picker prompt
          },
          change_dir = { enable = true, global = false },
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          -- Cursorline only in the tree window (default options.lua leaves it off
          -- globally to keep editor distraction-free).
          vim.wo.cursorline = true
          vim.wo.statuscolumn = ""
          local k = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs,
              { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = desc })
          end
          -- vim-feel navigation
          k("l", api.node.open.edit,        "Open / expand")
          k("h", api.node.navigate.parent_close, "Close parent")
          k("H", api.tree.collapse_all,     "Collapse all")
          k("E", api.tree.expand_all,       "Expand all")
          k("R", api.tree.reload,           "Refresh tree")
          k("?", api.tree.toggle_help,      "Help")
          -- splits
          k("<C-x>", api.node.open.horizontal, "Open in horizontal split")
          k("<C-v>", api.node.open.vertical,   "Open in vertical split")
          k("<C-t>", api.node.open.tab,        "Open in new tab")
        end,
      })

      vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>",
        { noremap = true, silent = true, desc = "Toggle file tree" })
    end,
  },
}
