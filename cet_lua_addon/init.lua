local FrameGenGhostingFix = {
__VERSION     = "FrameGen Ghosting 'Fix' 4.1.4xl",
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
local Presets = require("Modules/Presets")
local UIText = require("Modules/UIText")
local Vectors = require("Modules/Vectors")

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
    file:close()
    local userSettings = json.decode(userSettingsContents)

    enabledWindshieldSettings = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.enabledWindshield or false
    Vectors.VehMasks.Mask1.Scale.x = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.width or Vectors.VehMasks.Mask1.Scale.x
    Vectors.VehMasks.Mask1.Scale.y = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.height or Vectors.VehMasks.Mask1.Scale.y
  

    enabledFPPOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledOnFoot or false
    enabledFPPBlockerAimOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledBlockerAimOnFoot or false
    enabledFPPVignetteAimOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignetteOnFoot or false
    enabledFPPVignetteOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignetteOnFoot or false
    enabledFPPVignettePermamentOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignettePermamentOnFoot or false
    Calculate.FPPOnFoot.vignetteFootMarginLeft = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootMarginLeft or Calculate.FPPOnFoot.vignetteFootMarginLeft
    Calculate.FPPOnFoot.vignetteFootMarginTop = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootMarginTop or Calculate.FPPOnFoot.vignetteFootMarginTop
    Calculate.FPPOnFoot.vignetteFootSizeX = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootSizeX or Calculate.FPPOnFoot.vignetteFootSizeX
    Calculate.FPPOnFoot.vignetteFootSizeY = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootSizeY or Calculate.FPPOnFoot.vignetteFootSizeY

    Presets.selectedPreset = userSettings.Vehicles and userSettings.Vehicles.selectedPreset or Presets.selectedPreset

    if userSettings then
        print(UIText.General.modname_log, UIText.General.settings_loaded)
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

  Override('gameuiCrosshairContainerController', 'FrameGenFrameGenGhostingFixVehicleToggleEvent', function(self, wrappedMethod)
    local originalFunction = wrappedMethod()

    if Config.MaskingInVehiclesGlobal.enabled then return originalFunction end
    self:FrameGenGhostingFixVehicleToggle(false)
  end)
end

function TurnOnLiveViewWindshieldEditor()
  Override('gameuiCrosshairContainerController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.8, false, false, true)
  end)
end

function DefaultLiveViewWindshieldEditor()
  Override('gameuiCrosshairContainerController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.6, false, false, true)
  end)
end

function TurnOffLiveViewWindshieldEditor()
  Override('gameuiCrosshairContainerController', 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), 0.0, 0.0, 0.0, false, false, true)
  end)
end

function ApplyMasksOnFoot()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
    local originalOnFoot = wrappedMethod()

    if not enabledFPPOnFoot then return originalOnFoot end
    self:FrameGenGhostingFixOnFootToggle(true)
  end)
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
    self:FrameGenGhostingFixMasksOnFootSetMargins(Calculate.FPPOnFoot.cornerDownLeftMargin, Calculate.FPPOnFoot.cornerDownRightMargin, Calculate.FPPOnFoot.cornerDownMarginTop)
  end)
end

function ApplyBlockerAimOnFoot()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
    local originalBlockerAim = wrappedMethod()

    if not enabledFPPBlockerAimOnFoot then return originalBlockerAim end
    self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
  end)
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
    self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
  end)
end

function ApplyVignetteAimOnFoot()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
    local originalVignetteAim = wrappedMethod()

    if not enabledFPPVignetteAimOnFoot then return originalVignetteAim end
    self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
  end)
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
    self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
  end)
end

function ApplyVignetteOnFoot()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
    local originalVignette = wrappedMethod()

    if not enabledFPPVignetteOnFoot then return originalVignette end
    self:FrameGenGhostingFixVignetteOnFootToggle(true)
  end)
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
    local originalVignetteDimensions = wrappedMethod()

    if not enabledFPPVignetteOnFoot then return originalVignetteDimensions end
    self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
  end)
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
    local originalFunction = wrappedMethod()

    if not enabledFPPVignettePermamentOnFoot then return originalFunction end
    self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
  end)
end

function TurnOnLiveViewVignetteOnFootEditor()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
    self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
    self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
  end)
end

function TurnOffLiveViewVignetteOnFootEditor()
  Override('gameuiCrosshairContainerController', 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
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
        if ImGui.BeginTabItem(UIText.Vehicles.tabname) then
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.1
          ImGui.Text(UIText.General.title_general)
          ImGui.Separator()
          ImGui.Text(UIText.Vehicles.MaskingPresets.name)
          ImGui.PopStyleColor() --PSC.1
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
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.2
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
          ImGui.PopStyleColor() --PSC.2
          if appliedVeh then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.3
            ImGui.Text("")
            ImGui.Text(UIText.General.settings_applied_veh)
            ImGui.PopStyleColor() --PSC.3
          end
          if Config.MaskingInVehiclesGlobal.enabled then
            ImGui.Text("")
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.4
            ImGui.Text(UIText.General.title_fps90)
            ImGui.Separator()
            enabledWindshieldSettings, windshieldSettingsEnabled = ImGui.Checkbox(UIText.Vehicles.Windshield.name, enabledWindshieldSettings)
            if windshieldSettingsEnabled then
              Vectors.ReadCache()
              SaveUserSettings()
            end
            ImGui.PopStyleColor() --PSC.4
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.Vehicles.Windshield.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
            if enabledWindshieldSettings then
              if Vectors.Vehicle.currentSpeed ~= nil and Vectors.Vehicle.currentSpeed < 1 and Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") and Vectors.Vehicle.activePerspective == vehicleCameraPerspective.FPP then
                ImGui.Text("")
                ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.5
                ImGui.Text(UIText.Vehicles.Windshield.textfield_1)
                ImGui.Text("")
                ImGui.Text(UIText.Vehicles.Windshield.setting_1)
                ImGui.PopStyleColor() --PSC.5
                Vectors.VehMasks.Mask1.Scale.x, windshieldXChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_1,Vectors.VehMasks.Mask1.Scale.x, 100, 150, "%.0f")
                  if windshieldXChanged then
                    Vectors.ResizeBikeWindshieldMask()
                    saved = false
                    SettingsCtrl.TurnOnLiveViewWindshieldEditor()
                  end
                ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.6
                ImGui.Text(UIText.Vehicles.Windshield.setting_2)
                ImGui.PopStyleColor() --PSC.6
                Vectors.VehMasks.Mask1.Scale.y, windshieldYChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_2,Vectors.VehMasks.Mask1.Scale.y, 100, 300, "%.0f")
                  if windshieldYChanged then
                    Vectors.ResizeBikeWindshieldMask()
                    saved = false
                    SettingsCtrl.TurnOnLiveViewWindshieldEditor()
                  end
                ImGui.Text("")
                ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.7
                if saved == true then
                  ImGui.Text(UIText.General.settings_saved)
                end
                ImGui.PopStyleColor() --PSC.7
                if ImGui.Button(UIText.General.settings_default, 240, 40) then
                  saved = false
                  Vectors.SetWindshieldDefault()
                  SettingsCtrl.DefaultLiveViewWindshieldEditor()
                end
                ImGui.SameLine()
                if ImGui.Button(UIText.General.settings_save, 240, 40) then
                  saved = true
                  Vectors.SaveCache()
                  SaveUserSettings()
                end
              else
                ImGui.Text("")
                ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.8
                ImGui.Text(UIText.Vehicles.Windshield.warning)
                ImGui.Text("")
                ImGui.PopStyleColor() --PSC.8
              end
            else
              Vectors.SetWindshieldDefault()
            end
          end
          ImGui.EndTabItem()
        end
        if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.9
          ImGui.Text(UIText.General.title_general)
          ImGui.Separator()
          enabledFPPOnFoot, fppOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BottomCornersMasks.name, enabledFPPOnFoot)
          if fppOnFootEnabled then
            SaveUserSettings()
            SaveUserSettingsOnFootLog()
          end
          ImGui.PopStyleColor()--PSC.9
          if ImGui.IsItemHovered() then
            ImGui.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)
          else
            ImGui.SetTooltip(nil)
          end
          if not enabledFPPVignetteAimOnFoot then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.10
            enabledFPPBlockerAimOnFoot, fppBlockerAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BlockerAim.name, enabledFPPBlockerAimOnFoot)
            if fppBlockerAimOnFootEnabled then
              enabledFPPVignetteAimOnFoot = false
              SaveUserSettings()
              SaveUserSettingsOnFootLog()
            end
            ImGui.PopStyleColor() --PSC.10
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.OnFoot.BlockerAim.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
          else
            ImGui.Separator()
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.11
            ImGui.Text(UIText.General.info_aim_onfoot)
            ImGui.PopStyleColor() --PSC.11
            ImGui.Separator()
          end
          ImGui.Text("")
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.12
          ImGui.Text(UIText.General.title_fps120)
          ImGui.Separator()
          ImGui.PopStyleColor() --PSC.12
          if not enabledFPPBlockerAimOnFoot then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.13
            enabledFPPVignetteAimOnFoot, fppVignetteAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignetteAim.name, enabledFPPVignetteAimOnFoot)
            if fppVignetteAimOnFootEnabled then
              enabledFPPBlockerAimOnFoot = false
              SaveUserSettings()
              SaveUserSettingsOnFootLog()
            end
            ImGui.PopStyleColor() --PSC.13
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
          else
            ImGui.Separator()
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.14
            ImGui.Text(UIText.General.info_aim_onfoot)
            ImGui.PopStyleColor() --PSC.14
            ImGui.Separator()
          end
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.15
          enabledFPPVignetteOnFoot, fppVignetteOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.Vignette.name, enabledFPPVignetteOnFoot)
          if fppVignetteOnFootEnabled then
            SaveUserSettings()
            SaveUserSettingsOnFootLog()
          end
          ImGui.PopStyleColor() --PSC.15
          if ImGui.IsItemHovered() then
            ImGui.SetTooltip(UIText.OnFoot.Vignette.tooltip)
          else
            ImGui.SetTooltip(nil)
          end
          if enabledFPPVignetteOnFoot then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.16
            enabledFPPVignettePermamentOnFoot, fppVignettePermamentOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignettePermament.name, enabledFPPVignettePermamentOnFoot)
            if fppVignettePermamentOnFootEnabled then
              SaveUserSettings()
              SaveUserSettingsOnFootLog()
            end
            ImGui.PopStyleColor() --PSC.16
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.17
            if enabledFPPVignetteAimOnFoot and enabledFPPVignetteOnFoot then
              ImGui.Text("")
              ImGui.Text(UIText.OnFoot.VignetteAim.textfield_1)
            end
            ImGui.Text("")
            ImGui.Text(UIText.OnFoot.Vignette.textfield_1)
            ImGui.Text("")
            ImGui.Text(UIText.OnFoot.Vignette.setting_1)
            ImGui.PopStyleColor() --PSC.17
            Calculate.FPPOnFoot.vignetteFootSizeX, vignetteFootSizeXChanged = ImGui.SliderFloat("X size",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeX, "%.0f")
              if vignetteFootSizeXChanged then
                Calculate.VignetteCalcMarginX()
                Calculate.VignetteX()
                saved = false
                SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
              end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.18
            ImGui.Text(UIText.OnFoot.Vignette.setting_2)
            ImGui.PopStyleColor() --PSC.18
            Calculate.FPPOnFoot.vignetteFootSizeY, vignetteFootSizeYChanged = ImGui.SliderFloat("Y size",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeY, "%.0f")
              if vignetteFootSizeYChanged then
                Calculate.VignetteCalcMarginY()
                Calculate.VignetteY()
                saved = false
                SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
              end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.19
            ImGui.Text(UIText.OnFoot.Vignette.setting_3)
            ImGui.PopStyleColor() --PSC.19
            Calculate.FPPOnFoot.vignetteFootMarginLeft, vignetteFootMarginLeftChanged = ImGui.SliderFloat("X pos.",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX, "%.0f")
              if vignetteFootMarginLeftChanged then
                Calculate.VignetteCalcMarginX()
                Calculate.VignettePosX()
                saved = false
                SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
              end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.20
            ImGui.Text(UIText.OnFoot.Vignette.setting_4)
            ImGui.PopStyleColor() --PSC.20
            Calculate.FPPOnFoot.vignetteFootMarginTop, vignetteFootMarginTopChanged = ImGui.SliderFloat("Y pos.",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY, "%.0f")
              if vignetteFootMarginTopChanged then
                Calculate.VignetteCalcMarginY()
                Calculate.VignettePosY()
                saved = false
                SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
              end
            ImGui.Text("")
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.21
            if saved == true then
              ImGui.Text(UIText.General.settings_saved)
            end
            ImGui.PopStyleColor() --PSC.21
            if ImGui.Button(UIText.General.settings_default, 240, 40) then
              saved = false
              Calculate.SetVignetteDefault()
              SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
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
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.22
            ImGui.Text(UIText.General.settings_saved_onfoot)
            ImGui.PopStyleColor() --PSC.22
          end
          ImGui.EndTabItem()
        end
      ImGui.EndTabBar()
      end
    end
    ImGui.End()
    ImGui.PopStyleColor(26)
    ImGui.PopStyleVar(1)
  end
end)

return FrameGenGhostingFix