-- ui.lua
-- Visual plugins — colorscheme, statusline, bufferline, icons
-- Each plugin is a table with at minimum a github "owner/repo" string
-- lazy.nvim reads these and installs/loads them

-- ── Theme selection ───────────────────────────────────────
-- The active theme name lives in ~/.config/dotfiles-theme (one line),
-- written by `bash install.sh --theme <name>`. Reading it here keeps the
-- deployed config byte-identical to the repo (no drift). All theme
-- plugins stay installed (they're in the lockfile); only the active one
-- loads at startup, so switching costs nothing.
local THEMES = {
  ["catppuccin-mocha"] = "catppuccin",
  ["tokyonight"]       = "tokyonight-night",
  ["gruvbox"]          = "gruvbox",
  ["kanagawa"]         = "kanagawa-wave",
  ["rose-pine"]        = "rose-pine",
  ["nord"]             = "nord",
  ["dracula"]          = "dracula",
  ["everforest"]       = "everforest",
  ["onedark"]          = "onedark",
}

local function dotfiles_theme()
  local f = io.open(vim.fn.expand("~/.config/dotfiles-theme"), "r")
  if not f then return "catppuccin-mocha" end
  local name = (f:read("*l") or ""):gsub("%s+$", "")
  f:close()
  return THEMES[name] and name or "catppuccin-mocha"
end

local THEME       = dotfiles_theme()
local COLORSCHEME = THEMES[THEME]

-- Shared by every theme plugin spec: only the active theme loads eagerly
-- (colorschemes must load before other plugins or highlights break).
local function theme_spec(key, spec)
  local active = (key == THEME)
  spec.lazy     = not active
  spec.priority = active and 1000 or nil
  if not active then spec.config = nil end   -- don't run setup for inactive themes
  return spec
end

return {

    -- ── Icons ───────────────────────────────────────────────
    -- Required by many other plugins (lualine, bufferline, nvim-tree)
    -- Provides file type icons
    -- Needs a Nerd Font installed in your terminal to render
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,   -- don't load until another plugin needs it
    },

    -- ── Colorschemes ─────────────────────────────────────────
    -- One plugin per supported theme; theme_spec() makes exactly one of
    -- them load. Switch with: bash install.sh --theme <name>
    theme_spec("catppuccin-mocha", {
      "catppuccin/nvim",
      name = "catppuccin",
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
        vim.cmd.colorscheme("catppuccin")
      end,
    }),

    theme_spec("tokyonight", {
      "folke/tokyonight.nvim",
      config = function()
        require("tokyonight").setup({ style = "night" })
        vim.cmd.colorscheme("tokyonight-night")
      end,
    }),

    theme_spec("gruvbox", {
      "ellisonleao/gruvbox.nvim",
      config = function()
        require("gruvbox").setup({})
        vim.cmd.colorscheme("gruvbox")
      end,
    }),

    theme_spec("kanagawa", {
      "rebelot/kanagawa.nvim",
      config = function()
        require("kanagawa").setup({ theme = "wave" })
        vim.cmd.colorscheme("kanagawa-wave")
      end,
    }),

    theme_spec("rose-pine", {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({ variant = "main" })
        vim.cmd.colorscheme("rose-pine")
      end,
    }),

    theme_spec("nord", {
      "gbprod/nord.nvim",
      config = function()
        require("nord").setup({})
        vim.cmd.colorscheme("nord")
      end,
    }),

    theme_spec("dracula", {
      "Mofiqul/dracula.nvim",
      config = function()
        require("dracula").setup({})
        vim.cmd.colorscheme("dracula")
      end,
    }),

    theme_spec("everforest", {
      "neanias/everforest-nvim",
      config = function()
        require("everforest").setup({ background = "hard" })
        vim.cmd.colorscheme("everforest")
      end,
    }),

    theme_spec("onedark", {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({ style = "dark" })
        require("onedark").load()
      end,
    }),
  
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
            theme = "auto",             -- adapts to whichever colorscheme is active
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
        -- Slant separators are triangles colored like the editor bg to
        -- blend in — with wallpaper transparency (autocommands.lua) that
        -- bg is gone and they render as visible triangles. Same check as
        -- the transparency autocmd: wallpaper on → thin separators.
        local wallpaper = false
        local f = io.open(vim.fn.expand("~/.config/dotfiles-wallpaper"), "r")
        if f then
          local p = (f:read("*l") or ""):gsub("%s+$", "")
          f:close()
          wallpaper = p ~= "" and vim.fn.filereadable(vim.fn.expand(p)) == 1
        end

        -- Pull colors from the ACTIVE colorscheme's groups so the active
        -- tab styling follows all 9 themes with zero hardcoded hex:
        --   accent = Function fg (the theme's primary accent)
        --   surface = CursorLine bg (the theme's raised-surface tone)
        local function hl(group, attr)
          local h = vim.api.nvim_get_hl(0, { name = group, link = false })
          return h[attr]
        end
        local accent  = hl("Function", "fg")
        local surface = hl("CursorLine", "bg")
        local normfg  = hl("Normal", "fg")
        local dimfg   = hl("Comment", "fg")

        require("bufferline").setup({
          options = {
            mode = "buffers",             -- show buffers not tabs
            separator_style = wallpaper and "thin" or "slant",
            always_show_bufferline = true,
            show_buffer_close_icons = true,
            show_close_icon = false,
            color_icons = true,
            diagnostics = "nvim_lsp",     -- show LSP errors on buffer tabs
            -- thick accent bar on the active tab's left edge
            indicator = { icon = "▎", style = "icon" },
            offsets = {
              {
                filetype = "NvimTree",    -- when file tree is open
                text = "File Explorer",   -- show this label
                highlight = "Directory",
                separator = true,
              },
            },
          },
          -- Active tab = solid surface pill + bold + accent marker;
          -- inactive tabs recede into dim fg. Reads instantly, even
          -- over a wallpaper-transparent background.
          highlights = {
            background         = { fg = dimfg },
            buffer_selected    = { fg = normfg, bg = surface, bold = true, italic = false },
            indicator_selected = { fg = accent, bg = surface },
            close_button_selected = { bg = surface },
            modified_selected  = { bg = surface },
            duplicate_selected = { bg = surface, italic = true },
            separator_selected = { bg = surface },
            diagnostic_selected = { bg = surface },
            error_selected     = { bg = surface, bold = true },
            warning_selected   = { bg = surface, bold = true },
            info_selected      = { bg = surface, bold = true },
            hint_selected      = { bg = surface, bold = true },
          },
        })
      end,
    },
  
  }