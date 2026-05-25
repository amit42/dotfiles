# Vim Guide

A practical reference covering vim fundamentals + this config's custom bindings.
Leader key is `Space` throughout.

---

## Modes

| Mode | Enter with | Purpose |
|------|-----------|---------|
| **Normal** | `Esc` or `jk` | Move + execute commands. Where you live. |
| **Insert** | `i a o I A O s S` | Type text. |
| **Visual** | `v` | Select characters. |
| **V-Line** | `V` | Select whole lines. |
| **V-Block** | `Ctrl+v` | Select rectangular blocks (edit columns). |
| **Command** | `:` | Run ex commands (`:w`, `:%s/foo/bar/g`). |
| **Terminal** | inside `:terminal` buffer | Interact with shell. `Ctrl+\ Ctrl+n` exits to normal. |

**Custom:** `jk` in insert mode = `Esc`. Faster than reaching for escape.

---

## Movement

The vim **grammar** is: `[count][operator][motion]`. Almost everything composes.

### Basic motion
| Key | Moves to |
|-----|---------|
| `h j k l` | left, down, up, right |
| `w / b` | next / prev word start |
| `e / ge` | next / prev word end |
| `W B E` | same but WORD (whitespace-separated) |
| `0` | beginning of line |
| `^` | first non-blank char |
| `$` | end of line |
| `gg` | top of file |
| `G` | bottom of file |
| `{N}G` or `:N` | line N |
| `%` | matching bracket `( { [` |
| `f{c}` / `F{c}` | jump to next/prev char `c` on line |
| `t{c}` / `T{c}` | jump to before next/prev char `c` |
| `;` / `,` | repeat / reverse last `f` `t` |

### Screen navigation
| Key | Action |
|-----|--------|
| `Ctrl+d` / `Ctrl+u` | half-page down / up (re-centred — custom) |
| `Ctrl+f` / `Ctrl+b` | full page down / up |
| `H M L` | top, middle, bottom of screen |
| `zz` | centre current line on screen |
| `zt` / `zb` | scroll current line to top / bottom |

### Marks
| Key | Action |
|-----|--------|
| `m{a-z}` | set local mark |
| `m{A-Z}` | set global mark (works across files) |
| `` `{mark} `` | jump to exact position of mark |
| `'{mark}` | jump to line of mark |
| ` `` ` | jump back to position before last jump |
| `Ctrl+o` / `Ctrl+i` | older / newer jump |

---

## Operators (the verbs)

An operator + a motion = an action.

| Operator | Means |
|----------|-------|
| `d` | delete |
| `c` | change (delete + enter insert) |
| `y` | yank (copy) |
| `v` | visual select |
| `>` / `<` | indent right / left |
| `gu` / `gU` | lowercase / uppercase |
| `gq` | format (line wrap) |
| `=` | re-indent |
| `~` | swap case (no motion needed on a single char) |

**Examples:**
```
dw    delete to end of word
d$    delete to end of line     (same as D)
d0    delete to beginning of line
dgg   delete to top of file
dG    delete to bottom of file
yy    yank a whole line         (operator doubled = whole line)
cc    change a whole line       (same trick)
3dd   delete 3 lines
y2j   yank current line + 2 below
```

---

## Text Objects (the nouns)

Operators combine with **text objects** for surgical edits. Format: `[op]{i|a}{object}`.

- `i` = **i**nside (excludes delimiters)
- `a` = **a**round (includes delimiters)

| Object | Means |
|--------|-------|
| `w / W` | word / WORD |
| `s` | sentence |
| `p` | paragraph |
| `( )` or `b` | parentheses |
| `{ }` or `B` | braces |
| `[ ]` | brackets |
| `<>` or `t` | angle brackets / HTML tag |
| `" ' \`` | quoted strings |

**Treesitter objects (custom):**

| Object | Means |
|--------|-------|
| `af / if` | a function / inside function |
| `ac / ic` | a class / inside class |
| `aa / ia` | an argument / inside argument |
| `ab / ib` | a block / inside block |

**Examples:**
```
ciw   change inner word
da"   delete a quoted string (including the quotes)
yi(   yank inside parens
vat   visually select around HTML tag
cif   change inside function (treesitter)
```

---

## Editing

### Insert mode
| Key | Inserts |
|-----|---------|
| `i / a` | before / after cursor |
| `I / A` | beginning / end of line |
| `o / O` | new line below / above |
| `s / S` | substitute char / line |
| `r{c}` | replace single char |
| `R` | replace mode (overwrite) |
| `gi` | insert at last insert position |

### Quick edits in normal mode
| Key | Action |
|-----|--------|
| `x` | delete char under cursor |
| `X` | delete char before cursor |
| `D` | delete to end of line |
| `C` | change to end of line |
| `Y` | yank line |
| `~` | toggle case of char |
| `J` | join line below to current |
| `u` | undo |
| `Ctrl+r` | redo |
| `.` | repeat last change |

### Move lines (custom)
| Key | Action |
|-----|--------|
| `Alt+j / Alt+k` | move line / selection down / up |

### Comment (Comment.nvim — custom)
| Key | Action |
|-----|--------|
| `gcc` | toggle line comment |
| `gc` + motion | comment over motion |
| `gc` in visual | comment selection |

### Autopairs (custom)
| Key | Action |
|-----|--------|
| `Alt+e` | fast wrap next word with pending pair |

### Visual mode
| Key | Action |
|-----|--------|
| `< / >` | indent/dedent and stay in visual |
| `p` | paste without overwriting register |
| `o` | jump to other end of selection |
| `gv` | re-select last visual selection |

---

## Search & Replace

### Search
| Key | Action |
|-----|--------|
| `/{pattern}` | search forward |
| `?{pattern}` | search backward |
| `n / N` | next / prev (re-centred — custom) |
| `*` | search word under cursor (forward) |
| `#` | search word under cursor (backward) |
| `Esc` | clear highlight (custom) |
| `]] / [[` | next/prev occurrence (vim-illuminate, custom) |

### Replace
```
:s/old/new/         first match on current line
:s/old/new/g        all matches on current line
:%s/old/new/g       all matches in file
:%s/old/new/gc      ...with confirmation
:'<,'>s/old/new/g   in visual selection
```

Special chars in patterns: `\.` literal dot, `\<word\>` whole word, `\(...\)` group, `\1` backref.

---

## Yank & Paste

Vim has **registers** — different clipboards you can choose from.

| Key | Action |
|-----|--------|
| `y` + motion | yank |
| `yy` | yank line |
| `p / P` | paste after / before cursor |
| `"{reg}` + operation | use register `reg` |

**Useful registers:**
| Register | Contents |
|----------|---------|
| `"` | default — last yank/delete |
| `0` | last yank only (survives deletes) |
| `+` | system clipboard |
| `*` | selection clipboard (Linux) |
| `_` | black hole — discard |
| `a-z` | named (lowercase = overwrite, uppercase = append) |

**Examples:**
```
"+yy           yank line to system clipboard
"+p            paste from system clipboard
"_dd           delete line without polluting yank register
"ayy           yank line into register a
"Ayy           append line to register a
"ap            paste register a
:reg           list all register contents
```

---

## Macros

Recorded keystroke sequences, stored in registers.

| Key | Action |
|-----|--------|
| `q{a-z}` | start recording into register |
| `q` | stop recording |
| `@{reg}` | play macro from register |
| `@@` | replay last macro |
| `{N}@{reg}` | play macro N times |

**Workflow:** record once, replay many. Edit a register by pasting (`"ap`), editing, then yanking back (`"ay$`).

---

## Buffers, Windows, Tabs

Three different concepts. Buffers = loaded files; windows = viewports; tabs = window collections.

### Buffers
| Key | Action |
|-----|--------|
| `Shift+l / Shift+h` | next / prev buffer (custom) |
| `:bn / :bp` | next / prev buffer |
| `:b {name}` | switch by name |
| `:ls` | list buffers |
| `<leader>x` | close buffer, keep layout (custom) |
| `<leader>tb` | telescope buffers (custom) |

### Windows / Splits
| Key | Action |
|-----|--------|
| `:split` / `:sp` | horizontal split |
| `:vsplit` / `:vs` | vertical split |
| `Ctrl+w h/j/k/l` | navigate splits |
| `Ctrl+h/j/k/l` | navigate splits (custom — no prefix) |
| `Ctrl+w =` | equalize split sizes |
| `Ctrl+w o` | close all other splits |
| `Ctrl+w c` | close current split |
| `Ctrl+w T` | move split to new tab |

### Tabs
| Key | Action |
|-----|--------|
| `:tabnew` | new tab |
| `gt / gT` | next / prev tab |
| `:tabclose` | close tab |
| `:tab help foo` | open help in new tab |

---

## LSP (custom)

| Key | Action |
|-----|--------|
| `gd` | go to definition |
| `gD` | go to declaration |
| `gi` | go to implementation |
| `gr` | references |
| `K` | hover documentation |
| `gl` | diagnostic float for current line |
| `<leader>la` | code action |
| `<leader>lr` | rename symbol |
| `<leader>lf` | format buffer |
| `<leader>lj / lk` | next / prev diagnostic |
| `<leader>lq` | buffer diagnostics (Trouble) |
| `<leader>ts` | symbol picker (Telescope) |
| `<leader>td` | diagnostics picker (Telescope) |

---

## Telescope (custom)

All under `<leader>t`.

| Key | Action |
|-----|--------|
| `<leader>tf` | find files |
| `<leader>tr` | recent files |
| `<leader>tg` | live grep |
| `<leader>tw` | grep word under cursor |
| `<leader>te` | file browser |
| `<leader>tb` | open buffers |
| `<leader>tc` | git commits |
| `<leader>tp` | projects |
| `<leader>th` | help tags |
| `<leader>tk` | keymaps |

### Inside any Telescope picker
| Key | Action |
|-----|--------|
| `Ctrl+j / Ctrl+k` | move selection down / up |
| `Ctrl+q` | send selection to quickfix list |
| `Enter` | open selected |
| `Esc` | close picker |

---

## Git (custom)

### Inside nvim
| Key | Action |
|-----|--------|
| `<leader>gs` | git status (fugitive) |
| `<leader>gd` | git diff |
| `<leader>gb` | toggle inline blame |
| `]h / [h` | next / prev hunk |
| `<leader>hs` | stage hunk |
| `<leader>hr` | reset hunk |

---

## Folds (brief)

| Key | Action |
|-----|--------|
| `za` | toggle fold under cursor |
| `zR` | open all folds |
| `zM` | close all folds |
| `zc / zo` | close / open fold |

---

## Quickfix / Location List

The quickfix list is a project-wide list of locations (LSP refs, search results, grep hits).

| Key | Action |
|-----|--------|
| `:copen / :cclose` | open / close quickfix |
| `:cnext / :cprev` | navigate |
| `:cdo {cmd}` | run command on every quickfix item |

`Ctrl+q` inside Telescope sends results to quickfix → then `:cdo s/foo/bar/g | update` for project-wide replace.

---

## Command-line tricks

| Key | Action |
|-----|--------|
| `q:` | open command history as editable buffer |
| `:!{cmd}` | run shell command |
| `:read !{cmd}` | insert shell command output |
| `Ctrl+r {reg}` | insert register into command line (or insert mode) |

---

## Misc useful

| Key | Action |
|-----|--------|
| `<leader>w` | save file |
| `<leader>q` | quit |
| `<leader>Q` | force quit all |
| `<leader>n` | toggle file tree (nvim-tree) |
| `<leader>S` | restore session |
| `<leader>m / l` | Mason / Lazy |
| `Ctrl+\` | toggle floating terminal |
| `g?` (inside file tree, help, etc.) | help / keybinds |

---

## Tips for building muscle memory

1. **Stay in normal mode.** Don't park in insert mode. Get in, type, get out.
2. **Use text objects over visual selection.** `ciw` > `viwc`. One key shorter, no visual step.
3. **Compose, don't memorise.** Learn operators + motions + objects separately. The combos emerge.
4. **The dot command (`.`) is gold.** Make changes repeatable, then mash `.`.
5. **Don't use arrow keys.** Force `hjkl`. It pays off.
6. **Learn one new thing per week.** `gq`, registers, macros, marks — pick one and use it for a week.
7. **`:help {topic}`** is the canonical reference. Custom `:H {topic}` (if added) opens it as a centred float.

---

*Edit this file at `nvim/VIM_GUIDE.md`.*
