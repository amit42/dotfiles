-- settings/jsonls.lua
-- JSON language server settings
-- Uses schemastore.nvim for automatic schema association
-- (package.json, tsconfig.json, GitHub Actions, etc. all get validated)

return {
  settings = {
    json = {
      -- Pull the full schema catalog from schemastore.nvim
      -- Covers hundreds of common JSON config files automatically
      schemas  = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
