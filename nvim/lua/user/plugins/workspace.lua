-- workspace.lua
-- Project awareness, which-key discovery, diagnostics panel, and
-- project-wide search/replace.

return {

  -- ── Which Key ─────────────────────────────────────────
  -- Shows available keymaps as you type
  -- Press Space and wait → see all Space+? options
  -- Helps you discover and remember keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",                -- load after everything else
    config = function()
      require("which-key").setup({
        delay = 300,                   -- ms before popup appears
        icons = {
          mappings = true,
        },
      })

      -- Register keymap groups
      -- So which-key shows group names not just keys
      require("which-key").add({
        { "<leader>d",  desc = "Open dashboard" },
        { "<leader>u",  desc = "Undo tree" },
        { "<leader>s",  group = "Spectre" },
        { "<leader>sr", desc = "Project search/replace" },
        { "<leader>sw", desc = "Search word under cursor" },
        { "<leader>sf", desc = "Search in current file" },
        { "<leader>e",  desc = "File browser (telescope)" },
        { "<leader>n",  desc = "Toggle file tree" },
        { "<leader>w",  desc = "Save" },
        { "<leader>q",  desc = "Quit" },
        { "<leader>S",  desc = "Restore session" },
        { "<leader>g",  group = "Git" },
        { "<leader>gs", desc = "Git status (fugitive)" },
        { "<leader>gd", desc = "Git diff split" },
        { "<leader>gb", desc = "Toggle blame" },
        { "<leader>l",  group = "LSP" },
        { "<leader>lq", desc = "Buffer diagnostics (trouble)" },
        { "<leader>lt", desc = "Workspace diagnostics (trouble)" },
        { "<leader>t",  group = "Telescope" },
        { "<leader>tf", desc = "Find files" },
        { "<leader>tr", desc = "Recent files" },
        { "<leader>te", desc = "File browser" },
        { "<leader>tg", desc = "Live grep" },
        { "<leader>tw", desc = "Grep word under cursor" },
        { "<leader>tb", desc = "Open buffers" },
        { "<leader>tj", desc = "Jump list" },
        { "<leader>tm", desc = "Marks" },
        { "<leader>ts", desc = "Symbols in file" },
        { "<leader>td", desc = "Diagnostics" },
        { "<leader>tc", desc = "Git commits" },
        { "<leader>tp", desc = "Projects" },
        { "<leader>th", desc = "Help tags" },
        { "<leader>tk", desc = "Keymaps" },
      })
    end,
  },

  -- ── Trouble ───────────────────────────────────────────
  -- Diagnostics panel — a proper list of errors/warnings across the project
  -- Better than the quickfix list: grouped by file, filterable, navigable
  -- <leader>lq = current buffer   <leader>lt = whole workspace
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",   -- lazy load — only opens when first invoked
    config = function()
      require("trouble").setup({
        -- Modes define what gets shown when opened
        -- "diagnostics" is the most useful default
        modes = {
          diagnostics = {
            auto_close  = true,   -- close panel when no diagnostics remain
            auto_preview = true,  -- preview the error location as you navigate
          },
        },
        icons = {
          indent = {
            fold_open  = " ",
            fold_closed = " ",
          },
        },
      })
    end,
  },

  -- ── Projects ──────────────────────────────────────────
  -- Detects project roots automatically (by .git, go.mod, Cargo.toml etc.)
  -- Integrates with telescope via :Telescope projects (Space+p)
  -- Also changes cwd to the project root when you open a file inside one
  {
    "DrKJeff16/project.nvim",
    -- event = "VeryLazy" would be too late — needs to register roots before
    -- telescope picker is opened, so load immediately but it's very fast
    config = function()
      -- Self-heal: project.nvim writes project_history.json on every
      -- BufDelete with no file locking. Two concurrent nvim instances race
      -- and corrupt the JSON, then the plugin hard-errors at history.lua:619
      -- on every buffer close until the file is deleted by hand. Reset it
      -- at startup if it fails to parse — cheap, and the recent-project
      -- list rebuilds itself as you open projects.
      local hist = vim.fn.stdpath("data") .. "/project_nvim/project_history.json"
      if vim.fn.filereadable(hist) == 1 then
        local ok = pcall(vim.json.decode, table.concat(vim.fn.readfile(hist), "\n"))
        if not ok then
          vim.notify("project.nvim: history JSON was corrupt, resetting", vim.log.levels.WARN)
          vim.fn.writefile({ "[]" }, hist)
        end
      end

      require("project").setup({
        -- lsp.enabled=true tries LSP root first, falls back to pattern search
        lsp      = { enabled = true },
        -- Root markers — add any build system files your projects use
        patterns = { ".git", "Makefile", "go.mod", "Cargo.toml", "package.json", "pyproject.toml" },
        -- Silently change cwd to project root when opening a file
        silent_chdir = true,
        show_hidden  = false,
      })
    end,
  },

  -- ── Spectre ───────────────────────────────────────────────
  -- Project-wide find + replace with regex, live preview, and
  -- per-file confirmation before writing.
  -- <leader>sr  open Spectre (search whole project)
  -- <leader>sw  search for word under cursor across project
  -- <leader>sf  search + replace in current file only
  -- Inside Spectre:
  --   <leader>r  replace all matches
  --   <leader>rc replace match under cursor
  --   dd         exclude a match from the replacement
  --   Tab        toggle between search and replace fields
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd  = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").toggle() end,                              desc = "Spectre: project search/replace" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,   desc = "Spectre: search word under cursor", mode = { "n", "v" } },
      { "<leader>sf", function() require("spectre").open_file_search() end,                    desc = "Spectre: search in current file" },
    },
    config = function()
      require("spectre").setup({
        replace_vim_cmd = "cdo",
        highlight = {
          search  = "DiffChange",
          replace = "DiffDelete",
        },
      })
    end,
  },
}
