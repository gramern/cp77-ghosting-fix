local Debug = {
  __NAME = "Debug",
  __VERSION = { 5, 0, 0 },
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")

local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

local Presets = require("Modules/Presets")

function Debug.DrawUI()
  if ImGui.BeginTabItem("General Data") then
    ImGui.Separator()
    if Diagnostics and Diagnostics.modscompatibility then
      ImGuiExt.Text("Diagnostics:")
      ImGuiExt.Text("Mods Compatibility")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Diagnostics.modscompatibility))
    elseif Diagnostics and Diagnostics.modscompatibility == nil then
      ImGuiExt.Text("Diagnostics module deactivated")
    else
      ImGuiExt.Text("Diagnostics module not present")
    end

    ImGui.Separator()
    ImGuiExt.Text("Screen Resolution:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.Resolution.width))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.Resolution.height))
    ImGuiExt.Text("Screen Aspect Ratio:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.aspectRatio))
    ImGuiExt.Text("Screen Type:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.typeName))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.type))
    ImGuiExt.Text("Screen Width Factor:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.Factor.width))
    ImGuiExt.Text("Screen Space:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.Space.width))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.Screen.Space.height))
    ImGui.Separator()
    ImGuiExt.Text("Active Camera FOV:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Camera.fov))
    ImGui.Separator()
    ImGuiExt.Text("Is Pre-Game:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(FrameGenGhostingFix.GameState.isPreGame))
    ImGuiExt.Text("Is Game Loaded:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(FrameGenGhostingFix.GameState.isGameLoaded))
    ImGuiExt.Text("Is Game Paused:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(FrameGenGhostingFix.GameState.isGamePaused))
    ImGui.Separator()
    ImGuiExt.Text("Current FPS:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(FrameGenGhostingFix.GameState.currentFps))

    ImGui.Separator()
    ImGuiExt.Text("Masks Controller:")
    
    if Vectors then
      ImGuiExt.Text("For Vectors Module")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.MaskingGlobal.masksController))
    end
    if VectorsCustomize then
      ImGuiExt.Text("For VectorsCustomize Module")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(VectorsCustomize.MaskingGlobal.masksController))
    end
    if Calculate then
      ImGuiExt.Text("For Calculate Module")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.MaskingGlobal.masksController))
    end

    ImGui.Separator()
    ImGuiExt.Text("Is Mod Ready:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Globals.ModState.isReady))

    ImGui.Separator()

    ImGuiExt.Text("Masking enabled:")
    ImGuiExt.Text("For Vectors Module")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.MaskingGlobal.vehicles))

    ImGui.Separator()

    ImGuiExt.Text("Vehicles HED Mask Size:")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
    end

    ImGuiExt.Text("HED Fill Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue then
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue))
    end

    ImGui.Separator()

    ImGuiExt.Text("Masks Paths:")

    if Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath then
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedFillPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.maskPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.maskPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.maskPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.maskPath))
      ImGuiExt.Text(tostring(Vectors.VehMasks.MaskEditor1.maskPath))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Vectors Data") then
    ImGuiExt.Text("Camera Forward:")
    if Vectors.Camera.Forward then
      ImGuiExt.Text("DotProduct Vehicle Forward:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward))
      ImGuiExt.Text("DotProduct Vehicle Forward Absolute:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
      ImGuiExt.Text("DotProduct Vehicle Right:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right))
      ImGuiExt.Text("DotProduct Vehicle Right Absolute:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs))
      ImGuiExt.Text("DotProduct Vehicle Up:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up))
      ImGuiExt.Text("DotProduct Vehicle Up Absolute:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs))
      ImGui.Separator()
      ImGuiExt.Text("Camera Forward Angle:")
      ImGuiExt.Text("Vehicle Forward Horizontal Plane:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
      ImGuiExt.Text("Vehicle Forward Median Plane:")
      ImGuiExt.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane))
      ImGui.Separator()
      ImGuiExt.Text("Camera Forward Z:")
      ImGuiExt.Text(tostring(Vectors.Camera.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Forward then
      ImGuiExt.Text("Camera Forward (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Camera.Forward.x))
      ImGuiExt.Text(tostring(Vectors.Camera.Forward.y))
      ImGuiExt.Text(tostring(Vectors.Camera.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Right then
      ImGuiExt.Text("Camera Right (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Camera.Right.x))
      ImGuiExt.Text(tostring(Vectors.Camera.Right.y))
      ImGuiExt.Text(tostring(Vectors.Camera.Right.z))
    end

    ImGui.Separator()

    if Vectors.Camera.Up then
      ImGuiExt.Text("Camera Up (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Camera.Up.x))
      ImGuiExt.Text(tostring(Vectors.Camera.Up.y))
      ImGuiExt.Text(tostring(Vectors.Camera.Up.z))
    end

    ImGui.Separator()

    if Vectors.Vehicle.Forward then
      ImGuiExt.Text("Vehicle Forward (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Forward.x))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Forward.y))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Forward.z))
    end

    ImGui.Separator()

    if Vectors.Vehicle.Right then
      ImGuiExt.Text("Vehicle Right (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Right.x))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Right.y))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Right.z))
    end

    ImGui.Separator()
    
    if Vectors.Vehicle.Up then
      ImGuiExt.Text("Vehicle Up (x, y, z, w = 0):")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Up.x))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Up.y))
      ImGuiExt.Text(tostring(Vectors.Vehicle.Up.z))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Vehicle Data") then
    ImGuiExt.Text("Is in a Vehicle:")
    ImGui.SameLine()
    if Vectors.Vehicle.isMounted then
      if Vectors.Vehicle.vehicleBaseObject == 0 then
        ImGuiExt.Text("bike")
      elseif Vectors.Vehicle.vehicleBaseObject == 1 then
        ImGuiExt.Text("car")
      elseif Vectors.Vehicle.vehicleBaseObject == 2 then
        ImGuiExt.Text("tank")
      elseif Vectors.Vehicle.vehicleBaseObject == 3 then
        ImGuiExt.Text("AV")
      else
        ImGuiExt.Text("unknown")
      end

      ImGuiExt.Text("Current Vehicle's ID")
      if Vectors.Vehicle.vehicleID then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.vehicleID.value))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicle Current Speed:")
      if Vectors.Vehicle.currentSpeed then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.currentSpeed))
      end

      ImGuiExt.Text("Is Vehicle Moving:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.isMoving))

      ImGui.Separator()

      ImGuiExt.Text("Active Camera Perspective:")
      if Vectors.Camera.activePerspective then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Camera.activePerspective.value))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicle's Position:")
      if Vectors.Vehicle.Position then
        ImGuiExt.Text(tostring(Vectors.Vehicle.Position.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Position.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Position.z))
      end

      ImGui.Separator()

      ImGuiExt.Text("Wheels Positions:")
      if Vectors.Vehicle.Wheel.Position.Back.Left then
        ImGuiExt.Text("Back Left")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.z))
        ImGuiExt.Text("Back Right")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.z))
        ImGuiExt.Text("Front Left")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.z))
        ImGuiExt.Text("Front Right")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.z))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicle's Wheelbase:")
      if Vectors.Vehicle.Wheel.wheelbase then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.wheelbase))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicle Axes Midpoints' Positions:")
      if Vectors.Vehicle.Midpoint.Position.Back then
        ImGuiExt.Text("Back Wheels' Axis")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.z))
        ImGuiExt.Text("Front Wheels' Axis")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.z))
        ImGuiExt.Text("Left Wheels' Axis")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.z))
        ImGuiExt.Text("Right Wheels' Axis")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.z))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicle Bumpers Positions:")
      if Vectors.Vehicle.Bumper.Position.Back then
        ImGuiExt.Text("Back")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.z))
        ImGuiExt.Text("Front")
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.z))
        ImGuiExt.Text("Distance Between Bumpers:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.distance))
        ImGuiExt.Text("Bumpers Offset From Wheels:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.offset))
      end
    else
      ImGuiExt.Text("false")
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Screen Space Data") then

    ImGuiExt.Text("Wheels Screen Space Positions:")
    if Vectors.Vehicle.Wheel.ScreenSpace.Back.Left then
      ImGuiExt.Text("Back Left")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.y))
      ImGuiExt.Text("Back Right")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.y))
      ImGuiExt.Text("Front Left")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.y))
      ImGuiExt.Text("Front Right")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.y))
    end

    if Vectors.Vehicle.Bumper.ScreenSpace.distance then
      ImGui.Separator()
      ImGuiExt.Text("Bumpers Screen Space Distance:")
      ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distance))

      if Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation then
        ImGuiExt.Text("Distance (Longtitude Axis) Rotation:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation))
      end
    end

    ImGui.Separator()

    ImGuiExt.Text("Wheels' Axes Screen Data:")
    if Vectors.Vehicle.Axis.ScreenRotation.back then
      ImGuiExt.Text("Back")
      ImGuiExt.Text("Rotation:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.back))
      ImGuiExt.Text("Length:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.back))
      ImGuiExt.Text("Front")
      ImGuiExt.Text("Rotation:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.front))
      ImGuiExt.Text("Length:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.front))
      ImGuiExt.Text("Left")
      ImGuiExt.Text("Rotation:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.left))
      ImGuiExt.Text("Length:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.left))
      ImGuiExt.Text("Right")
      ImGuiExt.Text("Rotation:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.right))
      ImGuiExt.Text("Length:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.right))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Masks Data") then
    ImGuiExt.Text("Current HED Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.value then
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.value))
    end

    ImGuiExt.Text("Current HED Tracker Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker then
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Opacity.tracker))
    end

    ImGuiExt.Text("HED Fill Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue then
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue))
    end

    ImGuiExt.Text("Current Masks Opacities:")
    if Vectors.VehMasks.Opacity.value then
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Opacity.value))
      ImGuiExt.Text("Mask 1")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.opacity))
      ImGuiExt.Text("Mask 2")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.opacity))
      ImGuiExt.Text("Mask 3")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.opacity))
      ImGuiExt.Text("Mask 4")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.opacity))
    end

    ImGuiExt.Text("Opacity Gain:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.VehMasks.Opacity.Def.gain))

    if Vectors.VehMasks.Opacity.delayTime then
      ImGuiExt.Text("Opacity Transformation Delay Time:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Opacity.delayTime))
      ImGuiExt.Text("Is Opacity Normalized:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Opacity.isNormalized))

      if not Vectors.VehMasks.Opacity.isNormalized then
        ImGuiExt.Text(tostring(Vectors.VehMasks.Opacity.normalizedValue))
      end
    end

    ImGui.Separator()

    ImGuiExt.Text("HED Fill Lock:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock))

    ImGuiExt.Text("HED Tracker Position:")
    if Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker then
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y))
    end

    ImGui.Separator()

    ImGuiExt.Text("Masks Positions:")
    if Vectors.VehMasks.Mask1.Position then
      ImGuiExt.Text("Mask1")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.Position.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.Position.y))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.Position.z))
      ImGuiExt.Text("Mask2")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.Position.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.Position.y))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.Position.z))
      ImGuiExt.Text("Mask3")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.Position.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.Position.y))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.Position.z))
      ImGuiExt.Text("Mask4")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.Position.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.Position.y))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.Position.z))
    end

    ImGui.Separator()

    ImGuiExt.Text("HED Size Lock:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock))

    ImGuiExt.Text("HED Tracker Size (x, y):")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker then
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y))
    end

    ImGui.Separator()

    ImGuiExt.Text("Masks Sizes:")
    if Vectors.VehMasks.Mask1.Size.x then
      ImGuiExt.Text("Mask1 (x, y)")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.Size.x))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask1.Size.y))
      ImGuiExt.Text("Mask2 (x, y)")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.Size.x))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask2.Size.y))
      ImGuiExt.Text("Mask3 (x, y)")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.Size.x))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask3.Size.y))
      ImGuiExt.Text("Mask4 (x, y)")
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.Size.x))
      ImGuiExt.Text(tostring(Vectors.VehMasks.Mask4.Size.y))
    end

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Player Data") then
    ImGuiExt.Text("Player's World Position:")
    if Vectors.PlayerPuppet.Position then
      ImGuiExt.Text(tostring(Vectors.PlayerPuppet.Position.x))
      ImGuiExt.Text(tostring(Vectors.PlayerPuppet.Position.y))
      ImGuiExt.Text(tostring(Vectors.PlayerPuppet.Position.z))
    end

    ImGui.Separator()
    
    ImGuiExt.Text("Is Moving:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.PlayerPuppet.isMoving))
    ImGuiExt.Text("Has a Weapon in Hand:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.PlayerPuppet.isWeapon))
    ImGuiExt.Text("Is Mounted:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Vehicle.isMounted))

    ImGui.Separator()
    -- temporary to check Vectors Shared Data
    ImGuiExt.Text("Vectors Shared Data:")
    ImGuiExt.Text("Is Moving Player:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Shared.isMovingPlayer))
    ImGuiExt.Text("Has a Weapon in Hand:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Shared.isWeaponDrawn))
    ImGuiExt.Text("Is Mounted:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Shared.isMounted))
    ImGuiExt.Text("Is Moving Vehicle:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Shared.isMovingVehicle))
    ImGuiExt.Text("Vehicle' Current Speed:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vectors.Shared.currentSpeed))

    ImGui.EndTabItem()
  end

  if ImGui.BeginTabItem("Calculate Module") then
    ImGuiExt.Text("Corner Masks Screen Space:")
    if Calculate.Corners.ScreenSpace.Left.x then
      ImGuiExt.Text(tostring(Calculate.Corners.ScreenSpace.Left.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.Corners.ScreenSpace.Right.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.Corners.ScreenSpace.Bottom.y))
    end

    ImGui.Separator()

    ImGuiExt.Text("Blocker Size:")
    if Calculate.Blocker.Size.x then
      ImGuiExt.Text(tostring(Calculate.Blocker.Size.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.Blocker.Size.y))
    end

    ImGui.Separator()

    ImGuiExt.Text("Vignette Screen Space:")
    if Calculate.Vignette.ScreenSpace.x then
      ImGuiExt.Text(tostring(Calculate.Vignette.ScreenSpace.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.Vignette.ScreenSpace.y))
    end

    ImGuiExt.Text("Vignette Size:")
    if Calculate.Vignette.ScreenSpace.x then
      ImGuiExt.Text(tostring(Calculate.Vignette.Size.x))
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Calculate.Vignette.Size.y))
    end

    ImGui.EndTabItem()
  end
end

return Debug