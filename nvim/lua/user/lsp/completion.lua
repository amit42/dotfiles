-- lsp/completion.lua
-- nvim-cmp completion menu configuration
-- Loaded lazily on InsertEnter via lsp/init.lua spec
--
-- Sources (priority order): LSP → snippets → buffer words → file paths
-- Snippet engine: LuaSnip with friendly-snippets VS Code collection

local cmp     = require("cmp")
local luasnip = require("luasnip")

-- ── Kind icons ───────────────────────────────────────────────
-- One glyph per completion kind shown to the left of each item
-- Requires a Nerd Font — https://www.nerdfonts.com/cheat-sheet
local kind_icons = {
  Text          = "󰉿", Method        = "󰆧", Function  = "󰊕",
  Constructor   = "",  Field         = "󰜢", Variable  = "󰀫",
  Class         = "󰠱", Interface     = "",  Module    = "",
  Property      = "󰜢", Unit          = "󰑭", Value     = "󰎠",
  Enum          = "",  Keyword       = "󰌋", Snippet   = "",
  Color         = "󰏘", File          = "󰈙", Reference = "󰈇",
  Folder        = "󰉋", EnumMember    = "",  Constant  = "󰏿",
  Struct        = "󰙅", Event         = "",  Operator  = "󰆕",
  TypeParameter = "",
}

-- ── Setup ────────────────────────────────────────────────────
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Bordered windows for both the completion list and the docs panel
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({
    -- Navigate completion list
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),

    -- Scroll inside the documentation panel
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    -- Manually trigger completion (useful in places cmp doesn't auto-open)
    ["<C-Space>"] = cmp.mapping.complete(),

    -- Dismiss the menu without confirming
    ["<C-e>"] = cmp.mapping.abort(),

    -- Confirm the selected item; select = false means you must actively pick
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    -- Tab: move through completion list or jump through snippet placeholders
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Priority controls which source wins when items share the same score
  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip",  priority = 750 },
    { name = "buffer",   priority = 500 },
    { name = "path",     priority = 250 },
  }),

  -- Each item shows: <icon> <kind name>    [source label]
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s %s",
        kind_icons[vim_item.kind] or "?",
        vim_item.kind
      )
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip  = "[Snippet]",
        buffer   = "[Buffer]",
        path     = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- ── Command-line completion ──────────────────────────────────
-- / search: complete from words in the current buffer
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- : commands: complete paths first, then built-in commands
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})
