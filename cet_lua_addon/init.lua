local framegen_ghosting_fix = {
__VERSION     = "FrameGen Ghosting 'Fix' 3.0.0",
__DESCRIPTION = "Limits ghosting when using FSR3 frame generation mods in Cyberpunk 2077",
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

local Diagnostics = require("Modules/Diagnostics")
local Calculate = require("Modules/Calculate")
local UIText = require("Modules/UIText")

local saved = false

--default settings
local enabledFPPCarSideMirror = false
local enabledELGSettings = false
local enabledFPPOnFoot = false
local enabledFPPVignetteAimOnFoot = false
local enabledFPPVignetteOnFoot = false
local enabledFPPVignettePermamentOnFoot = false

--load user settigns
function LoadUserSettings()
	local file = io.open("user_settings.json", "r")
	if file then
		local userSettingsContents = file:read("*a")
		file:close();
		local userSettings = json.decode(userSettingsContents)
		if userSettings then
			print(UIText.General.modname_log,UIText.General.settings_loaded)
		end
		enabledFPPCarSideMirror = userSettings.FPPCar.enabledSideMirror
		enabledELGSettings = userSettings.FPPBikeELG.enabledELG
		Calculate.FPPBikeELG.windshieldWidth = userSettings.FPPBikeELG.windshieldWidth
		Calculate.FPPBikeELG.windshieldHeight = userSettings.FPPBikeELG.windshieldHeight
		Calculate.FPPBikeELG.handlebarsHeight = userSettings.FPPBikeELG.handlebarsHeight
		enabledFPPOnFoot = userSettings.FPPOnFoot.enabledOnFoot
		if userSettings.FPPOnFoot.enabledVignetteAimOnFoot then
			enabledFPPVignetteAimOnFoot = userSettings.FPPOnFoot.enabledVignetteAimOnFoot
		end
		if userSettings.FPPOnFoot.enabledVignetteOnFoot then
			enabledFPPVignetteOnFoot = userSettings.FPPOnFoot.enabledVignetteOnFoot
			enabledFPPVignettePermamentOnFoot = userSettings.FPPOnFoot.enabledVignettePermamentOnFoot
			Calculate.FPPOnFoot.vignetteFootMarginLeft = userSettings.FPPOnFoot.vignetteFootMarginLeft
			Calculate.FPPOnFoot.vignetteFootMarginTop = userSettings.FPPOnFoot.vignetteFootMarginTop
			Calculate.FPPOnFoot.vignetteFootSizeX = userSettings.FPPOnFoot.vignetteFootSizeX
			Calculate.FPPOnFoot.vignetteFootSizeY = userSettings.FPPOnFoot.vignetteFootSizeY
		end
	else
		Calculate.SetELGDefault()
		Calculate.SetVignetteDefault()
		print(UIText.General.modname_log,UIText.General.settings_notfound)
	end
end

--save user settigns
function SaveUserSettings()
	local userSettings = {
		FPPBikeELG = {
			enabledELG = enabledELGSettings,
			windshieldWidth = Calculate.FPPBikeELG.windshieldWidth,
			windshieldHeight = Calculate.FPPBikeELG.windshieldHeight,
			handlebarsHeight = Calculate.FPPBikeELG.handlebarsHeight
		},
		FPPCar = {
			enabledSideMirror = enabledFPPCarSideMirror
		},
		FPPOnFoot = {
			enabledOnFoot = enabledFPPOnFoot,
			enabledVignetteAimOnFoot = enabledFPPVignetteAimOnFoot,
			enabledVignetteOnFoot = enabledFPPVignetteOnFoot,
			enabledVignettePermamentOnFoot = enabledFPPVignettePermamentOnFoot,
			vignetteFootMarginLeft = Calculate.FPPOnFoot.vignetteFootMarginLeft,
			vignetteFootMarginTop = Calculate.FPPOnFoot.vignetteFootMarginTop,
			vignetteFootSizeX = Calculate.FPPOnFoot.vignetteFootSizeX,
			vignetteFootSizeY = Calculate.FPPOnFoot.vignetteFootSizeY
		}
	}

	local userSettingsContents = json.encode(userSettings)

	local file = io.open( "user_settings.json", "w+")
	if file and userSettingsContents ~= nil then
		-- print(userSettingsContents)
		file:write(userSettingsContents)
		file:close()
		print(UIText.General.modname_log,UIText.General.settings_save_path)
	end
end

function SaveUserSettingsOnFootLog()
	print(UIText.General.modname_log,UIText.General.settings_saved_onfoot)
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
			self:OnFrameGenGhostingFixFPPBikeSetTransition(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.04, 0.0, 0.04, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.03, 0.0, 0.03, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.02, 0.0, 0.02, 0.02)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.01, 0.0, 0.02, 0.01)
		end)
	else
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((Calculate.FPPBikeELG.originalHandlebarsHeightPx*1.2), Calculate.FPPBikeELG.originalWindshieldWidthPx, Calculate.FPPBikeELG.originalWindshieldHeightPx, 0.04, 0.0, 0.0, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((Calculate.FPPBikeELG.originalHandlebarsHeightPx*1.15), Calculate.FPPBikeELG.originalWindshieldWidthPx, Calculate.FPPBikeELG.originalWindshieldHeightPx, 0.03, 0.0, 0.0, 0.03)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((Calculate.FPPBikeELG.originalHandlebarsHeightPx*1.1), Calculate.FPPBikeELG.originalWindshieldWidthPx, Calculate.FPPBikeELG.originalWindshieldHeightPx, 0.02, 0.0, 0.0, 0.02)
		end)
		Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent', function(self)
			self:OnFrameGenGhostingFixFPPBikeSetTransition((Calculate.FPPBikeELG.originalHandlebarsHeightPx), Calculate.FPPBikeELG.originalWindshieldWidthPx, Calculate.FPPBikeELG.originalWindshieldHeightPx, 0.01, 0.0, 0.0, 0.01)
		end)
	end
end

function TurnOnLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.7, 0.7)
	end)
end

function DefaultLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.4, 0.4)
	end)
end

function TurnOffLiveViewELGEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeELGEEvent', function(self)
		self:OnFrameGenGhostingFixFPPBikeELGEditor(Calculate.FPPBikeELG.newHandlebarsHeightPx, Calculate.FPPBikeELG.newWindshieldWidthPx, Calculate.FPPBikeELG.newWindshieldHeightPx, 0.0, 0.0)
	end)
end

function ApplyMasksOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
		local originalOnFoot = wrappedMethod()

		if not enabledFPPOnFoot then return originalOnFoot end
		self:FrameGenGhostingFixOnFootToggle(true)
	end)
end

function ApplyVignetteAimOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
		local orginalAimVignette = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return orginalAimVignette end
		self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
		local orginalVignetteAimDimensions = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return orginalVignetteAimDimensions end
		self:FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.vignetteAimFootSizeXPx, Calculate.FPPOnFoot.vignetteAimFootSizeYPx)
	end)
end

function ApplyVignetteOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
		local orginalVignette = wrappedMethod()

		if not enabledFPPVignetteOnFoot then return orginalVignette end
		self:FrameGenGhostingFixVignetteOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
		local orginalVignetteDimensions = wrappedMethod()

		if not enabledFPPVignetteOnFoot then return orginalVignetteDimensions end
		self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
		local orginalFunction = wrappedMethod()

		if not enabledFPPVignettePermamentOnFoot then return orginalFunction end
		self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
	end)
end

function TurnOnLiveViewVignetteOnFootEditor()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
		self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
		self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
	end)
end

function TurnOffLiveViewVignetteOnFootEditor()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
		self:FrameGenGhostingFixVignetteOnFootEditorContext(false)
		self:FrameGenGhostingFixVignetteOnFootEditorTurnOff()
		self:FrameGenGhostingFixVignetteOnFootSetDimensions()
	end)
end

function ApplyUserSettings()
	ApplyMasksOnFoot()
	ApplyVignetteAimOnFoot()
	ApplyVignetteOnFoot()
	ApplyFPPCarSideMirror()
	ApplyELGSettings()
	TurnOffLiveViewELGEditor()
	TurnOffLiveViewVignetteOnFootEditor()
end

--initialize all stuff etc
registerForEvent("onInit", function()
	LoadUserSettings()
	Calculate.CalcAspectRatio()
	Calculate.GetAspectRatio()
	Calculate.SetMasksOrgSizes()
	Calculate.SetVignetteOrgMinMax()
	Calculate.SetVignetteOrgSize()
	Calculate.SetVignetteAimSize()
	Calculate.HandlebarsY()
	Calculate.WindshieldX()
	Calculate.WindshieldY()
	Calculate.VignettePosX()
	Calculate.VignettePosY()
	Calculate.VignetteX()
	Calculate.VignetteY()
	ApplyUserSettings()
	Diagnostics.CheckModsCompatibility()
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

		if ImGui.Begin(UIText.General.modname, ImGuiWindowFlags.AlwaysAutoResize) then
			if ImGui.BeginTabBar('Tabs') then
				if not Diagnostics.modscompatibility then
					if ImGui.BeginTabItem(UIText.Diagnostics.tabname) then
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, 1)
						ImGui.Text(UIText.Diagnostics.title)
						ImGui.PopStyleColor()
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.Diagnostics.textfield_1)
						ImGui.Text("")
						for modfile,mod in pairs(Diagnostics.modfiles) do
							ImGui.Text(mod)
						end
						ImGui.Text("")
						ImGui.Text(UIText.Diagnostics.textfield_2)
						ImGui.PopStyleColor()
					ImGui.EndTabItem()
					end
				end
				if ImGui.BeginTabItem(UIText.VehiclesFPP.tabname) then
					ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
					ImGui.Text(UIText.General.title_fps90)
					ImGui.Separator()
					enabledFPPCarSideMirror, fppCarSideMirrorEnabled = ImGui.Checkbox(UIText.VehiclesFPP.SideMirror.name, enabledFPPCarSideMirror)
					if fppCarSideMirrorEnabled then
						SaveUserSettings()
					end
					if ImGui.IsItemHovered() then
						ImGui.SetTooltip(UIText.VehiclesFPP.SideMirror.tooltip)
					else
						ImGui.SetTooltip(nil)
					end
					enabledELGSettings, elgSettingsEnabled = ImGui.Checkbox(UIText.VehiclesFPP.ELG.name, enabledELGSettings)
					if elgSettingsEnabled then
						SaveUserSettings()
					end
					if ImGui.IsItemHovered() then
						ImGui.SetTooltip(UIText.VehiclesFPP.ELG.tooltip)
					else
						ImGui.SetTooltip(nil)
					end
					if enabledELGSettings then
						ImGui.Text("")
						ImGui.Text(UIText.VehiclesFPP.ELG.textfield_1)
						ImGui.Text("")
						ImGui.Text(UIText.VehiclesFPP.ELG.textfield_2)
						ImGui.Text("")
						ImGui.Text(UIText.VehiclesFPP.ELG.setting_1)
					ImGui.PopStyleColor()
					Calculate.FPPBikeELG.handlebarsHeight, handlebarsYChanged = ImGui.SliderFloat(UIText.VehiclesFPP.ELG.comment_1,Calculate.FPPBikeELG.handlebarsHeight, 70, 350, "%.0f")
							if handlebarsYChanged then
								Calculate.HandlebarsY()
								saved = false
								TurnOnLiveViewELGEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.VehiclesFPP.ELG.setting_2)
						ImGui.PopStyleColor()
						Calculate.FPPBikeELG.windshieldWidth, windshieldXChanged = ImGui.SliderFloat(UIText.VehiclesFPP.ELG.comment_2,Calculate.FPPBikeELG.windshieldWidth, 70, 250, "%.0f")
							if windshieldXChanged then
								Calculate.WindshieldX()
								saved = false
								TurnOnLiveViewELGEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.VehiclesFPP.ELG.setting_3)
						ImGui.PopStyleColor()
						Calculate.FPPBikeELG.windshieldHeight, windshieldYChanged = ImGui.SliderFloat(UIText.VehiclesFPP.ELG.comment_3,Calculate.FPPBikeELG.windshieldHeight, 80, 400, "%.0f")
							if windshieldYChanged then
								Calculate.WindshieldY()
								saved = false
								TurnOnLiveViewELGEditor()
							end
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if saved == true then
							ImGui.Text(UIText.General.settings_saved)
						end
						ImGui.PopStyleColor()
						if ImGui.Button(UIText.General.settings_default, 240, 40) then
							saved = false
							Calculate.SetELGDefault()
							DefaultLiveViewELGEditor()
						end
						ImGui.SameLine()
						if ImGui.Button(UIText.General.settings_save, 240, 40) then
							saved = true
							SaveUserSettings()
						end
					end
				ImGui.PopStyleColor()
				ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
					ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
					ImGui.Text(UIText.General.title_fps90)
					ImGui.Separator()
					enabledFPPOnFoot, fppOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BottomCornersMasks.name, enabledFPPOnFoot)
					if fppOnFootEnabled then
						SaveUserSettings()
						SaveUserSettingsOnFootLog()
					end
					if ImGui.IsItemHovered() then
						ImGui.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)
					else
						ImGui.SetTooltip(nil)
					end
					ImGui.Text("")
					ImGui.Text(UIText.General.title_fps120)
					ImGui.Separator()
					enabledFPPVignetteAimOnFoot, fppVignetteAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignetteAim.name, enabledFPPVignetteAimOnFoot)
					if fppVignetteAimOnFootEnabled then
						SaveUserSettings()
						SaveUserSettingsOnFootLog()
					end
					if ImGui.IsItemHovered() then
						ImGui.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)
					else
						ImGui.SetTooltip(nil)
					end
					enabledFPPVignetteOnFoot, fppVignetteOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.Vignette.name, enabledFPPVignetteOnFoot)
					if fppVignetteOnFootEnabled then
						SaveUserSettings()
						SaveUserSettingsOnFootLog()
					end
					if ImGui.IsItemHovered() then
						ImGui.SetTooltip(UIText.OnFoot.Vignette.tooltip)
					else
						ImGui.SetTooltip(nil)
					end
					if enabledFPPVignetteOnFoot then
						enabledFPPVignettePermamentOnFoot, fppVignettePermamentOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignettePermament.name, enabledFPPVignettePermamentOnFoot)
						if fppVignettePermamentOnFootEnabled then
							SaveUserSettings()
							SaveUserSettingsOnFootLog()
						end
						if ImGui.IsItemHovered() then
							ImGui.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)
						else
							ImGui.SetTooltip(nil)
						end
						if enabledFPPVignetteAimOnFoot and enabledFPPVignetteOnFoot then
							ImGui.Text("")
							ImGui.Text(UIText.OnFoot.VignetteAim.textfield_1)
						end
						ImGui.Text("")
						ImGui.Text(UIText.OnFoot.Vignette.textfield_1)
						ImGui.Text("")
						ImGui.Text(UIText.OnFoot.Vignette.setting_1)
						ImGui.PopStyleColor()
						Calculate.FPPOnFoot.vignetteFootSizeX, vignetteFootSizeXChanged = ImGui.SliderFloat("X size",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeX, "%.0f")
							if vignetteFootSizeXChanged then
								Calculate.VignetteCalcMarginX()
								Calculate.VignetteX()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.OnFoot.Vignette.setting_2)
						ImGui.PopStyleColor()
						Calculate.FPPOnFoot.vignetteFootSizeY, vignetteFootSizeYChanged = ImGui.SliderFloat("Y size",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeY, "%.0f")
							if vignetteFootSizeYChanged then
								Calculate.VignetteCalcMarginY()
								Calculate.VignetteY()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.OnFoot.Vignette.setting_3)
						ImGui.PopStyleColor()
						Calculate.FPPOnFoot.vignetteFootMarginLeft, vignetteFootMarginLeftChanged = ImGui.SliderFloat("X pos.",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX, "%.0f")
							if vignetteFootMarginLeftChanged then
								Calculate.VignetteCalcMarginX()
								Calculate.VignettePosX()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.OnFoot.Vignette.setting_4)
						ImGui.PopStyleColor()
						Calculate.FPPOnFoot.vignetteFootMarginTop, vignetteFootMarginTopChanged = ImGui.SliderFloat("Y pos.",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY, "%.0f")
							if vignetteFootMarginTopChanged then
								Calculate.VignetteCalcMarginY()
								Calculate.VignettePosY()
								saved = false
								TurnOnLiveViewVignetteOnFootEditor()
							end
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if saved == true then
							ImGui.Text(UIText.General.settings_saved)
						end
						ImGui.PopStyleColor()
						if ImGui.Button(UIText.General.settings_default, 240, 40) then
							saved = false
							Calculate.SetVignetteDefault()
							TurnOnLiveViewVignetteOnFootEditor()
						end
						ImGui.SameLine()
						if ImGui.Button(UIText.General.settings_save, 240, 40) then
							saved = true
							SaveUserSettings()
							SaveUserSettingsOnFootLog()
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