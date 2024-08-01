local VectorsCustomize = {
  __NAME = "VectorsCustomize",
  __VERSION = { 5, 0, 0 },
}

local MaskingGlobal = {
  masksController = nil
}

local CustomizeData = {
  Bike = {
    AllMasks = {
      FPP = { visible = true },
      TPP = { visible = true }
    },
    Windshield = {
      Scale = {x = 100, y = 100},
    },
  },
  Car = {
    FrontMask = {
      visible = true,
    },
    RearMask = {
      visible = true,
    },
    SideMasks = {
      Scale = {x = 100, y = 100},
      visible = true,
    },
  }
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")

local Vectors = require("Modules/Vectors")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
local VehiclesText = Localization.GetVehiclesText()

----------------------------------------------------------------------------------------------------------------------
-- Vectors Masks Data
----------------------------------------------------------------------------------------------------------------------

local VehMasks = Vectors.GetVehMasksData()

local mask

----------------------------------------------------------------------------------------------------------------------
-- User Settings
----------------------------------------------------------------------------------------------------------------------

function VectorsCustomize.GetMasksController()
  return MaskingGlobal.masksController
end

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
        Scale = Vectors.GetScaleBikeWindshield()
      }
    }
  }

  return UserSettings
end

function VectorsCustomize.LoadUserSettings(userSettings)
  if not userSettings or userSettings == nil then return end

  Vectors.SetScaleBikeWindshield("x", UserSettings.Bike.Windshield.Scale.y)
  Vectors.SetScaleBikeWindshield("x", UserSettings.Bike.Windshield.Scale.y)
end

function VectorsCustomize.SaveUserSettings()
  Settings.WriteUserSettings("VehiclesCustomize", VectorsCustomize.GetUserSettings())
end

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

function VectorsCustomize.OnInitialize()
  UserSettings = Globals.MergeTables(UserSettings, Settings.GetUserSettings("VehiclesCustomize"))
  VectorsCustomize.ApplyMasksController()
  VectorsCustomize.LoadUserSettings()

  Observe('hudCarController', 'OnMountingEvent', function()
    VectorsCustomize.GetUserSettings()
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
  MaskingGlobal.masksController = Globals.GetMasksController()
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

----------------------------------------------------------------------------------------------------------------------
-- Toggle RedScript Methods
----------------------------------------------------------------------------------------------------------------------

function VectorsCustomize.TurnOnLiveViewMaskEditor1()
  local masksController = VectorsCustomize.MaskingGlobal.masksController

  if Vectors and masksController then
    Override(masksController, 'OnFrameGenGhostingFixMaskEditor1Event', function(self)
      local mask = Vectors.VehMasks.MaskEditor1
      local maskPath = CName.new(mask.maskPath)

      self:FrameGenGhostingFixSetTransformation(maskPath, Vector2.new({X = mask.ScreenSpace.x, Y = mask.ScreenSpace.y}), Vector2.new({X = mask.Size.x, Y = mask.Size.y}), mask.rotation, Vector2.new({X = 0, Y = 0}), Vector2.new({X = 0.5, Y = 0.5}), 0.8, true)
    end)
  end
end

function VectorsCustomize.TurnOffLiveViewMaskEditor1()
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

  ImGuiExt.Text(GeneralText.title_fps90)
  ImGui.Separator()

  if Vectors then
    if not vehicle.isMoving and vehicle.vehicleBaseObject == 0 and camera.activePerspective == vehicleCameraPerspective.FPP then
      ImGui.Text("")
      ImGuiExt.Text(VehiclesText.Windshield.textfield_1)
      ImGui.Text("")
      ImGuiExt.Text(VehiclesText.Windshield.setting_1)

      CustomizeData.Bike.Windshield.Scale.x, windshieldScaleToggle.x = ImGui.SliderFloat("##ScaleX", CustomizeData.Bike.Windshield.Scale.x, 70, 150, "%.0f")
      if windshieldScaleToggle.x then
        VectorsCustomize.TurnOnLiveViewMaskEditor1()
      end

      ImGuiExt.Text(VehiclesText.Windshield.setting_2)

      CustomizeData.Bike.Windshield.Scale.y, windshieldScaleToggle.y = ImGui.SliderFloat("##ScaleY", CustomizeData.Bike.Windshield.Scale.y, 70, 300, "%.0f")
      if windshieldScaleToggle.y then
        VectorsCustomize.TurnOnLiveViewMaskEditor1()
      end

      ImGui.Text("")

      if ImGui.Button(GeneralText.default, 500, 40) then
        VectorsCustomize.SetWindshieldDefault()

        ImGuiExt.SetStatusBar(GeneralText.settings_default)
      end

      ImGui.Text("")

      if ImGui.Button(GeneralText.settings_load, 500, 40) then
        VectorsCustomize.LoadUserSettings()

        ImGuiExt.SetStatusBar(GeneralText.settings_loaded)
      end

      if ImGui.Button(GeneralText.settings_save, 500, 40) then
        VectorsCustomize.SaveUserSettings()

        ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      end

    else
      ImGuiExt.Text(VehiclesText.Windshield.warning)
    end
  else
    ImGuiExt.Text(GeneralText.info_vectorsMissing)
  end
end

return VectorsCustomize