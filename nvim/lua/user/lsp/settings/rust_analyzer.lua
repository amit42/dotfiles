-- settings/rust_analyzer.lua
-- rust-analyzer settings
-- Formatting is handled by conform (rustfmt), not rust-analyzer directly

return {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",  -- use clippy instead of cargo check for richer lints
      },
      cargo = {
        allFeatures = true,  -- analyse all feature flags, not just the default set
      },
      procMacro = {
        enable = true,       -- expand procedural macros (derive, async, etc.)
      },
      inlayHints = {
        bindingModeHints          = { enable = true },
        chainingHints             = { enable = true },
        closingBraceHints         = { enable = true, minLines = 10 },
        parameterHints            = { enable = true },
        typeHints                 = { enable = true },
        reborrowHints             = { enable = "mutable" },
      },
    },
  },
}
