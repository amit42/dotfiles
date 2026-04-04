-- settings/clangd.lua
-- clangd settings for C and C++ (embedded / systems work)
-- Needs compile_commands.json in the project root for best results:
--   cmake:  -DCMAKE_EXPORT_COMPILE_COMMANDS=1
--   make:   bear -- make

return {
  cmd = {
    "clangd",
    "--background-index",          -- index project in the background at startup
    "--clang-tidy",                -- run clang-tidy checks inline as diagnostics
    "--header-insertion=iwyu",     -- suggest includes based on IWYU analysis
    "--completion-style=detailed", -- show full function signatures in completions
    "--function-arg-placeholders", -- insert named placeholders for function args
  },
  init_options = {
    usePlaceholders      = true,   -- snippet-style placeholders in completions
    completeUnimported   = true,   -- complete symbols from headers not yet included
    clangdFileStatus     = true,   -- show indexing status in the statusline
  },
}
