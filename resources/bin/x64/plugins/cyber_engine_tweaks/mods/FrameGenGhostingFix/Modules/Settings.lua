local Settings ={ 
   __VERSION_NUMBER = 480,
  appliedOnFoot = false,
  appliedVeh = false,
  enabledFPPOnFoot = false,
  enabledFPPBlockerAimOnFoot = true,
  enabledFPPVignetteAimOnFoot = false,
  enabledFPPVignetteOnFoot = false,
  enabledFPPVignettePermamentOnFoot = false,
  masksController = nil,
  masksControllerReady = nil,
}

local Calculate = require("Modules/Calculate")
local Config = require("Modules/Config")
local UIText = require("Modules/UIText")
local Vectors = require("Modules/Vectors")

function Settings.CheckCrossSetting()
  if Settings.enabledFPPBlockerAimOnFoot then
    Settings.enabledFPPVignetteAimOnFoot = false
  end

  if Settings.enabledFPPVignetteAimOnFoot then
    Settings.enabledFPPBlockerAimOnFoot = false
  end
end

function Settings.ApplySettings()
  Settings.ApplyMaskingGlobal()
  Settings.ApplyCornersOnFoot()
  Settings.ApplyBlockerAimOnFoot()
  Settings.ApplyVignetteAimOnFoot()
  Settings.ApplyVignetteOnFoot()
  Settings.TurnOffLiveViewWindshieldEditor()
  Settings.TurnOffLiveViewVignetteOnFootEditor()
end

function Settings.ApplyMaskingGlobal()
  Vectors.VehMasks.enabled = Config.MaskingGlobal.enabled

  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenFrameGenGhostingFixVehicleToggleEvent', function(self, wrappedMethod)
      local originalFunction = wrappedMethod()

      if Config.MaskingGlobal.enabled then return originalFunction end
      self:FrameGenGhostingFixVehicleToggle(false)
    end)
  end
end

function Settings.LogApplyOnFoot()
  Settings.appliedOnFoot = true

  print(UIText.General.modname_log,UIText.General.settings_saved_onfoot)
end

function Settings.LogResetOnFoot()
  Settings.appliedOnFoot = false
end

function Settings.LogApplyVehicles()
  Settings.appliedVeh = true
end

function Settings.LogResetVehicles()
  Settings.appliedVeh = false
end

function Settings.TurnOnLiveViewWindshieldEditor()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
      local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)

      self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 0.8, true)
    end)
  end
end

function Settings.DefaultLiveViewWindshieldEditor()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
      local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)

      self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 1.0, true)
    end)
  end
end

function Settings.TurnOffLiveViewWindshieldEditor()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
      local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)
      
      self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 0.0, true)
    end)
  end
end

function Settings.ApplyCornersOnFoot()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
      local originalOnFoot = wrappedMethod()

      if not Settings.enabledFPPOnFoot then return originalOnFoot end
      self:FrameGenGhostingFixOnFootToggle(true)
    end)
    Override(Settings.masksController, 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
      self:FrameGenGhostingFixMasksOnFootSetMargins(Calculate.FPPOnFoot.cornerDownLeftMargin, Calculate.FPPOnFoot.cornerDownRightMargin, Calculate.FPPOnFoot.cornerDownMarginTop)
    end)
  end
end

function Settings.ApplyBlockerAimOnFoot()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalBlockerAim = wrappedMethod()

      if not Settings.enabledFPPBlockerAimOnFoot then return originalBlockerAim end
      self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
    end)
    Override(Settings.masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
    end)
  end
end

function Settings.ApplyVignetteAimOnFoot()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignetteAim = wrappedMethod()

      if not Settings.enabledFPPVignetteAimOnFoot then return originalVignetteAim end
      self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
    end)
    Override(Settings.masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
    end)
  end
end

function Settings.ApplyVignetteOnFoot()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignette = wrappedMethod()

      if not Settings.enabledFPPVignetteOnFoot then return originalVignette end
      self:FrameGenGhostingFixVignetteOnFootToggle(true)
    end)
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
      local originalVignetteDimensions = wrappedMethod()

      if not Settings.enabledFPPVignetteOnFoot then return originalVignetteDimensions end
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
    end)
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
      local originalFunction = wrappedMethod()

      if not Settings.enabledFPPVignettePermamentOnFoot then return originalFunction end
      self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
    end)
  end
end

function Settings.TurnOnLiveViewVignetteOnFootEditor()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
      self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
    end)
  end
end

function Settings.TurnOffLiveViewVignetteOnFootEditor()
  if Settings.masksController and Settings.masksControllerReady then
    Override(Settings.masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
      self:FrameGenGhostingFixVignetteOnFootEditorContext(false)
      self:FrameGenGhostingFixVignetteOnFootEditorTurnOff()
      self:FrameGenGhostingFixVignetteOnFootSetDimensions()
    end)
  end
end

return Settings