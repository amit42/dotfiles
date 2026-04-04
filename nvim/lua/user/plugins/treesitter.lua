-- treesitter.lua
-- Syntax highlighting and code understanding
-- Treesitter parses code into an AST (Abstract Syntax Tree)
-- giving nvim actual understanding of code structure

return {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",              -- update parsers when plugin updates
      event = { "BufReadPre", "BufNewFile" },  -- load when opening a file
      dependencies = {
        -- Text objects based on code structure
        -- lets you select/delete/move by function, class, etc
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
        require("nvim-treesitter.configs").setup({
  
          -- ── Parsers to install ───────────────────────────
          -- Each parser teaches treesitter one language
          -- We install parsers for your exact stack
          ensure_installed = {
            -- Systems / Embedded
            "c",
            "cpp",
            "cmake",
            "make",
  
            -- Backend
            "go",
            "python",
            "rust",
            "java",
            "javascript",
            "typescript",
  
            -- DevOps
            "dockerfile",
            "yaml",
            "json",
            "hcl",           -- terraform
            "bash",
  
            -- Nvim config
            "lua",
            "vim",
            "vimdoc",
  
            -- Markup
            "markdown",
            "markdown_inline",
          },
  
          -- Install parsers automatically when opening a file
          -- that language if not already installed
          auto_install = true,
  
          -- ── Syntax Highlighting ──────────────────────────
          highlight = {
            enable = true,              -- enable treesitter highlighting
            additional_vim_regex_highlighting = false,  -- disable old regex
                                        -- using both causes conflicts
          },
  
          -- ── Indentation ──────────────────────────────────
          -- Treesitter based indentation
          -- smarter than vim's default
          indent = {
            enable = true,
          },
  
          -- ── Text Objects ─────────────────────────────────
          -- Select, move, swap code by structure
          -- af = around function, if = inside function
          -- ac = around class,    ic = inside class
          textobjects = {
            select = {
              enable = true,
              lookahead = true,         -- jump to next object if not on one
              keymaps = {
                ["af"] = "@function.outer",   -- around function
                ["if"] = "@function.inner",   -- inside function
                ["ac"] = "@class.outer",      -- around class
                ["ic"] = "@class.inner",      -- inside class
                ["aa"] = "@parameter.outer",  -- around argument
                ["ia"] = "@parameter.inner",  -- inside argument
                ["ab"] = "@block.outer",      -- around block
                ["ib"] = "@block.inner",      -- inside block
              },
            },
            -- Move between functions/classes
            move = {
              enable = true,
              set_jumps = true,         -- add to jumplist so Ctrl+o works
              goto_next_start = {
                ["]f"] = "@function.outer",   -- next function start
                ["]c"] = "@class.outer",      -- next class start
              },
              goto_next_end = {
                ["]F"] = "@function.outer",   -- next function end
                ["]C"] = "@class.outer",      -- next class end
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",   -- prev function start
                ["[c"] = "@class.outer",      -- prev class start
              },
            },
            -- Swap arguments/parameters
            swap = {
              enable = true,
              swap_next = {
                ["<leader>sa"] = "@parameter.inner",  -- swap with next arg
              },
              swap_previous = {
                ["<leader>sA"] = "@parameter.inner",  -- swap with prev arg
              },
            },
          },
        })
      end,
    },
  }