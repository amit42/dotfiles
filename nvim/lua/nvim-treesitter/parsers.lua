-- Compatibility shim for plugins that still call
-- require("nvim-treesitter.parsers").ft_to_lang(ft)
--
-- The new nvim-treesitter rewrite removed this module.
-- The equivalent is now vim.treesitter.language.get_lang() (Neovim 0.9+).
--
-- Neovim searches ~/.config/nvim/lua/ before plugin directories,
-- so this file is found first and satisfies the require() call.
-- Remove this file once telescope (and any other callers) update to the new API.

return {
  ft_to_lang = function(ft)
    return vim.treesitter.language.get_lang(ft) or ft
  end,
}
