local Presets = {
  __VERSION_NUMBER = 484,
  masksController = nil,
  selectedPreset = nil,
  selectedPresetPosition = nil,
  presetsFile = {},
  presetsList = {},
  presetsDesc = {},
  presetsAuth = {},
}

local Config = require("Modules/Config")
local Customize = require("Modules/Customize")
local Vectors = require("Modules/Vectors")

function Presets.SetDefaultPreset()
  if Customize then
    table.insert(Presets.presetsFile, 1, Config.Customize.PresetInfo.file)
    table.insert(Presets.presetsList, 1, Config.Customize.PresetInfo.name)
    table.insert(Presets.presetsDesc, 1, Config.Customize.PresetInfo.description)
    table.insert(Presets.presetsAuth, 1, Config.Customize.PresetInfo.author)

    table.insert(Presets.presetsFile, 2, Config.Default.PresetInfo.file)
    table.insert(Presets.presetsList, 2, Config.Default.PresetInfo.name)
    table.insert(Presets.presetsDesc, 2, Config.Default.PresetInfo.description)
    table.insert(Presets.presetsAuth, 2, Config.Default.PresetInfo.author)
  else
    table.insert(Presets.presetsFile, 1, Config.Default.PresetInfo.file)
    table.insert(Presets.presetsList, 1, Config.Default.PresetInfo.name)
    table.insert(Presets.presetsDesc, 1, Config.Default.PresetInfo.description)
    table.insert(Presets.presetsAuth, 1, Config.Default.PresetInfo.author)
  end

  Presets.selectedPreset = Presets.presetsList[1]

  if Customize then
    Presets.selectedPreset = Presets.presetsList[2]
  end
end

function Presets.GetPresets()
  local presetsDir = dir('Presets')
  local i = 2

  if Customize then
    i = 3
  end

  for _, preset in ipairs(presetsDir) do
    if string.find(preset.name, '%.lua$') then
      table.insert(Presets.presetsFile, i, preset.name)
      i = i + 1
    end
  end
end

function Presets.ListPresets()
  local i = 2

  if Customize then
    i = 3
  end

  for _,preset in pairs(Presets.presetsFile) do
    preset = string.gsub(preset, ".lua", "")
    local presetPath = "Presets/" .. preset
    local Preset = require(presetPath)
    if Preset and Preset.PresetInfo.name then
      table.insert(Presets.presetsList, i, Preset.PresetInfo.name)
      table.insert(Presets.presetsDesc, i, Preset.PresetInfo.description)
      table.insert(Presets.presetsAuth, i, Preset.PresetInfo.author)
      i = i + 1
    end
  end
end

function Presets.PrintPresets()
  for i,preset in pairs(Presets.presetsFile) do
      print(Presets.presetsList[i],Presets.presetsFile[i])
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
  local customizePresetPosition = 0
  local defaultPresetPosition = 1

  if Customize then
    customizePresetPosition = 1
    defaultPresetPosition = 2
  end

  if Presets.presetsFile[Presets.selectedPresetPosition] then
    presetPath = "Presets/" .. Presets.presetsFile[Presets.selectedPresetPosition]
  end

  if Presets.selectedPresetPosition == defaultPresetPosition or Presets.selectedPresetPosition == customizePresetPosition or not presetPath then
    if not presetPath then
      Presets.selectedPreset = "Default"
      Presets.GetPresetInfo()
    end

    local LoadDefault = Config.Default
    Config.MaskingGlobal.enabled = LoadDefault.MaskingGlobal.enabled
    Vectors.VehElements = LoadDefault.Vectors.VehElements
    Vectors.VehMasks.AnchorPoint = LoadDefault.Vectors.VehMasks.AnchorPoint
    Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def
    Vectors.VehMasks.HorizontalEdgeDown.Size.Def = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Size.Def
    Vectors.VehMasks.HorizontalEdgeDown.Visible.Def = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def
    Vectors.VehMasks.Opacity.Def = LoadDefault.Vectors.VehMasks.Opacity.Def
  else
    presetPath = string.gsub(presetPath, ".lua", "")
    local Preset = require(presetPath)

    if Preset.PresetInfo.name then
      if presetPath then
        Config.MaskingGlobal.enabled = Preset.MaskingGlobal.enabled
        Vectors.VehElements = Preset.Vectors.VehElements
        Vectors.VehMasks.AnchorPoint = Preset.Vectors.VehMasks.AnchorPoint
        Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def = Preset.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def
        Vectors.VehMasks.HorizontalEdgeDown.Size.Def = Preset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def
        Vectors.VehMasks.HorizontalEdgeDown.Visible.Def = Preset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def
        Vectors.VehMasks.Opacity.Def = Preset.Vectors.VehMasks.Opacity.Def
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
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPPFar Car
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarCarEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --FPP Car
  Override(masksController, 'OnFrameGenGhostingFixCameraFPPCarEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPP Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --TPPFar Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)

  --FPP Bike
  Override(masksController, 'OnFrameGenGhostingFixCameraFPPBikeEvent', function(self)
    self:OnFrameGenGhostingFixTransformationHEDCorners(hedCornersPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.corners)
    self:OnFrameGenGhostingFixTransformationHEDFill(hedFillPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.value, Vectors.VehMasks.HorizontalEdgeDown.Visible.fill)
    self:OnFrameGenGhostingFixTransformationHEDTracker(hedTrackerPath, new2({X = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y}), new2({X = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y}), Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker, Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker)
    self:OnFrameGenGhostingFixTransformationMask1(mask1Path, new2({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vectors.VehMasks.Mask1.rotation, new2({X = Vectors.VehMasks.Mask1.Shear.x, Y = Vectors.VehMasks.Mask1.Shear.y}), new2({X = Vectors.VehMasks.Mask1.AnchorPoint.x, Y = Vectors.VehMasks.Mask1.AnchorPoint.y}), Vectors.VehMasks.Mask1.opacity, Vectors.VehMasks.Mask1.visible)
    self:OnFrameGenGhostingFixTransformationMask2(mask2Path, new2({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vectors.VehMasks.Mask2.rotation, new2({X = Vectors.VehMasks.Mask2.Shear.x, Y = Vectors.VehMasks.Mask2.Shear.y}), new2({X = Vectors.VehMasks.Mask2.AnchorPoint.x, Y = Vectors.VehMasks.Mask2.AnchorPoint.y}), Vectors.VehMasks.Mask2.opacity, Vectors.VehMasks.Mask2.visible)
    self:OnFrameGenGhostingFixTransformationMask3(mask3Path, new2({X = Vectors.VehMasks.Mask3.ScreenSpace.x, Y = Vectors.VehMasks.Mask3.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask3.Size.x, Y = Vectors.VehMasks.Mask3.Size.y}), Vectors.VehMasks.Mask3.rotation, new2({X = Vectors.VehMasks.Mask3.Shear.x, Y = Vectors.VehMasks.Mask3.Shear.y}), new2({X = Vectors.VehMasks.Mask3.AnchorPoint.x, Y = Vectors.VehMasks.Mask3.AnchorPoint.y}), Vectors.VehMasks.Mask3.opacity, Vectors.VehMasks.Mask3.visible)
    self:OnFrameGenGhostingFixTransformationMask4(mask4Path, new2({X = Vectors.VehMasks.Mask4.ScreenSpace.x, Y = Vectors.VehMasks.Mask4.ScreenSpace.y}), new2({X = Vectors.VehMasks.Mask4.Size.x, Y = Vectors.VehMasks.Mask4.Size.y}), Vectors.VehMasks.Mask4.rotation, new2({X = Vectors.VehMasks.Mask4.Shear.x, Y = Vectors.VehMasks.Mask4.Shear.y}), new2({X = Vectors.VehMasks.Mask4.AnchorPoint.x, Y = Vectors.VehMasks.Mask4.AnchorPoint.y}), Vectors.VehMasks.Mask4.opacity, Vectors.VehMasks.Mask4.visible)
  end)
end

return Presets