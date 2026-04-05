# Dotfiles

Personal configuration for zsh, tmux, neovim, starship, and WezTerm.
Designed for backend, embedded, and DevOps development.
Bootstraps itself on any machine — one command, everything installs.

```bash
bash install.sh
```

Supports **macOS**, **Linux**, and **WSL**.

---

## Table of Contents

- [Quick Start](#quick-start)
- [What Gets Installed](#what-gets-installed)
- [File Structure](#file-structure)
- [ZSH](#zsh)
- [Tmux](#tmux)
- [Neovim](#neovim)
- [Starship](#starship)
- [WezTerm](#wezterm)
- [Updating Your Config](#updating-your-config)
- [Adding to a New Machine](#adding-to-a-new-machine)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
# 1. Clone the repo
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles/dotfiles

# 2. Run the installer
bash install.sh

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
| `zoxide` | Smart cd with directory learning |

### Configs deployed

| Config | Source | Destination |
|--------|--------|-------------|
| zshrc | `zsh/zshrc` | `~/.config/zsh/zshrc` |
| starship | `zsh/starship.toml` | `~/.config/starship.toml` |
| tmux | `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| neovim | `nvim/` | `~/.config/nvim/` |
| WezTerm | `wezterm/wezterm.lua` | `~/.wezterm.lua` |

---

## File Structure

```
dotfiles/
├── install.sh              ← run this on any machine
├── zsh/
│   ├── zshrc               ← main shell config
│   └── starship.toml       ← prompt config
├── tmux/
│   └── tmux.conf           ← tmux config
├── nvim/
│   ├── init.lua            ← neovim entry point
│   ├── KEYMAPS.md          ← full keymap reference
│   └── lua/user/
│       ├── plugins/        ← plugin specs (lazy.nvim)
│       └── lsp/            ← LSP, completion, formatting
└── wezterm/
    └── wezterm.lua         ← terminal emulator config
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
| `Prefix+c` | new window (in current path) |
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
| `Space+e` | toggle file explorer |
| `Space+l` | open Lazy plugin manager |
| `jk` | exit insert mode |
| `Ctrl+\` | toggle floating terminal |

**Telescope (fuzzy finder)**

| Key | Action |
|-----|--------|
| `Space+f` | find files |
| `Space+g` | live grep (search text in project) |
| `Space+b` | open buffers |
| `Space+r` | recent files |
| `Space+p` | projects |
| `Space+c` | git commits |

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

**Git**

| Key | Action |
|-----|--------|
| `Space+gs` | git status (fugitive) |
| `Space+gd` | git diff split |
| `]h / [h` | next/prev git hunk |
| `Space+hs` | stage hunk |
| `Space+hr` | reset hunk |
| `Space+tb` | toggle inline blame |

**Navigation**

| Key | Action |
|-----|--------|
| `Shift+l / Shift+h` | next/prev buffer |
| `Space+x` | close buffer |
| `Ctrl+h/j/k/l` | move between splits |
| `Ctrl+d / Ctrl+u` | scroll down/up (centered) |

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
| `Ctrl+Shift+T` | new tab |
| `Ctrl+Shift+W` | close tab |
| `Ctrl+Tab` | next tab |
| `Ctrl+Shift+Tab` | previous tab |
| `Ctrl+Shift+R` | rename tab |
| `Ctrl+Shift+C` | copy |
| `Ctrl+Shift+V` | paste |
| `Ctrl+=` | increase font size |
| `Ctrl+-` | decrease font size |
| `Ctrl+0` | reset font size |
| `F11` | fullscreen |
| `Cmd+R` | reload config |

> Pane splitting and navigation is handled by **tmux**, not WezTerm.

### WSL setup

To use WezTerm with WSL, update `wezterm.lua`:

```lua
-- Comment out:
-- config.default_prog = { "/bin/zsh", "-l" }

-- Uncomment:
config.default_prog = { "wsl.exe", "--distribution", "Ubuntu", "--exec", "/bin/zsh", "-l" }
```

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
nvim dotfiles/nvim/lua/user/plugins/editor.lua   # or whichever file
# Changes take effect immediately in neovim (no install.sh needed)
# Lazy auto-installs/removes plugins on next nvim open
```

### Update p10k / starship prompt style

```bash
# For starship — edit the TOML directly
nvim dotfiles/zsh/starship.toml
bash install.sh && source ~/.zshrc
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

# 5. Install tmux plugins
tmux
# Ctrl+Space I

# 6. Open neovim (lazy auto-installs all plugins)
nvim

# 7. Install JetBrainsMono Nerd Font on the host machine
# Download from: https://www.nerdfonts.com/font-downloads
```

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
