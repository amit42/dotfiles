-- dashboard.lua
-- Plugin-free startup screen. Logo + keymap reference, nothing else.

local M = {}

-- ── Content ──────────────────────────────────────────────────────────
-- { "Title" }            → section header
-- { "key", "desc" }      → keymap row

local C1 = {
  { "Telescope" },
  { "SPC tf",    "Find files"       },
  { "SPC tr",    "Recent files"     },
  { "SPC tg",    "Live grep"        },
  { "SPC tw",    "Grep word"        },
  { "SPC te",    "File browser"     },
  { "SPC tb",    "Buffers"          },
  { "SPC tj",    "Jump list"        },
  { "SPC tm",    "Marks"            },
  { "SPC tc",    "Git commits"      },
  { "SPC tp",    "Projects"         },
  { "SPC th",    "Help tags"        },
  { "SPC tk",    "Keymaps"          },
  { "Inside" },
  { "C-j / C-k", "Move selection"   },
  { "C-q",       "Quickfix list"    },
  { "Esc",       "Close picker"     },
  { "Enter",     "Open result"      },
}

local C2 = {
  { "Git" },
  { "SPC gs",    "Git status"       },
  { "SPC gd",    "Git diff"         },
  { "SPC gb",    "Toggle blame"     },
  { "]h / [h",   "Next/prev hunk"   },
  { "SPC hs",    "Stage hunk"       },
  { "SPC hr",    "Reset hunk"       },
  { "Navigate" },
  { "S-l / S-h", "Cycle buffers"    },
  { "SPC x",     "Close buffer"     },
  { "C-d / C-u", "Scroll centred"   },
  { "]] / [[",   "Next/prev ref"    },
  { "C-h/j/k/l", "Split nav"        },
  { "n / N",     "Search centred"   },
  { "General" },
  { "SPC w",     "Save file"        },
  { "SPC q",     "Quit"             },
  { "SPC Q",     "Force quit all"   },
}

local C3 = {
  { "LSP" },
  { "gd",        "Go to definition" },
  { "gD",        "Declaration"      },
  { "gi",        "Implementation"   },
  { "gr",        "References"       },
  { "K",         "Hover docs"       },
  { "gl",        "Diagnostic float" },
  { "SPC la",    "Code action"      },
  { "SPC lr",    "Rename symbol"    },
  { "SPC lf",    "Format buffer"    },
  { "SPC ls",    "Signature help"   },
  { "SPC li",    "LSP info"         },
  { "SPC lj",    "Next diagnostic"  },
  { "SPC lk",    "Prev diagnostic"  },
  { "SPC lq",    "Buffer trouble"   },
  { "SPC lt",    "Workspace trouble" },
  { "SPC ts",    "Symbols picker"   },
  { "SPC td",    "Diagnostics pick" },
}

local C4 = {
  { "Tools" },
  { "SPC n",     "File tree"        },
  { "SPC S",     "Restore session"  },
  { "SPC m",     "Mason"            },
  { "SPC l",     "Lazy plugins"     },
  { "C-\\",      "Terminal toggle"  },
  { "Esc",       "Clear highlights" },
  { "Edit" },
  { "gcc / gc",  "Comment ln / sel" },
  { "A-j / A-k", "Move line"        },
  { "jk",        "Exit insert"      },
  { "Alt+e",     "Fast wrap"        },
  { "< / >",     "Indent / dedent"  },
  { "p (visual)", "Paste no-clobber" },
  { "zz / zt",   "Centre / top"     },
  { "J",         "Join lines"       },
  { "C-a / C-x", "Increment / decr" },
}

local C5 = {
  { "Text Objects" },
  { "af / if",   "Func outer/inner" },
  { "ac / ic",   "Class outer/inner" },
  { "aa / ia",   "Arg outer/inner"  },
  { "ab / ib",   "Block outer/inner" },
  { "]f / [f",   "Next/prev func"   },
  { "]F / [F",   "Func end fwd/bk"  },
  { "]c / [c",   "Next/prev class"  },
  { "SPC sa",    "Swap arg next"    },
  { "SPC sA",    "Swap arg prev"    },
  { "Completion" },
  { "C-j / C-k", "Next/prev item"   },
  { "C-Space",   "Trigger"          },
  { "C-b / C-f", "Scroll docs"      },
  { "Enter",     "Confirm item"     },
  { "Tab/S-Tab", "Jump snippet"     },
  { "C-e",       "Dismiss menu"     },
}

local C6 = {
  { "Tmux (Pfx=C-Spc)" },
  { "M-h / M-l",  "Prev/next win"    },
  { "Pfx+|/-",    "Vert/horiz split" },
  { "Pfx+h/j/k/l","Navigate panes"   },
  { "Pfx+H/J/K/L","Resize panes"     },
  { "Pfx+c",      "New window"       },
  { "Pfx+,",      "Rename window"    },
  { "Pfx+x/X",    "Kill pane/win"    },
  { "Pfx+r",      "Reload config"    },
  { "Pfx+I",      "Install plugins"  },
  { "Pfx+Ctrl+s", "Save session"     },
  { "Pfx+Ctrl+r", "Restore session"  },
  { "Pfx+Enter",  "Enter copy mode"  },
  { "v / y",      "Select / copy"    },
  { "Pfx+p",      "Paste"            },
  { "Splits" },
  { "C-Up/Dn",    "Resize height"    },
  { "C-Lt/Rt",    "Resize width"     },
}

-- ── Logo ─────────────────────────────────────────────────────────────

local LOGO = {
  "·  n v i m  ·",
}

-- ── Geometry ─────────────────────────────────────────────────────────

local KEY_W   = 12
local DESC_W  = 18
local COL_W   = KEY_W + 2 + DESC_W        -- 32 display cells
local NCOLS   = 6
local GAP     = 3                          -- display cells between columns
local BLOCK_W = COL_W * NCOLS + GAP * (NCOLS - 1)  -- 207

-- Column separator " │ " — 3 display cells, 5 bytes (│ = U+2502, 3 bytes)
local DIV   = " \xe2\x94\x82 "
local DIV_B = #DIV  -- 5

-- ── Colours (catppuccin-mocha) ────────────────────────────────────────

local function setup_hl()
  vim.api.nvim_set_hl(0, "DashTitle",   { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "DashSection", { fg = "#cba6f7", bold = true })
  vim.api.nvim_set_hl(0, "DashKey",     { fg = "#fab387" })
  vim.api.nvim_set_hl(0, "DashColDiv",  { fg = "#45475a" })
  -- Logo gradient: blue → sapphire → sky → mauve → pink → rosewater
  vim.api.nvim_set_hl(0, "DashGrad1",   { fg = "#89b4fa" })  -- blue      ·
  vim.api.nvim_set_hl(0, "DashGrad2",   { fg = "#74c7ec" })  -- sapphire  n
  vim.api.nvim_set_hl(0, "DashGrad3",   { fg = "#89dceb" })  -- sky       v
  vim.api.nvim_set_hl(0, "DashGrad4",   { fg = "#cba6f7" })  -- mauve     i
  vim.api.nvim_set_hl(0, "DashGrad5",   { fg = "#f5c2e7" })  -- pink      m
  vim.api.nvim_set_hl(0, "DashGrad6",   { fg = "#f5e0dc" })  -- rosewater ·
end

-- ── Helpers ──────────────────────────────────────────────────────────

local function fmt(entry)
  if #entry == 1 then
    local dw = vim.fn.strdisplaywidth(entry[1])
    return entry[1] .. string.rep(" ", math.max(0, COL_W - dw))
  end
  return string.format("%-" .. KEY_W .. "s  %-" .. DESC_W .. "s", entry[1], entry[2])
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

  -- Block indent (centres the grid)
  local bi     = math.max(0, math.floor((tw - BLOCK_W) / 2))
  local indent = string.rep(" ", bi)

  -- Logo centering: centre within the same block
  local logo_dw  = vim.fn.strdisplaywidth(LOGO[1])
  local logo_pad = math.max(0, math.floor((BLOCK_W - logo_dw) / 2))

  -- Grid row count
  local cols = { C1, C2, C3, C4, C5, C6 }
  local n    = 0
  for _, c in ipairs(cols) do n = math.max(n, #c) end

  -- Vertical placement: upper third
  local inner_h = #LOGO + 2 + n
  local vpad    = math.max(1, math.floor((th - inner_h) / 3))

  -- ── top padding ──────────────────────────────────────────────────
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

  emit("")  -- gap between logo and grid
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
          row_hls[#row_hls+1] = { "DashKey", cur, cur + #entry[1] }
        end
      end

      table.insert(parts, cell_str)
      cur = cur + cbytes

      if ci < NCOLS then
        table.insert(parts, DIV)
        -- │ is at byte offset 1 inside " │ "
        row_hls[#row_hls+1] = { "DashColDiv", cur + 1, cur + 4 }
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

  vim.keymap.set("n", "q", "<cmd>bdelete!<CR>",
    { buffer = buf, silent = true, nowait = true })

  vim.api.nvim_create_autocmd("VimResized", {
    buffer   = buf,
    callback = render,
  })
end

return M
