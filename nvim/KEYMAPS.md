# Neovim Keymaps

Leader key: `Space`

---

## General

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>Q` | Force quit all |
| `<leader>l` | Open Lazy plugin manager |
| `<Esc>` | Clear search highlights |
| `jk` | Exit insert mode |

---

## Navigation

### Windows / Splits
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Move between splits |
| `Ctrl+↑/↓` | Resize split height |
| `Ctrl+←/→` | Resize split width |

### Buffers
| Key | Action |
|-----|--------|
| `Shift+l` | Next buffer |
| `Shift+h` | Previous buffer |
| `<leader>x` | Close buffer (keeps window layout) |

### Scrolling
| Key | Action |
|-----|--------|
| `Ctrl+d` | Scroll down (centered) |
| `Ctrl+u` | Scroll up (centered) |
| `n / N` | Next/prev search result (centered) |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>f` | Find files |
| `<leader>g` | Live grep (search text) |
| `<leader>b` | Open buffers |
| `<leader>h` | Help tags |
| `<leader>r` | Recent files |
| `<leader>c` | Git commits |
| `<leader>p` | Projects |
| `<leader>fb` | File browser (current file's directory) |

### Inside Telescope
| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Move selection down/up |
| `Ctrl+q` | Send selection to quickfix list |
| `Esc` | Close |

---

## File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |

---

## Terminal

| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle floating terminal |
| `Ctrl+h/j/k/l` | Move from terminal to split |

---

## Git

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (fugitive) |
| `<leader>gd` | Git diff split |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>tb` | Toggle inline git blame |

---

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ls` | Signature help |
| `gl` | Show diagnostic float |
| `<leader>lj` | Next diagnostic |
| `<leader>lk` | Previous diagnostic |
| `<leader>lq` | Buffer diagnostics (Trouble) |
| `<leader>lt` | Workspace diagnostics (Trouble) |
| `<leader>la` | Code action |
| `<leader>lr` | Rename symbol |
| `<leader>lf` | Format file |
| `<leader>li` | LSP info |
| `<leader>m` | Mason (server manager) |

---

## Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Next/prev item |
| `Ctrl+Space` | Trigger completion |
| `Ctrl+b/f` | Scroll docs |
| `Ctrl+e` | Dismiss menu |
| `Enter` | Confirm selected item |
| `Tab / Shift+Tab` | Next/prev item or jump snippet placeholder |

---

## Treesitter Text Objects

### Select
| Key | Action |
|-----|--------|
| `af / if` | Around/inside function |
| `ac / ic` | Around/inside class |
| `aa / ia` | Around/inside argument |
| `ab / ib` | Around/inside block |

### Move
| Key | Action |
|-----|--------|
| `]f / [f` | Next/prev function start |
| `]F / [F` | Next/prev function end |
| `]c / [c` | Next/prev class |

### Swap
| Key | Action |
|-----|--------|
| `<leader>sa` | Swap argument with next |
| `<leader>sA` | Swap argument with previous |

---

## References (vim-illuminate)

| Key | Action |
|-----|--------|
| `]]` | Next reference of word under cursor |
| `[[` | Previous reference of word under cursor |

---

## Movement (Visual Mode)

| Key | Action |
|-----|--------|
| `Alt+j/k` | Move selected lines down/up |
| `< / >` | Indent/dedent and reselect |
| `p` | Paste without overwriting register |

---

## Session

| Key | Action |
|-----|--------|
| `<leader>S` | Restore last session for current directory |
