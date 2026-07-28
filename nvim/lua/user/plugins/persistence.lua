-- persistence.lua
-- Sessions: saves your buffer/window layout per directory on quit and
-- restores it on the next launch in the same directory.
--   - Auto-save: happens on VimLeavePre (no action needed)
--   - Auto-restore: on `nvim` with no args, before the dashboard would open
--   - Manual restore: <leader>S

return {
  {
    "folke/persistence.nvim",
    lazy = false,                            -- need it loaded at VimEnter for auto-restore
    priority = 900,                          -- load early but after colorscheme (1000)
    config = function()
      require("persistence").setup({
        dir     = vim.fn.stdpath("state") .. "/sessions/",
        options = { "buffers", "curdir", "tabpages", "winsize" },
        -- Default `need = 1` skips the autosave when no real file
        -- buffers are open. Setting to 0 means every save attempt
        -- writes — including "empty" — so the on-disk session can't
        -- get stuck on a stale state.
        need = 0,
      })

      -- Save the session on common state changes too, not just on
      -- VimLeavePre. VimLeavePre never fires when the laptop sleeps,
      -- crashes, loses power, or nvim is SIGKILL'd — so a clean-quit-
      -- only save can leave the on-disk session badly out of date.
      -- Throttled to 2s so rapid events don't thrash the disk.
      local save_pending = false
      local function schedule_save()
        if save_pending then return end
        save_pending = true
        vim.defer_fn(function()
          save_pending = false
          pcall(function() require("persistence").save() end)
        end, 2000)
      end
      vim.api.nvim_create_autocmd(
        { "BufWritePost", "BufAdd", "BufDelete", "FocusLost" },
        {
          group    = vim.api.nvim_create_augroup("persistence_extra_save", { clear = true }),
          callback = schedule_save,
        }
      )

      -- Auto-restore on bare `nvim` (no file args). Runs before the
      -- dashboard's deferred VimEnter check (100ms), so if a session
      -- existed, buffers are populated and the dashboard skips itself.
      -- If no session exists, persistence.load() is a no-op and the
      -- dashboard opens as usual.
      vim.api.nvim_create_autocmd("VimEnter", {
        group  = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
        nested = true,
        callback = function()
          if vim.fn.argc(-1) == 0 then
            pcall(function() require("persistence").load() end)
            -- The buffer persistence makes active gets a stale half-attach
            -- from render-markdown / image.nvim / treesitter — only the
            -- active one, the other tabs are fine because BufEnter fires
            -- normally on switch. Force a fresh :edit on it to redo every
            -- attach cleanly. Cursor position is preserved by view save/restore.
            if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
              local view = vim.fn.winsaveview()
              vim.cmd("edit!")
              vim.fn.winrestview(view)
            end
          end
        end,
      })

      -- Manual restore — wipe any nomodifiable scratch (dashboard) first
      -- so persistence can populate buffers cleanly.
      vim.keymap.set("n", "<leader>S", function()
        vim.cmd("silent! %bwipeout!")
        require("persistence").load()
      end, { silent = true, desc = "Restore session" })
    end,
  },
}
