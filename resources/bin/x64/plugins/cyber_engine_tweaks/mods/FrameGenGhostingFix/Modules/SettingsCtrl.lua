--FrameGen Ghosting Fix 4.8.0xl

local SettingsCtrl ={
  enabledFPPOnFoot = false,
  enabledFPPBlockerAimOnFoot = true,
  enabledFPPVignetteAimOnFoot = false,
  enabledFPPVignetteOnFoot = false,
  enabledFPPVignettePermamentOnFoot = false,
  masksController = "gameuiCrosshairContainerController"
}

local Calculate = require("Modules/Calculate")
local Vectors = require("Modules/Vectors")

function SettingsCtrl.TurnOnLiveViewWindshieldEditor()
  Override(SettingsCtrl.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)

    self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 0.8, true)
  end)
end

function SettingsCtrl.DefaultLiveViewWindshieldEditor()
  Override(SettingsCtrl.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)

    self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 1.0, true)
  end)
end

function SettingsCtrl.TurnOffLiveViewWindshieldEditor()
  Override(SettingsCtrl.masksController, 'OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent', function(self)
    local mask2Path = CName.new(Vectors.VehMasks.Mask2.maskPath)
    
    self:FrameGenGhostingFixSetSimpleTransformation(mask2Path, Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), 0.0, true)
  end)
end

function SettingsCtrl.ApplyMasksOnFoot()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
    local originalOnFoot = wrappedMethod()

    if not SettingsCtrl.enabledFPPOnFoot then return originalOnFoot end
    self:FrameGenGhostingFixOnFootToggle(true)
  end)
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
    self:FrameGenGhostingFixMasksOnFootSetMargins(Calculate.FPPOnFoot.cornerDownLeftMargin, Calculate.FPPOnFoot.cornerDownRightMargin, Calculate.FPPOnFoot.cornerDownMarginTop)
  end)
end

function SettingsCtrl.ApplyBlockerAimOnFoot()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
    local originalBlockerAim = wrappedMethod()

    if not SettingsCtrl.enabledFPPBlockerAimOnFoot then return originalBlockerAim end
    self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
  end)
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
    self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
  end)
end

function SettingsCtrl.ApplyVignetteAimOnFoot()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
    local originalVignetteAim = wrappedMethod()

    if not SettingsCtrl.enabledFPPVignetteAimOnFoot then return originalVignetteAim end
    self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
  end)
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
    self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(Calculate.FPPOnFoot.aimFootSizeXPx, Calculate.FPPOnFoot.aimFootSizeYPx)
  end)
end

function SettingsCtrl.ApplyVignetteOnFoot()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
    local originalVignette = wrappedMethod()

    if not SettingsCtrl.enabledFPPVignetteOnFoot then return originalVignette end
    self:FrameGenGhostingFixVignetteOnFootToggle(true)
  end)
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
    local originalVignetteDimensions = wrappedMethod()

    if not SettingsCtrl.enabledFPPVignetteOnFoot then return originalVignetteDimensions end
    self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
  end)
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
    local originalFunction = wrappedMethod()

    if not SettingsCtrl.enabledFPPVignettePermamentOnFoot then return originalFunction end
    self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
  end)
end

function SettingsCtrl.TurnOnLiveViewVignetteOnFootEditor()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
    self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
    self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx, Calculate.FPPOnFoot.newVignetteFootMarginTopPx, Calculate.FPPOnFoot.newVignetteFootSizeXPx, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
  end)
end

function SettingsCtrl.TurnOffLiveViewVignetteOnFootEditor()
  Override(SettingsCtrl.masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
    self:FrameGenGhostingFixVignetteOnFootEditorContext(false)
    self:FrameGenGhostingFixVignetteOnFootEditorTurnOff()
    self:FrameGenGhostingFixVignetteOnFootSetDimensions()
  end)
end

return SettingsCtrl