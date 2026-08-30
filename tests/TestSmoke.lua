-- Loads the whole addon into a mocked client and drives it through login.
-- The shared body lives in build/Lua/SmokeTest.lua.

local fw = require("TestFramework")
local smoke = require("SmokeTest")
local WowMock = require("WowMock")

---The section rule is built by the framework and never handed back to the addon, so a test
---finds it the way a player sees it, by its label.
---@param text string
---@return boolean
local function HasDivider(text)
	for _, frame in ipairs(WowMock.Frames) do
		if frame.Label and frame.Label.GetText and frame.Label:GetText() == text then
			return true
		end
	end

	return false
end

---A checkbox is drawn with its label as a child font string, so a test finds it the way a
---player does.
---@param text string
---@return table?
local function FindCheckbox(text)
	for _, frame in ipairs(WowMock.Frames) do
		if frame.Text and frame.Text.GetText and frame.Text:GetText() == text then
			return frame
		end
	end
end

---The client draws nothing in the mock, so a test stands in for the tooltip and reads back
---what the hover asked it to show.
---@param frame table
---@return string? title, string? body
local function TooltipOn(frame)
	local title, body
	local realSetText, realAddLine = GameTooltip.SetText, GameTooltip.AddLine

	GameTooltip.SetText = function(_, text)
		title = text
	end

	GameTooltip.AddLine = function(_, text)
		body = text
	end

	local ok, err = pcall(frame:GetScript("OnEnter"), frame)

	GameTooltip.SetText, GameTooltip.AddLine = realSetText, realAddLine

	if not ok then
		error(err, 0)
	end

	return title, body
end

smoke.Run("MiniHotKeysHider", {
	extra = function(context)
		fw.eq(context.Addon.Framework.CustomStyling, true, "custom styling on")
		fw.eq(context.Addon.Framework.CustomStylingOverrides.Button, false, "stock buttons")
		fw.truthy(HasDivider("SETTINGS"), "the settings section rule under the header")

		-- The saved variable is per character, so the label has to say so rather than read
		-- like an account-wide switch.
		local checkbox = FindCheckbox("Hide Character HotKeys")
		fw.not_nil(checkbox, "the hide hotkeys checkbox")

		local title, body = TooltipOn(checkbox)
		fw.eq(title, "Hide Character HotKeys", "the tooltip is titled with the label")
		fw.eq(body, "Hides this character's hotkeys.", "the tooltip explains the scope")
	end,
})
