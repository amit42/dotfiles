-- dap.lua
-- Debug Adapter Protocol — breakpoints, stepping, variable inspection.
--
-- Adapters are installed by mason-nvim-dap (ensure_installed below):
--   codelldb → C / C++ / Rust
--   delve    → Go
--   debugpy  → Python
--
-- Keymaps follow the VS Code convention so muscle memory transfers:
--   F5  continue/start   F9  toggle breakpoint
--   F10 step over        F11 step into        F12 step out
-- dap-ui opens automatically when a session starts and closes when it ends.

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",   -- inline variable values while stepping
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
      },
    },
    -- Load only when a debug key is pressed — zero startup cost
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "DAP continue/start" },
      { "<F9>",       function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "DAP step over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "DAP step into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "DAP step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, desc = "Conditional breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },
      { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle DAP REPL" },
      { "<leader>dx", function() require("dap").terminate() end,         desc = "Terminate session" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "delve", "python" },
        automatic_installation = true,
        -- Empty handlers table = use mason-nvim-dap's default setup for
        -- every adapter (wires adapter binaries + standard launch configs).
        handlers = {},
      })

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      -- Auto open/close the UI with the debug session
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

      -- Catppuccin-friendly signs
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
    end,
  },
}
