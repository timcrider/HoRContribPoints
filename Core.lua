HoRContribPoints = CreateFrame("Frame")

--------------------------
-- Default storage data --
--------------------------
local HoRContribPointsLimits = {
  min = 0,
  max = 200
}

HoRContribPoints.defaults = {
  points = 0
}

-- Register the addon
HoRContribPoints:RegisterEvent("ADDON_LOADED")

-------------------------------------------
-- Check if string starts with a pattern --
-------------------------------------------
function string.starts(String,Start)
  return string.sub(String,1,string.len(Start))==Start
end

------------------
-- Fancy Output --
------------------
function out(message)
  print("|cffFFC125[HoR-CP]|r "..message)
end

---------------------------
-- Addon loading actions --
---------------------------
function HoRContribPoints:ADDON_LOADED(event, addOnName)
  -- Only run if we're the addon firing
  if addOnName == "HoRContribPoints" then
    -- Pull in the stored data
    HoRContribPointsDB = HoRContribPointsDB or {}

    -- Assign stored instance to this instance
    self.db = HoRContribPointsDB

    -- Cycle through data and fill defaults where needed
    for k, v in pairs(self.defaults) do
      if self.db[k] == nil then
        self.db[k] = v
      end
    end

    -- Get some client information
    local version, build, _, tocversion = GetBuildInfo()
    out(format("The current WoW build is %s (%d) and TOC is %d", version, build, tocversion))

    -- 
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent(event)
  end
end

------------------------------------
-- Handle slashcommand definition --
------------------------------------
SLASH_HORCP1 = "/horcp"
SLASH_HORCP2 = "/horcontribpoints"

----------------------------------
-- Handle slash command actions --
----------------------------------
SlashCmdList.HORCP = function(msg, editBox)
  -- Pull in the saved data
  HoRContribPointsDB = HoRContribPointsDB or {}

  if msg == "roll" then
    ---------------------------
    -- Handle Roll Modifiers --
    ---------------------------
    local base = HoRContribPointsDB.points + 0
    local top  = HoRContribPointsDB.points + 100

    -- Show the user rolling contributions
    out("Rolling based on your cp "..HoRContribPointsDB.points)

    -- Execute roll (user has no more control than a normal /rol)
    RandomRoll(base, top)
  elseif string.starts(msg, "set") then
    --------------------------------------------------------
    -- Manually set your contribution points for the week --
    --------------------------------------------------------
    words = {}

    -- Split into words
    for word in msg:gmatch("%S+") do 
      table.insert(words, word) 
    end

    -- If the first word is set, grab the 2nd word and convert to a number
    local cpval = tonumber(words[2])

    if cpval == nil then
      -- Limit the CP values to sane numbers
      out("Invalid entry. please choose a number between "..HoRContribPointsLimits.min.." and "..HoRContribPointsLimits.max)    
    elseif cpval >= HoRContribPointsLimits.min and cpval <= HoRContribPointsLimits.max then
      -- If the value is between the ranges, set it
      HoRContribPointsDB.points = cpval
      out("Setting CP value to "..cpval)
    else
      -- Handle invalid numbers
      out("CP value must be a number between "..HoRContribPointsLimits.min.." and "..HoRContribPointsLimits.max)
    end
  elseif msg == "help" then
    ------------------------
    --  Show help message --
    ------------------------
    out("Heart of Redemption (Stormrage) Contribution Points")
    out("Usage: /horcp")
    out(" ")
    out("  Set your contribution points using")
    out("    /horcp set 0-200")
    out(" ")
    out("  Roll using your contribution points modifiers")
    out("    /horcp roll")
  else
    -------------------------------
    -- Handle no arguments given --
    -------------------------------
    out("You have "..HoRContribPointsDB.points.." contribution points.")
  end
end