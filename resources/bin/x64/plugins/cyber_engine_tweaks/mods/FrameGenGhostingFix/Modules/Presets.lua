local Presets = {
  __VERSION_NUMBER = 480,
  isGamePaused = true,
  masksController = nil,
  selectedPreset = nil,
  selectedPresetPosition = nil,
  presetsFile = {},
  presetsList = {},
  presetsDesc = {},
  presetsAuth = {},
}

local Config = require("Modules/Config")
local Vectors = require("Modules/Vectors")

function Presets.GetPresets()
  local presetsDir = dir('Presets')
  local i = 1

  for _, preset in ipairs(presetsDir) do
    if string.find(preset.name, '%.lua$') then
      table.insert(Presets.presetsFile, i, preset.name)
      i = i + 1
    end
  end
end

function Presets.ListPresets()
  Presets.selectedPreset = Presets.presetsList[1]
  Presets.GetPresets()
  local i = 1

  for _,preset in pairs(Presets.presetsFile) do
    preset = string.gsub(preset, ".lua", "")
    local presetPath = "Presets/" .. preset
    local Preset = require(presetPath)
    if Preset.PresetInfo.name then
      i = i + 1
      table.insert(Presets.presetsList, i, Preset.PresetInfo.name)
      table.insert(Presets.presetsDesc, i, Preset.PresetInfo.description)
      table.insert(Presets.presetsAuth, i, Preset.PresetInfo.author)
    end
  end
end

function Presets.GetPresetInfo()
  for i, preset in ipairs(Presets.presetsList) do
    if preset == Presets.selectedPreset then
      Presets.selectedPresetPosition = i
      return i
    end
  end
end

function Presets.LoadPreset()
  local presetPath = nil

  if Presets.presetsFile[Presets.selectedPresetPosition] then
    presetPath = "Presets/" .. Presets.presetsFile[Presets.selectedPresetPosition]
  end

  if Presets.selectedPresetPosition == 1 or not presetPath then
    if not presetPath then
      Presets.selectedPreset = "Default"
      Presets.GetPresetInfo()
    end

    local LoadDefault = Config.Default
    Config.MaskingGlobal.enabled = LoadDefault.MaskingGlobal.enabled
    Vectors.VehElements = LoadDefault.Vectors.VehElements
    Vectors.VehMasks.AnchorPoint = LoadDefault.Vectors.VehMasks.AnchorPoint
    Vectors.VehMasks.HorizontalEdgeDown.opacity = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.opacity
    Vectors.VehMasks.HorizontalEdgeDown.opacityMax = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.opacityMax
    Vectors.VehMasks.HorizontalEdgeDown.Size.Base = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Size.Base
    Vectors.VehMasks.HorizontalEdgeDown.Visible.Base = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Visible.Base
    Vectors.VehMasks.opacity = LoadDefault.Vectors.VehMasks.opacity
    Vectors.VehMasks.opacityMax = LoadDefault.Vectors.VehMasks.opacityMax
  else
    presetPath = string.gsub(presetPath, ".lua", "")
    local Preset = require(presetPath)

    if Preset.PresetInfo.name then
      if presetPath then
        Config.MaskingGlobal.enabled = Preset.MaskingGlobal.enabled
        Vectors.VehElements = Preset.Vectors.VehElements
        Vectors.VehMasks.AnchorPoint = Preset.Vectors.VehMasks.AnchorPoint
        Vectors.VehMasks.HorizontalEdgeDown.opacity = Preset.Vectors.VehMasks.HorizontalEdgeDown.opacity
        Vectors.VehMasks.HorizontalEdgeDown.opacityMax = Preset.Vectors.VehMasks.HorizontalEdgeDown.opacityMax
        Vectors.VehMasks.HorizontalEdgeDown.Size.Base = Preset.Vectors.VehMasks.HorizontalEdgeDown.Size.Base
        Vectors.VehMasks.HorizontalEdgeDown.Visible.Base = Preset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Base
        Vectors.VehMasks.opacity = Preset.Vectors.VehMasks.opacity
        Vectors.VehMasks.opacityMax = Preset.Vectors.VehMasks.opacityMax
      end
    end
  end
end

--self:FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible)

function Presets.ApplyPreset()
  local cname = CName.new
  local new2 = Vector2.new

  local masksController = Presets.masksController

  local hedCornersPath = cname(Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath)
  local hedFillPath = cname(Vectors.VehMasks.HorizontalEdgeDown.hedFillPath)
  local hedTrackerPath = cname(Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath)
  local mask1Path = cname(Vectors.VehMasks.Mask1.maskPath)
  local mask2Path = cname(Vectors.VehMasks.Mask2.maskPath)
  local mask3Path = cname(Vectors.VehMasks.Mask3.maskPath)
  local mask4Path = cname(Vectors.VehMasks.Mask4.maskPath)

  --TPP Car
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPCarEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPPFar Car
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarCarEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --FPP Car
  Override(masksController, 'OnFrameGenGhostingFixCameraFPPCarEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPP Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPPFar Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --FPP Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraFPPBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.opacity, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.opacityTracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)
end

return Presets