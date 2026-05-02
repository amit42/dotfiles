-- ui.lua
-- Visual plugins — colorscheme, statusline, bufferline, icons
-- Each plugin is a table with at minimum a github "owner/repo" string
-- lazy.nvim reads these and installs/loads them

return {

    -- ── Icons ───────────────────────────────────────────────
    -- Required by many other plugins (lualine, bufferline, nvim-tree)
    -- Provides file type icons
    -- Needs a Nerd Font installed in your terminal to render
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,   -- don't load until another plugin needs it
    },
  
    -- ── Colorscheme ─────────────────────────────────────────
    -- Catppuccin — modern, well maintained, works great with LSP colors
    -- Has four flavors: latte (light), frappe, macchiato, mocha (darkest)
    {
      "catppuccin/nvim",
      name = "catppuccin",   -- name it so we can reference it
      priority = 1000,       -- load this FIRST before other plugins
                             -- colorscheme must load early or other
                             -- plugins get wrong highlight colors
      config = function()
        require("catppuccin").setup({
          flavour = "mocha",          -- darkest variant
          transparent_background = false,
          term_colors = true,         -- set terminal colors too
          integrations = {
            -- tell catppuccin to theme these plugins too
            -- adds correct highlight groups for each
            cmp        = true,
            gitsigns   = true,
            nvimtree   = true,
            telescope  = true,
            treesitter = true,
            bufferline = true,
            which_key  = true,
            mason      = true,
            noice      = true,
            native_lsp = {
              enabled = true,
            },
          },
        })
  
        -- Actually apply the colorscheme
        -- Must be called after setup()
        vim.cmd.colorscheme("catppuccin")
      end,
    },
  
    -- ── Statusline ──────────────────────────────────────────
    -- Lualine — shows info at bottom of screen
    -- mode, git branch, file name, errors, file type, cursor position
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",  -- needs icons
      },
      config = function()
        require("lualine").setup({
          options = {
            theme = "catppuccin-mocha",       -- match our colorscheme
            globalstatus = true,        -- one statusline for all splits
                                        -- instead of one per split
            component_separators = { left = "", right = "" },
            section_separators   = { left = "", right = "" },
          },
          sections = {
            -- left side of statusline
            lualine_a = { "mode" },           -- NORMAL / INSERT etc
            lualine_b = { "branch", "diff", "diagnostics" }, -- git info
            lualine_c = { { "filename", path = 1 } }, -- relative file path
  
            -- right side of statusline
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },       -- percentage through file
            lualine_z = { "location" },       -- line:column
          },
        })
      end,
    },
  
    -- ── Indent Guides ───────────────────────────────────────
    -- Draws vertical lines at each indentation level
    -- Scope highlight shows the block the cursor is currently inside
    -- Makes deeply nested code much easier to read at a glance
    {
      "lukas-reineke/indent-blankline.nvim",
      main  = "ibl",   -- v3 uses "ibl" module, not "indent_blankline"
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("ibl").setup({
          indent = {
            char      = "▎",   -- thin left-aligned bar, less visual noise than │
            tab_char  = "▎",
          },
          scope = {
            enabled    = true,   -- highlight the current scope (function, if, loop)
            show_start = true,
            show_end   = false,  -- end marker adds clutter without much value
          },
          -- Don't draw guides in UI buffers where they look wrong
          exclude = {
            filetypes = {
              "dashboard", "lazy", "mason", "help",  -- "dashboard" = our custom filetype
              "terminal", "toggleterm", "NvimTree",
            },
          },
        })
      end,
    },

    -- ── Floating Command Line ───────────────────────────────
    -- noice.nvim — replaces the bottom cmdline with a centered float.
    -- Only cmdline is floated; messages, notifications, and LSP hover stay native
    -- to avoid conflicts with other plugins.
    {
      "folke/noice.nvim",
      event        = "VeryLazy",
      dependencies = { "MunifTanjim/nui.nvim" },
      config = function()
        require("noice").setup({
          cmdline = {
            enabled = true,
            view    = "cmdline_popup",
          },
          messages = { enabled = false },
          notify   = { enabled = false },
          lsp = {
            progress  = { enabled = false },
            hover     = { enabled = false },
            signature = { enabled = false },
            message   = { enabled = false },
          },
          views = {
            cmdline_popup = {
              position    = { row = "45%", col = "50%" },
              size        = { width = 64, height = "auto" },
              border      = { style = "rounded" },
              win_options = { winblend = 15 },
            },
            popupmenu = {
              relative    = "editor",
              position    = { row = "55%", col = "50%" },
              size        = { width = 64, height = 10 },
              border      = { style = "rounded" },
              win_options = { winblend = 15 },
            },
          },
        })
      end,
    },

    -- ── Bufferline ──────────────────────────────────────────
    -- Shows open buffers as tabs at top of screen
    -- Shift+l / Shift+h to switch (we set this in keymaps)
    {
      "akinsho/bufferline.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("bufferline").setup({
          options = {
            mode = "buffers",             -- show buffers not tabs
            separator_style = "slant",    -- slanted separators look nice
            always_show_bufferline = true,
            show_buffer_close_icons = true,
            show_close_icon = false,
            color_icons = true,
            diagnostics = "nvim_lsp",     -- show LSP errors on buffer tabs
            offsets = {
              {
                filetype = "NvimTree",    -- when file tree is open
                text = "File Explorer",   -- show this label
                highlight = "Directory",
                separator = true,
              },
            },
          },
        })
      end,
    },
  
  }