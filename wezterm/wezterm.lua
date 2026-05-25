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

-- Maximize on launch + prompt to name the first tab. WezTerm has no boolean
-- for maximize; the documented approach is a gui-startup event. We piggyback
-- the prompt onto the same handler so it fires once per fresh window.
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  local gui = window:gui_window()
  gui:maximize()
  wezterm.time.call_after(0.15, function()
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
  active_titlebar_bg   = "#1e1e2e",
  inactive_titlebar_bg = "#1e1e2e",
}

-- Tab bar colors — Catppuccin Mocha
config.colors = {
  tab_bar = {
    background = "#1e1e2e",
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
    new_tab = {
      bg_color = "#313244",   -- surface1 — visible against #1e1e2e tab bar
      fg_color = "#cdd6f4",   -- text — bright "+"
    },
    new_tab_hover = {
      bg_color = "#cba6f7",   -- mauve highlight on hover
      fg_color = "#1e1e2e",
    },
  },
}

-- Per-tab palette with both vibrant (active) and dim (inactive) variants.
-- Each tab becomes a coloured "pill" with rounded Nerd-Font caps; active
-- pops bright, inactive shows a dim version of the same accent so every
-- tab keeps its identity but the active one is unmistakable.
local tab_palette_bright = {
  "#f38ba8",  -- red
  "#fab387",  -- peach
  "#f9e2af",  -- yellow
  "#a6e3a1",  -- green
  "#89dceb",  -- sky
  "#cba6f7",  -- mauve
  "#f5c2e7",  -- pink
  "#94e2d5",  -- teal
}
local tab_palette_dim = {
  "#5e3947",  -- dim red
  "#5e4738",  -- dim peach
  "#5e5742",  -- dim yellow
  "#3f5e3f",  -- dim green
  "#385a62",  -- dim sky
  "#51425e",  -- dim mauve
  "#5e4d58",  -- dim pink
  "#3f5e58",  -- dim teal
}

-- Powerline-style rounded caps (require Nerd Font; you have JBM NF).
--   U+E0B6 = left half-circle, U+E0B4 = right half-circle
local CAP_LEFT  = utf8.char(0xE0B6)
local CAP_RIGHT = utf8.char(0xE0B4)

wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local i = (tab.tab_index % #tab_palette_bright) + 1
  local bg   = tab.is_active and tab_palette_bright[i] or tab_palette_dim[i]
  local fg   = tab.is_active and "#1e1e2e" or "#cdd6f4"
  local bar  = "#1e1e2e"

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
  config.default_prog = { "wsl.exe", "~", "-d", "Ubuntu", "--exec", "/bin/zsh", "-l" }
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

-- Launch menu (Ctrl+Shift+Space to open) — lets you spawn alternative shells
-- without changing the default. Useful on Windows where you may want both
-- WSL (default) and native cmd (with Clink + Starship).
if wezterm.target_triple:find("windows") then
  -- Plain cmd.exe — cmd's AutoRun (set by clink autorun install) handles
  -- Clink injection + aliases + STARSHIP_CONFIG. Spawning explicit clink
  -- here injected it twice and slowed startup.
  config.launch_menu = {
    { label = "WSL (zsh)",  args = { "wsl.exe", "~", "-d", "Ubuntu", "--exec", "/bin/zsh", "-l" } },
    { label = "cmd",        args = { "cmd.exe" } },
    { label = "PowerShell", args = { "pwsh.exe" } },
  }
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- KEYBINDINGS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- Note: tmux handles most multiplexing (panes, windows).
-- WezTerm keys here are for tab management and OS-level actions only.
config.keys = {
  -- Tabs
  -- Ctrl+Shift+T: spawn a new tab, then immediately prompt for a name.
  -- Pressing Enter without typing leaves it as just the index — the prompt
  -- only sets the title if you provide one.
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

  -- Rename current tab
  { key = "r",          mods = "CTRL|SHIFT", action = act.PromptInputLine({
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    }),
  },

  -- Launcher — Ctrl+Shift+P (Ctrl+Shift+Space gets eaten by Windows IME).
  -- FUZZY adds search-as-you-type, LAUNCH_MENU_ITEMS pulls in the launch_menu list.
  { key = "p",          mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }) },
  -- Direct cmd tab on Windows. Plain cmd.exe — AutoRun loads Clink + Starship.
  { key = "n",          mods = "CTRL|SHIFT", action = act.SpawnCommandInNewTab({ args = { "cmd.exe" } }) },

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
