-- dashboard.lua
-- Thin wrapper so autocommands can open the dashboard without being coupled
-- to the specific plugin. Calls dashboard.nvim's :Dashboard command.
local M = {}

M.open = function()
  pcall(vim.cmd, "Dashboard")
end

return M
