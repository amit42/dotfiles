-- options.lua
-- Core vim settings — no plugins required
-- Using key-value table pattern for cleanliness
-- vim.opt[k] = v is same as vim.opt.number = true etc

local options = {

    -- ── Files ─────────────────────────────────────────────
    backup      = false,        -- don't create backup files (file.txt~)
    swapfile    = false,        -- don't create .swp files
    writebackup = false,        -- don't create temp backup during write
    undofile    = true,         -- save undo history to file
                                -- survives closing and reopening nvim
    fileencoding = "utf-8",     -- always write files as utf-8
  
    -- ── Clipboard ─────────────────────────────────────────
    clipboard = "unnamedplus",  -- sync nvim clipboard with system clipboard
                                -- yank in nvim → paste in browser etc
                                -- and vice versa
  
    -- ── Appearance ────────────────────────────────────────
    termguicolors = true,       -- enable full RGB color support
                                -- required for most colorschemes
    number         = true,      -- show line number on current line
    relativenumber = true,      -- show relative numbers on all other lines
                                -- lets you jump: 5j goes down 5 lines
    numberwidth    = 2,         -- width of number column (default 4, 2 is cleaner)
    cursorline     = true,      -- highlight entire line cursor is on
    signcolumn     = "yes",     -- always show sign column on left
                                -- prevents text shifting when signs appear
                                -- signs = git changes, errors, warnings
    showtabline    = 2,         -- always show tab/buffer line at top
    showmode       = false,     -- hide -- INSERT -- at bottom
                                -- statusline plugin shows this instead
    cmdheight      = 1,         -- command line height at bottom
    pumheight      = 10,        -- max items shown in autocomplete popup
    pumblend       = 10,        -- slight transparency on popup menu
    winblend       = 0,         -- transparency for floating windows
    conceallevel   = 0,         -- show `` in markdown files (don't hide)
    colorcolumn    = "120",     -- subtle vertical guide at col 120
    wrap           = false,     -- don't wrap long lines
                                -- horizontal scroll instead
    scrolloff      = 8,         -- keep 8 lines above/below cursor always
                                -- so cursor never hits top/bottom edge
    sidescrolloff  = 8,         -- keep 8 columns left/right of cursor
  
    -- ── Search ────────────────────────────────────────────
    hlsearch   = false,         -- clear highlights after search done
                                -- press n/N to search again
    incsearch  = true,          -- highlight matches AS you type search
    ignorecase = true,          -- /foo matches foo, Foo, FOO
    smartcase  = true,          -- /Foo only matches Foo
                                -- uppercase in pattern = case sensitive
  
    -- ── Indentation ───────────────────────────────────────
    expandtab   = true,         -- pressing Tab inserts spaces not \t
    tabstop     = 2,            -- tab character displays as 2 spaces
    shiftwidth  = 2,            -- >> and << shift by 2 spaces
    smartindent = true,         -- auto indent new lines based on context
  
    -- ── Splits ────────────────────────────────────────────
    splitbelow = true,          -- :split opens below current window
    splitright = true,          -- :vsplit opens right of current window
  
    -- ── Feel ──────────────────────────────────────────────
    mouse       = "a",          -- enable mouse in all modes
    updatetime  = 100,          -- ms before CursorHold fires
                                -- affects git signs refresh speed
                                -- and LSP hover speed
    timeoutlen  = 300,          -- ms to wait for mapped key sequence
                                -- lower = which-key appears faster
    completeopt = {             -- autocomplete behavior
      "menuone",                -- show menu even with one item
      "noselect",               -- don't auto select first item
    },
  
    -- ── Line behavior ─────────────────────────────────────
    whichwrap = "bs<>[]hl",     -- allow these keys to move to prev/next line
                                -- b=backspace, s=space, arrows, h, l
    linebreak = true,           -- if wrap=true, break at word boundary
                                -- not mid-word
  }
  
  -- Apply all options
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
  
  -- ── Append options (can't use = for these) ────────────────
  vim.opt.shortmess:append "c"             -- suppress autocomplete messages
                                           -- like "match 1 of 5"
  vim.opt.iskeyword:append "-"             -- treat hyphenated-words as one word
                                           -- for w, b, e motions
  vim.opt.formatoptions:remove { "c", "r", "o" }  -- don't auto insert comment
                                                   -- leader on new lines

  -- exrc: auto-load .nvim.lua from the project root when nvim starts there.
  -- secure: only runs if owned by you — prevents malicious project configs.
  vim.opt.exrc   = true
  vim.opt.secure = true