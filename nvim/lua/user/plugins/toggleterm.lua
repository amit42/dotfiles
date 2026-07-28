-- toggleterm.lua
-- Floating terminal (Ctrl+\) + the dedicated Claude Code terminal.

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event   = "VeryLazy",              -- defer past first paint; open_mapping registers on load
    config = function()
      require("toggleterm").setup({
        size = 15,                     -- height of terminal
        open_mapping = [[<C-\>]],      -- Ctrl+\ to toggle
        shade_terminals = true,
        start_in_insert = true,        -- terminal opens ready to type
        persist_mode = false,          -- don't restore normal mode on reopen
                                       -- (the C-a/C-q hide maps exit to normal
                                       -- first, which persist_mode would remember)
        direction = "float",           -- float, horizontal, vertical, tab
        float_opts = {
          border = "curved",
        },
      })

      -- ── Claude Code terminal ──────────────────────────────
      -- Plain floating claude — no IDE plugin. Context flows by *typing
      -- @file mentions into claude's prompt for you* via chan_send:
      --   <C-a>       toggle claude (same key opens and closes; also
      --               bound inside the terminal, buffer-local)
      --   <leader>ab  mention current file in claude's input
      --   <leader>as  (visual) mention file + selected line range
      -- The mention is typed without submitting — finish the question
      -- and press enter. The session persists across toggles.
      local Terminal = require("toggleterm.terminal").Terminal
      local claude = Terminal:new({
        -- --continue resumes this project's most recent conversation; it
        -- exits non-zero when there's none yet, so `||` falls back to a
        -- fresh session (same pattern as the ts() workspace launcher).
        cmd        = "claude --continue || claude",
        direction  = "float",
        hidden     = true,             -- not part of the C-\ rotation
        float_opts = { border = "curved", width = function() return math.floor(vim.o.columns * 0.85) end },
        on_open    = function(term)
          -- Same key closes from inside (buffer-local so shells keep C-a)
          vim.keymap.set("t", "<C-a>", [[<C-\><C-n>:close<CR>]],
            { buffer = term.bufnr, silent = true, desc = "Hide claude" })
          vim.cmd("startinsert!")   -- always land in the prompt ready to type
        end,
      })

      -- Type text into claude's input WITHOUT submitting (chan_send adds
      -- no newline, unlike Terminal:send). If the terminal was closed,
      -- open it and give the TUI a moment to boot before typing.
      local function claude_type(text)
        local was_closed = not claude:is_open()
        if was_closed then claude:open() end
        vim.defer_fn(function()
          pcall(vim.api.nvim_chan_send, claude.job_id, text)
        end, was_closed and 400 or 0)
      end

      vim.keymap.set("n", "<C-a>", function() claude:toggle() end,
        { noremap = true, silent = true, desc = "Toggle Claude Code" })

      vim.keymap.set("n", "<leader>ab", function()
        claude_type("@" .. vim.fn.expand("%:.") .. " ")
      end, { noremap = true, silent = true, desc = "Claude: mention current file" })

      vim.keymap.set("v", "<leader>as", function()
        local s, e = vim.fn.line("v"), vim.fn.line(".")
        if s > e then s, e = e, s end
        claude_type(("@%s lines %d-%d "):format(vim.fn.expand("%:."), s, e))
      end, { noremap = true, silent = true, desc = "Claude: mention selection" })
    end,
  },
}
