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
config.font_size = 13.0
config.line_height = 1.0       -- tight rows so the 35-row dashboard fits
config.cell_width  = 1.0       -- exact monospace width — prevents column drift

-- Disable ligatures. The dashboard relies on byte-accurate cell widths for
-- gradient highlights and column dividers; ligatures shift those widths.
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Fallback fonts for symbols not covered by JetBrainsMono
config.font_rules = {
  {
    italic = true,
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", italic = true }),
  },
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- THEME
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- The active theme name lives in ~/.config/dotfiles-theme (one line),
-- written by `bash install.sh --theme <name>`. Reading it here (instead
-- of install.sh editing this file) keeps the deployed wezterm.lua
-- byte-identical to the repo — dotdoctor drift checks stay clean.
-- Same palette flows to nvim + tmux + starship + ghostty.
local THEMES = {
  ["catppuccin-mocha"] = {
    scheme  = "Catppuccin Mocha",
    bg      = "#1e1e2e",
    surface = "#313244",
    text    = "#cdd6f4",
    accent  = "#cba6f7",
    tab_bright = { "#f38ba8", "#fab387", "#f9e2af", "#a6e3a1",
                   "#89dceb", "#cba6f7", "#f5c2e7", "#94e2d5" },
    tab_dim    = { "#5e3947", "#5e4738", "#5e5742", "#3f5e3f",
                   "#385a62", "#51425e", "#5e4d58", "#3f5e58" },
  },
  ["tokyonight"] = {
    scheme  = "Tokyo Night",
    bg      = "#1a1b26",
    surface = "#292e42",
    text    = "#c0caf5",
    accent  = "#bb9af7",
    tab_bright = { "#f7768e", "#ff9e64", "#e0af68", "#9ece6a",
                   "#7dcfff", "#bb9af7", "#7aa2f7", "#1abc9c" },
    tab_dim    = { "#63394a", "#664636", "#5a4a35", "#425435",
                   "#39566b", "#4c4366", "#374766", "#175046" },
  },
  ["gruvbox"] = {
    scheme  = "GruvboxDark",
    bg      = "#282828",
    surface = "#3c3836",
    text    = "#ebdbb2",
    accent  = "#d3869b",
    tab_bright = { "#fb4934", "#fe8019", "#fabd2f", "#b8bb26",
                   "#8ec07c", "#d3869b", "#83a598", "#d79921" },
    tab_dim    = { "#623126", "#63432a", "#615127", "#4f5122",
                   "#3f5540", "#55414a", "#3e4a48", "#574a24" },
  },
  ["kanagawa"] = {
    scheme  = "Kanagawa (Gogh)",
    bg      = "#1f1f28",
    surface = "#2a2a37",
    text    = "#dcd7ba",
    accent  = "#957fb8",
    tab_bright = { "#ff5d62", "#ffa066", "#e6c384", "#98bb6c",
                   "#7aa89f", "#957fb8", "#7e9cd8", "#d27e99" },
    tab_dim    = { "#663239", "#664a3c", "#5c5140", "#44502f",
                   "#38484a", "#42405c", "#3a4560", "#553d48" },
  },
  ["rose-pine"] = {
    scheme  = "rose-pine",
    bg      = "#191724",
    surface = "#26233a",
    text    = "#e0def4",
    accent  = "#c4a7e7",
    tab_bright = { "#eb6f92", "#f6c177", "#ebbcba", "#31748f",
                   "#9ccfd8", "#c4a7e7", "#56949f", "#d7827e" },
    tab_dim    = { "#5c3346", "#604f3b", "#5c4a4c", "#233a45",
                   "#3f545c", "#4e4560", "#2b4148", "#573b3d" },
  },
  ["nord"] = {
    scheme  = "Nord (Gogh)",
    bg      = "#2e3440",
    surface = "#3b4252",
    text    = "#d8dee9",
    accent  = "#88c0d0",
    tab_bright = { "#bf616a", "#d08770", "#ebcb8b", "#a3be8c",
                   "#88c0d0", "#b48ead", "#81a1c1", "#8fbcbb" },
    tab_dim    = { "#764a55", "#7f5d58", "#8c7f65", "#687966",
                   "#5b7a88", "#716176", "#576a80", "#5e787d" },
  },
  ["dracula"] = {
    scheme  = "Dracula",
    bg      = "#282a36",
    surface = "#44475a",
    text    = "#f8f8f2",
    accent  = "#bd93f9",
    tab_bright = { "#ff5555", "#ffb86c", "#f1fa8c", "#50fa7b",
                   "#8be9fd", "#bd93f9", "#ff79c6", "#6272a4" },
    tab_dim    = { "#933f45", "#937151", "#8c9261", "#3c9258",
                   "#598999", "#725e97", "#93517e", "#454e6d" },
  },
  ["everforest"] = {
    scheme  = "Everforest Dark (Gogh)",
    bg      = "#2d353b",
    surface = "#3d484d",
    text    = "#d3c6aa",
    accent  = "#a7c080",
    tab_bright = { "#e67e80", "#e69875", "#dbbc7f", "#a7c080",
                   "#83c092", "#d699b6", "#7fbbb3", "#9da9a0" },
    tab_dim    = { "#89595d", "#896658", "#84785d", "#6a7a5d",
                   "#587a66", "#816778", "#567877", "#656f6d" },
  },
  ["onedark"] = {
    scheme  = "OneDark (base16)",
    bg      = "#282c34",
    surface = "#3e4451",
    text    = "#abb2bf",
    accent  = "#61afef",
    tab_bright = { "#e06c75", "#d19a66", "#e5c07b", "#98c379",
                   "#56b6c2", "#c678dd", "#61afef", "#abb2bf" },
    tab_dim    = { "#844c54", "#7c634d", "#867657", "#607756",
                   "#3f717b", "#775288", "#446d91", "#696f79" },
  },
}

local function dotfiles_theme()
  local f = io.open(wezterm.home_dir .. "/.config/dotfiles-theme", "r")
  if not f then return "catppuccin-mocha" end
  local name = (f:read("*l") or ""):gsub("%s+$", "")
  f:close()
  return THEMES[name] and name or "catppuccin-mocha"
end

local T = THEMES[dotfiles_theme()]
config.color_scheme = T.scheme

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- WINDOW
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
config.window_background_opacity = 0.95      -- slight transparency
config.macos_window_background_blur = 20     -- frosted glass blur (macOS only)

config.window_padding = {
  left = 12, right = 12, top = 8, bottom = 8,
}

-- Hide the title bar — cleaner look, use native macOS borders only
config.window_decorations = "RESIZE"

-- Start size — used briefly before the maximize handler kicks in (below).
-- Sized to fit the dashboard so there's no flicker on launch.
config.initial_cols = 220
config.initial_rows = 55

-- Open new windows in Desktop. Cross-platform: on Windows (incl. when
-- WezTerm runs WSL) we use the Windows Desktop path — wsl.exe accepts
-- the Windows path and mounts it as /mnt/c/Users/.../Desktop inside WSL.
local function startup_dir()
  if wezterm.target_triple:find("windows") then
    local user = os.getenv("USERNAME")
    if user and user ~= "" then
      return "C:\\Users\\" .. user .. "\\Desktop"
    end
  end
  return wezterm.home_dir .. "/Desktop"   -- macOS / Linux
end
config.default_cwd = startup_dir()

-- Maximize on launch + prompt to name the first tab. Wrapped in pcall so a
-- failure here (e.g. a deferred prompt firing against a not-yet-realized
-- window) can't crash WezTerm at startup — worst case the window just
-- opens without being maximized / without the prompt.
wezterm.on("gui-startup", function(cmd)
  local ok, err = pcall(function()
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    local gui = window:gui_window()
    gui:maximize()
    wezterm.time.call_after(0.15, function()
      pcall(function()
        gui:perform_action(act.PromptInputLine({
          description = "Name first tab (Enter to skip):",
          action = wezterm.action_callback(function(win, _, line)
            if line and #line > 0 then
              win:active_tab():set_title(line)
            end
          end),
        }), pane)
      end)
    end)
  end)
  if not ok then
    wezterm.log_error("gui-startup failed: " .. tostring(err))
  end
end)

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true              -- fancy tab bar gives clickable × close + macOS-style chrome
config.hide_tab_bar_if_only_one_tab = false  -- always show so "+" new tab button is visible
config.tab_bar_at_bottom = false             -- tab bar at top (bottom is reserved for tmux status)
config.show_new_tab_button_in_tab_bar = true -- explicit so it doesn't get disabled silently
config.tab_max_width = 50                    -- allow wider tabs (default 16) so longer titles fit

-- Tab bar font (fancy tab bar only). Slightly smaller than terminal font
-- so the bar is compact vertically while horizontal padding stays generous.
config.window_frame = {
  font      = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
  font_size = 11.0,
  active_titlebar_bg   = T.bg,
  inactive_titlebar_bg = T.bg,
}

-- Tab bar colors — from the active theme (T)
config.colors = {
  tab_bar = {
    background = T.bg,
    inactive_tab_hover = {
      bg_color = T.surface,
      fg_color = T.text,
    },
    new_tab = {
      bg_color = T.surface,   -- visible against the tab bar bg
      fg_color = T.text,      -- bright "+"
    },
    new_tab_hover = {
      bg_color = T.accent,    -- accent highlight on hover
      fg_color = T.bg,
    },
  },
}

-- Per-tab palette with both vibrant (active) and dim (inactive) variants.
-- Each tab becomes a coloured "pill" with rounded Nerd-Font caps; active
-- pops bright, inactive shows a dim version of the same accent so every
-- tab keeps its identity but the active one is unmistakable.
local tab_palette_bright = T.tab_bright
local tab_palette_dim    = T.tab_dim

-- Powerline-style rounded caps (require Nerd Font; you have JBM NF).
--   U+E0B6 = left half-circle, U+E0B4 = right half-circle
local CAP_LEFT  = utf8.char(0xE0B6)
local CAP_RIGHT = utf8.char(0xE0B4)

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  -- Guard everything: a render error here can break the whole tab bar.
  -- On any failure, fall back to the plain numbered title.
  local ok, result = pcall(function()
  local i = (tab.tab_index % #tab_palette_bright) + 1
  local bg   = tab.is_active and tab_palette_bright[i] or tab_palette_dim[i]
  local fg   = tab.is_active and T.bg or T.text
  local bar  = T.bg

  local body
  if tab.tab_title and #tab.tab_title > 0 then
    body = string.format("%d  %s", tab.tab_index + 1, tab.tab_title)
  else
    body = tostring(tab.tab_index + 1)
  end
  local label = " " .. body .. " "

  -- Layout:  CAP_LEFT (in tab bg, on bar) | label (tab bg) | CAP_RIGHT (tab bg on bar)
  -- This produces a rounded "pill" sitting on the bar.
  local segments = {
    { Background = { Color = bar } },
    { Foreground = { Color = bg } },
    { Text       = CAP_LEFT },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
  }
  if tab.is_active then
    table.insert(segments, { Attribute = { Intensity = "Bold" } })
  end
  table.insert(segments, { Text = label })
  table.insert(segments, { Background = { Color = bar } })
  table.insert(segments, { Foreground = { Color = bg } })
  table.insert(segments, { Text       = CAP_RIGHT })
  -- One bar-coloured space between adjacent pills so they don't touch.
  table.insert(segments, { Text       = " " })
    return segments
  end)
  if ok then return result end
  -- Fallback: plain numbered title, no styling.
  return " " .. tostring(tab.tab_index + 1) .. " "
end)

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
-- Default shell: zsh on Mac/Linux, WSL zsh on Windows.
if wezterm.target_triple:find("windows") then
  -- Canonical wsl.exe arg order: distro, then --cd for the start dir, then
  -- -e and the command. The old form put a bare "~" before -d which wsl.exe
  -- mis-parses and can fail to launch (notably on a cold WSL VM).
  config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~", "-e", "/bin/zsh", "-l" }
  -- WSL strips Windows env vars unless they're listed in WSLENV. Without
  -- this the WEZTERM_PANE / WEZTERM_UNIX_SOCKET vars don't reach zsh, so
  -- `wezterm cli ...` (used by the `wtn` rename helper) fails with
  -- "not running inside a WezTerm pane".
  config.set_environment_variables = {
    WSLENV = "WEZTERM_PANE:WEZTERM_UNIX_SOCKET",
  }
else
  config.default_prog = { "/bin/zsh", "-l" }
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- KEYBINDINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Note: tmux handles most multiplexing (panes, windows).
-- WezTerm keys here are for tab management and OS-level actions only.
-- Shell is zsh everywhere — macOS/Linux natively, Windows via WSL
-- (default_prog above); no cmd/PowerShell launch menu.
config.keys = {
  -- Tabs
  -- Ctrl+Shift+T: new tab + immediate name prompt. Enter without typing
  -- leaves the title as just the index.
  { key = "t", mods = "CTRL|SHIFT", action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
      window:perform_action(act.PromptInputLine({
        description = "Name new tab (Enter to skip):",
        action = wezterm.action_callback(function(win, _, line)
          if line and #line > 0 then
            win:active_tab():set_title(line)
          end
        end),
      }), pane)
    end),
  },
  { key = "w",          mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "Tab",        mods = "CTRL",       action = act.ActivateTabRelative(1) },
  { key = "Tab",        mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

  -- Ctrl+Shift+N: rename current tab
  { key = "n",          mods = "CTRL|SHIFT", action = act.PromptInputLine({
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
