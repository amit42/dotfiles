-- ╔═══════════════════════════════════════════════════════╗
-- ║  wezterm.lua — managed via dotfiles                  ║
-- ║  Edit: dotfiles/wezterm/wezterm.lua                  ║
-- ║  Install: bash install.sh                            ║
-- ╚═══════════════════════════════════════════════════════╝
--
-- WezTerm is a GPU-accelerated terminal emulator written in Rust.
-- This config uses the Lua API — full docs: https://wezfurlong.org/wezterm/
--
-- FONT REQUIREMENT:
--   JetBrainsMono Nerd Font — required for icons in starship, eza, nvim-tree.
--   Download: https://www.nerdfonts.com/font-downloads
--   Install the font on the HOST machine (not WSL).

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- FONT
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 14.0
config.line_height = 1.2

-- Fallback fonts for symbols not covered by JetBrainsMono
config.font_rules = {
  {
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", italic = true }),
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- THEME — Catppuccin Mocha
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Same palette as nvim + tmux + starship — consistent everywhere
config.color_scheme = "Catppuccin Mocha"

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WINDOW
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.window_background_opacity = 0.95      -- slight transparency
config.macos_window_background_blur = 20     -- frosted glass blur (macOS only)

config.window_padding = {
  left = 8, right = 8, top = 8, bottom = 4,
}

-- Hide the title bar — cleaner look, use native macOS borders only
config.window_decorations = "RESIZE"

-- Start maximized
config.initial_cols = 220
config.initial_rows = 50

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false             -- use retro tab bar (matches terminal style)
config.hide_tab_bar_if_only_one_tab = true   -- hide bar when only one tab open
config.tab_bar_at_bottom = true             -- tab bar at bottom like tmux status

-- Tab bar colors — Catppuccin Mocha
config.colors = {
  tab_bar = {
    background = "#1e1e2e",
    active_tab = {
      bg_color = "#313244",
      fg_color = "#cba6f7",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#6c7086",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
    new_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#6c7086",
    },
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- CURSOR
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SCROLLBACK
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.scrollback_lines = 10000

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SHELL
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- macOS: use zsh login shell so ~/.zprofile is sourced (PATH, brew, etc.)
-- WSL: uncomment the wsl line and comment out the zsh line
config.default_prog = { "/bin/zsh", "-l" }
-- config.default_prog = { "wsl.exe", "--distribution", "Ubuntu", "--exec", "/bin/zsh", "-l" }

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- KEYBINDINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Note: tmux handles most multiplexing (panes, windows).
-- WezTerm keys here are for tab management and OS-level actions only.
config.keys = {
  -- Tabs
  { key = "t",          mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w",          mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "Tab",        mods = "CTRL",       action = act.ActivateTabRelative(1) },
  { key = "Tab",        mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

  -- Rename current tab
  { key = "r",          mods = "CTRL|SHIFT", action = act.PromptInputLine({
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    }),
  },

  -- Copy / Paste
  { key = "c",          mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v",          mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- Font size
  { key = "=",          mods = "CTRL",       action = act.IncreaseFontSize },
  { key = "-",          mods = "CTRL",       action = act.DecreaseFontSize },
  { key = "0",          mods = "CTRL",       action = act.ResetFontSize },

  -- Fullscreen
  { key = "F11",        mods = "",           action = act.ToggleFullScreen },

  -- Quick reload config
  { key = "r",          mods = "SUPER",      action = act.ReloadConfiguration },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PERFORMANCE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu"    -- GPU-accelerated rendering (faster than OpenGL)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- OPTION KEY (macOS)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- By default macOS Option+key sends composed Unicode (Option+h = ˙).
-- Setting to "EscapeCode" makes left Option send ESC+key instead,
-- which is what tmux/vim expect for Alt/Meta bindings (e.g. M-h, M-l).
-- Right Option keeps its default so you can still type special chars.
config.send_composed_key_when_left_alt_is_pressed  = false
config.send_composed_key_when_right_alt_is_pressed = true

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- MISC
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.audible_bell = "Disabled"          -- no bell sounds
config.warn_about_missing_glyphs = false  -- suppress icon warnings

return config
