# Dotfiles

Personal configuration for zsh, tmux, neovim, starship, WezTerm, and Ghostty.
Designed for backend, embedded, and DevOps development.
Bootstraps itself on any machine — one command, everything installs.

```bash
sh run.sh
```

> Use `sh run.sh` not `bash install.sh` — `run.sh` strips CRLF from
> `install.sh` before executing it, preventing "bad interpreter" errors on WSL.

Supports **macOS**, **Linux**, and **WSL**.

Highlights:
- **One theme everywhere** — 9 switchable themes drive nvim, tmux, starship,
  WezTerm, and Ghostty together (`bash install.sh --theme gruvbox`)
- **Project workspaces** — `ts` builds a tmux session per project
  (EDITOR / AGENT / TERMINAL) with a Claude Code agent window
- **Pinned plugin versions** — `lazy-lock.json` is committed; every machine
  gets byte-identical nvim plugins
- **Self-diagnosing** — `dotdoctor` checks tools, plugins, and config drift

---

## Table of Contents

- [Quick Start](#quick-start)
- [Theming](#theming)
- [What Gets Installed](#what-gets-installed)
- [File Structure](#file-structure)
- [ZSH](#zsh)
- [Workspace Sessions (ts)](#workspace-sessions-ts)
- [AI Helpers](#ai-helpers)
- [Music & News](#music--news)
- [Tmux](#tmux)
- [Neovim](#neovim)
- [Emacs](#emacs)
- [Starship](#starship)
- [WezTerm](#wezterm)
- [Health Check](#health-check)
- [Updating Your Config](#updating-your-config)
- [Adding to a New Machine](#adding-to-a-new-machine)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# 1. Clone the repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles/dotfiles

# 2. Run the installer (sh tolerates CRLF, strips install.sh first)
sh run.sh

# 3. Reload shell
source ~/.zshrc

# 4. Open tmux and install plugins
tmux
# then press: Ctrl+Space I
```

> **Font required:** Install **JetBrainsMono Nerd Font** on your host machine
> before opening WezTerm or neovim, otherwise icons show as boxes.
> Download: https://www.nerdfonts.com/font-downloads

---

## Theming

One theme drives everything — nvim, tmux, starship, WezTerm, Ghostty:

```bash
bash install.sh --list-themes     # see all 9
bash install.sh --theme kanagawa  # switch everything at once
```

Available: `catppuccin-mocha` (default), `tokyonight`, `gruvbox`, `kanagawa`,
`rose-pine`, `nord`, `dracula`, `everforest`, `onedark`.

The choice persists in `~/.config/dotfiles-theme`. nvim and WezTerm read it
at startup; tmux/Ghostty/starship get their palette materialized by
install.sh. Live tmux sessions are re-themed in place; terminals pick up the
change on reload. Even the shell startup banner recolors — it renders from
the terminal's ANSI palette.

---

## What Gets Installed

### Tools (auto-installed by install.sh)

| Tool | Purpose |
|------|---------|
| `starship` | Cross-shell prompt with Catppuccin Mocha theme |
| `fzf` | Fuzzy finder — files, history, processes |
| `fd` | Fast `find` replacement |
| `rg` | Fast `grep` replacement (ripgrep) |
| `eza` | Modern `ls` with icons and git status |
| `bat` | `cat` with syntax highlighting |
| `delta` | Beautiful git diffs with side-by-side view |
| `lazygit` | Full TUI git client |
| `zoxide` | Smart `cd` that learns your directories |
| `btop` | Visual system monitor |
| `tldr` | Practical quick-reference man pages |
| `lnav` | Log file viewer with syntax highlighting |
| `direnv` | Per-directory environment variables |
| `atuin` | Shell history sync + fuzzy search |
| `thefuck` | Corrects your last command |
| `jq` | JSON processor (powers the `ais` Claude session picker) |
| `tree-sitter-cli` | Compiles nvim treesitter parsers (required on nvim 0.12+) |
| `mpv` | terminal audio/video player (`play`, `music`) |
| `yt-dlp` | YouTube stream resolution for `play` |
| `circumflex` | Hacker News TUI (`hn`) |

tmux plugins (TPM + sensible + resurrect + continuum) are installed
headlessly — no manual `Prefix+I` needed. nvim plugins are pinned to
`nvim/lazy-lock.json` via `:Lazy! restore` on every install.

### Configs deployed

| Config | Source | Destination |
|--------|--------|-------------|
| zshrc | `zsh/zshrc` | `~/.config/zsh/zshrc` |
| starship | `zsh/starship.toml` | `~/.config/starship.toml` |
| tmux | `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| neovim | `nvim/` | `~/.config/nvim/` |
| WezTerm | `wezterm/wezterm.lua` | `~/.wezterm.lua` |
| Ghostty | `ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/` (mac) / `~/.config/ghostty/` |
| editorconfig | `editorconfig/editorconfig` | `~/.editorconfig` |
| clang-format | `clang-format/clang-format` | `~/.clang-format` |

---

## File Structure

```
dotfiles/
├── install.sh              ← run this on any machine (--theme, --list-themes)
├── doctor.sh               ← health check (alias: dotdoctor)
├── run.sh                  ← CRLF-safe wrapper for install.sh (WSL)
├── CLAUDE.md               ← conventions for Claude Code sessions
├── zsh/
│   ├── zshrc               ← main shell config (aliases, functions, AI helpers)
│   └── starship.toml       ← prompt config (per-theme palettes)
├── tmux/
│   ├── tmux.conf           ← tmux config
│   └── themes/             ← per-theme status bar colors
├── nvim/
│   ├── init.lua            ← neovim entry point
│   ├── KEYMAPS.md          ← full keymap reference
│   ├── VIM_GUIDE.md        ← vim learning guide (<leader>? in nvim)
│   ├── lazy-lock.json      ← pinned plugin versions (committed!)
│   └── lua/user/
│       ├── plugins/        ← one file per concern (telescope, git, dap, …)
│       └── lsp/            ← LSP, completion, formatting
├── emacs/
│   ├── early-init.el       ← pre-GUI: chrome off, GC deferred
│   └── init.el             ← evil + vertico/consult + eglot + magit + org
├── mpv/
│   ├── mpv.conf            ← player config (quiet startup, resume, 1080p cap)
│   └── scripts/pillbar.lua ← audio-reactive status-line visualizer
├── wezterm/
│   └── wezterm.lua         ← terminal emulator config
├── ghostty/
│   ├── config              ← alternate terminal (visual parity with wezterm)
│   └── themes/             ← per-theme palettes
├── editorconfig/           ← global indent rules (~/.editorconfig)
├── clang-format/           ← global C/C++ style (~/.clang-format)
└── windows/                ← cmd + clink + starship for Windows hosts
```

---

## ZSH

### How it loads

```
Terminal opens
    ↓
~/.zprofile         ← brew PATH, login shell setup
    ↓
~/.zshrc            ← machine-specific (conda, nvm, etc.)
    ├── source ~/.config/zsh/zshrc   ← our portable config
    ↓
~/.config/zsh/zshrc ← everything below lives here
```

### Plugin manager: zinit

zinit bootstraps itself on first run — no manual install needed.
Plugins are lazy-loaded after the prompt paints, keeping startup fast.

| Plugin | What it does |
|--------|-------------|
| `fzf-tab` | Tab completion becomes a fzf picker with previews |
| `zsh-autosuggestions` | Ghost-text suggestions from history |
| `zsh-completions` | Extra completion definitions |
| `fast-syntax-highlighting` | Real-time command coloring |

### Navigation aliases

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `-` | `cd -` (previous directory) |
| `ls` | `eza --icons` |
| `ll` | `eza -lh --icons --git` |
| `la` | `eza -lah --icons --git` |
| `lt` | `eza --tree --icons --level=2` |

> Just type a directory name without `cd` — `AUTO_CD` is enabled.

### Editor aliases

| Alias | Command |
|-------|---------|
| `v`, `vi`, `vim` | `nvim` |
| `cat` | `bat --paging=never` |
| `catp` | `bat` (with pager for large files) |
| `grep` | `rg` |
| `find` | `fd` |
| `top` | `btop` |
| `help` | `tldr` |

### Git aliases

| Alias | Command |
|-------|---------|
| `lg` | `lazygit` — full TUI git client |
| `gs` | `git status -sb` |
| `ga` | `git add` |
| `gaa` | `git add -A` |
| `gc "msg"` | `git commit -m` |
| `gca` | `git commit --amend --no-edit` |
| `gp` | `git push` |
| `gpf` | `git push --force-with-lease` |
| `gl` | `git pull` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gb` | `git branch -vv` |
| `glog` | visual branch graph |
| `gd` | `git diff` (rendered via delta) |
| `gds` | `git diff --staged` |
| `gst` | `git stash` |
| `gstp` | `git stash pop` |
| `grbi` | `git rebase -i` |
| `gundo` | undo last commit, keep changes |
| `gnuke` | ⚠ destroy all local changes |
| `groot` | cd to repo root |

### Docker aliases

| Alias | Command |
|-------|---------|
| `d` | `docker` |
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dex` | `docker exec -it` |
| `dlog` | `docker logs -f` |
| `dstop` | stop all running containers |
| `dclean` | ⚠ `docker system prune -af` |
| `dc` | `docker compose` |
| `dcu` | `docker compose up` |
| `dcud` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcr` | `docker compose restart` |
| `dcl` | `docker compose logs -f` |
| `dcb` | `docker compose build` |

### Kubernetes aliases

| Alias | Command |
|-------|---------|
| `k` | `kubectl` |
| `kgp` | `kubectl get pods` |
| `kgpa` | `kubectl get pods -A` |
| `kgs` | `kubectl get services` |
| `kgn` | `kubectl get nodes` |
| `kd` | `kubectl describe` |
| `klog` | `kubectl logs -f` |
| `kex` | `kubectl exec -it` |
| `kctx` | switch cluster context |
| `kns` | switch namespace |
| `kaf` | `kubectl apply -f` |
| `kdf` | `kubectl delete -f` |
| `ksh <pod>` | shell into pod (sh) |
| `kbash <pod>` | shell into pod (bash) |

### AWS aliases

| Alias | Command |
|-------|---------|
| `awsid` | show current IAM identity |
| `awsp <profile>` | switch AWS profile |
| `s3ls` | `aws s3 ls` |
| `ssm <instance-id>` | SSM session to EC2 |
| `cwlogs <group>` | tail CloudWatch log group |

### Embedded / C aliases

| Alias | Command |
|-------|---------|
| `armcc` | `arm-none-eabi-gcc` |
| `armobjdump` | `arm-none-eabi-objdump -d` |
| `armsize` | `arm-none-eabi-size` |
| `armgdb` | `arm-none-eabi-gdb` |
| `serial` | picocom on `/dev/ttyUSB0` at 115200 |
| `serial1` | picocom on `/dev/ttyUSB1` |
| `m` | `make` |
| `mc` | `make clean` |
| `mf` | `make flash` |
| `mb` | `make build` |
| `mr` | `make run` |
| `disasm <binary>` | objdump piped to less |

### Language aliases

**Python**
| Alias | Command |
|-------|---------|
| `py` | `python3` |
| `pip` | `pip3` |
| `venv` | create `.venv` in current dir |
| `va` | activate venv |
| `vd` | deactivate venv |
| `mkvenv` | create + activate in one shot |

**Go**
| Alias | Command |
|-------|---------|
| `gob` | `go build ./...` |
| `gor` | `go run .` |
| `got` | `go test ./...` |
| `gotv` | `go test -v ./...` |
| `gomod` | `go mod tidy` |
| `govet` | `go vet ./...` |

**Node**
| Alias | Command |
|-------|---------|
| `ni` | `npm install` |
| `nid` | `npm install --save-dev` |
| `nr` | `npm run` |
| `ns` | `npm start` |
| `nt` | `npm test` |
| `nb` | `npm run build` |

**Rust**
| Alias | Command |
|-------|---------|
| `cb` | `cargo build` |
| `cr` | `cargo run` |
| `ct` | `cargo test` |
| `ccheck` | `cargo check` (fast type-check) |
| `cclippy` | `cargo clippy` |
| `cfmt` | `cargo fmt` |
| `cbr` | `cargo build --release` |
| `crr` | `cargo run --release` |
| `cwatch` | rebuild + rerun on file change |

### FZF functions

| Function | What it does |
|----------|-------------|
| `Ctrl+T` | fuzzy insert file path at cursor |
| `Ctrl+R` | fuzzy search history (via atuin) |
| `Alt+C` | fuzzy cd into a directory |
| `fglog` | browse git log, preview full diff per commit |
| `fcd` | fuzzy cd into any subdirectory |
| `fkill` | fuzzy pick a process and kill it |

### Utility functions

| Function | Usage | What it does |
|----------|-------|-------------|
| `mkcd` | `mkcd my-dir` | mkdir + cd in one step |
| `backup` | `backup file.txt` | copy with timestamp suffix |
| `extract` | `extract archive.tar.gz` | universal archive extractor |
| `whichport` | `whichport 8080` | show what's using a port |
| `json` | `json '{"k":"v"}'` | pretty-print JSON in nvim |
| `serve` | `serve [port]` | HTTP server in current dir |
| `weather` | `weather [city]` | weather in terminal |
| `crun` | `crun main.c` | compile + run a C file |
| `csizeof` | `csizeof uint32_t` | print sizeof a C type |
| `bigfiles` | `bigfiles` | top 20 largest files |
| `gclone` | `gclone <url>` | git clone + cd into repo |

### Log viewing

| Command | Usage | What it does |
|---------|-------|-------------|
| `log` | `log /var/log/nginx/access.log` | open in lnav TUI |
| `sshlog` | `sshlog user@host /var/log/app.log` | tail remote log via lnav |
| `sshcat` | `sshcat user@host /var/log/app.log` | view remote log via bat |
| `sshj` | `sshj user@host [unit]` | tail remote systemd journal |

**Inside lnav:**

| Key | Action |
|-----|--------|
| `/` | regex search |
| `;` | SQL query mode |
| `:filter-in <pattern>` | show only matching lines |
| `:filter-out <pattern>` | hide matching lines |
| `q` | quit |

### Prompt positioning

| Key | Action |
|-----|--------|
| `Ctrl+L` | Push prompt to middle of screen |

Previous output stays in scrollback — scroll up in WezTerm/tmux to see it.
Use this whenever the prompt hits the bottom after long command output.

### Elite tools

| Tool | How it works |
|------|-------------|
| `zoxide` (`cd`) | learns frequent dirs; `cd proj` jumps to `~/dev/my-project` after a few visits |
| `direnv` | place a `.envrc` in a project dir, `direnv allow`, env vars load/unload on cd |
| `thefuck` | press `Esc Esc` to correct last command |
| `atuin` | `Ctrl+R` opens searchable history with timestamps and exit codes |

---

## Workspace Sessions (ts)

`ts` from any project directory creates (or re-attaches to) a tmux session
named after the directory, with a fixed window layout:

| Window | What |
|--------|------|
| 1 ` EDITOR` | nvim |
| 2 `󰍛 AGENT` | Claude Code (`--continue`, resumes the project's last conversation) |
| 3 ` TERMINAL` | plain shell |
| 4 ` CMD` | cmd.exe (WSL only) |

Extra windows from `Prefix+c` auto-name themselves `ALPHA`, `BETA`, `GAMMA`, …
(first unused Greek letter — closing a window recycles its name).

| Command | What it does |
|---------|-------------|
| `ts` | create/attach the session for the current directory |
| `tn <name>` | attach-or-create a session by name |
| `tswitch` | fzf picker over sessions (switches inside tmux, attaches outside) |
| `tq` | detach (session keeps running) |
| `tkill` | kill current session |

`ts` and `tswitch` also rename the WezTerm tab to match the session, so
terminal tabs mirror your projects.

---

## AI Helpers

All powered by [Claude Code](https://claude.com/claude-code); every helper is
a no-op if `claude` isn't installed.

| Command | What it does |
|---------|-------------|
| `ai "question"` | one-shot answer in the terminal |
| `aiy "do X"` | same, with permissions skipped (own projects only) |
| `aime "what's my keymap for …"` | ask about *your own setup* — read-only, persistent session |
| `aidiff [--staged]` | pipe a git diff to Claude for a quick review |
| `ais` | fzf picker over this project's Claude sessions — transcript preview, Enter resumes |

**Inside nvim** (see [Neovim](#neovim)): `Ctrl+a` toggles a floating Claude
terminal that resumes the project conversation; `<Space>ab` types an
`@current-file` mention into its prompt, `<Space>as` (visual) mentions the
selected line range.

---

## Music & News

### Music — stream, remember, playlist (mpv + yt-dlp, nothing downloaded)

`play` streams audio in the terminal and logs URL + title to a history
file; `music` re-plays from that history. Storage is two flat TSV files
under `~/.local/share/music/` — hand-editable, no database.

| Command | What it does |
|---------|-------------|
| `play <url \| search words>` | stream audio (searches YouTube if not a URL) |
| `playv …` | same, with mpv's video window (1080p cap) |
| `play -l …` | loop the track forever |
| `music` | fzf over everything played — Enter plays, Tab queues |
| `music loop` | picked tracks on repeat |
| `music ls` / `music all` | print history / shuffle-stream all of it |
| `music add` / `music del` | curate the one global playlist (picked via fzf) |
| `music show` | print the playlist in play order |
| `music pl [loop]` | play the playlist top to bottom (optionally forever) |
| `musicv …` | any of the above with video |

**The status line** is a live visualizer (`mpv/scripts/pillbar.lua`):
thin bars dancing to the music in the classic LED spectrum-analyzer
palette (green base, amber mids, red peaks), split stereo — left half of
the bars follows the left channel, right half the right. Loudness is
measured inside mpv's own audio chain (ffmpeg `astats`), relative to the
track's rolling baseline, with VU ballistics — instant attack, gentle
decay. One line of plain ANSI text: no capture devices, no graphics
protocols, terminal never taken over. `9`/`0` flash a `vol %` readout;
pause freezes the bars.

mpv keys: `Space` pause · `←/→` seek · `9/0` volume · `>` `<` next/prev
in queue · `q` quit. Quit mid-track and it resumes on replay.

### Hacker News

`hn` opens [circumflex](https://github.com/bensadeh/circumflex): `j/k`
move, `Enter` reads comments as clean pages, `o` opens in browser,
`Space` favorites, `Tab` switches top/new/ask/show, `q` quits.

---

## Tmux

### Prefix key

`Ctrl+Space`

### Sessions

| Key | Action |
|-----|--------|
| `Prefix+d` | detach from session |
| `Prefix+s` | session switcher |
| `Prefix+$` | rename session |
| `tmux new -s name` | new named session |
| `tmux attach -t name` | attach to session |
| `tmux ls` | list sessions |
| `Prefix+Ctrl+s` | save session (resurrect) |
| `Prefix+Ctrl+r` | restore session (resurrect) |

> Sessions auto-save every 15 minutes via tmux-continuum.
> Sessions auto-restore when tmux starts.

### Windows

| Key | Action |
|-----|--------|
| `Prefix+c` | new window in current path, auto-named ALPHA/BETA/GAMMA… |
| `Prefix+,` | rename window |
| `Prefix+w` | window list |
| `Prefix+1-9` | jump to window by number |
| `Prefix+Ctrl+l` | next window |
| `Prefix+Ctrl+h` | previous window |
| `Prefix+X` | kill window |

### Panes

| Key | Action |
|-----|--------|
| `Prefix+\|` | split vertical (side by side) |
| `Prefix+-` | split horizontal (top/bottom) |
| `Prefix+h/j/k/l` | navigate panes |
| `Prefix+H/J/K/L` | resize panes |
| `Prefix+z` | zoom pane (fullscreen toggle) |
| `Prefix+x` | kill pane |

### Copy mode

| Key | Action |
|-----|--------|
| `Prefix+Enter` | enter copy mode |
| `v` | begin selection |
| `Ctrl+v` | rectangle/block select |
| `y` | copy selection |
| `Prefix+p` | paste |
| `Escape` | exit copy mode |

### Config

| Key | Action |
|-----|--------|
| `Prefix+r` | reload tmux.conf |
| `Prefix+I` | install plugins (TPM) |
| `Prefix+U` | update plugins |

### Typical workflow

```bash
# Start of day
tmux new -s work      # or just open terminal (auto-attach)

# Set up windows
Prefix+c              # new window
Prefix+,              # rename it

# Split for code + terminal
Prefix+|              # nvim on left, terminal on right

# End of day
Prefix+d              # detach (session keeps running)

# Next day — terminal auto-attaches to 'main' session
```

---

## Neovim

Leader key: `Space`

Full keymap reference: `nvim/KEYMAPS.md`

### Most used keymaps

**General**

| Key | Action |
|-----|--------|
| `Space+w` | save file |
| `Space+q` | quit |
| `Space+e` | file browser (telescope) |
| `Space+n` | toggle file tree (floating nvim-tree) |
| `Space+l` | open Lazy plugin manager |
| `jk` | exit insert mode |
| `Ctrl+\` | toggle floating terminal |

**Claude Code**

| Key | Action |
|-----|--------|
| `Ctrl+a` | toggle floating Claude (resumes project conversation; same key hides it) |
| `Space+ab` | type `@current-file` into Claude's prompt |
| `Space+as` | (visual) type `@file lines N-M` for the selection |

**Telescope (fuzzy finder — all under `Space+t`)**

| Key | Action |
|-----|--------|
| `Space+tf` | find files |
| `Space+tg` | live grep (search text in project) |
| `Space+t/` | fuzzy search in current buffer |
| `Space+t.` | resume last picker (results intact) |
| `Space+tb` | open buffers |
| `Space+tr` | recent files |
| `Space+tp` | projects |
| `Space+tc` | git commits |
| `Space+tt` | search TODO/FIXME comments |

**Motion**

| Key | Action |
|-----|--------|
| `s` + 2 chars | flash jump anywhere on screen |
| `]f / [f` | next/prev function |
| `]h / [h` | next/prev git hunk |
| `]t / [t` | next/prev TODO comment |
| `vif / vaf` | select inner/outer function (textobjects) |

**LSP**

| Key | Action |
|-----|--------|
| `gd` | go to definition |
| `gr` | references |
| `K` | hover docs |
| `Space+la` | code action |
| `Space+lr` | rename symbol |
| `Space+lf` | format file |
| `Space+lq` | buffer diagnostics |

**Debug (DAP — VS Code conventions)**

| Key | Action |
|-----|--------|
| `F5` | start / continue |
| `F9` | toggle breakpoint |
| `F10 / F11 / F12` | step over / into / out |
| `Space+du` | toggle debug UI |

**Git**

| Key | Action |
|-----|--------|
| `Space+gs` | git status (fugitive) |
| `Space+gd` | git diff split |
| `]h / [h` | next/prev git hunk |
| `Space+hs` | stage hunk |
| `Space+hr` | reset hunk |
| `Space+gb` | toggle inline blame |

**Navigation**

| Key | Action |
|-----|--------|
| `Shift+l / Shift+h` | next/prev buffer |
| `Space+x` | close buffer |
| `Ctrl+h/j/k/l` | move between splits |
| `Ctrl+d / Ctrl+u` | smooth scroll down/up |

---

## Emacs

Terminal-first Emacs (`em` = `emacs -nw`) built to mirror the nvim setup:
**evil-mode with the same Space leader**, `jk` to escape, and the same
theme — init.el reads `~/.config/dotfiles-theme` and maps each of the 9
themes to its best Emacs port (catppuccin, doom-*, kanagawa; rose-pine
and everforest approximate to the closest doom theme). Wallpaper
transparency carries over in terminal frames too.

Config: `emacs/init.el` → `~/.config/emacs/` (install.sh backs up any
legacy `~/.emacs.d`, which would shadow it, and pre-warms all packages
headlessly so first launch is instant).

| nvim | emacs equivalent |
|------|-----------------|
| telescope | vertico + consult (`SPC t f/g/b/r//`) |
| nvim-cmp | corfu + cape |
| LSP/mason | eglot (same server binaries) |
| gitsigns + fugitive | diff-hl + magit (`SPC g s`) |
| lualine | doom-modeline |
| treesitter | built-in treesit + treesit-auto |
| Comment.nvim / surround | evil-commentary / evil-surround |

**Org mode** is set up with `org-modern` styling and evil bindings:
files in `~/org`, `SPC o a` agenda · `SPC o c` capture · `SPC o o` notes.
TODO flow: `TODO → DOING → DONE` (done items get timestamped).

---

## Starship

Config: `dotfiles/zsh/starship.toml` → deployed to `~/.config/starship.toml`

**Prompt layout:**
```
~/dev/project  main +2!      node 20.1          2.3s  15:42
❯
```

- **Left:** directory → git branch → git status → active language
- **Right:** command duration (if >1s) + time
- Languages only appear when relevant files exist in the directory
- Kubernetes/AWS only appear in directories with relevant config files

**To customize:**
```bash
# Edit the config
nvim dotfiles/zsh/starship.toml

# Deploy and apply
bash install.sh && source ~/.zshrc
```

Full docs: https://starship.rs/config/

---

## WezTerm

Config: `dotfiles/wezterm/wezterm.lua` → deployed to `~/.wezterm.lua`

### Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+Shift+T` | new tab (prompts for a name; Enter skips) |
| `Ctrl+Shift+N` | rename current tab |
| `Ctrl+Shift+W` | close tab |
| `Ctrl+Tab` | next tab |
| `Ctrl+Shift+Tab` | previous tab |
| `Ctrl+Shift+C` | copy |
| `Ctrl+Shift+V` | paste |
| `Ctrl+=` | increase font size |
| `Ctrl+-` | decrease font size |
| `Ctrl+0` | reset font size |
| `F11` | fullscreen |
| `Cmd+R` | reload config |

> Pane splitting and navigation is handled by **tmux**, not WezTerm.
> On Windows hosts WezTerm boots straight into WSL zsh automatically
> (`default_prog` detects the platform — no edits needed).

---

## Health Check

```bash
dotdoctor        # alias for: bash doctor.sh
```

Verifies, with a ✓/✗ per item:
- core tools on PATH (nvim, tmux, fzf, rg, jq, tree-sitter, …)
- nvim loads headlessly, treesitter parsers compiled, project.nvim history intact
- TPM + resurrect + continuum installed **and** the resurrect save is fresh
- `lazy-lock.json` committed and matching the deployed copy
- drift between this repo and every deployed config

Exit code = number of problems, so it's script/CI-friendly. A GitHub Actions
workflow runs shellcheck + a headless nvim bootstrap on every push.

---

## Updating Your Config

### Change a zsh alias or function

```bash
nvim dotfiles/zsh/zshrc
bash install.sh
source ~/.zshrc
```

### Change the prompt

```bash
nvim dotfiles/zsh/starship.toml
bash install.sh && source ~/.zshrc
```

### Change tmux config

```bash
nvim dotfiles/tmux/tmux.conf
bash install.sh
# Inside tmux:
Prefix+r    # reload config live
```

### Change neovim config

```bash
nvim dotfiles/nvim/lua/user/plugins/telescope.lua   # one file per concern
bash install.sh    # deploys to ~/.config/nvim and re-pins plugins
```

### Upgrade nvim plugins (intentionally)

Plugin versions are pinned to `nvim/lazy-lock.json`. To upgrade:

```bash
# In nvim: :Lazy sync — then test things work, then:
cp ~/.config/nvim/lazy-lock.json dotfiles/nvim/lazy-lock.json
git commit -m "nvim: bump plugin pins"
```

---

## Adding to a New Machine

```bash
# 1. Prerequisites (macOS)
xcode-select --install          # git, make, compilers
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles/dotfiles

# 3. Run installer (installs all tools, deploys all configs)
bash install.sh

# 4. Reload shell
source ~/.zshrc

# 5. Open neovim — plugins restore to the pinned lockfile versions
nvim

# 6. Install JetBrainsMono Nerd Font on the host machine
# Download from: https://www.nerdfonts.com/font-downloads

# 7. Verify everything
dotdoctor
```

tmux plugins install automatically during step 3 — no manual `Prefix+I`.

---

## Troubleshooting

### Icons show as boxes
Font not installed on the host machine. Install **JetBrainsMono Nerd Font**.
On WSL: install the font on Windows, not inside WSL.

### zsh config not loading
Check what file zsh is actually reading:
```bash
echo $ZDOTDIR        # should be empty (or unset)
grep zshrc ~/.zshrc  # should contain: source ~/.config/zsh/zshrc
```

### zinit not installing plugins
```bash
rm -rf ~/.local/share/zinit   # remove broken install
# Open new terminal — zinit re-clones itself
```

### Starship not showing
```bash
which starship        # should return a path
brew install starship # reinstall if missing
```

### Tmux plugins not working
Open tmux, then press `Prefix+I` (Ctrl+Space, then I).
TPM downloads and installs all plugins.

### Neovim colors look wrong in tmux
Ensure `tmux.conf` has:
```
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:RGB"
```
Then restart tmux (not just reload config).

### delta not showing styled diffs
```bash
which delta               # confirm it's installed
git config --global core.pager  # should return 'delta'
bash install.sh           # re-run to configure git
```

### Neovim LSP not working
```
:Mason          ← open Mason server manager
:LspInfo        ← see what's attached to current buffer
:LspLog         ← check error logs
```
