local addonName = ...
local db

local function ApplyAlpha(frame, alpha)
	if not frame then
		return
	end

	frame:SetAlpha(alpha)
end

local function ShowHideHotkeys(show)
	local hotKeyAlpha = show and 1 or 0

	for i = 1, 12 do
		ApplyAlpha(_G["ActionButton" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarBottomLeftButton" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarBottomRightButton" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarRightButton" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarLeftButton" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar5Button" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar6Button" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar7Button" .. i .. "HotKey"], hotKeyAlpha)
		ApplyAlpha(_G["PetActionButton" .. i .. "HotKey"], hotKeyAlpha)

		ApplyAlpha(_G["ActionButton" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarBottomLeftButton" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarBottomRightButton" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarRightButton" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBarLeftButton" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar5Button" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar6Button" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["MultiBar7Button" .. i .. "Name"], hotKeyAlpha)
		ApplyAlpha(_G["PetActionButton" .. i .. "Name"], hotKeyAlpha)
	end
end

local function Run()
	local show = not db.Enabled

	ShowHideHotkeys(show)
end

local function OnEvent()
	-- seems we need to wait a frame for our hiding to persist
	C_Timer.After(0, Run)
end

local function AddCategory(panel)
	if Settings then
		local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(category)

		return category
	elseif InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(panel)

		return panel
	end

	return nil
end

local function InitUI()
	local panel = CreateFrame("Frame")
	panel.name = addonName

	local category = AddCategory(panel)

	if not category then
		return
	end

	local version = C_AddOns.GetAddOnMetadata(addonName, "Version")
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 0, -16)
	title:SetText(string.format("%s - %s", addonName, version))

	local description = panel:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	description:SetPoint("TOPLEFT", title, 0, -25)
	description:SetText("Hide your action bar hotkeys for a cleaner look")

	local checkbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", description, 0, -20)
	checkbox.Text:SetText("Hide HotKeys")
	checkbox.Text:SetFontObject("GameFontNormal")
	checkbox:SetChecked(db.Enabled or false)
	checkbox:SetScript("OnClick", function()
		db.Enabled = checkbox:GetChecked()
		Run()
	end)
end

local function Init()
	MiniHotKeysHiderDB = MiniHotKeysHiderDB or {
		Enabled = true,
	}

	db = MiniHotKeysHiderDB

	InitUI()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		Init()

		frame:UnregisterEvent("ADDON_LOADED")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:SetScript("OnEvent", OnEvent)
	end
end)
