# Neovim Keymaps

Leader key: `Space`

---

## General

| Key | Action |
|-----|--------|
| `SPC w` | Save file |
| `SPC q` | Quit |
| `SPC Q` | Force quit all |
| `SPC l` | Open Lazy plugin manager |
| `SPC m` | Open Mason (LSP server manager) |
| `SPC n` | Toggle file tree (nvim-tree) |
| `SPC e` | File browser (Telescope) |
| `SPC S` | Restore session for current directory |
| `Esc` | Clear search highlights |
| `jk` | Exit insert mode |

---

## Navigation

### Splits
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
| `SPC x` | Close buffer (keeps window layout) |

### Scrolling / Search
| Key | Action |
|-----|--------|
| `Ctrl+d` | Scroll down (re-centres cursor) |
| `Ctrl+u` | Scroll up (re-centres cursor) |
| `n / N` | Next / prev search match (re-centred) |

### References (vim-illuminate)
| Key | Action |
|-----|--------|
| `]]` | Next occurrence of word under cursor |
| `[[` | Previous occurrence of word under cursor |

---

## Telescope

All bindings are under `SPC t`.

| Key | Action |
|-----|--------|
| `SPC tf` | Find files |
| `SPC tr` | Recent files |
| `SPC tg` | Live grep |
| `SPC tw` | Grep word under cursor |
| `SPC te` | File browser |
| `SPC tb` | Open buffers |
| `SPC tj` | Jump list |
| `SPC tm` | Marks |
| `SPC ts` | Symbols in file (LSP) |
| `SPC td` | Diagnostics |
| `SPC tc` | Git commits |
| `SPC tp` | Projects |
| `SPC th` | Help tags |
| `SPC tk` | Keymaps |

### Inside Telescope
| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Move selection down / up |
| `Ctrl+q` | Send selection to quickfix list |
| `Esc` | Close |

---

## File Tree (nvim-tree)

| Key | Action |
|-----|--------|
| `SPC n` | Toggle sidebar |
| `R` | Refresh tree manually |
| Standard nvim-tree keys apply inside the tree |

---

## Terminal

| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle floating terminal |
| `Ctrl+h/j/k/l` | Navigate from terminal to split |

---

## Git

### Fugitive
| Key | Action |
|-----|--------|
| `SPC gs` | Git status (interactive fugitive buffer) |
| `SPC gd` | Git diff split |

### Gitsigns (hunk operations)
| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `SPC hs` | Stage hunk |
| `SPC hr` | Reset hunk |
| `SPC gb` | Toggle inline git blame |

---

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `K` | Hover documentation |
| `gl` | Show diagnostic float |
| `SPC la` | Code action |
| `SPC lr` | Rename symbol |
| `SPC lf` | Format file |
| `SPC ls` | Signature help |
| `SPC li` | LSP info |
| `SPC lj` | Next diagnostic |
| `SPC lk` | Previous diagnostic |
| `SPC lq` | Buffer diagnostics (Trouble) |
| `SPC lt` | Workspace diagnostics (Trouble) |
| `SPC ts` | Symbols picker (Telescope) |
| `SPC td` | Diagnostics picker (Telescope) |

---

## Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Next / prev item |
| `Ctrl+Space` | Trigger completion |
| `Ctrl+b/f` | Scroll docs up / down |
| `Ctrl+e` | Dismiss menu |
| `Enter` | Confirm selected item |
| `Tab / Shift+Tab` | Next / prev item or jump snippet placeholder |

---

## Editing

### Comments (Comment.nvim)
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` + motion | Toggle comment over motion |
| `gc` (visual) | Toggle comment on selection |

### Move Lines
| Key | Action |
|-----|--------|
| `Alt+j` | Move line / selection down |
| `Alt+k` | Move line / selection up |

### Visual Mode
| Key | Action |
|-----|--------|
| `< / >` | Indent / dedent and stay in visual |
| `p` | Paste without overwriting register |

### Autopairs
| Key | Action |
|-----|--------|
| `Alt+e` | Fast wrap — wrap next word with pending pair |

---

## Treesitter Text Objects

### Select
| Key | Action |
|-----|--------|
| `af / if` | Around / inside function |
| `ac / ic` | Around / inside class |
| `aa / ia` | Around / inside argument |
| `ab / ib` | Around / inside block |

### Move
| Key | Action |
|-----|--------|
| `]f / [f` | Next / prev function start |
| `]F / [F` | Next / prev function end |
| `]c / [c` | Next / prev class |

### Swap
| Key | Action |
|-----|--------|
| `SPC sa` | Swap argument with next |
| `SPC sA` | Swap argument with previous |

---

## Session

| Key | Action |
|-----|--------|
| `SPC S` | Restore last session for current directory |

---

## Tmux (prefix = `Ctrl+Space`)

| Key | Action |
|-----|--------|
| `Prefix+\|` | Vertical split |
| `Prefix+-` | Horizontal split |
| `Prefix+c` | New window |
| `Prefix+,` | Rename window |
| `Prefix+h/j/k/l` | Navigate panes |
| `Prefix+H/J/K/L` | Resize panes |
| `Ctrl+h/l` | Previous / next window (with prefix) |
| `Alt+h/l` | Previous / next window (no prefix needed) |
| `Prefix+x` | Kill pane |
| `Prefix+X` | Kill window |
| `Prefix+r` | Reload tmux config |
| `Prefix+Enter` | Enter copy mode |
| `v` | Begin selection (copy mode) |
| `y` | Copy selection (copy mode) |
| `Prefix+p` | Paste |
| `Prefix+Ctrl+s` | Save session (tmux-resurrect) |
| `Prefix+Ctrl+r` | Restore session (tmux-resurrect) |
| `Prefix+I` | Install plugins (TPM) |
