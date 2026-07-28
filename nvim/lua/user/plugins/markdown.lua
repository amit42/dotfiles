-- markdown.lua
-- In-buffer markdown rendering + inline images.

return {

  -- render-markdown.nvim — headings, code blocks, tables, checkboxes.
  -- Maintained and compatible with nvim 0.12+ and the new treesitter
  -- TSMatch format. (Replaces markview.nvim, which crashes against the
  -- newer TSMatch API on nvim 0.12 + nvim-treesitter v1 master.)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- ft-lazy: lazy.nvim registers its own FileType trigger at startup,
    -- so even session-restored markdown buffers load the plugin on open.
    ft           = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      heading    = { enabled = true },
      code       = { enabled = true, style = "full" },
      checkbox   = {
        enabled = true,
        checked = { scope_highlight = "@markup.strikethrough" },
      },
      pipe_table = { enabled = true },
      bullet     = { enabled = true },
    },
  },

  -- image.nvim — renders images inline in markdown buffers and lets you
  -- open image files (.png/.jpg/.gif/etc.) directly as picture viewers.
  -- Requires the terminal to support the Kitty graphics protocol
  -- (WezTerm does). Inside tmux, also requires `set -g allow-passthrough on`.
  -- System deps (imagemagick, luarocks, magick rock, libmagickwand-dev on
  -- Linux) are installed by install.sh.
  {
    "3rd/image.nvim",
    ft   = { "markdown", "png", "jpg", "jpeg", "gif", "webp", "bmp" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled                     = true,
          clear_in_insert_mode        = true,   -- hide images while typing
          download_remote_images      = true,
          only_render_image_at_cursor = true,   -- render the one near cursor only — less laggy
          filetypes                   = { "markdown" },
        },
      },
      max_width_window_percentage  = 80,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,      -- redraw when another window overlaps
    },
  },
}
