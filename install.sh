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

# ══════════════════════════════════════════════════════════
# TOOLS
# ══════════════════════════════════════════════════════════
echo ""
echo "── Tools ─────────────────────────────────────────────"

install_brew_pkg() {
  if check_cmd "$1"; then
    warn "$1 already installed — skipping"
  else
    log "Installing $1..."
    brew install "$1" && success "Installed $1"
  fi
}

install_apt_pkg() {
  local cmd="$1" pkg="$2"
  if check_cmd "$cmd" || dpkg -s "$pkg" &>/dev/null 2>&1; then
    warn "$cmd already installed — skipping"
  else
    log "Installing $cmd..."
    sudo apt-get install -y "$pkg" && success "Installed $cmd"
  fi
}

if [[ "$OS" == "mac" ]]; then
  if check_cmd brew; then
    install_brew_pkg fzf
    install_brew_pkg fd
    install_brew_pkg rg
    install_brew_pkg zoxide
    install_brew_pkg eza
    install_brew_pkg starship
    install_brew_pkg direnv
    install_brew_pkg atuin
    install_brew_pkg thefuck
    install_brew_pkg bat
    install_brew_pkg delta
    install_brew_pkg lazygit
    install_brew_pkg btop
    install_brew_pkg tldr
    install_brew_pkg lnav
  else
    warn "Homebrew not found — skipping tool installs"
    warn "Install Homebrew from https://brew.sh then re-run"
  fi
elif [[ "$OS" == "linux" ]] || [[ "$OS" == "wsl" ]]; then
  install_apt_pkg fzf fzf
  install_apt_pkg fdfind fd-find
  install_apt_pkg rg ripgrep
  install_apt_pkg lnav lnav
  if ! check_cmd starship; then
    log "Installing starship..."
    curl -sSk https://starship.rs/install.sh | sh -s -- --yes
    success "Installed starship"
  else
    warn "starship already installed — skipping"
  fi
  if ! check_cmd zoxide; then
    log "Installing zoxide..."
    curl -sSk https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    success "Installed zoxide"
  else
    warn "zoxide already installed — skipping"
  fi
  if ! check_cmd eza; then
    if check_cmd cargo; then
      log "Installing eza via cargo..."
      cargo install eza && success "Installed eza"
    else
      warn "eza not installed — install cargo (rustup) then: cargo install eza"
    fi
  else
    warn "eza already installed — skipping"
  fi
fi

echo ""
echo "── Git (delta) ───────────────────────────────────────"
# delta — beautiful diffs with syntax highlighting and side-by-side view
# Configured as git's pager so `git diff`, `git show`, `git log -p` all use it
if check_cmd delta; then
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true        # n/N to jump between diff sections
  git config --global delta.side-by-side true    # two-column diff view
  git config --global delta.line-numbers true
  git config --global delta.syntax-theme "Catppuccin Mocha"
  git config --global merge.conflictstyle diff3
  git config --global diff.colorMoved default
  success "Configured delta as git pager"
else
  warn "delta not installed — skipping git pager config"
fi

echo ""
echo "── Nvim ──────────────────────────────────────────────"

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
  safe_copy "$DOTFILES/zsh/zshrc" "$CONFIG/zsh/zshrc"

  # starship config — starship reads ~/.config/starship.toml automatically
  if [[ -f "$DOTFILES/zsh/starship.toml" ]]; then
    safe_copy "$DOTFILES/zsh/starship.toml" "$CONFIG/starship.toml"
  fi

  append_if_missing "$HOME/.zshrc" "source $CONFIG/zsh/zshrc"
else
  warn "zsh not installed — skipping zsh config"
fi

echo ""
echo "── Tmux ──────────────────────────────────────────────"

# Install tmux if missing
if ! check_cmd tmux; then
  if [[ "$OS" == "mac" ]] && check_cmd brew; then
    log "Installing tmux..."
    brew install tmux && success "Installed tmux"
  elif [[ "$OS" == "linux" ]] || [[ "$OS" == "wsl" ]]; then
    log "Installing tmux..."
    sudo apt-get install -y tmux && success "Installed tmux"
  else
    warn "tmux not found — install manually then re-run"
  fi
fi

if check_cmd tmux; then
  # TPM — tmux plugin manager, self-installs plugins on first tmux start
  TPM_DIR="$HOME/.tmux/plugins/tpm"
  if [[ ! -d "$TPM_DIR" ]]; then
    log "Installing TPM (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" && success "Installed TPM"
  else
    warn "TPM already installed — skipping"
  fi

  safe_copy "$DOTFILES/tmux/tmux.conf" "$CONFIG/tmux/tmux.conf"
  append_if_missing "$HOME/.tmux.conf" "source $CONFIG/tmux/tmux.conf"

  success "Tmux ready — open tmux and press Prefix+I to install plugins"
else
  warn "tmux not installed — skipping tmux config"
fi

echo ""
echo "── WezTerm ───────────────────────────────────────────"
# WezTerm reads ~/.wezterm.lua on macOS/Linux
# and %USERPROFILE%\.wezterm.lua on Windows
WEZTERM_CONFIG="$HOME/.wezterm.lua"
if [[ -f "$DOTFILES/wezterm/wezterm.lua" ]]; then
  if [[ -f "$WEZTERM_CONFIG" ]]; then
    warn "Backing up $WEZTERM_CONFIG → $WEZTERM_CONFIG.bak"
    mv "$WEZTERM_CONFIG" "$WEZTERM_CONFIG.bak"
  fi
  cp "$DOTFILES/wezterm/wezterm.lua" "$WEZTERM_CONFIG"
  success "Copied wezterm.lua → $WEZTERM_CONFIG"
  warn "Requires JetBrainsMono Nerd Font — download from https://www.nerdfonts.com"
else
  warn "dotfiles/wezterm/wezterm.lua not found — skipping"
fi

# ══════════════════════════════════════════════════════════
# DONE
# ══════════════════════════════════════════════════════════
echo ""
echo "═══════════════════════════════════════════════════════"
success "Install complete"
echo ""
echo "  Nvim      → $CONFIG/nvim"
echo "  Zsh       → $CONFIG/zsh/zshrc"
echo "  Tmux      → $CONFIG/tmux/tmux.conf"
echo "  Starship  → $CONFIG/starship.toml"
echo "  WezTerm   → $HOME/.wezterm.lua"
echo ""
echo "  Next steps:"
echo "  1. source ~/.zshrc"
echo "  2. Open tmux → press Prefix+I to install plugins"
echo "  3. Install JetBrainsMono Nerd Font on host machine"
echo "═══════════════════════════════════════════════════════"

