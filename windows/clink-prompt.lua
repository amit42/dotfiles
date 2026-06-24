-- clink-prompt.lua
-- Loaded by Clink (deployed to %LOCALAPPDATA%\clink\starship.lua by install.bat).
-- Drives Starship as the cmd prompt and silently falls back to Clink's default
-- if starship isn't on PATH (so a missing/broken install doesn't spam the user
-- with "'starship' is not recognized..." messages on every prompt render).

local starship_filter = clink.promptfilter(50)
local starship_available = nil  -- nil = untried, true/false = cached

function starship_filter:filter(prompt)
  -- Already determined starship is missing — return the original prompt
  -- without spawning a process every keystroke.
  if starship_available == false then return prompt end

  -- 2>nul suppresses Windows' "command not recognized" error so it doesn't
  -- print into the cmd window on every Enter.
  local handle = io.popen("starship prompt 2>nul")
  if not handle then
    starship_available = false
    return prompt
  end
  local out = handle:read("*a")
  handle:close()
  if out == nil or out == "" then
    starship_available = false  -- starship couldn't run; stop trying
    return prompt
  end
  starship_available = true
  return out
end

function starship_filter:filtering()
  return false
end
