local VectorsCustomize = {
  __NAME = "VectorsCustomize",
  __VERSION = { 5, 0, 0 },
  MaskingGlobal = {
    masksController = nil,
  },
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")

local LogText = Localization.GetLogText()
local UIText = Localization.GetUIText()

local Vectors = require("Modules/Vectors")

function VectorsCustomize.SetDefault()
  VectorsCustomize.SetWindshieldDefault()
end

function VectorsCustomize.SetWindshieldDefault()
  Vectors.VehMasks.Mask4.Def.Scale.x = 100
  Vectors.VehMasks.Mask4.Def.Scale.y = 100
end

function VectorsCustomize.GetUserSettings()
  UserSettings = {
    Bike = {
      Windshield = {
        Scale = Vectors.VehMasks.Mask4.Def.Scale,
      }
    }
  }

  return UserSettings
end

function VectorsCustomize.LoadUserSettings()
  if UserSettings == nil then return end
  Vectors.VehMasks.Mask4.Def.Scale = Globals.SafeMergeTables(Vectors.VehMasks.Mask4.Def.Scale, UserSettings.Bike.Windshield.Scale)
end

function VectorsCustomize.SaveUserSettings()
  Settings.WriteUserSettings("VectorsCustomize", VectorsCustomize.GetUserSettings())
  VectorsCustomize.LoadUserSettings()
end

function VectorsCustomize.OnInitialize()
  UserSettings = Globals.MergeTables(UserSettings, Settings.GetUserSettings("VectorsCustomize"))
  VectorsCustomize.ApplyMasksController()
  VectorsCustomize.LoadUserSettings()

  Observe('hudCarController', 'OnMountingEvent', function()
    VectorsCustomize.LoadUserSettings()
  end)
end

function VectorsCustomize.OnOverlayOpen()
  VectorsCustomize.ApplyMasksController()
  VectorsCustomize.LoadUserSettings()
end

function VectorsCustomize.OnOverlayClose()
  VectorsCustomize.TurnOffLiveView()
  VectorsCustomize.LoadUserSettings()
end

function VectorsCustomize.ApplyMasksController()
  VectorsCustomize.MaskingGlobal.masksController = Globals.GetMasksController()
end

function VectorsCustomize.UpdateLiveView()
  local activePerspective = Vectors.Camera.activePerspective
  local vehicleBaseObject = Vectors.Vehicle.vehicleBaseObject
  local vehMasks = Vectors.VehMasks
  local maskEditor1 = vehMasks.MaskEditor1
  local maskEditor2 = vehMasks.MaskEditor2

  if vehicleBaseObject == 0 then
    if activePerspective ~= vehicleCameraPerspective.FPP then return end
    maskEditor1.Size = vehMasks.Mask4.Size
    maskEditor1.ScreenSpace = vehMasks.Mask4.ScreenSpace
    maskEditor1.rotation = vehMasks.Mask4.rotation
  end
end

function VectorsCustomize.TurnOnLiveView()
  local masksController = VectorsCustomize.MaskingGlobal.masksController

  if Vectors and masksController then
    Override(masksController, 'OnFrameGenGhostingFixMaskEditor1Event', function(self)
      local mask = Vectors.VehMasks.MaskEditor1
      local maskPath = CName.new(mask.maskPath)

      self:FrameGenGhostingFixSetTransformation(maskPath, Vector2.new({X = mask.ScreenSpace.x, Y = mask.ScreenSpace.y}), Vector2.new({X = mask.Size.x, Y = mask.Size.y}), mask.rotation, Vector2.new({X = 0, Y = 0}), Vector2.new({X = 0.5, Y = 0.5}), 0.8, true)
    end)
  end
end

function VectorsCustomize.DefaultLiveView()
  local masksController = VectorsCustomize.MaskingGlobal.masksController

  if Vectors and masksController then
    Override(masksController, 'OnFrameGenGhostingFixMaskEditor1Event', function(self)
      local mask = Vectors.VehMasks.MaskEditor1
      local maskPath = CName.new(mask.maskPath)

      self:FrameGenGhostingFixSetTransformation(maskPath, Vector2.new({X = mask.ScreenSpace.x, Y = mask.ScreenSpace.y}), Vector2.new({X = mask.Size.x, Y = mask.Size.y}), mask.rotation, Vector2.new({X = 0, Y = 0}), Vector2.new({X = 0.5, Y = 0.5}), 1, true)
    end)
  end
end

function VectorsCustomize.TurnOffLiveView()
  local masksController = VectorsCustomize.MaskingGlobal.masksController

  if Vectors and masksController then
    Override(masksController, 'OnFrameGenGhostingFixMaskEditor1Event', function(self)
      local mask = Vectors.VehMasks.MaskEditor1
      local maskPath = CName.new(mask.maskPath)
      
      self:FrameGenGhostingFixSetTransformation(maskPath, Vector2.new({X = mask.ScreenSpace.x, Y = mask.ScreenSpace.y}), Vector2.new({X = mask.Size.x, Y = mask.Size.y}), mask.rotation, Vector2.new({X = 0, Y = 0}), Vector2.new({X = 0.5, Y = 0.5}), 0.0, false)
    end)
  end
end

--Local UI
local camera = Vectors.Camera
local vehMasks = Vectors.VehMasks
local vehicle = Vectors.Vehicle

local windshieldScaleToggle = {}

function VectorsCustomize.DrawUI()
  VectorsCustomize.UpdateLiveView()

  ImGuiExt.Text(UIText.General.title_fps90)
  ImGui.Separator()

  if Vectors then
    if not vehicle.isMoving and vehicle.vehicleBaseObject == 0 and camera.activePerspective == vehicleCameraPerspective.FPP then
      ImGui.Text("")
      ImGuiExt.Text(UIText.Vehicles.Windshield.textfield_1)
      ImGui.Text("")
      ImGuiExt.Text(UIText.Vehicles.Windshield.setting_1)

      vehMasks.Mask4.Def.Scale.x, windshieldScaleToggle.x = ImGui.SliderFloat("##ScaleX", vehMasks.Mask4.Def.Scale.x, 70, 150, "%.0f")
      if windshieldScaleToggle.x then
        VectorsCustomize.TurnOnLiveView()
      end

      ImGuiExt.Text(UIText.Vehicles.Windshield.setting_2)

      vehMasks.Mask4.Def.Scale.y, windshieldScaleToggle.y = ImGui.SliderFloat("##ScaleY", vehMasks.Mask4.Def.Scale.y, 70, 300, "%.0f")
      if windshieldScaleToggle.y then
        VectorsCustomize.TurnOnLiveView()
      end

      ImGui.Text("")

      if ImGui.Button(UIText.General.default, 500, 40) then
        VectorsCustomize.SetWindshieldDefault()
        VectorsCustomize.DefaultLiveView()

        ImGuiExt.SetStatusBar(UIText.General.settings_default)
      end

      ImGui.Text("")

      if ImGui.Button(UIText.General.settings_load, 500, 40) then
        VectorsCustomize.LoadUserSettings()

        ImGuiExt.SetStatusBar(UIText.General.settings_loaded)
      end

      if ImGui.Button(UIText.General.settings_save, 500, 40) then
        VectorsCustomize.SaveUserSettings()

        ImGuiExt.SetStatusBar(UIText.General.settings_saved)
      end

    else
      ImGuiExt.Text(UIText.Vehicles.Windshield.warning)
    end
  else
    ImGuiExt.Text(UIText.General.info_vectorsMissing)
  end
end

return VectorsCustomize