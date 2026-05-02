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
  { "SPC tc",    "Git commits"      },
  { "SPC tp",    "Projects"         },
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
}

local C3 = {
  { "LSP" },
  { "gd",        "Go to definition" },
  { "gr",        "References"       },
  { "K",         "Hover docs"       },
  { "SPC la",    "Code action"      },
  { "SPC lr",    "Rename symbol"    },
  { "SPC lf",    "Format buffer"    },
  { "SPC ts",    "Symbols"          },
  { "SPC td",    "Diagnostics"      },
  { "Diagnostics" },
  { "gl",        "Float"            },
  { "SPC lj",    "Next diagnostic"  },
  { "SPC lk",    "Prev diagnostic"  },
  { "SPC lq",    "Trouble buffer"   },
}

local C4 = {
  { "Tools" },
  { "SPC n",     "File tree"        },
  { "SPC S",     "Restore session"  },
  { "SPC m",     "Mason"            },
  { "SPC l",     "Lazy plugins"     },
  { "SPC tk",    "Keymaps"          },
  { "SPC th",    "Help tags"        },
  { "Edit" },
  { "gcc / gc",  "Comment ln / sel" },
  { "A-j / A-k", "Move line"        },
  { "jk",        "Exit insert"      },
  { "C-\\",      "Terminal"         },
  { "Alt+e",     "Fast wrap"        },
}

-- ── Logos ────────────────────────────────────────────────────────────
-- Two sizes chosen at render time based on usable terminal height.
-- LOGO_LG uses the standard NVIM block-drawing art; LOGO_SM is the
-- current single-line dot form for small/narrow terminals.

local LOGO_SM = { "\xc2\xb7  n v i m  \xc2\xb7" }  -- "·  n v i m  ·"

local LOGO_LG = {
  "  \xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97   \xe2\x96\x88\xe2\x96\x88\xe2\x95\x97\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97   \xe2\x96\x88\xe2\x96\x88\xe2\x95\x97\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97   \xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97  ",
  "  \xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97  \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91   \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97 \xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91  ",
  "  \xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97 \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97 \xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x95\x9d\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91  ",
  "  \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x95\x97\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91 \xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x95\x9d \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x95\x9d\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91  ",
  "  \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91 \xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91  \xe2\x95\x9a\xe2\x96\x88\xe2\x96\x88\xe2\x95\x94\xe2\x95\x9d  \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91\xe2\x96\x88\xe2\x96\x88\xe2\x95\x91 \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d \xe2\x96\x88\xe2\x96\x88\xe2\x95\x91  ",
  "  \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d  \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x9d   \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d   \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d\xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d     \xe2\x95\x9a\xe2\x95\x90\xe2\x95\x9d  ",
}

local function select_logo(th)
  return th >= 35 and LOGO_LG or LOGO_SM
end

-- ── Geometry ─────────────────────────────────────────────────────────

local KEY_W   = 10
local DESC_W  = 17
local COL_W   = KEY_W + 2 + DESC_W        -- 29 display cells
local NCOLS   = 4
local GAP     = 3                          -- display cells between columns
local BLOCK_W = COL_W * NCOLS + GAP * (NCOLS - 1)  -- 125

-- Column separator " │ " — 3 display cells, 5 bytes (│ = U+2502, 3 bytes)
local DIV   = " \xe2\x94\x82 "
local DIV_B = #DIV  -- 5

-- ── Colours (catppuccin-mocha) ────────────────────────────────────────

local GRAD = { "DashGrad1", "DashGrad2", "DashGrad3", "DashGrad4", "DashGrad5", "DashGrad6" }

local function setup_hl()
  vim.api.nvim_set_hl(0, "DashTitle",   { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "DashSection", { fg = "#cba6f7", bold = true })
  vim.api.nvim_set_hl(0, "DashKey",     { fg = "#fab387" })
  vim.api.nvim_set_hl(0, "DashColDiv",  { fg = "#45475a" })
  -- Logo gradient: blue → sapphire → sky → mauve → pink → rosewater
  vim.api.nvim_set_hl(0, "DashGrad1",   { fg = "#89b4fa" })  -- blue
  vim.api.nvim_set_hl(0, "DashGrad2",   { fg = "#74c7ec" })  -- sapphire
  vim.api.nvim_set_hl(0, "DashGrad3",   { fg = "#89dceb" })  -- sky
  vim.api.nvim_set_hl(0, "DashGrad4",   { fg = "#cba6f7" })  -- mauve
  vim.api.nvim_set_hl(0, "DashGrad5",   { fg = "#f5c2e7" })  -- pink
  vim.api.nvim_set_hl(0, "DashGrad6",   { fg = "#f5e0dc" })  -- rosewater
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

  local LOGO = select_logo(th)

  -- Block indent (centres the 125-cell grid)
  local bi     = math.max(0, math.floor((tw - BLOCK_W) / 2))
  local indent = string.rep(" ", bi)

  -- Logo centering: use the widest line
  local logo_max_dw = 0
  for _, line in ipairs(LOGO) do
    logo_max_dw = math.max(logo_max_dw, vim.fn.strdisplaywidth(line))
  end
  local logo_pad = math.max(0, math.floor((BLOCK_W - logo_max_dw) / 2))

  -- Grid row count
  local cols = { C1, C2, C3, C4 }
  local n    = 0
  for _, c in ipairs(cols) do n = math.max(n, #c) end

  -- Vertical placement: upper third
  -- gap between logo and grid grows by 1 on tall terminals
  local logo_gap = (th >= 50) and 3 or 2
  local inner_h  = #LOGO + logo_gap + n
  local vpad     = math.max(1, math.floor((th - inner_h) / 3))

  -- ── top padding ──────────────────────────────────────────────────
  for _ = 1, vpad do emit("") end

  -- ── logo ─────────────────────────────────────────────────────────
  -- Single-line: per-character gradient on the 6 visible glyphs.
  -- Multi-line:  one gradient colour per row spread across the palette.
  --
  -- LOGO_SM byte map (· = U+00B7, 2 bytes UTF-8):
  --   0-1:·  2-3:sp  4:n  5:sp  6:v  7:sp  8:i  9:sp  10:m  11-12:sp  13-14:·
  local nlogo = #LOGO
  for li, line in ipairs(LOGO) do
    local logo_lnum = lnum
    emit(indent .. string.rep(" ", logo_pad) .. line)
    local o = bi + logo_pad
    if nlogo == 1 then
      hl("DashGrad1", logo_lnum, o + 0,  o + 2)
      hl("DashGrad2", logo_lnum, o + 4,  o + 5)
      hl("DashGrad3", logo_lnum, o + 6,  o + 7)
      hl("DashGrad4", logo_lnum, o + 8,  o + 9)
      hl("DashGrad5", logo_lnum, o + 10, o + 11)
      hl("DashGrad6", logo_lnum, o + 13, o + 15)
    else
      local gi = math.max(1, math.min(#GRAD, math.ceil(li * #GRAD / nlogo)))
      hl(GRAD[gi], logo_lnum, o, o + #line)
    end
  end

  for _ = 1, logo_gap do emit("") end

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
