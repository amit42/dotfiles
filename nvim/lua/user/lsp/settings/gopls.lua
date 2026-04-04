-- settings/gopls.lua
-- gopls (Go language server) settings
-- Formatting is handled by conform (goimports → gofmt), not gopls directly

return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,  -- flag unused function parameters
        shadow       = true,  -- flag variable shadowing
      },
      staticcheck  = true,   -- run staticcheck analysers inside gopls
      gofumpt      = true,   -- stricter formatting than gofmt (if gofumpt installed)
    },
  },
}
