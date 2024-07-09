local VectorsCustomize = {
  __NAME = "VectorsCustomize",
  __VERSION_NUMBER = 490,
  MaskingGlobal = {
    masksController = nil,
  },
  Bike = {
    Windshield = {
      Scale = {x = 100, y = 100}
    }
  }
}

local UserSettings = {}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Vectors = require("Modules/Vectors")

local UIText = Localization.UIText

function VectorsCustomize.SetDefault()
  VectorsCustomize.SetWindshieldDefault()
end

function VectorsCustomize.SetWindshieldDefault()
  Vectors.VehMasks.Mask4.Scale.x = 100
  Vectors.VehMasks.Mask4.Scale.y = 100
end

function VectorsCustomize.GetUserSettings()
  UserSettings = {
    Bike = VectorsCustomize.Bike
  }

  return UserSettings
end

function VectorsCustomize.SaveUserSettings()
  Settings.WriteUserSettings("VectorsCustomize",VectorsCustomize.GetUserSettings())
end

function VectorsCustomize.OnInitialize()
  Config.MergeTables(VectorsCustomize,Settings.GetUserSettings("VectorsCustomize"))
  VectorsCustomize.ApplyMasksController()
end

function VectorsCustomize.OnOverlayOpen()
  VectorsCustomize.ApplyMasksController()

  Localization = require("Modules/Localization")
  UIText = Localization.UIText
end

function VectorsCustomize.OnOverlayClose()
  VectorsCustomize.TurnOffLiveView()
end

function VectorsCustomize.ApplyMasksController()
  VectorsCustomize.MaskingGlobal.masksController = Config.GetMasksController()
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

--UI

local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiExt = {
  Checkbox = {
    TextWhite = function(string, setting, toggle)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      setting, toggle = ImGui.Checkbox(string, setting)
      ImGui.PopStyleColor()

      return setting, toggle
    end,
  },
  OnItemHovered = {
    SetTooltip = function(string)
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(string)
      else
        ImGui.SetTooltip(nil)
      end
    end,
  },
  TextWhite = function(string)
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
    ImGui.Text(string)
    ImGui.PopStyleColor()
  end
}

local camera = Vectors.Camera
local vehMasks = Vectors.VehMasks
local vehicle = Vectors.Vehicle

local windshieldScaleToggle = {}

function VectorsCustomize.DrawUI()
  VectorsCustomize.UpdateLiveView()

  ImGuiExt.TextWhite(UIText.General.title_fps90)
  ImGui.Separator()

  if Vectors and Vectors.__VERSION_NUMBER == VectorsCustomize.__VERSION_NUMBER then
    if vehicle.currentSpeed ~= nil and vehicle.currentSpeed < 1 and vehicle.vehicleBaseObject == 0 and camera.activePerspective == vehicleCameraPerspective.FPP then
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Vehicles.Windshield.textfield_1)
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Vehicles.Windshield.setting_1)

      vehMasks.Mask4.Scale.x, windshieldScaleToggle.x = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_1,vehMasks.Mask4.Scale.x, 70, 150, "%.0f")
      if windshieldScaleToggle.x then
        VectorsCustomize.TurnOnLiveView()
      end

      ImGuiExt.TextWhite(UIText.Vehicles.Windshield.setting_2)

      vehMasks.Mask4.Scale.y, windshieldScaleToggle.y = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_2,vehMasks.Mask4.Scale.y, 70, 300, "%.0f")
      if windshieldScaleToggle.y then
        VectorsCustomize.TurnOnLiveView()
      end

      ImGui.Text("")

      if ImGui.Button(UIText.General.default, 240, 40) then
        VectorsCustomize.SetWindshieldDefault()
        VectorsCustomize.DefaultLiveView()
        VectorsCustomize.SaveUserSettings()
      end

      ImGui.SameLine()

      if ImGui.Button(UIText.General.settings_save, 240, 40) then
        Settings.WriteUserSettings()
      end
    else
      ImGuiExt.TextWhite(UIText.Vehicles.Windshield.warning)
    end
  else
    ImGuiExt.TextWhite(UIText.General.info_vectorsMissing)
  end
end

return VectorsCustomize