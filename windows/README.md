# Windows cmd setup

A "pretty cmd" environment that mirrors the look & feel of the WSL/zsh setup
in this repo, but runs natively on Windows with `cmd.exe` (no WSL required).

## What's in here

| File | Purpose |
|------|---------|
| `install.bat` | One-shot installer. Run from any cmd, no admin needed. |
| `cmd-aliases.cmd` | doskey aliases (`ls`, `gs`, `gc`, `vim`, …) — loaded by Clink at every cmd start |
| `clink-prompt.lua` | Hooks Starship and Zoxide into Clink so cmd gets the same prompt as zsh |

## What it installs

Via [scoop](https://scoop.sh) (no admin):

- **clink** — gives cmd modern features (tab completion, persistent history, lua scripting, prompt theming)
- **starship** — the prompt (same `starship.toml` as the zsh setup is deployed)
- **eza, fd, ripgrep, fzf, bat, lazygit, delta, zoxide, gh, neovim, jq**

And deploys:

- `cmd-aliases.cmd` → `%USERPROFILE%\cmd-aliases.cmd`
- `clink-prompt.lua` → `%LOCALAPPDATA%\clink\starship.lua` (Clink auto-loads any `.lua` here)
- `starship.toml` → `%USERPROFILE%\.config\starship.toml` (copied from `../zsh/starship.toml`)
- `nvim` config → `%LOCALAPPDATA%\nvim` (the same config as Linux/Mac)
- Clink autorun → registers itself to load on every cmd launch

## Usage

```cmd
cd path\to\dotfiles\windows
install.bat
```

Close that cmd window. Open a new one. You should see:

- Starship prompt
- Aliases (`ls`, `gs`, `vim`, `dot`, …)
- Tab completion + persistent history
- `nvim` opens your full config

## Limitations vs the zsh setup

- `cmd-aliases.cmd` is doskey-based. No multi-line functions like `ts()`,
  `aime()`, `gnuke()` — those would need `.cmd`/`.bat` scripts written separately.
- No `tmux` (Windows-side). Use WezTerm's tab/split features instead.
- Some bash-isms (here-docs, complex pipelines, `${var:-default}`) don't work.

## Updating

Edit the source files in this directory, then re-run `install.bat`.
