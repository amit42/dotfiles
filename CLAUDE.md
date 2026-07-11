# CLAUDE.md — dotfiles

Personal dotfiles for macOS / Linux / WSL: nvim, zsh (zinit), tmux, starship,
WezTerm, Ghostty, plus a Windows cmd/clink setup. Theme is Catppuccin Mocha
everywhere — keep new UI consistent with it.

## Golden rules

1. **Deploy with `bash install.sh` — never copy files to `~/.config` by hand.**
   The script backs up targets (`*.bak`), is idempotent, and handles
   OS differences. After editing any config here, run it to deploy.
2. **Verify nvim changes headlessly before telling the user to restart:**
   `nvim --headless "+lua require('<module>')" +qa` or `+checkhealth`.
3. **Commit style:** lowercase `area: summary` (e.g. `nvim: fix X`,
   `zsh: add Y`). Body explains why. Never push without being asked.

## Hard constraints (learned the painful way)

- **Neovim 0.12 requires nvim-treesitter v2 (`branch = "main"`).** v1/master
  calls `node:range()` which 0.12 removed — it breaks *every* treesitter
  parse including markdown rendering. Never pin back to master.
- **treesitter must NOT attach to plugin-owned buffers** (TelescopePrompt,
  NvimTree, …). The `SKIP_FT` guard in `nvim/lua/user/plugins/treesitter.lua`
  prevents a race that crashes telescope-file-browser. Keep it.
- **nvim-treesitter-textobjects also needs `branch = "main"`** (v2 API:
  `require("nvim-treesitter-textobjects.select")`, not the old `opts` table).
- **Parser builds need the `tree-sitter` CLI** (installed by install.sh:
  brew `tree-sitter-cli` on mac, cargo on linux). `cc` alone is not enough.
- **project.nvim corrupts its history JSON when two nvim instances run**
  concurrently (no file locking). A self-heal check in `editor.lua` resets
  it at startup — don't remove.
- **zsh plugin load order matters:** fzf-tab first,
  fast-syntax-highlighting last (in its own second `zinit wait` block).

## Plugin version pinning

`nvim/lazy-lock.json` is committed and is the source of truth.
- install.sh runs `:Lazy! restore` after deploying, so every machine gets
  identical plugin versions.
- To upgrade plugins intentionally: `:Lazy sync` in nvim, test, then copy
  `~/.config/nvim/lazy-lock.json` back into the repo and commit it.

## Layout

| Path | What |
|---|---|
| `install.sh` | one-shot installer/deployer (mac/linux/WSL) |
| `doctor.sh` | health check: tools, parsers, drift between repo and deployed |
| `nvim/lua/user/` | options, keymaps, autocommands, dashboard, lazy bootstrap |
| `nvim/lua/user/plugins/` | ui.lua, editor.lua, treesitter.lua, dap.lua |
| `nvim/lua/user/lsp/` | mason + per-server settings in `settings/` |
| `zsh/zshrc` | zinit plugins, aliases, functions (ai/aiy/aime/aidiff, workspace launcher) |
| `tmux/tmux.conf` | TPM, resurrect + continuum, catppuccin |
| `wezterm/`, `ghostty/` | terminal configs (visual parity is a goal) |
| `windows/` | cmd + clink + starship for Windows hosts |
| `legacy_nvim/` | old vimscript config, kept for reference — don't touch |

## Conventions

- Leader is Space. Telescope lives under `<leader>t*`, git hunks `<leader>h*`,
  spectre `<leader>s*`, dap `<leader>d*` + F5/F9-F12, AI `<leader>a*`.
  Check for collisions before adding keymaps (`keymaps.lua` + plugin `keys`).
- Comments in configs explain *why*, matching the existing teaching style.
- Heavy plugins must be lazy (`event`/`keys`/`cmd`/`ft`) — startup budget
  is tight. `lazy = false` needs a written justification comment.
