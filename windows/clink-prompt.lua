-- clink-prompt.lua
-- Drives Starship as the cmd prompt asynchronously so input never blocks.
-- The prompt redraws once starship returns; otherwise the previous value
-- is reused, so there's no $ placeholder flash if starship is fast enough.

local starship_filter = clink.promptfilter(50)

-- Cache the last successful prompt so we always have something to show
-- while the coroutine is computing the next one.
local last_prompt = ""

function starship_filter:filter(prompt)
  local out = clink.promptcoroutine(function()
    local f = io.popen("starship prompt")
    if not f then return last_prompt end
    local s = f:read("*a")
    f:close()
    return s
  end)
  if out and out ~= "" then
    last_prompt = out
    return out
  end
  -- While the coroutine is computing for the first time we have no cache yet.
  -- Return a minimal prompt; subsequent renders use last_prompt.
  if last_prompt ~= "" then return last_prompt end
  return "$ "
end

function starship_filter:filtering()
  return false
end
