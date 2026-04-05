-- lazy.lua
-- Plugin manager bootstrap + plugin loading
--
-- lazy.nvim lives at: ~/.local/share/nvim/lazy/lazy.nvim
-- This is OUTSIDE your dotfiles — it gets downloaded automatically
-- You never commit lazy.nvim itself, just your plugin specs

-- ── Bootstrap ─────────────────────────────────────────────
-- stdpath("data") = ~/.local/share/nvim
-- We install lazy inside nvim's data folder, not config folder
-- So it survives config wipes
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- vim.uv.fs_stat checks if path exists on disk
-- if lazy folder not found → first time setup → clone it
if not vim.uv.fs_stat(lazypath) then
  vim.notify("Installing lazy.nvim, please wait...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",   -- partial clone, only download what's needed
                            -- saves bandwidth, faster clone
    "--branch=stable",      -- use stable release not nightly
    "https://github.com/folke/lazy.nvim.git",
    lazypath,               -- clone into our data folder
  })
end

-- Prepend lazy to runtime path
-- so nvim can find and load it with require("lazy")
vim.opt.rtp:prepend(lazypath)

-- ── Load Plugins ──────────────────────────────────────────
-- spec = list of plugin files to load
-- each file in plugins/ returns a table of plugin specs
-- we split by concern so files stay small and focused
require("lazy").setup({

  spec = {
    { import = "user.plugins.ui" },          -- colors, statusline, icons
    { import = "user.plugins.editor" },      -- telescope, autopairs, etc
    { import = "user.plugins.treesitter" },  -- syntax highlighting
    { import = "user.lsp.init" },            -- LSP, completion, formatting
  },

  rocks = {
    enabled = false,
  },

  -- Don't show notification when config changes detected
  change_detection = { notify = false },

  -- UI settings for the lazy popup window
  ui = {
    border = "rounded",    -- rounded border on lazy popup
    size = {
      width = 0.8,         -- 80% of screen width
      height = 0.8,        -- 80% of screen height
    },
  },

  -- Performance tweaks
  performance = {
    rtp = {
      -- Disable built-in plugins we don't use
      -- Reduces startup time
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",    -- we'll use nvim-tree instead
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Open lazy UI with Space+l
vim.keymap.set("n", "<leader>l", ":Lazy<CR>",
  { noremap = true, silent = true, desc = "Open Lazy" })