#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#  dotfiles/doctor.sh — health check
#  Run any time: bash doctor.sh   (or the `dotdoctor` alias)
#
#  Verifies tools, nvim plugin/parser state, tmux/zsh plugin
#  managers, and drift between this repo and what's deployed.
#  Exit code = number of problems found (0 = healthy).
# ═══════════════════════════════════════════════════════════

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $1"; }
bad()  { echo -e "${RED}✗${NC} $1"; PROBLEMS=$((PROBLEMS + 1)); }
note() { echo -e "${YELLOW}⚠${NC} $1"; }
hdr()  { echo ""; echo -e "${BLUE}── $1 ──────────────────────────────${NC}"; }

PROBLEMS=0
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

# ── Core tools ─────────────────────────────────────────────
hdr "Core tools"
for cmd in nvim tmux fzf rg fd starship zoxide eza delta lazygit tree-sitter; do
  if command -v "$cmd" &>/dev/null; then
    ok "$cmd"
  else
    bad "$cmd missing — re-run install.sh"
  fi
done

# ── Neovim ─────────────────────────────────────────────────
hdr "Neovim"
if command -v nvim &>/dev/null; then
  NVIM_VER=$(nvim --version | head -1)
  ok "$NVIM_VER"

  # Parsers compiled?
  PARSER_DIR="$HOME/.local/share/nvim/site/parser"
  if [ -d "$PARSER_DIR" ] && [ -n "$(ls "$PARSER_DIR" 2>/dev/null)" ]; then
    ok "treesitter parsers: $(ls "$PARSER_DIR" | wc -l | tr -d ' ') compiled"
  else
    bad "no treesitter parsers in $PARSER_DIR — open nvim, run :TSUpdate"
  fi

  # Config loads without error?
  if nvim --headless "+qa" 2>/dev/null; then
    ok "config loads cleanly (headless)"
  else
    bad "nvim config errors on startup — run: nvim --headless +qa"
  fi

  # project.nvim history JSON valid? (corrupts if two nvims race)
  PROJ_HIST="$HOME/.local/share/nvim/project_nvim/project_history.json"
  if [ -f "$PROJ_HIST" ]; then
    if python3 -c "import json,sys; json.load(open('$PROJ_HIST'))" 2>/dev/null; then
      ok "project.nvim history JSON valid"
    else
      bad "project.nvim history corrupt — delete $PROJ_HIST"
    fi
  fi
fi

# ── Plugin managers ────────────────────────────────────────
hdr "Plugin managers"
[ -d "$HOME/.tmux/plugins/tpm" ] \
  && ok "TPM installed" \
  || bad "TPM missing — re-run install.sh"
[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git" ] \
  && ok "zinit installed" \
  || bad "zinit missing — open a new shell to auto-install"
[ -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ] \
  && ok "lazy.nvim installed" \
  || note "lazy.nvim not yet cloned — first nvim launch installs it"

# ── Version pinning ────────────────────────────────────────
hdr "Version pinning"
if [ -f "$DOTFILES/nvim/lazy-lock.json" ]; then
  ok "lazy-lock.json committed in repo"
  if [ -f "$CONFIG/nvim/lazy-lock.json" ]; then
    if diff -q "$DOTFILES/nvim/lazy-lock.json" "$CONFIG/nvim/lazy-lock.json" >/dev/null 2>&1; then
      ok "deployed lockfile matches repo"
    else
      note "deployed lockfile differs from repo — after :Lazy sync, copy it back: cp $CONFIG/nvim/lazy-lock.json $DOTFILES/nvim/"
    fi
  fi
else
  bad "nvim/lazy-lock.json missing from repo — plugin versions are unpinned"
fi

# ── Config drift (repo vs deployed) ────────────────────────
hdr "Config drift"
drift_check() {
  local label="$1" src="$2" dst="$3"
  if [ ! -e "$dst" ]; then
    bad "$label not deployed — run install.sh"
  elif diff -rq "$src" "$dst" >/dev/null 2>&1; then
    ok "$label in sync"
  else
    note "$label drifted from repo — re-run install.sh (repo wins) or port changes back"
  fi
}
drift_check "nvim"     "$DOTFILES/nvim"            "$CONFIG/nvim"
drift_check "zshrc"    "$DOTFILES/zsh/zshrc"       "$CONFIG/zsh/zshrc"
drift_check "tmux"     "$DOTFILES/tmux/tmux.conf"  "$CONFIG/tmux/tmux.conf"
drift_check "wezterm"  "$DOTFILES/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
if [[ "$OSTYPE" == "darwin"* ]]; then
  drift_check "ghostty" "$DOTFILES/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
fi

# ── Summary ────────────────────────────────────────────────
echo ""
if [ "$PROBLEMS" -eq 0 ]; then
  echo -e "${GREEN}═══ All healthy ═══${NC}"
else
  echo -e "${RED}═══ $PROBLEMS problem(s) found ═══${NC}"
fi
exit "$PROBLEMS"
