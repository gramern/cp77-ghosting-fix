local framegen_ghosting_fix= {
__VERSION     = 'FrameGen Ghosting Fix 2.11',
__DESCRIPTION = 'Limits ghosting when using FSR3 frame generation mods in Cyberpunk 2077',
__LICENSE     = [[
	MIT License

	Copyright (c) 2024 gramern (scz_g)

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]
}

local defaultLogTitle = "[FrameGen Ghosting 'Fix']"
local saved = false

--default settings
local enabledFPPOnFoot = false
local enabledFPPCarSideMirror = false
local enabledELGSettings = false

local originalHandlebarsHeightPx = 950
local originalWindshieldWidthPx = 1800
local originalWindshieldHeightPx = 800

--get the game's aspect ratio
function GetAspectRatio()
	if FGGFaspectratio <= 1.59 then
		FGGFscreentype = "4:3"
	elseif FGGFaspectratio >= 1.6 and FGGFaspectratio <= 1.7 then
		FGGFscreentype = "16:10"
	elseif FGGFaspectratio >= 1.71 and FGGFaspectratio <= 2.19 then
		FGGFscreentype = "16:9"
	elseif FGGFaspectratio >= 2.2 and FGGFaspectratio <= 3.4 then
		FGGFscreentype = "21:9"
	elseif FGGFaspectratio >= 3.41 then
		FGGFscreentype = "32:9"
	end
	-- print(defaultLogTitle,FGGFreswidth,"x",FGGFresheight,"is your screen resolution. Make sure you're using the",FGGFscreentype,"edition of the mod.")
end

function SetMasksOrgSizes()
	if FGGFscreentype == "16:10" then
		originalHandlebarsHeightPx = 1150
	elseif FGGFscreentype == "4:3" then
		originalHandlebarsHeightPx = 1200
		originalWindshieldHeightPx = 900
	end
end

--calc dimensions of AG masks
function HandlebarsY()
	newHandlebarsHeightPx = originalHandlebarsHeightPx*(handlebarsHeight/100.0)
	newHandlebarsHeightPx = (math.floor(newHandlebarsHeightPx+0.5))
	-- print(defaultLogTitle,"Handelbars AG mask height is scaled",handlebarsHeight,"%",'(',newHandlebarsHeightPx,'px)')
end

function WindshieldX()
	newWindshieldWidthPx = originalWindshieldWidthPx*(windshieldWidth/100.0)
	newWindshieldWidthPx = (math.floor(newWindshieldWidthPx+0.5))
	-- print(defaultLogTitle,"Windshield AG mask width is scaled",windshieldWidth,"%.",'(',newWindshieldWidthPx,'px)')
end

function WindshieldY()
	newWindshieldHeightPx = originalWindshieldHeightPx*(windshieldHeight/100.0)
	newWindshieldHeightPx = (math.floor(newWindshieldHeightPx+0.5))
	-- print(defaultLogTitle,"Windshield AG mask height is scaled",windshieldHeight,"%.",'(',newWindshieldHeightPx,'px)')
end

function SetELGDefault()
	handlebarsHeight = 170
	windshieldWidth = 120
	windshieldHeight = 300
	WindshieldX()
	WindshieldY()
	HandlebarsY()
end

-- function HasWeaponDrawn()
-- 	local hasWeapon = Game.GetTransactionSystem()
-- 	if not hasWeapon:GetItemInSlot(Game.GetPlayer(), TweakDBID.new("AttachmentSlots.WeaponRight")) then return end
-- 	print("A weapon equipped!")
-- end

--load/save user settigns
function LoadUserSettings()
	local file = io.open("user_settings.json", "r")
	if file then
		local userSettingsContents = file:read("*a")
		file:close();
		local userSettings = json.decode(userSettingsContents)
		if userSettings then
			print(defaultLogTitle,"User settings loaded.")
		end
		enabledFPPCarSideMirror = userSettings.FPPCar.enabledSideMirror
		enabledELGSettings = userSettings.FPPBikeELG.enabledELG
		windshieldWidth = userSettings.FPPBikeELG.windshieldWidth
		windshieldHeight = userSettings.FPPBikeELG.windshieldHeight
		handlebarsHeight = userSettings.FPPBikeELG.handlebarsHeight
		enabledFPPOnFoot = userSettings.FPPOnFoot.enabledOnFoot
	else
		SetELGDefault()
		print(defaultLogTitle,"A 'user_settings.json' file hasn't been found. Setting default values...")
	end
end

function SaveUserSettings()
	local userSettings = {
		FPPBikeELG = {
			enabledELG = enabledELGSettings,
			windshieldWidth = windshieldWidth,
			windshieldHeight = windshieldHeight,
			handlebarsHeight = handlebarsHeight
		},
		FPPCar = {
			enabledSideMirror = enabledFPPCarSideMirror
		},
		FPPOnFoot = {
			enabledOnFoot = enabledFPPOnFoot
		}
	}

	local userSettingsContents = json.encode(userSettings)

	local file = io.open( "user_settings.json", "w+")
	if file and userSettingsContents ~= nil then
		-- print(userSettingsContents)
		file:write(userSettingsContents)
		file:close()
		print(defaultLogTitle,"Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.")
	end
end

function ApplyFPPCarSideMirror()
	if not enabledFPPCarSideMirror then return end
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPCarSideMirrorToggleEvent', function(self)
		self:OnFrameGenGhostingFixDumboCameraFPPCarEvent(0.0500000007, 2400.0, 1800.0)
	end)
end

function ApplyELGSettings()
	if not enabledELGSettings then return end
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsEvent', function(self)
		self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.0299999993, 0.00100000005, 0.0250000004)
	end)
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsAmplifyEvent', function(self)
		self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.0399999991, 0.00100000005, 0.0399999991)
	end)
end

function TurnOffLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.0, 0.0)
	end)
end

function ApplyUserSettings()
	Override('IronsightGameController', 'OnFrameGenGhostingFixOnFootToggleEvent', function(self, masksOnFoot, wrappedMethod)
		local orginalFunc = wrappedMethod(masksOnFoot)

		if not enabledFPPOnFoot then return orginalFunc end
		self:OnFrameGenGhostingFixOnFootToggle(true)
	end)
	ApplyFPPCarSideMirror()
	ApplyELGSettings()
	TurnOffLiveViewELGEditor()
end


--initialize all stuff etc
registerForEvent("onInit", function()
	LoadUserSettings()
	FGGFreswidth, FGGFresheight = GetDisplayResolution();
	FGGFaspectratio = FGGFreswidth / FGGFresheight
	GetAspectRatio()
	SetMasksOrgSizes()
	HandlebarsY()
	WindshieldX()
	WindshieldY()
	ApplyUserSettings()
end)

registerForEvent("onOverlayOpen", function()
	CyberEngineOpen = true
end)

registerForEvent("onOverlayClose", function()
	CyberEngineOpen = false
	ApplyUserSettings()
end)

-- draw a ImGui window
registerForEvent("onDraw", function()
	if CyberEngineOpen then
		ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)
		ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, 300, 100)

		ImGui.PushStyleColor(ImGuiCol.TitleBg, 0.73, 0.56, 0, 1)
        ImGui.PushStyleColor(ImGuiCol.TitleBgActive, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGrip, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, 1, 0.85, 0.325, 1)
        ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBg, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgActive, 0.74, 0.58, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.CheckMark, 0, 0, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrab, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.82, 0, 1)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 0.85, 0.325, 1)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.Text, 0, 0, 0, 1)

		if ImGui.Begin("FrameGen Ghosting 'Fix'", ImGuiWindowFlags.AlwaysAutoResize) then

			ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
			ImGui.Text("On foot FPP options:")
			enabledFPPOnFoot, fppOnFootEnabled = ImGui.Checkbox("Enable bottom corners AG masks for FPP on foot", enabledFPPOnFoot)
			if fppOnFootEnabled then
				SaveUserSettings()
			end
			ImGui.Text("NOTE: This option needs the 'Input Loader' mod to work")
			ImGui.Text("")
			ImGui.Text("Vehicles FPP options:")
			enabledFPPCarSideMirror, fppCarSideMirrorEnabled = ImGui.Checkbox("Enable left-side mirror AG mask for FPP in cars", enabledFPPCarSideMirror)
			if fppCarSideMirrorEnabled then
				SaveUserSettings()
			end
			enabledELGSettings, elgSettingsEnabled = ImGui.Checkbox("Enable Even Less Ghosting for FPP on motorcycles", enabledELGSettings)
			if elgSettingsEnabled then
				SetELGDefault()
				SaveUserSettings()
			end
			ImGui.PopStyleColor()
			if enabledELGSettings then
				ImGui.Text("")
				ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
				ImGui.Text("For a live view, change the values below when in FPP on")
				ImGui.Text("a motorcycle during gameplay (not in the game's menu).")
				ImGui.Text("")
				ImGui.Text("CAUTION CHOOM! The default ELG settings are optimized")
				ImGui.Text("for 45 base fps (90 fps with FG ON). You need much more")
				ImGui.Text("base fps for an OK experience when setting high values")
				ImGui.Text("below. Potential Side Effects: sunscreen and banding.")
				ImGui.Text("")
				ImGui.Text("Handlebars AG mask height (ELG default 170%):")
				ImGui.PopStyleColor()
				handlebarsHeight, handlebarsYChanged = ImGui.SliderFloat("Extreme",handlebarsHeight, 70, 350, "%.0f")
					if handlebarsYChanged then
						HandlebarsY()
						saved = false
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsEvent', function(self)
							self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.2, 0.00100000005, 0.2)
						end)
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
							self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.7, 0.7)
						end)
					end
				ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
				ImGui.Text("Windshield AG mask width (ELG default 120%):")
				ImGui.PopStyleColor()
				windshieldWidth, windshieldXChanged = ImGui.SliderFloat("Oooffff",windshieldWidth, 70, 250, "%.0f")
					if windshieldXChanged then
						WindshieldX()
						saved = false
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsEvent', function(self)
							self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.2, 0.00100000005, 0.2)
						end)
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
							self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.7, 0.7)
						end)
					end
				ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
				ImGui.Text("Windshield AG mask height (ELG default 300%):")
				ImGui.PopStyleColor()
				windshieldHeight, windshieldYChanged = ImGui.SliderFloat("Bonkers",windshieldHeight, 80, 400, "%.0f")
					if windshieldYChanged then
						WindshieldY()
						saved = false
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsEvent', function(self)
							self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.2, 0.00100000005, 0.2)
						end)
						Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
							self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.7, 0.7)
						end)
					end
				ImGui.Text("")
				ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
				if saved == true then
					ImGui.Text("Your ELG settings are saved.")
				end
				ImGui.PopStyleColor()
				if ImGui.Button("Set ELG to default", 218, 40) then
					saved = false
					SetELGDefault()
					Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGSettingsEvent', function(self)
						self:OnFrameGenGhostingFixDumboCameraFPPBikeEvent(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.2, 0.00100000005, 0.2)
					end)
					Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
						self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.4, 0.4)
					end)
				end
				ImGui.SameLine()
				if ImGui.Button("Save ELG settings", 218, 40) then
					saved = true
					SaveUserSettings()
				end
			end
		end
		ImGui.End()
		ImGui.PopStyleVar(1)
	end
end)