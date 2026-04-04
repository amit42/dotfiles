-- settings/pyright.lua
-- Pyright settings for Python type checking and analysis
-- Formatting is handled by conform (black + isort), not pyright

return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode       = "basic",   -- off | basic | strict
        autoSearchPaths        = true,      -- find packages in src/ etc.
        useLibraryCodeForTypes = true,      -- infer types from installed libs
        diagnosticMode         = "workspace", -- analyse all files, not just open ones
      },
    },
  },
}
