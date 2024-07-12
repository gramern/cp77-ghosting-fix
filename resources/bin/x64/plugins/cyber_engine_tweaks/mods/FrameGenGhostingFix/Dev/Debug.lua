local Debug = {
  __NAME = "Debug",
  __VERSION_NUMBER = 500,
}

local Config = require("Modules/Config")
local UI = require("Modules/UI")

local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

function Debug.DrawUI()
  if UI.Std.BeginTabItem("General Data") then
    if Diagnostics and Diagnostics.modscompatibility then
      UI.Ext.TextWhite("Diagnostics:")
      UI.Ext.TextWhite("Mods Compatibility")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Diagnostics.modscompatibility))
    elseif Diagnostics and Diagnostics.modscompatibility == nil then
      UI.Ext.TextWhite("Diagnostics module deactivated")
    else
      UI.Ext.TextWhite("Diagnostics module not present")
    end

    UI.Std.Separator()
    UI.Ext.TextWhite("Screen Resolution:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.Resolution.width))
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.Resolution.height))
    UI.Ext.TextWhite("Screen Aspect Ratio:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.aspectRatio))
    UI.Ext.TextWhite("Screen Type:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.typeName))
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.type))
    UI.Ext.TextWhite("Screen Width Factor:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.Factor.width))
    UI.Ext.TextWhite("Screen Space:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.Space.width))
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.Screen.Space.height))
    UI.Std.Separator()
    UI.Ext.TextWhite("Active Camera FOV:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.Camera.fov))
    UI.Std.Separator()
    UI.Ext.TextWhite("Is Pre-Game:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(FrameGenGhostingFix.GameState.isPreGame))
    UI.Ext.TextWhite("Is Game Loaded:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(FrameGenGhostingFix.GameState.isGameLoaded))
    UI.Ext.TextWhite("Is Game Paused:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(FrameGenGhostingFix.GameState.isGamePaused))
    UI.Std.Separator()
    UI.Ext.TextWhite("Current FPS:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(FrameGenGhostingFix.GameState.currentFps))

    UI.Std.Separator()
    UI.Ext.TextWhite("Masks Controller:")
    
    if Vectors then
      UI.Ext.TextWhite("For Vectors Module")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.MaskingGlobal.masksController))
    end
    if VectorsCustomize then
      UI.Ext.TextWhite("For VectorsCustomize Module")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(VectorsCustomize.MaskingGlobal.masksController))
    end
    if Calculate then
      UI.Ext.TextWhite("For Calculate Module")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.MaskingGlobal.masksController))
    end

    UI.Std.Separator()
    UI.Ext.TextWhite("Is Mod Ready:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Config.ModState.isReady))

    UI.Std.Separator()

    UI.Ext.TextWhite("Masking enabled:")
    UI.Ext.TextWhite("For Vectors Module")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.MaskingGlobal.vehicles))

    UI.Std.Separator()

    UI.Ext.TextWhite("Vehicles HED Mask Size:")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
    end

    UI.Ext.TextWhite("HED Fill Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue then
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Masks Paths:")

    if Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath then
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedFillPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.maskPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.maskPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.maskPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.maskPath))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.MaskEditor1.maskPath))
    end

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Vectors Data") then
    UI.Ext.TextWhite("Camera Forward:")
    if Vectors.Camera.Forward then
      UI.Ext.TextWhite("DotProduct Vehicle Forward:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward))
      UI.Ext.TextWhite("DotProduct Vehicle Forward Absolute:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
      UI.Ext.TextWhite("DotProduct Vehicle Right:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right))
      UI.Ext.TextWhite("DotProduct Vehicle Right Absolute:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs))
      UI.Ext.TextWhite("DotProduct Vehicle Up:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up))
      UI.Ext.TextWhite("DotProduct Vehicle Up Absolute:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs))
      UI.Std.Separator()
      UI.Ext.TextWhite("Camera Forward Angle:")
      UI.Ext.TextWhite("Vehicle Forward Horizontal Plane:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
      UI.Ext.TextWhite("Vehicle Forward Median Plane:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane))
      UI.Std.Separator()
      UI.Ext.TextWhite("Camera Forward Z:")
      UI.Ext.TextWhite(tostring(Vectors.Camera.Forward.z))
    end

    UI.Std.Separator()

    if Vectors.Camera.Forward then
      UI.Ext.TextWhite("Camera Forward (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Camera.Forward.x))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Forward.y))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Forward.z))
    end

    UI.Std.Separator()

    if Vectors.Camera.Right then
      UI.Ext.TextWhite("Camera Right (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Camera.Right.x))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Right.y))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Right.z))
    end

    UI.Std.Separator()

    if Vectors.Camera.Up then
      UI.Ext.TextWhite("Camera Up (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Camera.Up.x))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Up.y))
      UI.Ext.TextWhite(tostring(Vectors.Camera.Up.z))
    end

    UI.Std.Separator()

    if Vectors.Vehicle.Forward then
      UI.Ext.TextWhite("Vehicle Forward (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Forward.x))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Forward.y))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Forward.z))
    end

    UI.Std.Separator()

    if Vectors.Vehicle.Right then
      UI.Ext.TextWhite("Vehicle Right (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Right.x))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Right.y))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Right.z))
    end

    UI.Std.Separator()
    
    if Vectors.Vehicle.Up then
      UI.Ext.TextWhite("Vehicle Up (x, y, z, w = 0):")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Up.x))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Up.y))
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Up.z))
    end

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Vehicle Data") then
    UI.Ext.TextWhite("Is in a Vehicle:")
    UI.Std.SameLine()
    if Vectors.Vehicle.isMounted then
      if Vectors.Vehicle.vehicleBaseObject == 0 then
        UI.Ext.TextWhite("bike")
      elseif Vectors.Vehicle.vehicleBaseObject == 1 then
        UI.Ext.TextWhite("car")
      elseif Vectors.Vehicle.vehicleBaseObject == 2 then
        UI.Ext.TextWhite("tank")
      else
        UI.Ext.TextWhite("vehicle")
      end

      UI.Ext.TextWhite("Current Vehicle's ID")
      if Vectors.Vehicle.vehicleID then
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.vehicleID.value))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Vehicle Current Speed:")
      if Vectors.Vehicle.currentSpeed then
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.currentSpeed))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Active Camera Perspective:")
      if Vectors.Camera.activePerspective then
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Camera.activePerspective.value))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Vehicle's Position:")
      if Vectors.Vehicle.Position then
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Position.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Position.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Position.z))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Wheels Positions:")
      if Vectors.Vehicle.Wheel.Position.Back.Left then
        UI.Ext.TextWhite("Back Left")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.z))
        UI.Ext.TextWhite("Back Right")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.z))
        UI.Ext.TextWhite("Front Left")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.z))
        UI.Ext.TextWhite("Front Right")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.z))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Vehicle's Wheelbase:")
      if Vectors.Vehicle.Wheel.wheelbase then
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.wheelbase))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Vehicle Axes Midpoints' Positions:")
      if Vectors.Vehicle.Midpoint.Position.Back then
        UI.Ext.TextWhite("Back Wheels' Axis")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.z))
        UI.Ext.TextWhite("Front Wheels' Axis")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.z))
        UI.Ext.TextWhite("Left Wheels' Axis")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.z))
        UI.Ext.TextWhite("Right Wheels' Axis")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.z))
      end

      UI.Std.Separator()

      UI.Ext.TextWhite("Vehicle Bumpers Positions:")
      if Vectors.Vehicle.Bumper.Position.Back then
        UI.Ext.TextWhite("Back")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.z))
        UI.Ext.TextWhite("Front")
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.x))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.y))
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.z))
        UI.Ext.TextWhite("Distance Between Bumpers:")
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.distance))
        UI.Ext.TextWhite("Bumpers Offset From Wheels:")
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.offset))
      end
    else
      UI.Ext.TextWhite("false")
    end

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Screen Space Data") then

    UI.Ext.TextWhite("Wheels Screen Space Positions:")
    if Vectors.Vehicle.Wheel.ScreenSpace.Back.Left then
      UI.Ext.TextWhite("Back Left")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.y))
      UI.Ext.TextWhite("Back Right")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.y))
      UI.Ext.TextWhite("Front Left")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.y))
      UI.Ext.TextWhite("Front Right")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.y))
    end

    if Vectors.Vehicle.Bumper.ScreenSpace.distance then
      UI.Std.Separator()
      UI.Ext.TextWhite("Bumpers Screen Space Distance:")
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distance))

      if Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation then
        UI.Ext.TextWhite("Distance (Longtitude Axis) Rotation:")
        UI.Std.SameLine()
        UI.Ext.TextWhite(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation))
      end
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Wheels' Axes Screen Data:")
    if Vectors.Vehicle.Axis.ScreenRotation.back then
      UI.Ext.TextWhite("Back")
      UI.Ext.TextWhite("Rotation:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.back))
      UI.Ext.TextWhite("Length:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.back))
      UI.Ext.TextWhite("Front")
      UI.Ext.TextWhite("Rotation:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.front))
      UI.Ext.TextWhite("Length:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.front))
      UI.Ext.TextWhite("Left")
      UI.Ext.TextWhite("Rotation:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.left))
      UI.Ext.TextWhite("Length:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.left))
      UI.Ext.TextWhite("Right")
      UI.Ext.TextWhite("Rotation:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.right))
      UI.Ext.TextWhite("Length:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.right))
    end

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Masks Data") then
    UI.Ext.TextWhite("Current HED Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.value then
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.value))
    end

    UI.Ext.TextWhite("Current HED Tracker Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker then
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker))
    end

    UI.Ext.TextWhite("HED Fill Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue then
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue))
    end

    UI.Ext.TextWhite("Current Masks Opacities:")
    if Vectors.VehMasks.Opacity.value then
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Opacity.value))
      UI.Ext.TextWhite("Mask 1")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.opacity))
      UI.Ext.TextWhite("Mask 2")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.opacity))
      UI.Ext.TextWhite("Mask 3")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.opacity))
      UI.Ext.TextWhite("Mask 4")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.opacity))
    end

    UI.Ext.TextWhite("Opacity Gain:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.VehMasks.Opacity.Def.gain))

    if Vectors.VehMasks.Opacity.delayTime then
      UI.Ext.TextWhite("Opacity Transformation Delay Time:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Opacity.delayTime))
      UI.Ext.TextWhite("Is Opacity Normalized:")
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Opacity.isNormalized))

      if not Vectors.VehMasks.Opacity.isNormalized then
        UI.Ext.TextWhite(tostring(Vectors.VehMasks.Opacity.normalizedValue))
      end
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("HED Fill Lock:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock))

    UI.Ext.TextWhite("HED Tracker Position:")
    if Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker then
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Masks Positions:")
    if Vectors.VehMasks.Mask1.Position then
      UI.Ext.TextWhite("Mask1")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.y))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.z))
      UI.Ext.TextWhite("Mask2")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.y))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.z))
      UI.Ext.TextWhite("Mask3")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.y))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.z))
      UI.Ext.TextWhite("Mask4")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.y))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.z))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("HED Size Lock:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock))

    UI.Ext.TextWhite("HED Tracker Size (x, y):")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker then
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Masks Sizes:")
    if Vectors.VehMasks.Mask1.Size.x then
      UI.Ext.TextWhite("Mask1 (x, y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Size.x))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Size.y))
      UI.Ext.TextWhite("Mask2 (x, y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Size.x))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Size.y))
      UI.Ext.TextWhite("Mask3 (x, y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Size.x))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Size.y))
      UI.Ext.TextWhite("Mask4 (x, y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Size.x))
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Size.y))
    end

    UI.Ext.TextWhite("Cached Masks Sizes:")
    if Vectors.VehMasks.Mask2.Cache.Size.y then
      UI.Ext.TextWhite("Mask1 (y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask1.Cache.Size.y))
      UI.Ext.TextWhite("Mask2 (y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask2.Cache.Size.y))
      UI.Ext.TextWhite("Mask3 (y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask3.Cache.Size.y))
      UI.Ext.TextWhite("Mask4 (y)")
      UI.Ext.TextWhite(tostring(Vectors.VehMasks.Mask4.Cache.Size.y))
    end

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Player Data") then
    UI.Ext.TextWhite("Is Moving:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.PlayerPuppet.isMoving))
    UI.Ext.TextWhite("Has a Weapon in Hand:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.PlayerPuppet.hasWeapon))
    UI.Ext.TextWhite("Is Mounted:")
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(Vectors.Vehicle.isMounted))

    UI.Std.EndTabItem()
  end

  if UI.Std.BeginTabItem("Calculate Module") then
    UI.Ext.TextWhite("Corner Masks Screen Space:")
    if Calculate.Corners.ScreenSpace.Left.x then
      UI.Ext.TextWhite(tostring(Calculate.Corners.ScreenSpace.Left.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.Corners.ScreenSpace.Right.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.Corners.ScreenSpace.Bottom.y))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Blocker Size:")
    if Calculate.Blocker.Size.x then
      UI.Ext.TextWhite(tostring(Calculate.Blocker.Size.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.Blocker.Size.y))
    end

    UI.Std.Separator()

    UI.Ext.TextWhite("Vignette Screen Space:")
    if Calculate.Vignette.ScreenSpace.x then
      UI.Ext.TextWhite(tostring(Calculate.Vignette.ScreenSpace.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.Vignette.ScreenSpace.y))
    end

    UI.Ext.TextWhite("Vignette Size:")
    if Calculate.Vignette.ScreenSpace.x then
      UI.Ext.TextWhite(tostring(Calculate.Vignette.Size.x))
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(Calculate.Vignette.Size.y))
    end

    UI.Std.EndTabItem()
  end
end

return Debug