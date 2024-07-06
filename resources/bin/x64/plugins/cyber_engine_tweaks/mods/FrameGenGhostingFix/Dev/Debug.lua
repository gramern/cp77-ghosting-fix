local Debug = {
  __NAME = "Debug",
  __VERSION_NUMBER = 490,
}

local Config = require("Modules/Config")
local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Presets = require("Modules/Presets")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiExt = {

  TextWhite = function(string)
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
    ImGui.Text(string)
    ImGui.PopStyleColor()
  end
}

function Debug.DrawUI()
  if ImGui.BeginTabItem("General Data") then
    if Diagnostics and Diagnostics.modscompatibility then
      ImGuiExt.TextWhite("Diagnostics:")
      ImGuiExt.TextWhite("Mods Compatibility")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Diagnostics.modscompatibility))
    elseif Diagnostics and Diagnostics.modscompatibility == nil then
      ImGuiExt.TextWhite("Diagnostics module deactivated")
    else
      ImGuiExt.TextWhite("Diagnostics module not present")
    end

    ImGui.Separator()
    ImGuiExt.TextWhite("Screen Resolution:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.Resolution.width))
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.Resolution.height))
    ImGuiExt.TextWhite("Screen Aspect Ratio:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.aspectRatio))
    ImGuiExt.TextWhite("Screen Type:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.typeName))
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.type))
    ImGuiExt.TextWhite("Screen Width Factor:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.Factor.width))
    ImGuiExt.TextWhite("Screen Space:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.Space.width))
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.Screen.Space.height))
    ImGui.Separator()
    ImGuiExt.TextWhite("Active Camera FOV:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.Camera.fov))
    ImGui.Separator()
    ImGuiExt.TextWhite("Is Pre-Game:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.GameState.isPreGame))
    ImGuiExt.TextWhite("Is Game Loaded:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.GameState.isGameLoaded))
    ImGuiExt.TextWhite("Is Game Paused:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.GameState.isGamePaused))
    ImGui.Separator()
    ImGuiExt.TextWhite("Current FPS:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.GameState.currentFps))

    ImGui.Separator()
    ImGuiExt.TextWhite("Masks Controller:")
    
    if Vectors then
      ImGuiExt.TextWhite("For Vectors Module")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.MaskingGlobal.masksController))
    end
    if VectorsCustomize then
      ImGuiExt.TextWhite("For VectorsCustomize Module")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(VectorsCustomize.MaskingGlobal.masksController))
    end
    if Calculate then
      ImGuiExt.TextWhite("For Calculate Module")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.MaskingGlobal.masksController))
    end

    ImGui.Separator()
    ImGuiExt.TextWhite("Is Mod Ready:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Config.ModState.isReady))

    ImGui.Separator()

    ImGuiExt.TextWhite("Masking enabled:")
    ImGuiExt.TextWhite("For Vectors Module")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.MaskingGlobal.vehicles))

    ImGui.Separator()

    ImGuiExt.TextWhite("Vehicles HED Mask Size:")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
    end

    ImGuiExt.TextWhite("HED Fill/Tracker Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Masks Paths:")

    if Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath then
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedFillPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.maskPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.maskPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.maskPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.maskPath))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.MaskEditor1.maskPath))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Vectors Data") then
    ImGuiExt.TextWhite("Camera Forward:")
    if Vectors.Camera.Forward then
      ImGuiExt.TextWhite("DotProduct Vehicle Forward:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward))
      ImGuiExt.TextWhite("DotProduct Vehicle Forward Absolute:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
      ImGuiExt.TextWhite("DotProduct Vehicle Right:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right))
      ImGuiExt.TextWhite("DotProduct Vehicle Right Absolute:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs))
      ImGuiExt.TextWhite("DotProduct Vehicle Up:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up))
      ImGuiExt.TextWhite("DotProduct Vehicle Up Absolute:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs))
      ImGui.Separator()
      ImGuiExt.TextWhite("Camera Forward Angle:")
      ImGuiExt.TextWhite("Vehicle Forward Horizontal Plane:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
      ImGuiExt.TextWhite("Vehicle Forward Median Plane:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane))
      ImGui.Separator()
      ImGuiExt.TextWhite("Camera Forward Z:")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Forward then
      ImGuiExt.TextWhite("Camera Forward (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Forward.x))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Forward.y))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Right then
      ImGuiExt.TextWhite("Camera Right (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Right.x))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Right.y))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Right.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Up then
      ImGuiExt.TextWhite("Camera Up (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Up.x))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Up.y))
      ImGuiExt.TextWhite(tostring(Vectors.Camera.Up.z))
    end

    ImGui.Separator()

    if Vectors.Vehicle.Forward then
      ImGuiExt.TextWhite("Vehicle Forward (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Forward.x))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Forward.y))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Vehicle.Right then
      ImGuiExt.TextWhite("Vehicle Right (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Right.x))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Right.y))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Right.z))
    end

    ImGui.Separator()
    
    if Vectors.Vehicle.Up then
      ImGuiExt.TextWhite("Vehicle Up (x, y, z, w = 0):")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Up.x))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Up.y))
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Up.z))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Vehicle Data") then
    ImGuiExt.TextWhite("Is in a Vehicle:")
    ImGui.SameLine()
    if Vectors.Vehicle.isMounted then
      if Vectors.Vehicle.vehicleBaseObject == 0 then
        ImGuiExt.TextWhite("bike")
      elseif Vectors.Vehicle.vehicleBaseObject == 1 then
        ImGuiExt.TextWhite("car")
      elseif Vectors.Vehicle.vehicleBaseObject == 2 then
        ImGuiExt.TextWhite("tank")
      else
        ImGuiExt.TextWhite("vehicle")
      end

      ImGuiExt.TextWhite("Current Vehicle's ID")
      if Vectors.Vehicle.vehicleID then
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.vehicleID.value))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Vehicle Current Speed:")
      if Vectors.Vehicle.currentSpeed then
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.currentSpeed))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Active Camera Perspective:")
      if Vectors.Camera.activePerspective then
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Camera.activePerspective.value))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Vehicle's Position:")
      if Vectors.Vehicle.Position then
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Position.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Position.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Position.z))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Wheels Positions:")
      if Vectors.Vehicle.Wheel.Position.Back.Left then
        ImGuiExt.TextWhite("Back Left")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.z))
        ImGuiExt.TextWhite("Back Right")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.z))
        ImGuiExt.TextWhite("Front Left")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.z))
        ImGuiExt.TextWhite("Front Right")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.z))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Vehicle's Wheelbase:")
      if Vectors.Vehicle.Wheel.wheelbase then
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.wheelbase))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Vehicle Axes Midpoints' Positions:")
      if Vectors.Vehicle.Midpoint.Position.Back then
        ImGuiExt.TextWhite("Back Wheels' Axis")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Back.z))
        ImGuiExt.TextWhite("Front Wheels' Axis")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Front.z))
        ImGuiExt.TextWhite("Left Wheels' Axis")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Left.z))
        ImGuiExt.TextWhite("Right Wheels' Axis")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Midpoint.Position.Right.z))
      end

      ImGui.Separator()

      ImGuiExt.TextWhite("Vehicle Bumpers Positions:")
      if Vectors.Vehicle.Bumper.Position.Back then
        ImGuiExt.TextWhite("Back")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Back.z))
        ImGuiExt.TextWhite("Front")
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.x))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.y))
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.Position.Front.z))
        ImGuiExt.TextWhite("Distance Between Bumpers:")
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.distance))
        ImGuiExt.TextWhite("Bumpers Offset From Wheels:")
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.offset))
      end
    else
      ImGuiExt.TextWhite("false")
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Screen Space Data") then

    ImGuiExt.TextWhite("Wheels Screen Space Positions:")
    if Vectors.Vehicle.Wheel.ScreenSpace.Back.Left then
      ImGuiExt.TextWhite("Back Left")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.y))
      ImGuiExt.TextWhite("Back Right")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.y))
      ImGuiExt.TextWhite("Front Left")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.y))
      ImGuiExt.TextWhite("Front Right")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.y))
    end

    if Vectors.Vehicle.Bumper.ScreenSpace.distance then
      ImGui.Separator()
      ImGuiExt.TextWhite("Bumpers Screen Space Distance:")
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distance))

      if Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation then
        ImGuiExt.TextWhite("Distance (Longtitude Axis) Rotation:")
        ImGui.SameLine()
        ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation))
      end
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Wheels' Axes Screen Data:")
    if Vectors.Vehicle.Axis.ScreenRotation.back then
      ImGuiExt.TextWhite("Back")
      ImGuiExt.TextWhite("Rotation:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.back))
      ImGuiExt.TextWhite("Length:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.back))
      ImGuiExt.TextWhite("Front")
      ImGuiExt.TextWhite("Rotation:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.front))
      ImGuiExt.TextWhite("Length:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.front))
      ImGuiExt.TextWhite("Left")
      ImGuiExt.TextWhite("Rotation:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.left))
      ImGuiExt.TextWhite("Length:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.left))
      ImGuiExt.TextWhite("Right")
      ImGuiExt.TextWhite("Rotation:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenRotation.right))
      ImGuiExt.TextWhite("Length:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.Vehicle.Axis.ScreenLength.right))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Masks Data") then
    ImGuiExt.TextWhite("Current HED Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.value then
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.value))
    end

    ImGuiExt.TextWhite("Current HED Tracker Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker then
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker))
    end

    ImGuiExt.TextWhite("HED Fill Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.fillToggleValue then
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue))
    end

    ImGuiExt.TextWhite("Current Masks Opacities:")
    if Vectors.VehMasks.Opacity.value then
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Opacity.value))
      ImGuiExt.TextWhite("Mask 1")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.opacity))
      ImGuiExt.TextWhite("Mask 2")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.opacity))
      ImGuiExt.TextWhite("Mask 3")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.opacity))
      ImGuiExt.TextWhite("Mask 4")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.opacity))
    end

    ImGuiExt.TextWhite("Opacity Gain:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Opacity.Def.gain))

    if Vectors.VehMasks.Opacity.delayTime then
      ImGuiExt.TextWhite("Opacity Transformation Delay Time:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Opacity.delayTime))
      ImGuiExt.TextWhite("Is Opacity Normalized:")
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Opacity.isNormalized))

      if not Vectors.VehMasks.Opacity.isNormalized then
        ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Opacity.normalizedValue))
      end
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("HED Fill Lock:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock))

    ImGuiExt.TextWhite("HED Tracker Position:")
    if Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker then
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Masks Positions:")
    if Vectors.VehMasks.Mask1.Position then
      ImGuiExt.TextWhite("Mask1")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.y))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Position.z))
      ImGuiExt.TextWhite("Mask2")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.y))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Position.z))
      ImGuiExt.TextWhite("Mask3")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.y))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Position.z))
      ImGuiExt.TextWhite("Mask4")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.y))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Position.z))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("HED Size Lock:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock))

    ImGuiExt.TextWhite("HED Tracker Size (x, y):")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker then
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Masks Sizes:")
    if Vectors.VehMasks.Mask1.Size.x then
      ImGuiExt.TextWhite("Mask1 (x, y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Size.x))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Size.y))
      ImGuiExt.TextWhite("Mask2 (x, y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Size.x))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Size.y))
      ImGuiExt.TextWhite("Mask3 (x, y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Size.x))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Size.y))
      ImGuiExt.TextWhite("Mask4 (x, y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Size.x))
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Size.y))
    end

    ImGuiExt.TextWhite("Cached Masks Sizes:")
    if Vectors.VehMasks.Mask2.Cache.Size.y then
      ImGuiExt.TextWhite("Mask1 (y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask1.Cache.Size.y))
      ImGuiExt.TextWhite("Mask2 (y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask2.Cache.Size.y))
      ImGuiExt.TextWhite("Mask3 (y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask3.Cache.Size.y))
      ImGuiExt.TextWhite("Mask4 (y)")
      ImGuiExt.TextWhite(tostring(Vectors.VehMasks.Mask4.Cache.Size.y))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Player Data") then
    ImGuiExt.TextWhite("Is Moving:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.PlayerPuppet.isMoving))
    ImGuiExt.TextWhite("Has a Weapon in Hand:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.PlayerPuppet.hasWeapon))
    ImGuiExt.TextWhite("Is Mounted:")
    ImGui.SameLine()
    ImGuiExt.TextWhite(tostring(Vectors.Vehicle.isMounted))

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Calculate Module") then
    ImGuiExt.TextWhite("Corner Masks Screen Space:")
    if Calculate.Corners.ScreenSpace.Left.x then
      ImGuiExt.TextWhite(tostring(Calculate.Corners.ScreenSpace.Left.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.Corners.ScreenSpace.Right.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.Corners.ScreenSpace.Bottom.y))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Blocker Size:")
    if Calculate.Blocker.Size.x then
      ImGuiExt.TextWhite(tostring(Calculate.Blocker.Size.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.Blocker.Size.y))
    end

    ImGui.Separator()

    ImGuiExt.TextWhite("Vignette Screen Space:")
    if Calculate.Vignette.ScreenSpace.x then
      ImGuiExt.TextWhite(tostring(Calculate.Vignette.ScreenSpace.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.Vignette.ScreenSpace.y))
    end

    ImGuiExt.TextWhite("Vignette Size:")
    if Calculate.Vignette.ScreenSpace.x then
      ImGuiExt.TextWhite(tostring(Calculate.Vignette.Size.x))
      ImGui.SameLine()
      ImGuiExt.TextWhite(tostring(Calculate.Vignette.Size.y))
    end

    ImGui.EndTabItem()
  end
end

return Debug