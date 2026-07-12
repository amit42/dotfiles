-- settings/clangd.lua
-- clangd settings for C and C++ (embedded / systems work)
-- Needs compile_commands.json in the project root for best results:
--   cmake:  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
--   make:   bear -- make

return {
  cmd = {
    "clangd",
    "--background-index",          -- index project in the background at startup
    "--background-index-priority=background", -- index on idle CPUs, keep the UI responsive
    "-j=2",                        -- cap indexer threads (RAM-constrained machines: avoids thrashing)
    -- NOTE: do NOT add --query-driver here. On this machine the compile commands
    -- already carry the correct -isysroot (Xcode SDK). --query-driver makes clangd
    -- interrogate Homebrew clang, which injects the Command Line Tools SDK and
    -- causes a sysroot clash ("unknown type name '__uint32_t'" + cascading errors).
    -- "--clang-tidy",             -- (disabled: slows indexing a lot; re-enable once the index is built)
    "--header-insertion=iwyu",     -- suggest includes based on IWYU analysis
    "--completion-style=detailed", -- show full function signatures in completions
    "--function-arg-placeholders=1", -- insert named placeholders for function args
  },
  init_options = {
    usePlaceholders      = true,   -- snippet-style placeholders in completions
    completeUnimported   = true,   -- complete symbols from headers not yet included
    clangdFileStatus     = true,   -- show indexing status in the statusline
  },
}
