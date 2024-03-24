local framegen_ghosting_fix= {
__VERSION     = 'FrameGen Ghosting Fix 2.13.0-alpha',
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
local hasWeapon = nil

--other mods compatibility
local modscompatibility = true
local modfiles = {}
local modfile = nil
local mod = nil

--default settings
local enabledFPPCarSideMirror = false
local enabledELGSettings = false
local enabledFPPOnFoot = false
local enabledFPPVignetteOnFoot = false

--default values vehicles
local handlebarsHeight = 170
local windshieldWidth = 120
local windshieldHeight = 300

local originalHandlebarsHeightPx = 950
local originalWindshieldWidthPx = 1800
local originalWindshieldHeightPx = 800

--default values on foot
local vignetteFootMarginLeft = 100
local vignetteFootMarginTop = 80
local vignetteFootSizeX = 120
local vignetteFootSizeY = 120

local originalVignetteFootMarginLeftPx = 1920
local originalVignetteFootMarginTopPx = 1080
local originalVignetteFootSizeXPx = 4840
local originalVignetteFootSizeYPx = 2560

--check for compatibility with other mods
function CheckModsCompatibility()
	if ModArchiveExists('basegame_hud_minimap_scanner_tweak.archive') then
		modscompatibility = false
		table.insert(modfiles, 1, "Limited HUD")
	end
	if ModArchiveExists('##ReduxUI_AddonSpeedometer.archive') and not ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
		modscompatibility = false
		table.insert(modfiles, 2, "Redux UI E3 Speedometer")
	end
	if ModArchiveExists('#Project-E3_HUD.archive') and not ModArchiveExists('###framegenghostingfix_ProjectE3.archive') then
		modscompatibility = false
		table.insert(modfiles, 3, "Project E3 - HUD")
	end
	if ModArchiveExists('#Project-E3_HUD-Lite.archive') and not ModArchiveExists('###framegenghostingfix_ProjectE3Lite.archive') then
		modscompatibility = false
		table.insert(modfiles, 4, "Project E3 - HUD (Lite)")
	end
end

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

function SetVignetteOrgSize()
	if FGGFscreentype == "4:3" then
		originalVignetteFootMarginLeftPx = 1920
		originalVignetteFootMarginTopPx = 1440
		originalVignetteFootSizeXPx = 4840
		originalVignetteFootSizeYPx = 3072
	elseif FGGFscreentype == "16:10" then
		originalVignetteFootMarginLeftPx = 1920
		originalVignetteFootMarginTopPx = 1200
		originalVignetteFootSizeXPx = 4840
		originalVignetteFootSizeYPx = 2880
	elseif FGGFscreentype == "21:9" then
		originalVignetteFootMarginLeftPx = 1920
		originalVignetteFootMarginTopPx = 1080
		originalVignetteFootSizeXPx = 6460
		originalVignetteFootSizeYPx = 2560
	elseif FGGFscreentype == "32:9" then
		originalVignetteFootMarginLeftPx = 1920
		originalVignetteFootMarginTopPx = 1080
		originalVignetteFootSizeXPx = 9680
		originalVignetteFootSizeYPx = 2560
	end
end

--calc dimensions of ELG masks
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

-- calc dimensions of vignette
function VignettePosX()
	newVignetteFootMarginLeftPx = originalVignetteFootMarginLeftPx*(vignetteFootMarginLeft/100.0)
	newVignetteFootMarginLeftPx = (math.floor(newVignetteFootMarginLeftPx+0.5))
	print(defaultLogTitle,"Vignette scaled",vignetteFootMarginLeft, newVignetteFootMarginLeftPx)
end

function VignettePosY()
	newVignetteFootMarginTopPx = originalVignetteFootMarginTopPx*(vignetteFootMarginTop/100.0)
	newVignetteFootMarginTopPx = (math.floor(newVignetteFootMarginTopPx+0.5))
	print(defaultLogTitle,"Vignette scaled",vignetteFootMarginTop, newVignetteFootMarginTopPx)
end

function VignetteX()
	newVignetteFootSizeXPx = originalVignetteFootSizeXPx*(vignetteFootSizeX/100.0)
	newVignetteFootSizeXPx = (math.floor(newVignetteFootSizeXPx+0.5))
	print(defaultLogTitle,"Vignette scaled",vignetteFootSizeX, newVignetteFootSizeXPx)
end

function VignetteY()
	newVignetteFootSizeYPx = originalVignetteFootSizeYPx*(vignetteFootSizeY/100.0)
	newVignetteFootSizeYPx = (math.floor(newVignetteFootSizeYPx+0.5))
	print(defaultLogTitle,"Vignette scaled",vignetteFootSizeY, newVignetteFootSizeYPx)
end

function SetVignetteDefault()
	vignetteFootMarginLeft = 100
	vignetteFootMarginTop = 100
	vignetteFootSizeX = 100
	vignetteFootSizeY = 100
	VignettePosX()
	VignettePosY()
	VignetteX()
	VignetteY()
end

-- function HasWeaponDrawn()
-- 	hasWeapon = Game.GetTransactionSystem()
-- 	if not hasWeapon:GetItemInSlot(Game.GetPlayer(), TweakDBID.new("AttachmentSlots.WeaponRight")) then return end
-- 	-- print("A weapon equipped!")
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
		if userSettings.FPPOnFoot.enabledVignetteOnFoot then
			enabledFPPVignetteOnFoot = userSettings.FPPOnFoot.enabledVignetteOnFoot
			vignetteFootMarginLeft = userSettings.FPPOnFoot.vignetteFootMarginLeft
			vignetteFootMarginTop = userSettings.FPPOnFoot.vignetteFootMarginTop
			vignetteFootSizeX = userSettings.FPPOnFoot.vignetteFootSizeX
			vignetteFootSizeY = userSettings.FPPOnFoot.vignetteFootSizeY
		end
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
			enabledOnFoot = enabledFPPOnFoot,
			enabledVignetteOnFoot = enabledFPPVignetteOnFoot,
			vignetteFootMarginLeft = vignetteFootMarginLeft,
			vignetteFootMarginTop = vignetteFootMarginTop,
			vignetteFootSizeX = vignetteFootSizeX,
			vignetteFootSizeY = vignetteFootSizeY
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

--apply user settings
function ApplyFPPCarSideMirror()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPCarSideMirrorToggleEvent', function(self)
		if not enabledFPPCarSideMirror then return end
		self:OnFrameGenGhostingFixDumboCameraFPPCarEvent(0.05, 2400.0, 1800.0)
	end)
end

function ApplyELGSettings()
	if enabledELGSettings then
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.04, 0.0, 0.04, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.03, 0.0, 0.03, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.02, 0.0, 0.02, 0.02)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.01, 0.0, 0.02, 0.01)
		end)
	else
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((originalHandlebarsHeightPx*1.2), originalWindshieldWidthPx, originalWindshieldHeightPx, 0.04, 0.0, 0.0, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((originalHandlebarsHeightPx*1.15), originalWindshieldWidthPx, originalWindshieldHeightPx, 0.03, 0.0, 0.0, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((originalHandlebarsHeightPx*1.1), originalWindshieldWidthPx, originalWindshieldHeightPx, 0.02, 0.0, 0.0, 0.02)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((originalHandlebarsHeightPx), originalWindshieldWidthPx, originalWindshieldHeightPx, 0.01, 0.0, 0.0, 0.01)
		end)
	end
end

function TurnOnLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.7, 0.7)
	end)
end

function DefaultLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.4, 0.4)
	end)
end

function TurnOffLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(newHandlebarsHeightPx, newWindshieldWidthPx, newWindshieldHeightPx, 0.0, 0.0)
	end)
end

function ApplyMasksOnFoot()
	Override('IronsightGameController', 'OnFrameGenGhostingFixOnFootToggleEvent', function(self, masksOnFoot, wrappedMethod)
		local originalOnFoot = wrappedMethod(masksOnFoot)

		if not enabledFPPOnFoot then return originalOnFoot end
		self:OnFrameGenGhostingFixOnFootToggle(true)
	end)
end

function ApplyVignetteOnFoot()
	Override('IronsightGameController', 'OnFrameGenGhostingFixVignetteOnFootToggleEvent', function(self, vignetteOnFoot, wrappedMethod)
		local orginalVignette = wrappedMethod(vignetteOnFoot)

		if not enabledFPPVignetteOnFoot then return orginalVignette end
		self:OnFrameGenGhostingFixVignetteOnFootToggle(true)
	end)
	Override('IronsightGameController', 'OnFrameGenGhostingFixVignetteFootSetDimensionsEvent', function(self, replacer, wrappedMethod)
		local orginalVignetteDimensions = wrappedMethod(replacer)

		if not enabledFPPVignetteOnFoot then return orginalVignetteDimensions end
		self:FrameGenGhostingFixVignetteFootSetDimensions(newVignetteFootMarginLeftPx, newVignetteFootMarginTopPx, newVignetteFootSizeXPx, newVignetteFootSizeYPx)
		-- self:FrameGenGhostingFixVignetteFootSetDimensions(vignetteFootMarginLeft, vignetteFootMarginTop, vignetteFootSizeX, vignetteFootSizeY)
	end)
end

function TurnOnLiveViewVignetteOnFootEditor()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
		self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
		self:FrameGenGhostingFixVignetteFootSetDimensions(newVignetteFootMarginLeftPx, newVignetteFootMarginTopPx, newVignetteFootSizeXPx, newVignetteFootSizeYPx)
		-- self:FrameGenGhostingFixVignetteFootSetDimensions(vignetteFootMarginLeft, vignetteFootMarginTop, vignetteFootSizeX, vignetteFootSizeY)
	end)
end

function TurnOffLiveViewVignetteOnFootEditor()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
		self:FrameGenGhostingFixVignetteOnFootEditorContext(false)
	end)
end

function ApplyUserSettings()
	ApplyMasksOnFoot()
	ApplyVignetteOnFoot()
	ApplyFPPCarSideMirror()
	ApplyELGSettings()
	TurnOffLiveViewELGEditor()
	TurnOffLiveViewVignetteOnFootEditor()
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
	VignettePosX()
	VignettePosY()
	VignetteX()
	VignetteY()
	ApplyUserSettings()
	CheckModsCompatibility()
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

		ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.CheckMark, 0, 0, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBg, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgActive, 0.74, 0.58, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGrip, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, 1, 0.85, 0.325, 1)
        ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrab, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.Tab, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabHovered, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.TabActive, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabUnfocused, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabUnfocusedActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.Text, 0, 0, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TitleBg, 0.73, 0.56, 0, 1)
        ImGui.PushStyleColor(ImGuiCol.TitleBgActive, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, 0.73, 0.56, 0, 1)

		if ImGui.Begin("FrameGen Ghosting 'Fix'", ImGuiWindowFlags.AlwaysAutoResize) then
			if ImGui.BeginTabBar('Tabs') then
				if not modscompatibility then
					if ImGui.BeginTabItem('Diagnostics') then
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, 1)
						ImGui.Text("POTENTIAL CONFLICTS WITH OTHER MODS DETECTED")
						ImGui.PopStyleColor()
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("To resolve potential conflicts with these mods:")
						ImGui.Text("")
						for modfile,mod in pairs(modfiles) do
							ImGui.Text(mod)
						end
						ImGui.Text("")
						ImGui.Text("and make sure Ghosting 'Fix' will work as expected,")
						ImGui.Text("please visit the mod's Nexus page for compatibility")
						ImGui.Text("tweaks and instructions.")
						ImGui.PopStyleColor()
					ImGui.EndTabItem()
					end
				end
				if ImGui.BeginTabItem('Vehicles FPP') then
					ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
					enabledFPPCarSideMirror, fppCarSideMirrorEnabled = ImGui.Checkbox("Enable left-side mirror AG mask for FPP in cars", enabledFPPCarSideMirror)
					if fppCarSideMirrorEnabled then
						SaveUserSettings()
					end
					enabledELGSettings, elgSettingsEnabled = ImGui.Checkbox("Enable Even Less Ghosting for FPP on motorcycles", enabledELGSettings)
					if elgSettingsEnabled then
						SetELGDefault()
						SaveUserSettings()
					end
					if enabledELGSettings then
						ImGui.Text("")
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
								TurnOnLiveViewELGEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("Windshield AG mask width (ELG default 120%):")
						ImGui.PopStyleColor()
						windshieldWidth, windshieldXChanged = ImGui.SliderFloat("Oooffff",windshieldWidth, 70, 250, "%.0f")
							if windshieldXChanged then
								WindshieldX()
								saved = false
								TurnOnLiveViewELGEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("Windshield AG mask height (ELG default 300%):")
						ImGui.PopStyleColor()
						windshieldHeight, windshieldYChanged = ImGui.SliderFloat("Bonkers",windshieldHeight, 80, 400, "%.0f")
							if windshieldYChanged then
								WindshieldY()
								saved = false
								TurnOnLiveViewELGEditor()
							end
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if saved == true then
							ImGui.Text("Your settings are saved.")
						end
						ImGui.PopStyleColor()
						if ImGui.Button("Set ELG to default", 225, 40) then
							saved = false
							SetELGDefault()
							DefaultLiveViewELGEditor()
						end
						ImGui.SameLine()
						if ImGui.Button("Save ELG settings", 225, 40) then
							saved = true
							SaveUserSettings()
						end
					end
				ImGui.PopStyleColor()
				ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem('On Foot') then
					ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
					ImGui.Text("NOTE: These options needs the 'Input Loader' mod to work")
					ImGui.Text("")
					enabledFPPOnFoot, fppOnFootEnabled = ImGui.Checkbox("Enable bottom corners AG masks for FPP on foot", enabledFPPOnFoot)
					if fppOnFootEnabled then
						SaveUserSettings()
					end
					ImGui.Text("")
					ImGui.Text("EXPERIMENTAL / FOR FUN FEATURES BELOW - 120+ FPS ONLY:")
					ImGui.Text("")
					ImGui.Text("Options  below let you configure a AG vignette to cover")
					ImGui.Text("ghosting on your screen edges. These settings come with")
					ImGui.Text("a cost of perceived smoothness in certain parts of your")
					ImGui.Text("screen. You can enable and customize them but you need")
					ImGui.Text("a HIGH base framerate (more than 60 fps without FG) to")
					ImGui.Text("achieve acceptable results.")
					ImGui.Text("")
					enabledFPPVignetteOnFoot, fppVignetteOnFootEnabled = ImGui.Checkbox("Enable AG vignette for FPP on foot", enabledFPPVignetteOnFoot)
					if fppVignetteOnFootEnabled then
						SaveUserSettings()
					end
					ImGui.PopStyleColor()
					if enabledFPPVignetteOnFoot then
						ImGui.PushStyleColor(ImGuiCol.Text, 0.9, 0.1, 0.1, 1)
						ImGui.Text("")
						ImGui.Text("SERIOUSLY, YOU REALLY NEED THAT 120+ FPS (WITH FG ON)")
						ImGui.PopStyleColor()
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("The black area will be excluded from frame generation.")
						ImGui.Text("")
						ImGui.Text("Vignette's horizontal position:")
						ImGui.PopStyleColor()
						vignetteFootMarginLeft, vignetteFootMarginLeftChanged = ImGui.SliderFloat("X pos.",vignetteFootMarginLeft, 70, 130, "%.0f")
							if vignetteFootMarginLeftChanged then
								VignettePosX()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("Vignette's vertical position:")
						ImGui.PopStyleColor()
						vignetteFootMarginTop, vignetteFootMarginTopChanged = ImGui.SliderFloat("Y pos.",vignetteFootMarginTop, 70, 130, "%.0f")
							if vignetteFootMarginTopChanged then
								VignettePosY()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("Vignette's width:")
						ImGui.PopStyleColor()
						vignetteFootSizeX, vignetteFootSizeXChanged = ImGui.SliderFloat("X size",vignetteFootSizeX, 70, 130, "%.0f")
							if vignetteFootSizeXChanged then
								VignetteX()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text("Vignette's height:")
						ImGui.PopStyleColor()
						vignetteFootSizeY, vignetteFootSizeYChanged = ImGui.SliderFloat("Y size",vignetteFootSizeY, 70, 130, "%.0f")
							if vignetteFootSizeYChanged then
								VignetteY()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if saved == true then
							ImGui.Text("Your settings are saved.")
						end
						ImGui.PopStyleColor()
						if ImGui.Button("Set to default", 240, 40) then
							saved = false
							SetVignetteDefault()
						end
						ImGui.SameLine()
						if ImGui.Button("Save vignette settings", 240, 40) then
							saved = true
							SaveUserSettings()
						end	
					end
				ImGui.EndTabItem()
				end
			ImGui.EndTabBar()
			end
        end
		ImGui.End()
		ImGui.PopStyleVar(1)
	end
end)