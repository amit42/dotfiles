#!/bin/sh
# ╔═══════════════════════════════════════════════════════╗
# ║  run.sh — CRLF-safe entry point                      ║
# ║  Use this instead of: bash install.sh                ║
# ║  Works on: macOS, Linux, WSL                         ║
# ╚═══════════════════════════════════════════════════════╝
#
# Problem: if install.sh has CRLF line endings (from Windows),
# the shebang becomes "#!/usr/bin/env bash\r" and the OS rejects
# it with "bad interpreter" before any code runs.
# install.sh cannot strip itself because it's already executing.
#
# Solution: this script uses /bin/sh (always available, tolerates
# \r in most implementations), strips install.sh first, then runs it.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Strip CRLF from install.sh before executing it
sed -i 's/\r//' "$SCRIPT_DIR/install.sh"

# Now run it cleanly
bash "$SCRIPT_DIR/install.sh"
