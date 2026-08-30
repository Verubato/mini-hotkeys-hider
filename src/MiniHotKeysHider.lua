local addonName, addon = ...
---@type MiniFramework
local mini = addon.Framework
local didWeHide = false
local db

local function ApplyAlpha(frame, alpha)
	if not frame then
		return
	end

	frame:SetAlpha(alpha)
end

local function ShowHideHotkeys(show)
	local hotKeyAlpha = show and 1 or 0

	-- avoid touching if we didn't do anything
	if show and not didWeHide then
		return
	end

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

	didWeHide = not show
end

local function Run()
	local show = not db.Enabled

	ShowHideHotkeys(show)
end

local function OnEvent()
	-- seems we need to wait a frame for our hiding to persist
	C_Timer.After(0, Run)
end

local function InitUI()
	-- A styled button clashes with the stock Blizzard art around it in the settings screen.
	mini:SetCustomStyling(true, { Button = false })

	local panel = CreateFrame("Frame")
	panel.name = addonName

	local category = mini:AddCategory(panel)

	if not category then
		return
	end

	local header = mini:PanelHeader({
		Parent = panel,
		Description = "Hide your action bar hotkeys for a cleaner look",
		Divider = true,
	})

	local checkbox = mini:Checkbox({
		Parent = panel,
		LabelText = "Hide HotKeys",
		GetValue = function()
			return db.Enabled
		end,
		SetValue = function(value)
			db.Enabled = value
			Run()
		end,
	})
	checkbox:SetPoint("TOPLEFT", header.Anchor, "BOTTOMLEFT", 0, -mini.VerticalSpacing)
end

local function Init()
	MiniHotKeysHiderDB = MiniHotKeysHiderDB or {
		Enabled = true,
	}

	db = MiniHotKeysHiderDB

	InitUI()
end

local frame = CreateFrame("Frame") -- luaconv: its handler is a function defined above
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		Init()

		frame:UnregisterEvent("ADDON_LOADED")
		frame:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame:SetScript("OnEvent", OnEvent)
	end
end)
