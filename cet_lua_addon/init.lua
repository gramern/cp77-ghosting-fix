local framegen_ghosting_fix = {
__VERSION     = "FrameGen Ghosting 'Fix' 4.0.0",
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
local Config = require("Modules/Config")
local Diagnostics = require("Modules/Diagnostics")
local Presets = require("Modules/Presets")
local UIText = require("Modules/UIText")
local Vectors = require("Modules/Vectors")

--debug switch
local debugInfo = true

--debug prints
function PrintVehData()
	print("Vectors.Vehicle.Position:",Vectors.Vehicle.Position)
	print("Vectors.Vehicle.Forward:",Vectors.Vehicle.Forward)
	print("Vectors.Vehicle.Right:",Vectors.Vehicle.Right)
	print("Vectors.Vehicle.Up:",Vectors.Vehicle.Up)
	print(Vectors.Vehicle.vehicleType)
	print(Vectors.Vehicle.currentSpeed)
end

local saved = false
local appliedVeh = false
local appliedOnFoot = false
local enabledGFixWindow = false

--default settings
local enabledWindshieldSettings = false
local enabledFPPOnFoot = false
local enabledFPPBlockerAimOnFoot = true
local enabledFPPVignetteAimOnFoot = false
local enabledFPPVignetteOnFoot = false
local enabledFPPVignettePermamentOnFoot = false

--set default preset
function SetDefaultPreset()
	table.insert(Presets.presetsList, 1, Config.Default.PresetInfo.name)
	table.insert(Presets.presetsDesc, 1, Config.Default.PresetInfo.description)
	table.insert(Presets.presetsAuth, 1, Config.Default.PresetInfo.author)
end

function SetDefaultPresetFile()
	table.insert(Presets.presetsFile, 1, Config.Default.PresetInfo.file)
end

function SetDefaultIf43()
	if Calculate.ScreenDetection.screenType == 5 then
		Presets.selectedPreset = "Stronger"
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
		if userSettings.FPPBikeWindshield.enabledWindshield then
			enabledWindshieldSettings = userSettings.FPPBikeWindshield.enabledWindshield
			Vectors.VehMasks.Mask1.Scale.x = userSettings.FPPBikeWindshield.width
			Vectors.VehMasks.Mask1.Scale.y = userSettings.FPPBikeWindshield.height
		end
		if userSettings.FPPOnFoot.enabledOnFoot then
			enabledFPPOnFoot = userSettings.FPPOnFoot.enabledOnFoot
		end
		if userSettings.FPPOnFoot.enabledBlockerAimOnFoot then
			enabledFPPBlockerAimOnFoot = userSettings.FPPOnFoot.enabledBlockerAimOnFoot
		end
		if userSettings.FPPOnFoot.enabledVignetteOnFoot then
			enabledFPPVignetteAimOnFoot = userSettings.FPPOnFoot.enabledVignetteAimOnFoot
			enabledFPPVignetteOnFoot = userSettings.FPPOnFoot.enabledVignetteOnFoot
			enabledFPPVignettePermamentOnFoot = userSettings.FPPOnFoot.enabledVignettePermamentOnFoot
			Calculate.FPPOnFoot.vignetteFootMarginLeft = userSettings.FPPOnFoot.vignetteFootMarginLeft
			Calculate.FPPOnFoot.vignetteFootMarginTop = userSettings.FPPOnFoot.vignetteFootMarginTop
			Calculate.FPPOnFoot.vignetteFootSizeX = userSettings.FPPOnFoot.vignetteFootSizeX
			Calculate.FPPOnFoot.vignetteFootSizeY = userSettings.FPPOnFoot.vignetteFootSizeY
		end
		if userSettings.Vehicles.selectedPreset then
			Presets.selectedPreset = userSettings.Vehicles.selectedPreset
		end
	else
		SetDefaultIf43()
		Vectors.SetWindshieldDefault()
		Calculate.SetVignetteDefault()
		print(UIText.General.modname_log,UIText.General.settings_notfound)
	end
end

--save user settigns
function SaveUserSettings()
	local userSettings = {
		Vehicles = {
			selectedPreset = Presets.selectedPreset,
		},
		FPPBikeWindshield = {
			enabledWindshield = enabledWindshieldSettings,
			width = Vectors.VehMasks.Mask1.CachedScale.x,
			height = Vectors.VehMasks.Mask1.CachedScale.y,
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
	appliedOnFoot = true
end

--apply user settings
function ApplyMaskingInVehiclesGlobal()
	Vectors.VehMasks.enabled = Config.MaskingInVehiclesGlobal.enabled
	Override('IronsightGameController', 'FrameGenFrameGenGhostingFixVehicleToggleEvent', function(self, wrappedMethod)
		local originalFunction = wrappedMethod()

		if Config.MaskingInVehiclesGlobal.enabled then return originalFunction end
		self:FrameGenGhostingFixVehicleToggle(false)
	end)
end

function TurnOnLiveViewWindshieldEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
		self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.8, false, false, true)
	end)
end

function DefaultLiveViewWindshieldEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
		self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.6, false, false, true)
	end)
end

function TurnOffLiveViewWindshieldEditor()
	Override('IronsightGameController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
		self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.0, false, false, true)
	end)
end

function ApplyMasksOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
		local originalOnFoot = wrappedMethod()

		if not enabledFPPOnFoot then return originalOnFoot end
		self:FrameGenGhostingFixOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
		self:FrameGenGhostingFixMasksOnFootSetMargins(Calculate.FPPOnFoot.cornerDownLeftMargin, Calculate.FPPOnFoot.cornerDownRightMargin, Calculate.FPPOnFoot.cornerDownMarginTop)
	end)
end

function ApplyBlockerAimOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
		local originalBlockerAim = wrappedMethod()

		if not enabledFPPBlockerAimOnFoot then return originalBlockerAim end
		self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
		self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
	end)
end

function ApplyVignetteAimOnFoot()
	Override('IronsightGameController', 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
		local originalVignetteAim = wrappedMethod()

		if not enabledFPPVignetteAimOnFoot then return originalVignetteAim end
		self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
	end)
	Override('IronsightGameController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
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
	TurnOffLiveViewWindshieldEditor()
	TurnOffLiveViewVignetteOnFootEditor()
	ApplyMaskingInVehiclesGlobal()
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
		Calculate.SetCornersMargins()
		Calculate.SetVignetteOrgMinMax()
		Calculate.SetVignetteOrgSize()
		Calculate.SetMaskingAimSize()
		Calculate.VignettePosX()
		Calculate.VignettePosY()
		Calculate.VignetteX()
		Calculate.VignetteY()
		Vectors.SetWindshieldDefault()
		Calculate.SetHEDSize()
		ApplyUserSettings()
	end
end)

registerForEvent("onOverlayOpen", function()
	CyberEngineOpen = true
end)

registerForEvent("onOverlayClose", function()
	if not enabledGFixWindow then
		CyberEngineOpen = false
	end
	appliedOnFoot = false
	Calculate.CalcAspectRatio()
	Calculate.GetAspectRatio()
	Calculate.SetCornersMargins()
	Calculate.SetVignetteOrgMinMax()
	Calculate.SetVignetteOrgSize()
	Calculate.SetMaskingAimSize()
	Calculate.VignettePosX()
	Calculate.VignettePosY()
	Calculate.VignetteX()
	Calculate.VignetteY()
	Calculate.SetHEDSize()
	ApplyUserSettings()
end)

registerForEvent("onUpdate", function(delta)
		Vectors.IsMounted()
		Vectors.ProjectMasks()
end)

--debug get data hotkey
registerInput('getdata', 'Get data', function(keypress)
    if keypress then
    else
		Vectors.IsDriver()
		Vectors.PrintVehData()
    end
end)

-- draw a ImGui window
registerForEvent("onDraw", function()
	if CyberEngineOpen then
		ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)
		ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, 300, 100)

		ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.78, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 0.85, 0.31, 1)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.CheckMark, 0, 0, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBg, 1, 0.78, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, 1, 0.85, 0.31, 1)
		ImGui.PushStyleColor(ImGuiCol.FrameBgActive, 0.74, 0.58, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.Header, 1, 0.78, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.HeaderHovered, 1, 0.85, 0.31, 1)
		ImGui.PushStyleColor(ImGuiCol.HeaderActive, 1, 0.78, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGrip, 0.78, 0.612, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, 1, 0.85, 0.31, 1)
        ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrab, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, 1, 0.85, 0.31, 1)
		ImGui.PushStyleColor(ImGuiCol.Tab, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabHovered, 1, 0.85, 0.31, 1)
		ImGui.PushStyleColor(ImGuiCol.TabActive, 1, 0.78, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabUnfocused, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TabUnfocusedActive, 0.73, 0.56, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.Text, 0, 0, 0, 1)
		ImGui.PushStyleColor(ImGuiCol.TitleBg, 0.73, 0.56, 0, 1)
        ImGui.PushStyleColor(ImGuiCol.TitleBgActive, 1, 0.78, 0, 1)
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
									appliedVeh = false
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
							appliedVeh = true
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
						if appliedVeh then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text("")
							ImGui.Text(UIText.General.settings_applied_veh)
							ImGui.PopStyleColor()
						end
						ImGui.PopStyleColor()
						if Config.MaskingInVehiclesGlobal.enabled then
							ImGui.Text("")
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text(UIText.General.title_fps90)
							ImGui.Separator()
							enabledWindshieldSettings, WindshieldSettingsEnabled = ImGui.Checkbox(UIText.Vehicles.Windshield.name, enabledWindshieldSettings)
							if WindshieldSettingsEnabled then
								Vectors.ReadCache()
								SaveUserSettings()
							end
							ImGui.PopStyleColor()
							if ImGui.IsItemHovered() then
								ImGui.SetTooltip(UIText.Vehicles.Windshield.tooltip)
							else
								ImGui.SetTooltip(nil)
							end
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							if enabledWindshieldSettings then
								if Vectors.Vehicle.currentSpeed ~= nil and Vectors.Vehicle.currentSpeed < 1 and Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") and Vectors.Vehicle.activePerspective == vehicleCameraPerspective.FPP then
									ImGui.Text("")
									ImGui.Text(UIText.Vehicles.Windshield.textfield_1)
									ImGui.Text("")
									ImGui.PopStyleColor()
									ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
									ImGui.Text(UIText.Vehicles.Windshield.setting_1)
									ImGui.PopStyleColor()
									Vectors.VehMasks.Mask1.Scale.x, windshieldXChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_1,Vectors.VehMasks.Mask1.Scale.x, 100, 150, "%.0f")
										if windshieldXChanged then
											Vectors.ResizeBikeWindshieldMask()
											saved = false
											TurnOnLiveViewWindshieldEditor()
										end
									ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
									ImGui.Text(UIText.Vehicles.Windshield.setting_2)
									ImGui.PopStyleColor()
									Vectors.VehMasks.Mask1.Scale.y, windshieldYChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_2,Vectors.VehMasks.Mask1.Scale.y, 100, 300, "%.0f")
										if windshieldYChanged then
											Vectors.ResizeBikeWindshieldMask()
											saved = false
											TurnOnLiveViewWindshieldEditor()
										end
									ImGui.Text("")
									ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
									if saved == true then
										ImGui.Text(UIText.General.settings_saved)
									end
									ImGui.PopStyleColor()
									if ImGui.Button(UIText.General.settings_default, 240, 40) then
										saved = false
										Vectors.SetWindshieldDefault()
										DefaultLiveViewWindshieldEditor()
									end
									ImGui.SameLine()
									if ImGui.Button(UIText.General.settings_save, 240, 40) then
										saved = true
										Vectors.SaveCache()
										SaveUserSettings()
									end
								else
									ImGui.Text("")
									ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
									ImGui.Text(UIText.Vehicles.Windshield.warning)
									ImGui.Text("")
									ImGui.PopStyleColor()
								end
							else
								Vectors.SetWindshieldDefault()
							end
						end
						ImGui.PopStyleColor()
					ImGui.EndTabItem()
					end
					if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
						ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
						ImGui.Text(UIText.General.title_general)
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
						if appliedOnFoot then
							ImGui.Separator()
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							ImGui.Text(UIText.General.settings_saved_onfoot)
							ImGui.PopStyleColor()
						end
						ImGui.PopStyleColor()
					ImGui.EndTabItem()
					end
					if debugInfo then
						if ImGui.BeginTabItem("Debug Data") then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							enabledGFixWindow, GFixWindowEnabled = ImGui.Checkbox("Keep this window open", enabledGFixWindow)
							if GFixWindowEnabled then
								CyberEngineOpen = true
							end
							ImGui.Separator()
							ImGui.Text("Screen Resolution:")
							ImGui.Text(tostring(Vectors.Screen.Real.width))
							ImGui.SameLine()
							ImGui.Text(tostring(Vectors.Screen.Real.height))
							ImGui.Text("Screen Aspect Ratio:")
							ImGui.Text(tostring(Vectors.Screen.aspectRatio))
							ImGui.Separator()
							ImGui.Text("Masking enabled:")
							ImGui.Text(tostring(Vectors.VehMasks.enabled))
							if Vectors.Vehicle.activePerspective then
								ImGui.Text("Active Perspective in Vehicles:")
								ImGui.Text(tostring(Vectors.Vehicle.activePerspective))
							end
							ImGui.Separator()
							if Vectors.VehMasks.Mask2.Position then
								ImGui.Text("Mask2 Offset:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.Def.Offset.x))
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.Def.Offset.y))
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.Def.Offset.z))
							end
							ImGui.Separator()
							if Vectors.Camera.dotProduct then
								ImGui.Text("Dot Product:")
								ImGui.Text(tostring(Vectors.Camera.dotProduct))
							end
							if Vectors.Camera.convergenceRound then
								ImGui.Text("Forward Convergence:")
								ImGui.Text(tostring(Vectors.Camera.convergenceRound))
							end
							if Vectors.Camera.forwardXDiffAbs then
								ImGui.Text("Forward X Difference (Absolute):")
								ImGui.Text(tostring(Vectors.Camera.forwardXDiffAbs))
							end
							if Vectors.Camera.Forward.z then
								ImGui.Text("Forward Z:")
								ImGui.Text(tostring(Vectors.Camera.Forward.z))
							end
							ImGui.Separator()
							if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
								ImGui.Text("Vehicles HED Mask Size:")
								ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
								ImGui.SameLine()
								ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
							end
							ImGui.Separator()
							if Vectors.VehMasks.AnchorPoint.y then
								ImGui.Text("Masks' Anchor Point Y:")
								ImGui.Text(tostring(Vectors.VehMasks.AnchorPoint.y))
							end
							ImGui.Separator()
							if Vectors.VehMasks.Mask1.ScreenSpace.x then
								ImGui.Text("Mask1 Screen Space Coordinates:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.ScreenSpace.x))
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.ScreenSpace.y))
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.visible))
								ImGui.Text("Current Size Multiplier:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.multiplyFactor))
								ImGui.Text("Size X:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.x))
								ImGui.Text("Size Y:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.y))
							end
							ImGui.Separator()
							if Vectors.VehMasks.Mask2.ScreenSpace.x then
								ImGui.Text("Mask2 Screen Space Coordinates:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.ScreenSpace.x))
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.ScreenSpace.y))
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.visible))
								ImGui.Text("Current Size Multiplier:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.multiplyFactor))
								ImGui.Text("Size X:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.x))
								ImGui.Text("Size Y:")
								ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.y))
							end
							ImGui.PopStyleColor()
						ImGui.EndTabItem()
						end
						if ImGui.BeginTabItem("Vector Data") then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							if Vectors.Camera.dotProduct then
								ImGui.Text("Dot Product:")
								ImGui.Text(tostring(Vectors.Camera.dotProduct))
							end
							if Vectors.Camera.convergenceRound then
								ImGui.Text("Forward Convergence:")
								ImGui.Text(tostring(Vectors.Camera.convergenceRound))
							end
							if Vectors.Camera.forwardXDiffAbs then
								ImGui.Text("Forward X Difference (Absolute):")
								ImGui.Text(tostring(Vectors.Camera.forwardXDiffAbs))
							end
							if Vectors.Camera.Forward.z then
								ImGui.Text("Forward Z:")
								ImGui.Text(tostring(Vectors.Camera.Forward.z))
							end
							ImGui.Separator()
							if Vectors.Camera.Forward then
								ImGui.Text("Camera Forward (x, y, z, w):")
								ImGui.Text(tostring(Vectors.Camera.Forward.x))
								ImGui.Text(tostring(Vectors.Camera.Forward.y))
								ImGui.Text(tostring(Vectors.Camera.Forward.z))
								ImGui.Text(tostring(Vectors.Camera.Forward.w))
							end
							ImGui.Separator()
							if Vectors.Camera.Right then
								ImGui.Text("Camera Right (x, y, z, w):")
								ImGui.Text(tostring(Vectors.Camera.Right.x))
								ImGui.Text(tostring(Vectors.Camera.Right.y))
								ImGui.Text(tostring(Vectors.Camera.Right.z))
								ImGui.Text(tostring(Vectors.Camera.Right.w))
							end
							ImGui.Separator()
							if Vectors.Camera.Up then
								ImGui.Text("Camera Up (x, y, z, w):")
								ImGui.Text(tostring(Vectors.Camera.Up.x))
								ImGui.Text(tostring(Vectors.Camera.Up.y))
								ImGui.Text(tostring(Vectors.Camera.Up.z))
								ImGui.Text(tostring(Vectors.Camera.Up.w))
							end
							ImGui.Separator()
							if Vectors.Vehicle.Forward then
								ImGui.Text("Vehicle Forward (x, y, z, w):")
								ImGui.Text(tostring(Vectors.Vehicle.Forward.x))
								ImGui.Text(tostring(Vectors.Vehicle.Forward.y))
								ImGui.Text(tostring(Vectors.Vehicle.Forward.z))
								ImGui.Text(tostring(Vectors.Vehicle.Forward.w))
							end
							ImGui.PopStyleColor()
						ImGui.EndTabItem()
						end
						if ImGui.BeginTabItem("Other") then
							ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
							if Calculate.FPPOnFoot.cornerDownLeftMargin then
								ImGui.Text("Corner Masks On Foot Margins:")
								ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownLeftMargin))
								ImGui.SameLine()
								ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownRightMargin))
								ImGui.SameLine()
								ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownMarginTop))
								ImGui.SameLine()
							end
							ImGui.Separator()
							ImGui.Text("Is in a Vehicle:")
							if Vectors.Vehicle.isMounted then
								if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
									ImGui.Text("bike")
								elseif Vectors.Vehicle.vehicleType:IsA("vehicleCarBaseObject") then
									ImGui.Text("car")
								else
									ImGui.Text("vehicle")
								end
								ImGui.Text("Is a Driver:")
								ImGui.Text(tostring(Vectors.Vehicle.isDriver))
								if Vectors.Vehicle.activePerspective then
									ImGui.Text("Active Perspective in Vehicles:")
									ImGui.Text(tostring(Vectors.Vehicle.activePerspective))
								end
								ImGui.Text("Has a Weapon in Hand:")
								ImGui.Text(tostring(Vectors.Vehicle.hasWeapon))
								ImGui.PopStyleColor()
							else
								ImGui.Text("false")
							end
						ImGui.EndTabItem()
						end
					end
				ImGui.EndTabBar()
				end
			end
        end
		ImGui.End()
		ImGui.PopStyleVar(1)
	end
end)