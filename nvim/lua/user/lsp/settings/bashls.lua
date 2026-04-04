-- settings/bashls.lua
-- bash-language-server settings for Bash and Zsh
--
-- There is no dedicated zsh LSP. bash-language-server covers zsh well enough:
-- syntax checking, completions, hover docs for builtins.
-- The filetypes key below extends lspconfig's default (sh only) to include zsh.

return {
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      -- Path to shellcheck binary (linting)
      -- nvim-lint also runs shellcheck separately — bashls uses it for hover diagnostics
      shellcheckPath = "shellcheck",
      -- Glob patterns to exclude from analysis
      globPattern     = "*@(.sh|.inc|.bash|.command|.zsh|.zshrc|.zprofile)",
    },
  },
}
