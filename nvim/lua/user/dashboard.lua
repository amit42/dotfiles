-- dashboard.lua
-- Plugin-free startup screen. Logo + keymap reference, nothing else.

local M = {}

-- ── Content ──────────────────────────────────────────────────────────
-- One clear theme per column.
--   C1 Find     C2 Code      C3 Edit     C4 Git      C5 System

local C1 = {
  { "Telescope" },
  { "SPC tf",    "Find files"       },
  { "SPC tr",    "Recent files"     },
  { "SPC tg",    "Live grep"        },
  { "SPC tw",    "Grep word"        },
  { "SPC te",    "File browser"     },
  { "SPC tb",    "Buffers"          },
  { "SPC tc",    "Git commits"      },
  { "SPC tp",    "Projects"         },
  { "SPC tk",    "Keymaps"          },
  { "SPC th",    "Help tags"        },
  { "SPC ts",    "Symbols"          },
  { "SPC td",    "Diagnostics"      },
  { "In picker" },
  { "C-j / C-k", "Move selection"   },
  { "C-q",       "Quickfix list"    },
  { "Enter",     "Open"             },
  { "Esc",       "Close"            },
}

local C2 = {
  { "LSP" },
  { "gd",        "Go to def"        },
  { "gr",        "References"       },
  { "K",         "Hover docs"       },
  { "gl",        "Diag float"       },
  { "SPC la",    "Code action"      },
  { "SPC lr",    "Rename"           },
  { "SPC lf",    "Format buffer"    },
  { "SPC lj/lk", "Next/prev diag"   },
  { "SPC lq",    "Buffer diags"     },
  { "Navigate" },
  { "S-l / S-h", "Cycle buffers"    },
  { "SPC x",     "Close buffer"     },
  { "C-d / C-u", "Scroll centred"   },
  { "C-h/j/k/l", "Split nav"        },
}

local C3 = {
  { "Vim" },
  { ".",         "Repeat"           },
  { "q<r>/@<r>", "Record / play"    },
  { "ci / di",   "Change/del in"    },
  { "ca / da",   "Change/del arnd"  },
  { "Edit" },
  { "gcc / gc",  "Comment ln/sel"   },
  { "A-j / A-k", "Move line"        },
  { "jk",        "Exit insert"      },
  { "Alt+e",     "Fast wrap"        },
  { "< / >",     "Indent / dedent"  },
  { "Text Objects" },
  { "af / if",   "Func out/in"      },
  { "ac / ic",   "Class out/in"     },
  { "aa / ia",   "Arg out/in"       },
  { "ab / ib",   "Block out/in"     },
  { "Completion" },
  { "C-j / C-k", "Next/prev"        },
  { "Tab",       "Accept"           },
  { "Enter",     "Confirm"          },
}

local C4 = {
  { "Git (nvim)" },
  { "SPC gs",    "Status"           },
  { "SPC gd",    "Diff"             },
  { "SPC gb",    "Blame toggle"     },
  { "]h / [h",   "Next/prev hunk"   },
  { "SPC hs",    "Stage hunk"       },
  { "SPC hr",    "Reset hunk"       },
  { "Git (shell)" },
  { "lg",        "lazygit TUI"      },
  { "gs / gd",   "status / diff"    },
  { "ga / gaa",  "add / add -A"     },
  { "gc / gca",  "commit / amend"   },
  { "gp / gpf",  "push / force"     },
  { "gl",        "pull"             },
  { "gco / gcb", "checkout / -b"    },
  { "glog",      "branch graph"     },
  { "gsync",     "rebase on main"   },
  { "gpr",       "push + open PR"   },
}

local C5 = {
  { "Tools" },
  { "SPC n",     "File tree"        },
  { "SPC S",     "Session restore"  },
  { "SPC u",     "Undo tree"        },
  { "SPC m / l", "Mason / Lazy"     },
  { "C-\\",      "Terminal"         },
  { "Tmux (Pfx=C-Spc)" },
  { "M-h / M-l", "Prev/next win"    },
  { "Pfx +|/-",  "Split V / H"      },
  { "Pfx hjkl",  "Nav panes"        },
  { "Pfx c / ,", "New / rename"     },
  { "Pfx x / X", "Kill pane / win"  },
  { "Pfx C-s/r", "Save / restore"   },
  { "Shell" },
  { "ts / tn",   "Tmux session"     },
  { "vf / rgf",  "nvim/rg fuzzy"    },
  { "fkill",     "Fuzzy kill proc"  },
}

-- ── Logo ─────────────────────────────────────────────────────────────

local LOGO = {
  "·  n v i m  ·",
}

-- ── Geometry ─────────────────────────────────────────────────────────

local KEY_W   = 9
local DESC_W  = 12
local COL_W   = KEY_W + 2 + DESC_W        -- 23 display cells
local NCOLS   = 5
local GAP     = 1                          -- display cells between columns
local BLOCK_W = COL_W * NCOLS + GAP * (NCOLS - 1)  -- 119

-- Column separator "│" — 1 display cell, 3 bytes (U+2502)
local DIV   = "\xe2\x94\x82"
local DIV_B = #DIV  -- 3

-- ── Colours (catppuccin-mocha) ────────────────────────────────────────

local function setup_hl()
  vim.api.nvim_set_hl(0, "DashTitle",   { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "DashSection", { fg = "#cba6f7", bold = true })
  vim.api.nvim_set_hl(0, "DashKey",     { fg = "#fab387" })
  vim.api.nvim_set_hl(0, "DashColDiv",  { fg = "#45475a" })
  -- Logo gradient: blue → sapphire → sky → mauve → pink → rosewater
  vim.api.nvim_set_hl(0, "DashGrad1",   { fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "DashGrad2",   { fg = "#74c7ec" })
  vim.api.nvim_set_hl(0, "DashGrad3",   { fg = "#89dceb" })
  vim.api.nvim_set_hl(0, "DashGrad4",   { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "DashGrad5",   { fg = "#f5c2e7" })
  vim.api.nvim_set_hl(0, "DashGrad6",   { fg = "#f5e0dc" })
end

-- ── Helpers ──────────────────────────────────────────────────────────

local function fmt(entry)
  if #entry == 1 then
    local dw = vim.fn.strdisplaywidth(entry[1])
    return entry[1] .. string.rep(" ", math.max(0, COL_W - dw))
  end
  local key  = string.sub(entry[1], 1, KEY_W)
  local desc = string.sub(entry[2], 1, DESC_W)
  return string.format("%-" .. KEY_W .. "s  %-" .. DESC_W .. "s", key, desc)
end

-- ── Build ─────────────────────────────────────────────────────────────

local ns = vim.api.nvim_create_namespace("dashboard")

function M.build()
  local lines = {}
  local hls   = {}
  local lnum  = 0

  local function emit(line)
    table.insert(lines, line)
    lnum = lnum + 1
  end
  local function hl(group, l, s, e)
    table.insert(hls, { group, l, s, e })
  end

  local tw = vim.o.columns
  local th = vim.o.lines - vim.o.cmdheight - 1

  local bi     = math.max(0, math.floor((tw - BLOCK_W) / 2))
  local indent = string.rep(" ", bi)

  local logo_dw  = vim.fn.strdisplaywidth(LOGO[1])
  local logo_pad = math.max(0, math.floor((BLOCK_W - logo_dw) / 2))

  local cols = { C1, C2, C3, C4, C5 }
  local n    = 0
  for _, c in ipairs(cols) do n = math.max(n, #c) end

  local inner_h = #LOGO + 2 + n
  local vpad    = math.max(1, math.floor((th - inner_h) / 3))

  for _ = 1, vpad do emit("") end

  -- ── logo ─────────────────────────────────────────────────────────
  -- "·  n v i m  ·"  byte map (· = U+00B7, 2 bytes):
  --  0-1:·  2-3:sp  4:n  5:sp  6:v  7:sp  8:i  9:sp  10:m  11-12:sp  13-14:·
  for _, line in ipairs(LOGO) do
    local logo_lnum = lnum
    emit(indent .. string.rep(" ", logo_pad) .. line)
    local o = bi + logo_pad
    hl("DashGrad1", logo_lnum, o + 0,  o + 2)
    hl("DashGrad2", logo_lnum, o + 4,  o + 5)
    hl("DashGrad3", logo_lnum, o + 6,  o + 7)
    hl("DashGrad4", logo_lnum, o + 8,  o + 9)
    hl("DashGrad5", logo_lnum, o + 10, o + 11)
    hl("DashGrad6", logo_lnum, o + 13, o + 15)
  end

  emit("")
  emit("")

  -- ── content grid ─────────────────────────────────────────────────
  for i = 1, n do
    local parts   = {}
    local row_hls = {}
    local cur     = bi

    for ci, col in ipairs(cols) do
      local entry    = col[i]
      local cell_str = entry and fmt(entry) or string.rep(" ", COL_W)
      local cbytes   = #cell_str

      if entry then
        if #entry == 1 then
          row_hls[#row_hls+1] = { "DashSection", cur, cur + #entry[1] }
        else
          row_hls[#row_hls+1] = { "DashKey", cur, cur + math.min(#entry[1], KEY_W) }
        end
      end

      table.insert(parts, cell_str)
      cur = cur + cbytes

      if ci < NCOLS then
        table.insert(parts, DIV)
        row_hls[#row_hls+1] = { "DashColDiv", cur, cur + 3 }
        cur = cur + DIV_B
      end
    end

    local row_lnum = lnum
    emit(indent .. table.concat(parts))
    for _, h in ipairs(row_hls) do
      hl(h[1], row_lnum, h[2], h[3])
    end
  end

  return lines, hls
end

-- ── Open ─────────────────────────────────────────────────────────────

function M.open()
  setup_hl()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype   = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype  = "dashboard"

  local function render()
    local ls, hls_list = M.build()
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, ls)
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, h in ipairs(hls_list) do
      vim.api.nvim_buf_add_highlight(buf, ns, h[1], h[2], h[3], h[4])
    end
  end

  render()
  vim.api.nvim_win_set_buf(0, buf)

  vim.wo.number         = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn     = "no"
  vim.wo.foldcolumn     = "0"
  vim.wo.cursorline     = false
  vim.wo.wrap           = false

  -- close
  vim.keymap.set("n", "q", "<cmd>bdelete!<CR>",
    { buffer = buf, silent = true, nowait = true })

  vim.api.nvim_create_autocmd("VimResized", {
    buffer   = buf,
    callback = render,
  })

  -- Restore window options after the dashboard buffer is wiped.
  -- BufHidden never fires when bufhidden=wipe; BufWipeout is the correct event.
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once   = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.wo[win].number         = true
          vim.wo[win].relativenumber = true
          vim.wo[win].signcolumn     = "yes"
          vim.wo[win].foldcolumn     = "0"
          vim.wo[win].cursorline     = true
        end
      end)
    end,
  })
end

return M
