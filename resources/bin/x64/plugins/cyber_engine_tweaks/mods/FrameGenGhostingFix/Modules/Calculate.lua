local Calculate = {
  __VERSION_NUMBER = 484,
  Screen = {
    Base = {width = 3840, height = 2160},
    Edge = {
      down = 2160,
      left = 0,
      right = 3840,
    },
    Factor = {width = 1, height = 1},
    Space = {width = 3840, height = 2160},
    width = nil,
    height = nil,
    aspectRatio = 1,
    aspectRatioChange = false,
    screenType = 1,
    screenTypeName = "16:9",
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
  },
}

local Vectors = require("Modules/Vectors")
local ConsoleText = require("Translations/en-us")

function Calculate.CalcAspectRatio()
  local vectorsScreen = Vectors.Screen
  local previousAspectRatio = Calculate.Screen.aspectRatio

  Calculate.Screen.width, Calculate.Screen.height = GetDisplayResolution();
  Calculate.Screen.aspectRatio = Calculate.Screen.width / Calculate.Screen.height

  vectorsScreen.Resolution.width = Calculate.Screen.width
  vectorsScreen.Resolution.height = Calculate.Screen.height
  vectorsScreen.aspectRatio = Calculate.Screen.aspectRatio

  if previousAspectRatio == 1 then return end

  if Calculate.Screen.aspectRatio ~= previousAspectRatio then
    Calculate.Screen.aspectRatioChange = true
    print(ConsoleText.General.modname_log,ConsoleText.General.info_aspectRatioChange)
  end
end

--get the game's aspect ratio
function Calculate.GetAspectRatio()
  local screenAspectRatio = Calculate.Screen.aspectRatio

  if screenAspectRatio <= 1.59 then
    Calculate.Screen.screenType = 5
  elseif screenAspectRatio >= 1.6 and screenAspectRatio <= 1.7 then
    Calculate.Screen.screenType = 2
  elseif screenAspectRatio >= 2.2 and screenAspectRatio <= 3.4 then
    Calculate.Screen.screenType = 3
  elseif screenAspectRatio >= 3.41 then
    Calculate.Screen.screenType = 4
  end
end

function Calculate.NameScreenType()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then
    Calculate.Screen.screenTypeName = "16:9"
  elseif screenType == 2 then
    Calculate.Screen.screenTypeName = "16:10"
  elseif screenType == 3 then
    Calculate.Screen.screenTypeName = "21:9"
  elseif screenType == 4 then
    Calculate.Screen.screenTypeName = "32:9"
  elseif screenType == 5 then
    Calculate.Screen.screenTypeName = "4:3"
  end
end

function Calculate.GetScreenEdges()
  local screenType = Calculate.Screen.screenType
  local vecScreenEdge = Vectors.Screen.Edge

  if screenType == 1 then 
    vecScreenEdge.left = Calculate.Screen.Edge.left
    vecScreenEdge.right = Calculate.Screen.Edge.right
    vecScreenEdge.down = Calculate.Screen.Edge.down
    return
  end

  if screenType == 5 then
    Calculate.Screen.Edge.left = 0
    Calculate.Screen.Edge.right = 3840
    Calculate.Screen.Edge.down = 2640
  elseif screenType == 2 then
    Calculate.Screen.Edge.left = 0
    Calculate.Screen.Edge.right = 3840
    Calculate.Screen.Edge.down = 2280
  elseif screenType == 3 then
    Calculate.Screen.Edge.left = -640
    Calculate.Screen.Edge.right = 4480
    Calculate.Screen.Edge.down = 2160
  elseif screenType == 4 then
    Calculate.Screen.Edge.left = -1920
    Calculate.Screen.Edge.right = 5760
    Calculate.Screen.Edge.down = 2160
  end

  vecScreenEdge.left = Calculate.Screen.Edge.left
  vecScreenEdge.right = Calculate.Screen.Edge.right
  vecScreenEdge.down = Calculate.Screen.Edge.down
end

function Calculate.GetScreenFactors()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then return end

  if screenType == 2 then
    Calculate.Screen.Factor.height = 1.22
    Vectors.Screen.Factor.height = 1.22
  elseif screenType == 3 then
    Calculate.Screen.Factor.width = 1.34
    Vectors.Screen.Factor.width = 1.34
  elseif screenType == 4 then
    Calculate.Screen.Factor.width = 2
    Vectors.Screen.Factor.width = 2
  elseif screenType == 5 then
    Calculate.Screen.Factor.height = 1.06
    Vectors.Screen.Factor.height = 1.06
  end
end

function Calculate.GetScreenSpace()
  local screenBase = Calculate.Screen.Base
  local screenFactor = Calculate.Screen.Factor
  local screenType = Calculate.Screen.screenType
  
  if screenType == 3 then
    Calculate.Screen.Space.width = screenBase.width * screenFactor.width
    Vectors.Screen.Space.width = Calculate.Screen.Space.width
  elseif screenType == 4 then
    Calculate.Screen.Space.width = screenBase.width * screenFactor.width
    Vectors.Screen.Space.width = Calculate.Screen.Space.width
  end
end

function Calculate.SetHED()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then return end

  local vectorsVehHED = Vectors.VehMasks.HorizontalEdgeDown

  if screenType == 5 then
    vectorsVehHED.ScreenSpace.Base.x = 1920
    vectorsVehHED.ScreenSpace.Base.y = 2640
  elseif screenType == 2 then
    vectorsVehHED.ScreenSpace.Base.x = 1920
    vectorsVehHED.ScreenSpace.Base.y = 2400
  elseif screenType == 3 then
    vectorsVehHED.ScreenSpace.Base.x = 1920
    vectorsVehHED.ScreenSpace.Base.y = 2280
  elseif screenType == 4 then
    vectorsVehHED.ScreenSpace.Base.x = 1920
    vectorsVehHED.ScreenSpace.Base.y = 2280
  end

  vectorsVehHED.Size.x = Vectors.ResizeVehHED(vectorsVehHED.Size.Base.x, 1, true)

  Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y = vectorsVehHED.ScreenSpace.Base.y
  Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y = vectorsVehHED.ScreenSpace.Base.y
end

function Calculate.SetCornersMargins()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then return end

  local screenEdge = Calculate.Screen.Edge

  if screenType == 5 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = screenEdge.left
    Calculate.FPPOnFoot.cornerDownRightMargin = screenEdge.right
    Calculate.FPPOnFoot.cornerDownMarginTop = 2440
  elseif screenType == 2 then
    Calculate.FPPOnFoot.cornerDownLeftMargin = screenEdge.left
    Calculate.FPPOnFoot.cornerDownRightMargin = screenEdge.right
    Calculate.FPPOnFoot.cornerDownMarginTop = 2280
  else
    Calculate.FPPOnFoot.cornerDownLeftMargin = screenEdge.left
    Calculate.FPPOnFoot.cornerDownRightMargin = screenEdge.right
    Calculate.FPPOnFoot.cornerDownMarginTop = screenEdge.down
  end
end

function Calculate.SetVignetteOrgMinMax()
  if Calculate.Screen.screenType == 5 then
    Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY = 95
  end
end

function Calculate.SetVignetteOrgSize()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then return end

  Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
  Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080

  if screenType == 5 then
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 3072
  elseif screenType == 2 then
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2880
  elseif screenType == 3 then

    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 6460
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
  elseif screenType == 4 then
    Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 9680
    Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
  end

  -- print("Vignette position and size:",Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx,Calculate.FPPOnFoot.originalVignetteFootMarginTopPx,Calculate.FPPOnFoot.originalVignetteFootSizeXPx,Calculate.FPPOnFoot.originalVignetteFootSizeYPx)
end

function Calculate.SetMaskingAimSize()
  local screenType = Calculate.Screen.screenType

  if screenType == 1 then return end

  if screenType == 5 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 3840
    Calculate.FPPOnFoot.aimFootSizeYPx = 3072
  elseif screenType == 2 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 3840
    Calculate.FPPOnFoot.aimFootSizeYPx = 2640
  elseif screenType == 3 then
    Calculate.FPPOnFoot.aimFootSizeXPx = 5140
    Calculate.FPPOnFoot.aimFootSizeYPx = 2440
  elseif screenType == 4 then
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
  local floor = math.floor

  Calculate.FPPOnFoot.newVignetteFootSizeXPx = Calculate.FPPOnFoot.originalVignetteFootSizeXPx*(Calculate.FPPOnFoot.vignetteFootSizeX/100.0)
  Calculate.FPPOnFoot.newVignetteFootSizeXPx = (floor(Calculate.FPPOnFoot.newVignetteFootSizeXPx+0.5))

  -- print("Vignette Size X",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.newVignetteFootSizeXPx)
end

--calc y size of vignette
function Calculate.VignetteY()
  local floor = math.floor

  Calculate.FPPOnFoot.newVignetteFootSizeYPx = Calculate.FPPOnFoot.originalVignetteFootSizeYPx*(Calculate.FPPOnFoot.vignetteFootSizeY/100.0)
  Calculate.FPPOnFoot.newVignetteFootSizeYPx = (floor(Calculate.FPPOnFoot.newVignetteFootSizeYPx+0.5))

  -- print("Vignette Size Y",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
end

--calc x margin of vignette
function Calculate.VignettePosX()
  local floor = math.floor

  Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx*(Calculate.FPPOnFoot.vignetteFootMarginLeft/100.0)
  Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = (floor(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx+0.5))

  -- print("Vignette Pos X",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.newVignetteFootMarginLeftPx)
end

--calc y margin of vignette
function Calculate.VignettePosY()
  local floor = math.floor

  Calculate.FPPOnFoot.newVignetteFootMarginTopPx = Calculate.FPPOnFoot.originalVignetteFootMarginTopPx*(Calculate.FPPOnFoot.vignetteFootMarginTop/100.0)
  Calculate.FPPOnFoot.newVignetteFootMarginTopPx = (floor(Calculate.FPPOnFoot.newVignetteFootMarginTopPx+0.5))

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