--FrameGen Ghosting Fix 4.1.4

local Calculate = {
  ScreenDetection = {
  width = nil,
  height = nil,
  aspectratio = 1.78,
    screenType = 1,
  screenTypeName = "16:9"
  },
  FPPBikeWindshield = {
    width = 100,
    height = 100
  },
  FPPOnFoot = {
  VignetteEditor = {
    vignetteMinMarginX = 50,
    vignetteMaxMarginX = 150,
    vignetteMinSizeX = 80,
    vignetteMaxSizeX = 130,
    vignetteMinMarginY = 55,
    vignetteMaxMarginY = 145,
    vignetteMinSizeY = 85,
    vignetteMaxSizeY = 130,
  },
  cornerDownLeftMargin = 0,
  cornerDownRightMargin = 3840,
  cornerDownMarginTop = 2160,
    vignetteFootMarginLeft = 100,
    vignetteFootMarginTop = 80,
    vignetteFootSizeX = 120,
    vignetteFootSizeY = 120,
    originalVignetteFootMarginLeftPx = 1920,
    originalVignetteFootMarginTopPx = 1080,
    originalVignetteFootSizeXPx = 4840,
    originalVignetteFootSizeYPx = 2560,
  newVignetteFootMarginLeftPx = nil,
    newVignetteFootMarginTopPx = nil,
    newVignetteFootSizeXPx = nil,
    newVignetteFootSizeYPx = nil,
  aimFootSizeXPx = 3840,
    aimFootSizeYPx = 2440
  }
}

local Vectors = require("Modules/Vectors")

function Calculate.CalcAspectRatio()
  Calculate.ScreenDetection.width, Calculate.ScreenDetection.height = GetDisplayResolution();
  Calculate.ScreenDetection.aspectratio = Calculate.ScreenDetection.width / Calculate.ScreenDetection.height

  Vectors.Screen.Real.width = Calculate.ScreenDetection.width
  Vectors.Screen.Real.height = Calculate.ScreenDetection.height
  Vectors.Screen.aspectRatio = Calculate.ScreenDetection.aspectratio

end

function Calculate.NameScreenType()
  if Calculate.ScreenDetection.screenType == 1 then
    Calculate.ScreenDetection.screenTypeName = "16:9"
  elseif Calculate.ScreenDetection.screenType == 2 then
    Calculate.ScreenDetection.screenTypeName = "16:10"
  elseif Calculate.ScreenDetection.screenType == 3 then
    Calculate.ScreenDetection.screenTypeName = "21:9"
  elseif Calculate.ScreenDetection.screenType == 4 then
    Calculate.ScreenDetection.screenTypeName = "32:9"
  elseif Calculate.ScreenDetection.screenType == 5 then
    Calculate.ScreenDetection.screenTypeName = "4:3"
  end

end

--get the game's aspect ratio
function Calculate.GetAspectRatio()
  if Calculate.ScreenDetection.aspectratio <= 1.59 then
    Calculate.ScreenDetection.screenType = 5
  elseif Calculate.ScreenDetection.aspectratio >= 1.6 and Calculate.ScreenDetection.aspectratio <= 1.7 then
    Calculate.ScreenDetection.screenType = 2
  elseif Calculate.ScreenDetection.aspectratio >= 2.2 and Calculate.ScreenDetection.aspectratio <= 3.4 then
    Calculate.ScreenDetection.screenType = 3
  elseif Calculate.ScreenDetection.aspectratio >= 3.41 then
    Calculate.ScreenDetection.screenType = 4
  end

end

function Calculate.SetHEDSize()
  if Calculate.ScreenDetection.screenType == 5 then
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.left = 1920
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top = 2640
    Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen = 1
  elseif Calculate.ScreenDetection.screenType == 2 then
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.left = 1920
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top = 2400
    Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen = 1
  elseif Calculate.ScreenDetection.screenType == 3 then
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.left = 1920
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top = 2280
    Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen = 1.34
  elseif Calculate.ScreenDetection.screenType == 4 then
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.left = 1920
    Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top = 2280
    Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen = 2
  end

  Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 1, true)
end

function Calculate.SetCornersMargins()
  if Calculate.ScreenDetection.screenType == 5 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = 0
    Calculate.FPPOnFoot.cornerDownRightMargin = 3840
    Calculate.FPPOnFoot.cornerDownMarginTop = 2440
  elseif Calculate.ScreenDetection.screenType == 2 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = 0
    Calculate.FPPOnFoot.cornerDownRightMargin = 3840
    Calculate.FPPOnFoot.cornerDownMarginTop = 2280
  elseif Calculate.ScreenDetection.screenType == 3 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = -640
    Calculate.FPPOnFoot.cornerDownRightMargin = 4480
    Calculate.FPPOnFoot.cornerDownMarginTop = 2160
  elseif Calculate.ScreenDetection.screenType == 4 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = -1920
    Calculate.FPPOnFoot.cornerDownRightMargin = 5760
    Calculate.FPPOnFoot.cornerDownMarginTop = 2160
  end

end

function Calculate.SetVignetteOrgMinMax()
  if Calculate.ScreenDetection.screenType == 5 then
    Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY = 95
  end

end

function Calculate.SetVignetteOrgSize()
  if Calculate.ScreenDetection.screenType == 5 then
    Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
    Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 3072
  elseif Calculate.ScreenDetection.screenType == 2 then
    Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
    Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2880
  elseif Calculate.ScreenDetection.screenType == 3 then
    Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
    Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 6460
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
  elseif Calculate.ScreenDetection.screenType == 4 then
    Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
    Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 9680
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
  end

  -- print("Vignette position and size:",Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx,Calculate.FPPOnFoot.originalVignetteFootMarginTopPx,Calculate.FPPOnFoot.originalVignetteFootSizeXPx,Calculate.FPPOnFoot.originalVignetteFootSizeYPx)
end

function Calculate.SetMaskingAimSize()
  if Calculate.ScreenDetection.screenType == 5 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 3840
    Calculate.FPPOnFoot.aimFootSizeYPx = 3072
  elseif Calculate.ScreenDetection.screenType == 2 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 3840
    Calculate.FPPOnFoot.aimFootSizeYPx = 2640
  elseif Calculate.ScreenDetection.screenType == 3 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 5140
    Calculate.FPPOnFoot.aimFootSizeYPx = 2440
  elseif Calculate.ScreenDetection.screenType == 4 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 7770
    Calculate.FPPOnFoot.aimFootSizeYPx = 2440
  end

  -- print("Aim size:",Calculate.FPPOnFoot.aimFootSizeXPx,Calculate.FPPOnFoot.aimFootSizeYPx)
end

--calc X margin for vignette
function Calculate.VignetteCalcMarginX()
  local vignetteSizeChangeX = nil
  vignetteSizeChangeX = Calculate.FPPOnFoot.vignetteFootSizeX - Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeX

  Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX = 100 - vignetteSizeChangeX
  Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX = 100 + vignetteSizeChangeX

  if Calculate.FPPOnFoot.vignetteFootMarginLeft < Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX then
    Calculate.FPPOnFoot.vignetteFootMarginLeft = Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX
  end

  if Calculate.FPPOnFoot.vignetteFootMarginLeft > Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX  then
    Calculate.FPPOnFoot.vignetteFootMarginLeft = Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX
  end

  Calculate.VignettePosX()
end

--calc Y margin for vignette
function Calculate.VignetteCalcMarginY()
  local vignetteSizeChangeY = nil
  vignetteSizeChangeY = Calculate.FPPOnFoot.vignetteFootSizeY - Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY

  Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY = 100 - vignetteSizeChangeY
  Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY = 100 + vignetteSizeChangeY

  if Calculate.FPPOnFoot.vignetteFootMarginTop < Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY then
    Calculate.FPPOnFoot.vignetteFootMarginTop = Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY
  end

  if Calculate.FPPOnFoot.vignetteFootMarginTop > Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY  then
    Calculate.FPPOnFoot.vignetteFootMarginTop = Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY
  end

  Calculate.VignettePosY()
end

--calc x size of vignette
function Calculate.VignetteX()
  Calculate.FPPOnFoot.newVignetteFootSizeXPx = Calculate.FPPOnFoot.originalVignetteFootSizeXPx*(Calculate.FPPOnFoot.vignetteFootSizeX/100.0)
  Calculate.FPPOnFoot.newVignetteFootSizeXPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeXPx+0.5))

  -- print("Vignette Size X",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.newVignetteFootSizeXPx)
end

--calc y size of vignette
function Calculate.VignetteY()
  Calculate.FPPOnFoot.newVignetteFootSizeYPx = Calculate.FPPOnFoot.originalVignetteFootSizeYPx*(Calculate.FPPOnFoot.vignetteFootSizeY/100.0)
  Calculate.FPPOnFoot.newVignetteFootSizeYPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeYPx+0.5))

  -- print("Vignette Size Y",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
end

--calc x margin of vignette
function Calculate.VignettePosX()
  Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx*(Calculate.FPPOnFoot.vignetteFootMarginLeft/100.0)
  Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx+0.5))

  -- print("Vignette Pos X",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.newVignetteFootMarginLeftPx)
end

--calc y margin of vignette
function Calculate.VignettePosY()
  Calculate.FPPOnFoot.newVignetteFootMarginTopPx = Calculate.FPPOnFoot.originalVignetteFootMarginTopPx*(Calculate.FPPOnFoot.vignetteFootMarginTop/100.0)
  Calculate.FPPOnFoot.newVignetteFootMarginTopPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginTopPx+0.5))

  -- print("Vignette Pos Y",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.newVignetteFootMarginTopPx)
end

function Calculate.SetVignetteDefault()
  Calculate.FPPOnFoot.vignetteFootMarginLeft = 100
  Calculate.FPPOnFoot.vignetteFootMarginTop = 75
  Calculate.FPPOnFoot.vignetteFootSizeX = 120
  Calculate.FPPOnFoot.vignetteFootSizeY = 120
  Calculate.VignettePosX()
  Calculate.VignettePosY()
  Calculate.VignetteX()
  Calculate.VignetteY()
end

return Calculate