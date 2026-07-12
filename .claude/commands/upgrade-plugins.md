---
description: Upgrade nvim plugins intentionally and re-pin the lockfile
---

Upgrade the pinned nvim plugin set (see "Plugin version pinning" in CLAUDE.md):

1. `nvim --headless "+Lazy! sync" +qa` — pull latest plugin versions.
2. Verify: `nvim --headless +qa` must exit 0 with no errors. Also check
   markdown rendering and telescope still load:
   `nvim --headless "+lua require('telescope')" +qa`.
3. If anything breaks, `nvim --headless "+Lazy! restore" +qa` rolls back to
   the committed lockfile — diagnose before retrying.
4. On success: `cp ~/.config/nvim/lazy-lock.json nvim/lazy-lock.json`
   (repo copy is the source of truth).
5. Commit as `nvim: upgrade plugins` with a body listing notable version
   jumps. Do not push unless asked.
