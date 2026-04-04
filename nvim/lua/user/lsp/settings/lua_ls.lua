-- settings/lua_ls.lua
-- lua-language-server settings
-- Needs special config so it understands vim.* globals and the neovim runtime

return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",  -- neovim uses LuaJIT, not standard Lua
      },
      diagnostics = {
        globals = { "vim" },  -- stop lua_ls flagging vim as undefined
      },
      workspace = {
        -- Expose the full neovim runtime to lua_ls so it can
        -- type-check vim.* calls and complete neovim APIs
        library        = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,  -- suppress "configure third-party" prompts
      },
      telemetry = {
        enable = false,  -- don't phone home
      },
    },
  },
}
