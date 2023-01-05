HoRContribPoints = CreateFrame("Frame")

function HoRContribPoints:OnEvent(event, ...)
	self[event](self, event, ...)
end

HoRContribPoints:SetScript("OnEvent", HoRContribPoints.OnEvent)
HoRContribPoints:RegisterEvent("ADDON_LOADED")

function HoRContribPoints:ADDON_LOADED(event, addOnName)
	if addOnName == "HoRContribPoints" then
		HoRContribPointsDB = HoRContribPointsDB or {}
		self.db = HoRContribPointsDB
		for k, v in pairs(self.defaults) do
			if self.db[k] == nil then
				self.db[k] = v
			end
		end

    self.db.sessions = self.db.sessions + 1
--		print("You loaded this addon "..self.db.sessions.." times")

		local version, build, _, tocversion = GetBuildInfo()
		print(format("[HORCP] The current WoW build is %s (%d) and TOC is %d", version, build, tocversion))

		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:InitializeOptions()
		self:UnregisterEvent(event)
	end
end

function string.starts(String,Start)
  return string.sub(String,1,string.len(Start))==Start
end

function HoRContribPoints:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	if isLogin and self.db.hello then
		DoEmote("HELLO")
	end
end

SLASH_HELLOW1 = "/horcp"
SLASH_HELLOW2 = "/horcontribpoints"

SlashCmdList.HELLOW = function(msg, editBox)
  HoRContribPointsDB = HoRContribPointsDB or {}
  if msg == "roll" then
    local base = HoRContribPointsDB.points + 0
    local top  = HoRContribPointsDB.points + 100
    print("[HORCP] Rolling based on your cp "..HoRContribPointsDB.points)
    RandomRoll(base, top)
  elseif string.starts(msg, "set") then
    words = {}
    for word in msg:gmatch("%S+") do table.insert(words, word) end
    local cpval = tonumber(words[2])

    if cpval >= 0 and cpval <= 200 then
      HoRContribPointsDB = HoRContribPointsDB or {}
      HoRContribPointsDB.points = cpval
      print("[HORCP] Setting CP value to "..cpval)

    else
      print("[HORCP] CP value must be a number between 0 and 200")
    end
  elseif msg == "config" then
    InterfaceOptionsFrame_OpenToCategory(HoRContribPoints.panel_main)
  elseif msg == "help" then
    print("[HORCP] Usage: /horcp")
    print("[HORCP]   Get CP  : /horcp get")
    print("[HORCP]   Set CP  : /horcp set 0-200")
    print("[HORCP]   Roll CP : /horcp roll")
  else
    print("[HORCP] You have "..HoRContribPointsDB.points.." contrib points.")
    print("[HORCP] Help: /horcp help")
  end
end