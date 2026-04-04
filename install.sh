#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
#  dotfiles/install.sh
#  Run once on any machine: bash install.sh
#  Supports: macOS, Linux, WSL
# ═══════════════════════════════════════════════════════════

set -e  # stop on any error

# ── Colors for output ──────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log()     { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; exit 1; }


DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "Dotfiles source : $DOTFILES"

# ── Detect OS ──────────────────────────────────────────────
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS="wsl"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
fi
log "Detected OS     : $OS"

CONFIG="$HOME/.config"
log "Config target   : $CONFIG"
echo ""

safe_copy() {
  local src="$1"
  local dst="$2"

  # Make sure parent directory exists
  mkdir -p "$(dirname "$dst")"

  # Backup if destination already exists
  if [ -e "$dst" ]; then
    warn "Backing up $dst → $dst.bak"
    rm -rf "$dst.bak"          # remove old backup first
    mv "$dst" "$dst.bak"
  fi

  cp -r "$src" "$dst"
  success "Copied $(basename $src) → $dst"
}

append_if_missing() {
  local file="$1"
  local line="$2"

  # Create file if it doesn't exist
  touch "$file"

  if grep -qF "$line" "$file"; then
    warn "Already present in $(basename $file) — skipping"
  else
    echo "" >> "$file"         # blank line for cleanliness
    echo "$line" >> "$file"
    success "Added to $(basename $file): $line"
  fi
}

check_cmd() {
  command -v "$1" &>/dev/null
}

if check_cmd nvim; then
  # Copy our entire nvim/ folder to ~/.config/nvim
  # nvim always looks here — no extra source line needed
  safe_copy "$DOTFILES/nvim" "$CONFIG/nvim"
else
  warn "nvim not installed — skipping nvim config"
  warn "Install nvim then re-run this script"
fi

# ══════════════════════════════════════════════════════════
# ZSH
# ══════════════════════════════════════════════════════════
echo ""
echo "── Zsh ───────────────────────────────────────────────"

if check_cmd zsh; then
  # Copy our zshrc to ~/.config/zsh/zshrc
  # This is NOT where zsh auto-reads — but it's clean and standard
  safe_copy "$DOTFILES/zsh/zshrc" "$CONFIG/zsh/zshrc"

  # Add ONE source line to ~/.zshrc
  # ~/.zshrc is what zsh reads by default on every shell start
  # We don't rewrite it — just tell it to load our config
  append_if_missing "$HOME/.zshrc" "source $CONFIG/zsh/zshrc"
else
  warn "zsh not installed — skipping zsh config"
fi

echo ""
echo "── Tmux ──────────────────────────────────────────────"

if check_cmd tmux; then
  # Copy our tmux.conf to ~/.config/tmux/tmux.conf
  safe_copy "$DOTFILES/tmux/tmux.conf" "$CONFIG/tmux/tmux.conf"

  # Add ONE source line to ~/.tmux.conf
  # tmux reads ~/.tmux.conf by default
  # We just point it to our actual config
  append_if_missing "$HOME/.tmux.conf" "source $CONFIG/tmux/tmux.conf"
else
  warn "tmux not installed — skipping tmux config"
fi

# ══════════════════════════════════════════════════════════
# DONE
# ══════════════════════════════════════════════════════════
echo ""
echo "═══════════════════════════════════════════════════════"
success "Install complete"
echo ""
echo "  Nvim   → $CONFIG/nvim"
echo "  Zsh    → $CONFIG/zsh/zshrc"
echo "  Tmux   → $CONFIG/tmux/tmux.conf"
echo ""
echo "  ~/.zshrc     sources our zsh config"
echo "  ~/.tmux.conf sources our tmux config"
echo ""
echo "  Run: source ~/.zshrc"
echo "═══════════════════════════════════════════════════════"

