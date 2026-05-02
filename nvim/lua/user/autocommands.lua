-- autocommands.lua
-- Automatic actions triggered by events
-- vim.api.nvim_create_autocmd(event, options)
--   event   = what triggers it
--   pattern = which files (optional)
--   callback = what to do

-- ── Helper ────────────────────────────────────────────────
-- Group autocommands so they can be cleared and reloaded
-- Prevents duplicates when config is reloaded
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
  end
  
  -- ── Highlight on Yank ─────────────────────────────────────
  -- Briefly flashes what you just copied
  -- Visual confirmation that yank worked
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
      vim.highlight.on_yank({
        higroup = "Visual",   -- use Visual highlight color
        timeout = 200,        -- flash for 200ms
      })
    end,
  })
  
  -- ── Restore Cursor Position ───────────────────────────────
  -- When reopening a file, jump to where cursor was last time
  -- nvim remembers position in ~/.local/share/nvim/shada
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("restore_cursor"),
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local line_count = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
  
  -- ── Auto Resize Splits ────────────────────────────────────
  -- When terminal is resized, equalize all split sizes
  -- So splits don't become lopsided after resize
  vim.api.nvim_create_autocmd("VimResized", {
    group = augroup("resize_splits"),
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  })
  
  -- ── Remove Trailing Whitespace ────────────────────────────
  -- Automatically strip trailing spaces on save
  -- Keeps git diffs clean
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("trim_whitespace"),
    pattern = "*",
    callback = function()
      local save = vim.fn.winsaveview()    -- save cursor position
      vim.cmd([[%s/\s\+$//e]])             -- delete trailing whitespace
      vim.fn.winrestview(save)             -- restore cursor position
    end,
  })
  
  -- ── File Type Settings ────────────────────────────────────
  -- Override settings for specific file types
  -- Because different languages have different conventions
  
  -- C/C++ — embedded code uses 4 spaces typically
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("c_settings"),
    pattern = { "c", "cpp" },
    callback = function()
      vim.opt_local.tabstop    = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.colorcolumn = "80"  -- strict 80 char limit for embedded
    end,
  })
  
  -- Go — uses tabs not spaces (gofmt standard)
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("go_settings"),
    pattern = "go",
    callback = function()
      vim.opt_local.expandtab  = false  -- real tabs for go
      vim.opt_local.tabstop    = 4
      vim.opt_local.shiftwidth = 4
    end,
  })
  
  -- Python — PEP8 standard is 4 spaces
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("python_settings"),
    pattern = "python",
    callback = function()
      vim.opt_local.tabstop    = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.colorcolumn = "79"  -- PEP8 line length
    end,
  })
  
  -- Git commits — wrap and spell so messages are readable
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("gitcommit_settings"),
    pattern = "gitcommit",
    callback = function()
      vim.opt_local.wrap  = true
      vim.opt_local.spell = true
    end,
  })

  -- Markdown — wrap is useful for writing
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_settings"),
    pattern = { "markdown", "md" },
    callback = function()
      vim.opt_local.wrap     = true
      vim.opt_local.spell    = true   -- spell check in markdown
      vim.opt_local.linebreak = true
    end,
  })
  
  -- ── Close Certain Windows With q ──────────────────────────
  -- Lets you press q to close help, man pages, quickfix
  -- Without this you have to type :q every time
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
      "help",
      "man",
      "qf",          -- quickfix list
      "lspinfo",
      "checkhealth",
      "lazy",
      "mason",
      "notify",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", ":close<CR>",
        { buffer = event.buf, silent = true })
    end,
  })
  
  -- ── Telescope Window Overrides ───────────────────────────
  -- sidescrolloff=8 (options.lua) causes telescope results to scroll right
  -- because entries are padded to fill the window. Zero it out only for
  -- telescope buffers so other windows keep their margin.
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("telescope_win_opts"),
    pattern = { "TelescopeResults", "TelescopePrompt", "TelescopePreview" },
    callback = function()
      vim.opt_local.sidescrolloff = 0
      vim.opt_local.scrolloff     = 0
    end,
  })

  -- ── Show Dashboard on Startup ─────────────────────────────
  -- Handles: nvim (empty), nvim . (directory), nvim-tree restored by resurrect.
  -- Deferred 100ms so all plugins (dashboard, nvim-tree) are fully loaded.
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("startup_dashboard"),
    once  = true,
    callback = function()
      vim.defer_fn(function()
        local ft      = vim.bo.filetype
        local bufname = vim.api.nvim_buf_get_name(0)
        local is_empty = bufname == "" and (ft == "" or ft == "dashboard")
        local is_dir   = vim.fn.isdirectory(bufname) == 1
        local is_tree  = ft == "NvimTree"

        if is_empty or is_dir or is_tree then
          if is_dir then vim.cmd("cd " .. vim.fn.fnameescape(bufname)) end
          pcall(vim.cmd, "NvimTreeClose")
          require("user.dashboard").open()
        end
      end, 100)
    end,
  })

  -- ── Dashboard on Last Buffer Close ────────────────────────
  -- When the last real (listed) buffer is deleted, show the dashboard
  -- instead of leaving an empty unnamed buffer.
  vim.api.nvim_create_autocmd("BufDelete", {
    group = augroup("dashboard_on_last_buffer"),
    callback = function(event)
      if not vim.bo[event.buf].buflisted then return end
      vim.schedule(function()
        local bufs = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
        end, vim.api.nvim_list_bufs())
        if #bufs == 0 then
          require("user.dashboard").open()
        end
      end)
    end,
  })

  -- ── Restore Line Numbers After Dashboard ─────────────────
  -- Backstop: if any code path leaves number=false on a normal edit window,
  -- BufWinEnter resets it. buftype=="" means a real file, not a plugin panel.
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("restore_number_after_dashboard"),
    callback = function()
      if vim.bo.buftype == "" and vim.bo.filetype ~= "dashboard" then
        vim.wo.number         = true
        vim.wo.relativenumber = true
        vim.wo.signcolumn     = "yes"
        vim.wo.cursorline     = true
      end
    end,
  })

  -- ── Auto Create Dir on Save ───────────────────────────────
  -- If you save a file in a folder that doesn't exist
  -- automatically create the folder
  -- e.g. :w lua/new/folder/file.lua → creates lua/new/folder/
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup("auto_create_dir"),
    callback = function(event)
      local file = vim.loop.fs_realpath(event.match)
        or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  })