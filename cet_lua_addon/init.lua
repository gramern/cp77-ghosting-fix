local framegen_ghosting_fix = {
__VERSION     = "FrameGen Ghosting 'Fix' 3.1.0",
__DESCRIPTION = "Limits ghosting when using frame generation in Cyberpunk 2077",
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

local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Presets = require("Modules/Presets")
local UIText = require("Modules/UIText")

local saved = false
local applied_onfoot = false

--default settings
local enabledFPPCarSideMirror = false
local enabledELGSettings = false
local enabledFPPOnFoot = false
local enabledFPPBlockerAimOnFoot = false
local enabledFPPVignetteAimOnFoot = false
local enabledFPPVignetteOnFoot = false
local enabledFPPVignettePermamentOnFoot = false

--set default preset
function SetDefaultPreset()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		table.insert(Presets.presetsList, 1, Presets.Default43.PresetInfo.name)
		table.insert(Presets.presetsDesc, 1, Presets.Default43.PresetInfo.description)
		table.insert(Presets.presetsAuth, 1, Presets.Default43.PresetInfo.author)
	else
		table.insert(Presets.presetsList, 1, Presets.Default.PresetInfo.name)
		table.insert(Presets.presetsDesc, 1, Presets.Default.PresetInfo.description)
		table.insert(Presets.presetsAuth, 1, Presets.Default.PresetInfo.author)
	end
	print(UIText.General.modname_log,"Set default preset:",Presets.presetsList[1])
end

function SetDefaultPresetFile()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		table.insert(Presets.presetsFile, 1, Presets.Default43.PresetInfo.file)
	else
		table.insert(Presets.presetsFile, 1, Presets.Default.PresetInfo.file)
	end
end

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
		if userSettings.FPPOnFoot.enabledBlockerAimOnFoot then
			enabledFPPBlockerAimOnFoot = userSettings.FPPOnFoot.enabledBlockerAimOnFoot
		end
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
		if userSettings.TPPVehicles.selectedPreset then
			Presets.selectedPreset = userSettings.TPPVehicles.selectedPreset
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
		TPPVehicles = {
			selectedPreset = Presets.selectedPreset,
		},
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
			enabledBlockerAimOnFoot = enabledFPPBlockerAimOnFoot,
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
	applied_onfoot = true
end

--apply user settings
function ApplyMaskingInVehiclesGlobal()
	Override('IronsightGameController', 'FrameGenFrameGenGhostingFixVehicleToggleEvent', function(self, wrappedMethod)
		local originalFunction = wrappedMethod()

		if Presets.MaskingInVehiclesGlobal.enabled then return originalFunction end
		self:FrameGenGhostingFixVehicleToggle(false)
	end)
end

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
		if Presets.FPPBike.enabled == false then
			Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeEvent', function(self)
				self:OnFrameGenGhostingFixFPPBikeSetTransition(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end)
			Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent', function(self)
				self:OnFrameGenGhostingFixFPPBikeSetTransition(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end)
			Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent', function(self)
				self:OnFrameGenGhostingFixFPPBikeSetTransition(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end)
			Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent', function(self)
				self:OnFrameGenGhostingFixFPPBikeSetTransition(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
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

function ApplyBlockerAimOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
		local originalBlockerAim = wrappedMethod()

		if not enabledFPPBlockerAimOnFoot then return originalBlockerAim end
		self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
		local originalAimDimensions = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return originalAimDimensions end
		self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
	end)
end

function ApplyVignetteAimOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
		local originalVignetteAim = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return originalVignetteAim end
		self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
		local originalAimDimensions = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return originalAimDimensions end
		self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
	end)
end

function ApplyVignetteOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
		local originalVignette = wrappedMethod()

		if not enabledFPPVignetteOnFoot then return originalVignette end
		self:FrameGenGhostingFixVignetteOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
		local originalVignetteDimensions = wrappedMethod()

		if not enabledFPPVignetteOnFoot then return originalVignetteDimensions end
		self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
		local originalFunction = wrappedMethod()

		if not enabledFPPVignettePermamentOnFoot then return originalFunction end
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
	ApplyBlockerAimOnFoot()
	ApplyVignetteAimOnFoot()
	ApplyVignetteOnFoot()
	TurnOffLiveViewELGEditor()
	TurnOffLiveViewVignetteOnFootEditor()
	ApplyMaskingInVehiclesGlobal()
	if not Presets.MaskingInVehiclesGlobal.enabled then return end
	ApplyFPPCarSideMirror()
	ApplyELGSettings()
end

--initialize all stuff etc
registerForEvent("onInit", function()
	Diagnostics.CheckModsCompatibility()
	if Diagnostics.modscompatibility then
		Calculate.CalcAspectRatio()
		Calculate.GetAspectRatio()
		SetDefaultPreset()
		Presets.ListPresets()
		SetDefaultPresetFile()
		LoadUserSettings()
		Presets.GetPresetInfo()
		Presets.LoadPreset()
		Presets.ApplyPreset()
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
	end
end)

registerForEvent("onOverlayOpen", function()
	CyberEngineOpen = true
end)

registerForEvent("onOverlayClose", function()
	CyberEngineOpen = false
	applied_onfoot = false
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
		ImGui.PushStyleColor(ImGuiCol.Header, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.HeaderHovered, 1, 0.85, 0.325, 1)
		ImGui.PushStyleColor(ImGuiCol.HeaderActive, 1, 0.82, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.73, 0.56, 0, 1)
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
		ImGui.PushStyleColor(ImGuiCol.WindowBg, 0, 0, 0, 0.75)

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
				else
					if ImGui.BeginTabItem(UIText.Vehicles.tabname) then
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.General.title_general)
						ImGui.Separator()
						ImGui.Text(UIText.Vehicles.MaskingPresets.name)
						ImGui.PopStyleColor()
						if Presets.selectedPresetPosition == nil then
							Presets.GetPresetInfo()
						end
						if ImGui.BeginCombo("##", Presets.selectedPreset) then
							for _, preset in ipairs(Presets.presetsList) do
							local preset_selected = (Presets.selectedPreset == preset)
								if ImGui.Selectable(preset, preset_selected) then
									Presets.selectedPreset = preset
									Presets.GetPresetInfo()
								end
								if preset_selected then
									ImGui.SetItemDefaultFocus()
								end
							end
							ImGui.EndCombo()
						end
						if ImGui.IsItemHovered() then
							ImGui.SetTooltip(UIText.Vehicles.MaskingPresets.tooltip)
						else
							ImGui.SetTooltip(nil)
						end
						ImGui.SameLine()
						if ImGui.Button(UIText.General.settings_apply) then
							SaveUserSettings()
							Presets.LoadPreset()
							Presets.ApplyPreset()
						end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if Presets.selectedPresetPosition then
							if Presets.presetsDesc[Presets.selectedPresetPosition] then
								ImGui.Text("Preset's info:")
								ImGui.Text(Presets.presetsDesc[Presets.selectedPresetPosition])
							end
							if Presets.presetsAuth[Presets.selectedPresetPosition] then
								ImGui.Text("Preset's author:")
								ImGui.SameLine()
								ImGui.Text(Presets.presetsAuth[Presets.selectedPresetPosition])
							end
						end
						if Presets.MaskingInVehiclesGlobal.enabled then
							ImGui.Text("")
							ImGui.Text(UIText.General.title_fps90)
							ImGui.Separator()
							enabledFPPCarSideMirror, fppCarSideMirrorEnabled = ImGui.Checkbox(UIText.Vehicles.SideMirror.name, enabledFPPCarSideMirror)
							if fppCarSideMirrorEnabled then
								SaveUserSettings()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.Vehicles.SideMirror.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							enabledELGSettings, elgSettingsEnabled = ImGui.Checkbox(UIText.Vehicles.ELG.name, enabledELGSettings)
							if elgSettingsEnabled then
								SaveUserSettings()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.Vehicles.ELG.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							if enabledELGSettings then
								ImGui.Text("")
								ImGui.Text(UIText.Vehicles.ELG.textfield_1)
								ImGui.Text("")
								ImGui.Text(UIText.Vehicles.ELG.textfield_2)
								ImGui.Text("")
								ImGui.Text(UIText.Vehicles.ELG.setting_1)
							ImGui.PopStyleColor()
							Calculate.FPPBikeELG.handlebarsHeight, handlebarsYChanged = ImGui.SliderFloat(UIText.Vehicles.ELG.comment_1,Calculate.FPPBikeELG.handlebarsHeight, 70, 350, "%.0f")
									if handlebarsYChanged then
										Calculate.HandlebarsY()
										saved = false
										TurnOnLiveViewELGEditor()
									end
								ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
								ImGui.Text(UIText.Vehicles.ELG.setting_2)
								ImGui.PopStyleColor()
								Calculate.FPPBikeELG.windshieldWidth, windshieldXChanged = ImGui.SliderFloat(UIText.Vehicles.ELG.comment_2,Calculate.FPPBikeELG.windshieldWidth, 70, 250, "%.0f")
									if windshieldXChanged then
										Calculate.WindshieldX()
										saved = false
										TurnOnLiveViewELGEditor()
									end
								ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
								ImGui.Text(UIText.Vehicles.ELG.setting_3)
								ImGui.PopStyleColor()
								Calculate.FPPBikeELG.windshieldHeight, windshieldYChanged = ImGui.SliderFloat(UIText.Vehicles.ELG.comment_3,Calculate.FPPBikeELG.windshieldHeight, 80, 400, "%.0f")
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
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							ImGui.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)
						else
							ImGui.SetTooltip(nil)
						end
						if not enabledFPPVignetteAimOnFoot then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							enabledFPPBlockerAimOnFoot, fppBlockerAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BlockerAim.name, enabledFPPBlockerAimOnFoot)
							if fppBlockerAimOnFootEnabled then
								enabledFPPVignetteAimOnFoot = false
								SaveUserSettings()
								SaveUserSettingsOnFootLog()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.OnFoot.BlockerAim.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
						else
							ImGui.Separator()
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text(UIText.General.info_aim_onfoot)
							ImGui.PopStyleColor()
							ImGui.Separator()
						end
						ImGui.Text("")
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.General.title_fps120)
						ImGui.Separator()
						ImGui.PopStyleColor()
						if not enabledFPPBlockerAimOnFoot then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							enabledFPPVignetteAimOnFoot, fppVignetteAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignetteAim.name, enabledFPPVignetteAimOnFoot)
							if fppVignetteAimOnFootEnabled then
								enabledFPPBlockerAimOnFoot = false
								SaveUserSettings()
								SaveUserSettingsOnFootLog()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
						else
							ImGui.Separator()
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text(UIText.General.info_aim_onfoot)
							ImGui.PopStyleColor()
							ImGui.Separator()
						end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						enabledFPPVignetteOnFoot, fppVignetteOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.Vignette.name, enabledFPPVignetteOnFoot)
						if fppVignetteOnFootEnabled then
							SaveUserSettings()
							SaveUserSettingsOnFootLog()
						end
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							ImGui.SetTooltip(UIText.OnFoot.Vignette.tooltip)
						else
							ImGui.SetTooltip(nil)
						end
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						if enabledFPPVignetteOnFoot then
							enabledFPPVignettePermamentOnFoot, fppVignettePermamentOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignettePermament.name, enabledFPPVignettePermamentOnFoot)
							if fppVignettePermamentOnFootEnabled then
								SaveUserSettings()
								SaveUserSettingsOnFootLog()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
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
						else
							enabledFPPVignettePermamentOnFoot = false
						end
						if applied_onfoot then
							ImGui.Separator()
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text(UIText.General.settings_saved_onfoot)
							ImGui.PopStyleColor()
						end
					ImGui.EndTabItem()
					end
				ImGui.EndTabBar()
				end
			end
        end
		ImGui.End()
		ImGui.PopStyleVar(1)
	end
end)