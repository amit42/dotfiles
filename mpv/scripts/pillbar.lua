-- pillbar.lua — audio-reactive pill strip in mpv's terminal status line.
--
--   ██████████░░░░░░  ▶ Track Title  1:23 / 3:45
--
-- Same square pills as the shell banner (ANSI palette → follows the
-- active dotfiles theme). Loudness is measured RELATIVE to the track's
-- own rolling average, so pills dance with the beat instead of pegging
-- at max on loudly-mastered music. A white peak-hold pill marks the
-- recent maximum, decaying like a classic VU meter.
--
-- How: ffmpeg's astats filter runs inside mpv's own audio chain and
-- publishes per-frame loudness as filter metadata; this script polls it
-- 10x/sec and rewrites term-status-msg. No audio capture, no external
-- tools, one line of plain ANSI text — nothing here can take over the
-- terminal (see the no-untested-terminal-graphics memory).

local PILLS = 8          -- height steps (▁..█)
-- Bar count adapts to the terminal: each bar is 1 cell + 1 gap (thin
-- discrete EQ columns, not a solid wall), everything except the icon +
-- time readout is bars. Falls back to ~27 bars when size is unknown.
local RESERVED = 26      -- "  ▶ 00:00:00 / 00:00:00" + margin
local function bar_width()
  local w = mp.get_property_native("term-size/w")
  local width = math.floor(((w or 80) - RESERVED) / 2)
  if width < 8 then width = 8 end
  if width > 75 then width = 75 end
  return width
end
-- Bar color by height (ANSI indices — they follow the active theme).
-- Default: the classic LED spectrum analyzer — Winamp / hi-fi deck VU:
-- green base, amber mids, red peaks. Other looks:
--   all mauve:      { 5, 5, 5, 5, 5, 5, 5, 5 }
--   cool→hot ramp:  { 4, 4, 6, 6, 5, 5, 13, 1 }
--   all cyan:       { 6, 6, 6, 6, 6, 6, 6, 6 }
local COLORS = { 2, 2, 2, 2, 3, 3, 1, 1 }
local DIM, TIME_COLOR = 8, 8
local GLYPHS = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

local function fg(n) return string.format("\027[38;5;%dm", n) end
local RESET = "\027[0m"

local filter_added = false
mp.register_event("file-loaded", function()
  if filter_added then return end
  -- @pill label makes the metadata readable as property af-metadata/pill
  mp.commandv("af", "add", "@pill:lavfi=[astats=metadata=1:reset=1]")
  filter_added = true
end)

local avgL, avgR = nil, nil   -- per-channel rolling baselines
local bars = {}          -- per-column heights 0..1 (the dancing state)
local noise = {}         -- per-column smoothed randomness (bar character)
local last_vol, vol_until = nil, 0
math.randomseed(os.time())

-- dB → 0..1 relative to that channel's own rolling baseline, so the
-- bars dance to THIS song's dynamics instead of pegging on loud masters
local function channel_level(rms, avg)
  if not (rms and rms > -90) then return 0, nil end
  avg = avg and (avg * 0.95 + rms * 0.05) or rms
  local l = ((rms - avg) + 6) / 12
  if l < 0 then l = 0 end
  if l > 1 then l = 1 end
  return l, avg
end

local function tick()
  -- freeze the bars while paused instead of flat-lining them
  if mp.get_property_bool("pause") then return end

  local m = mp.get_property_native("af-metadata/pill") or {}
  local rmsL = tonumber(m["lavfi.astats.1.RMS_level"])
  local rmsR = tonumber(m["lavfi.astats.2.RMS_level"]) or rmsL  -- mono → mirror
  local LL, LR
  LL, avgL = channel_level(rmsL, avgL)
  LR, avgR = channel_level(rmsR, avgR)

  -- resize state to the current terminal width
  local W = bar_width()
  while #bars < W do bars[#bars + 1] = 0; noise[#noise + 1] = math.random() end
  while #bars > W do table.remove(bars); table.remove(noise) end

  -- per-column temporally-smoothed noise gives each bar its own life;
  -- spatial smoothing keeps neighbors correlated so it reads like a
  -- spectrum, not static. Stereo: columns left of center follow the
  -- left channel, right of center the right — dual VU, hi-fi style.
  local center = (W + 1) / 2
  for i = 1, W do
    noise[i] = 0.55 * noise[i] + 0.45 * math.random()
  end
  for i = 1, W do
    local a = noise[i - 1] or noise[i]
    local b = noise[i + 1] or noise[i]
    local sm = (a + 2 * noise[i] + b) / 4
    local level = (i <= center) and LL or LR
    local target = level * (0.30 + 0.90 * sm)
    if target > 1 then target = 1 end
    -- ballistics per bar: leap up with the hit, fall gently
    if target >= bars[i] then bars[i] = target
    else bars[i] = math.max(target, bars[i] - 0.13) end
  end

  local s = {}
  for i = 1, W do
    local h = math.floor(bars[i] * PILLS + 0.5)
    if h < 1 then
      s[#s + 1] = fg(DIM) .. "▁"
    else
      s[#s + 1] = fg(COLORS[h]) .. GLYPHS[h]
    end
  end
  -- thin columns: one cell of bar, one of gap
  local bar = table.concat(s, " ") .. RESET

  -- volume readout, visible for 2.5s after a change (9/0 keys)
  local vol = mp.get_property_number("volume")
  local now = mp.get_time()
  if vol and last_vol and math.abs(vol - last_vol) > 0.5 then
    vol_until = now + 2.5
  end
  last_vol = vol
  local vol_seg = ""
  if now < vol_until and vol then
    vol_seg = fg(3) .. string.format("  vol %d%%", math.floor(vol + 0.5)) .. RESET
  end

  -- no title here — it's printed once by play()/music and never changes
  mp.set_property("options/term-status-msg",
    bar .. "  ${?pause==yes:⏸}${!pause==yes:▶} " ..
    fg(TIME_COLOR) .. "${time-pos} / ${duration}" .. RESET .. vol_seg)
end

mp.add_periodic_timer(0.1, tick)
