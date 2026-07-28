-- git.lua
-- Git integration: gitsigns handles the gutter, fugitive handles full
-- Git operations (:Git status buffer — stage, commit, diff, push).

return {
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
                                       -- toggle with Space+gb
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
          map("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", opts)
        end,
      })
    end,
  },

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
}
