HoRContribPoints.defaults = {
	sessions = 0,
  hello = false,
	points = 0
}

local function CreateIcon(icon, width, height, parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(width, height)
	f.tex = f:CreateTexture()
	f.tex:SetAllPoints(f)
	f.tex:SetTexture(icon)
	return f
end

function HoRContribPoints:CreateCheckbox(option, label, parent, updateFunc)
	local cb = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
	cb.Text:SetText(label)
	local function UpdateOption(value)
		self.db[option] = value
		cb:SetChecked(value)
		if updateFunc then
			updateFunc(value)
		end
	end
	UpdateOption(self.db[option])
	-- there already is an existing OnClick script that plays a sound, hook it
	cb:HookScript("OnClick", function(_, btn, down)
		UpdateOption(cb:GetChecked())
	end)
	EventRegistry:RegisterCallback("HoRContribPoints.OnReset", function()
		UpdateOption(self.defaults[option])
	end, cb)
	return cb
end

function HoRContribPoints:CreateSlider(option, name, label, points, parent)
  local Slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")

  Slider.Text:SetText("HOR CB Foo")

--  Slider.tooltipText = "Contrib Points 0-200"
--  Slider.SetValue(10)
  _G[Slider:GetName() .. 'Low']:SetText("0")
  _G[Slider:GetName() .. 'High']:SetText("200")

--  Slider.Text:SetText("CPPoints")
--  _G[Slider:GetName() .. 'High']:SetValueStep(1);
--  _G[Slider:GetName() .. 'High']:SetValue(44);

  local function UpdateOption(value)
--    print("Updating option to "..value)
--    self.db[option] = value
    _G[Slider:GetName()]:SetValue(value)
--    Slider:SetValue(value)

--    if updateFunc then
--      updateFunc(value)
--    end
  end

  UpdateOption(99)

  return Slider
end

function HoRContribPoints:InitializeOptions()
	-- main panel
	self.panel_main = CreateFrame("Frame")
	self.panel_main.name = "HoRContribPoints"

--	local cb_hello = self:CreateCheckbox("hello", "Do the |cFFFFFF00/hello|r emote when you login", self.panel_main)
--	cb_hello:SetPoint("TOPLEFT", 20, -20)

  HoRContribPointsDB = HoRContribPointsDB or {}

  local cb_points = self:CreateSlider("points", "SliderPoints", "Contribution Points", HoRContribPointsDB.points, self.panel_main)
  cb_points:SetPoint("TOPLEFT", 20, -20)


--	local btn_reset = CreateFrame("Button", nil, self.panel_main, "UIPanelButtonTemplate")
--	btn_reset:SetPoint("TOPLEFT", cb_combat, 0, -40)
--	btn_reset:SetText(RESET)
--	btn_reset:SetWidth(100)
--	btn_reset:SetScript("OnClick", function()
--		HoRContribPointsDB = CopyTable(HoRContribPoints.defaults)
--		self.db = HoRContribPointsDB
--		EventRegistry:TriggerEvent("HoRContribPoints.OnReset")
--	end)

	InterfaceOptions_AddCategory(HoRContribPoints.panel_main)
end

function HoRContribPoints.UpdateIcon(value)
	if not HoRContribPoints.mushroom then
		HoRContribPoints.mushroom = CreateIcon("interface/icons/inv_mushroom_11", 64, 64, UIParent)
		HoRContribPoints.mushroom:SetPoint("CENTER")
	end
	HoRContribPoints.mushroom:SetShown(value)
end

-- a bit more efficient to register/unregister the event when it fires a lot
function HoRContribPoints:UpdateEvent(value, event)
	if value then
		self:RegisterEvent(event)
	else
		self:UnregisterEvent(event)
	end
end