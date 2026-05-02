-- keymaps.lua
-- All keybindings in one place
-- Modes:
--   "n" = normal
--   "i" = insert
--   "v" = visual
--   "x" = visual block
--   "t" = terminal
--   "c" = command

-- ── Setup ─────────────────────────────────────────────────

local keymap = vim.keymap.set

local opts = {
  noremap = true,   -- don't allow remapping of this key
                    -- prevents infinite loops in key chains
  silent = true,    -- don't print the command in command line
}

local term_opts = {
  silent = true,    -- terminal mode only needs silent
                    -- noremap doesn't apply in terminal mode
}

-- ── Leader Key ────────────────────────────────────────────
-- Must be set BEFORE any leader keymaps
-- Space is most ergonomic — thumb press
-- <Nop> on Space in all modes first
-- prevents Space from moving cursor while leader is processing
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Normal Mode ───────────────────────────────────────────

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", opts)          -- Space+w = save
keymap("n", "<leader>q", ":q<CR>", opts)          -- Space+q = quit
keymap("n", "<leader>Q", ":qa!<CR>", opts)        -- Space+Q = force quit all

-- Clear search highlights
-- after searching, press Escape to clear highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Window navigation
-- Ctrl+hjkl to move between splits
-- much faster than Ctrl+w then hjkl
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize splits with arrows
-- Ctrl+arrows to resize current split
keymap("n", "<C-Up>",    ":resize -2<CR>", opts)
keymap("n", "<C-Down>",  ":resize +2<CR>", opts)
keymap("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
-- Shift+l/h to cycle through open buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>x", ":Bdelete<CR>", opts)    -- close buffer, keep window layout (vim-bbye)

-- Stay centered when scrolling
-- zz recenters screen after jump
-- so code always stays in middle of screen
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Stay centered when searching
-- n/N jump to next/prev match
-- zzzv = center screen + open folds if any
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Move lines up and down in normal mode
-- Alt+j/k shifts current line
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- ── Insert Mode ───────────────────────────────────────────

-- jk to exit insert mode
-- faster than reaching for Escape key
-- kj removed — causes accidental triggers
keymap("i", "jk", "<ESC>", opts)

-- ── Visual Mode ───────────────────────────────────────────

-- Stay in indent mode after indenting
-- normally < and > drop you out of visual mode
-- ^ moves to first non-blank character
keymap("v", "<", "<gv^", opts)
keymap("v", ">", ">gv^", opts)

-- Move selected lines up and down
-- gv reselects previous selection after move
-- = auto-indents reselected block
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Paste over selection without losing clipboard
-- "_dP = delete to black hole register, then paste
-- normally pasting over selection overwrites your clipboard
keymap("v", "p", '"_dP', opts)

-- ── Visual Block Mode ─────────────────────────────────────

-- Move selected block up and down
-- same as visual mode but for block selections (Ctrl+v)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Paste in visual block without losing clipboard
keymap("x", "p", '"_dP', opts)

-- ── Terminal Mode ─────────────────────────────────────────

-- Navigate out of terminal splits with Ctrl+hjkl
-- <C-\><C-N> exits terminal mode first
-- then <C-w>h moves to the split
-- lets you use same window nav keys in terminal
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- Lazy lua
keymap("n", "<leader>l", ":Lazy<CR>", opts)

-- WSL: gx opens URLs via Windows cmd.exe instead of xdg-open (which times out in WSL)
if vim.fn.has("wsl") == 1 then
  vim.ui.open = function(path)
    vim.fn.jobstart({ "cmd.exe", "/c", "start", "", path }, { detach = true })
  end
end
