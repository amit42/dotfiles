-- settings/jdtls.lua
-- Eclipse JDT Language Server settings for Java
--
-- NOTE: jdtls works here for basic projects. For full support (hot reload,
-- test runners, Spring Boot, per-project JVM config) consider replacing this
-- with the mfussenegger/nvim-jdtls plugin, which wraps jdtls more completely.
-- This file handles the common case — single JDK, standard Maven/Gradle layout.

return {
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          -- Point to a custom Eclipse formatter XML if you have one:
          -- url = vim.fn.expand("~/.config/nvim/java-formatter.xml"),
          -- profile = "GoogleStyle",
        },
      },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      inlayHints = {
        parameterNames = { enabled = "all" },  -- off | literals | all
      },
      sources = {
        organizeImports = {
          starThreshold         = 9999,  -- don't collapse to * imports
          staticStarThreshold   = 9999,
        },
      },
    },
  },
}
