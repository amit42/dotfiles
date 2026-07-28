-- telescope.lua
-- Fuzzy finder for everything: files, text, git commits, buffers, keymaps.

return {
  {
    "nvim-telescope/telescope.nvim",
    tag   = "v0.2.2",  -- latest stable; includes standalone treesitter implementation
    event = "VeryLazy",  -- defer past first paint; dashboard opens at VimEnter+100ms, well after
    dependencies = {
      "nvim-lua/plenary.nvim",          -- utility functions, required by many plugins
      "DrKJeff16/project.nvim",        -- project detection, enables Telescope projects
      "nvim-telescope/telescope-file-browser.nvim",  -- file browser picker
      "nvim-telescope/telescope-ui-select.nvim",    -- code actions in telescope dropdown
      {
        "nvim-telescope/telescope-fzf-native.nvim",  -- faster fuzzy sorting
        build = "make",                 -- compiles fzf in C on install
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      -- Custom directory previewer: shows contents with devicons, same look as the
      -- file browser entry list. Files fall through to telescope's default previewer.
      local function make_fb_previewer()
        local previewers  = require("telescope.previewers")
        local conf        = require("telescope.config").values
        local _, devicons = pcall(require, "nvim-web-devicons")
        local uv          = vim.uv or vim.loop
        local dir_icon    = "\xef\x90\x93 "   -- U+F413 nerd-font folder

        return previewers.new_buffer_previewer({
          define_preview = function(self, entry)
            local bufnr    = self.state.bufnr
            local filepath = tostring(entry.path or entry.filename or "")
            if filepath == "" then return end

            local stat = uv.fs_stat(filepath)
            if not stat then return end

            if stat.type ~= "directory" then
              conf.buffer_previewer_maker(filepath, bufnr, {
                bufname = self.state.bufname,
                winid   = self.state.winid,
                preview = conf.preview or {},
              })
              return
            end

            local dirs, files = {}, {}
            local scan = uv.fs_scandir(filepath)
            if not scan then return end
            while true do
              local name, ftype = uv.fs_scandir_next(scan)
              if not name then break end
              if ftype == "link" then
                local s = uv.fs_stat(filepath .. "/" .. name)
                ftype = s and s.type or "file"
              end
              if ftype == "directory" then table.insert(dirs, name)
              else table.insert(files, name) end
            end
            table.sort(dirs)
            table.sort(files)

            local lines, hls = {}, {}
            for _, name in ipairs(dirs) do
              table.insert(lines, dir_icon .. name .. "/")
              table.insert(hls, { "TelescopePreviewDirectory", #lines - 1, 0, -1 })
            end
            for _, name in ipairs(files) do
              local icon, hl_grp = "  ", "Normal"
              if devicons then
                local i, g = devicons.get_icon(name, name:match("%.([^%.]+)$"), { default = true })
                if i then icon = i .. " "; hl_grp = g or "Normal" end
              end
              table.insert(lines, icon .. name)
              local ib = #icon
              table.insert(hls, { hl_grp,  #lines - 1, 0,  ib })
              table.insert(hls, { "Normal", #lines - 1, ib, -1 })
            end

            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            for _, h in ipairs(hls) do
              vim.api.nvim_buf_add_highlight(bufnr, 0, h[1], h[2], h[3], h[4])
            end
          end,
        })
      end

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          file_browser = {
            display_stat = false,
            git_status   = false,  -- git icons have variable cell width; disabling prevents entry shifting
            grouped      = true,
            path_display = { "tail" },
          },
        },
        defaults = {
          prompt_prefix  = " ",
          selection_caret = " ",
          entry_prefix   = " ",          -- must match selection_caret width
          path_display   = { "truncate" }, -- paths relative to cwd, no ../ artifacts
          -- Huge-repo ergonomics (ClickHouse-scale, ~65k files):
          -- debounce coalesces keystrokes so live_grep doesn't re-spawn rg
          -- on every character; --max-columns skips pathological lines
          -- (minified/generated) that make ingest slow; --trim drops
          -- leading whitespace so C++ results aren't half indentation.
          debounce = 100,
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case",
            "--trim", "--max-columns=240",
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "*.o",
            "*.elf",
            "build/",
          },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("projects")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")

      -- ── Telescope Keymaps ──────────────────────────────
      -- All under <leader>t
      local map     = vim.keymap.set
      local opts    = { noremap = true, silent = true }
      local builtin = require("telescope.builtin")

      local function file_browser()
        -- Start at the current buffer's directory; fall back to cwd
        -- if the buffer is unnamed (e.g. dashboard, scratch).
        local here = vim.fn.expand("%:p:h")
        if here == "" or vim.bo.filetype == "dashboard" then
          here = vim.fn.getcwd()
        end
        require("telescope").extensions.file_browser.file_browser({
          display_stat  = false,
          git_status    = false,
          grouped       = true,
          path_display  = { "tail" },
          previewer     = make_fb_previewer(),
          path          = here,    -- open at current file's dir
          select_buffer = true,    -- highlight the current file
        })
      end

      -- Files
      map("n", "<leader>tf", builtin.find_files,   opts)
      map("n", "<leader>tr", builtin.oldfiles,     opts)
      map("n", "<leader>te", file_browser,         opts)

      -- Search
      map("n", "<leader>tg", builtin.live_grep,    opts)
      map("n", "<leader>tw", builtin.grep_string,  opts)
      -- Fuzzy search within the current buffer (typo-tolerant, unlike /)
      map("n", "<leader>t/", builtin.current_buffer_fuzzy_find, opts)
      -- Reopen the previous picker with its results intact — no re-search.
      -- In huge repos this is the difference between instant and seconds.
      map("n", "<leader>t.", builtin.resume,       opts)

      -- Buffers / Navigation
      map("n", "<leader>tb", builtin.buffers,                opts)
      map("n", "<leader>tj", builtin.jumplist,               opts)
      map("n", "<leader>tm", builtin.marks,                  opts)

      -- LSP
      map("n", "<leader>ts", builtin.lsp_document_symbols,   opts)
      map("n", "<leader>td", builtin.diagnostics,            opts)

      -- Git / Meta
      map("n", "<leader>tc", builtin.git_commits,            opts)
      map("n", "<leader>tp", ":Telescope projects<CR>",      opts)
      map("n", "<leader>th", builtin.help_tags,              opts)
      map("n", "<leader>tk", builtin.keymaps,                opts)

      -- Space+e → file browser (quick access without full <leader>te)
      map("n", "<leader>e", file_browser, opts)
    end,
  },
}
