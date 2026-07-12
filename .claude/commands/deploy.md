---
description: Deploy dotfiles and run the health check
---

Deploy and verify this dotfiles repo:

1. Run `bash install.sh` from the repo root (never copy files to ~/.config by hand).
2. Run `bash doctor.sh` and report its findings.
3. If doctor reports drift, treat the REPO as the source of truth by default —
   but if the user said they edited the deployed config directly, sync the
   deployed file back into the repo instead (diff first, show what changed).
4. Fix any ✗ problems doctor reports; ask before anything destructive.
