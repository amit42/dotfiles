#!/usr/bin/env bash

# ─────────────────────────────────────────
# dotfiles install script
# Works on: macOS, Linux, WSL
# ─────────────────────────────────────────

set -e   # exit on any error

DOTFILES="$HOME/dotfiles"

echo "→ Setting up dotfiles..."

# ── Detect OS ──────────────────────────
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  OS="wsl"
else
  OS="linux"
fi
echo "→ Detected OS: $OS"
