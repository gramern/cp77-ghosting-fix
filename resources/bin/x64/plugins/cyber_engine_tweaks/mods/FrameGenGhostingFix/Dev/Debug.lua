local Debug = {
  __VERSION_NUMBER = 481,
  currentFps = 0,
  ironsightController = nil,
  isGamePaused = true,
  isGameLoaded = nil,
  isPreGame = true,
  masksController = nil,
  masksControllerReady = false,
}

local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Presets = require("Modules/Presets")
local Settings = require("Modules/Settings")
local Vectors = require("Modules/Vectors")

local ImGui = ImGui
local ImGuiCol = ImGuiCol

function Debug.DebugUI()
  if ImGui.BeginTabItem("General Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.1
    ImGui.Text("Diagnostics:")
    if Diagnostics then
      ImGui.Text("Mods Compatibility")
      ImGui.SameLine()
      ImGui.Text(tostring(Diagnostics.modscompatibility))
    else
      ImGui.Text("Diagnostics module not present")
    end
    ImGui.Separator()
    ImGui.Text("Screen Resolution:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Resolution.width))
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Resolution.height))
    ImGui.Text("Screen Aspect Ratio:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.aspectRatio))
    ImGui.Text("Active Camera FOV:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Camera.fov))
    ImGui.Text("Screen Aspect Factor:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.widthFactor))
    ImGui.Text("Screen Space:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Space.width))
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Space.height))
    ImGui.Separator()
    ImGui.Text("Is Pre-Game:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isPreGame))
    ImGui.Text("Is Game Loaded:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isGameLoaded))
    ImGui.Text("Is Game Paused:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isGamePaused))
    ImGui.Separator()
    ImGui.Text("Current FPS:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.currentFps))
    ImGui.Separator()
    ImGui.Text("Masks Controller:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.masksController))
    ImGui.Text("For Presets Module")
    ImGui.SameLine()
    ImGui.Text(tostring(Presets.masksController))
    ImGui.Text("For Settings Module")
    ImGui.SameLine()
    ImGui.Text(tostring(Settings.masksController))
    if Debug.ironsightController then
      ImGui.Text("For init.lua")
      ImGui.SameLine()
      ImGui.Text(tostring(Debug.ironsightController))
    end
    ImGui.Separator()
    ImGui.Text("Is Masks Controller Ready:")
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.masksControllerReady))
    ImGui.Text("For Vectors Module")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.masksControllerReady))
    ImGui.Separator()
    ImGui.Text("Masking enabled:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.enabled))
    ImGui.Separator()
    ImGui.Text("Vehicles HED Mask Size:")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
    end
    ImGui.Text("HED Fill/Tracker Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue))
    end
    ImGui.Separator()
    ImGui.Text("On Foot Corner Masks Margins:")
    if Calculate.FPPOnFoot.cornerDownLeftMargin then
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownLeftMargin))
      ImGui.SameLine()
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownRightMargin))
      ImGui.SameLine()
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownMarginTop))
    end
    ImGui.Separator()
    ImGui.Text("Masks Paths:")
    if Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath))
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedFillPath))
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath))
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.maskPath))
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.maskPath))
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.maskPath))
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.maskPath))
      ImGui.Text(tostring(Vectors.VehMasks.MaskEditor.maskPath))
    end
    ImGui.PopStyleColor() --PSC.1
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem("Vectors Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.2
    ImGui.Text("Camera Forward:")
    if Vectors.Camera.Forward then
      ImGui.Text("DotProduct Vehicle Forward:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward))
      ImGui.Text("DotProduct Vehicle Forward Absolute:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
      ImGui.Text("DotProduct Vehicle Right:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right))
      ImGui.Text("DotProduct Vehicle Right Absolute:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs))
      ImGui.Text("DotProduct Vehicle Up:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up))
      ImGui.Text("DotProduct Vehicle Up Absolute:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs))
      ImGui.Separator()
      ImGui.Text("Camera Forward Angle:")
      ImGui.Text("Vehicle Forward Horizontal Plane:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
      ImGui.Text("Vehicle Forward Median Plane:")
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane))
      ImGui.Separator()
      ImGui.Text("Camera Forward Z:")
      ImGui.Text(tostring(Vectors.Camera.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Forward then
      ImGui.Text("Camera Forward (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Camera.Forward.x))
      ImGui.Text(tostring(Vectors.Camera.Forward.y))
      ImGui.Text(tostring(Vectors.Camera.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Right then
      ImGui.Text("Camera Right (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Camera.Right.x))
      ImGui.Text(tostring(Vectors.Camera.Right.y))
      ImGui.Text(tostring(Vectors.Camera.Right.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Up then
      ImGui.Text("Camera Up (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Camera.Up.x))
      ImGui.Text(tostring(Vectors.Camera.Up.y))
      ImGui.Text(tostring(Vectors.Camera.Up.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Forward then
      ImGui.Text("Vehicle Forward (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Vehicle.Forward.x))
      ImGui.Text(tostring(Vectors.Vehicle.Forward.y))
      ImGui.Text(tostring(Vectors.Vehicle.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Right then
      ImGui.Text("Vehicle Right (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Vehicle.Right.x))
      ImGui.Text(tostring(Vectors.Vehicle.Right.y))
      ImGui.Text(tostring(Vectors.Vehicle.Right.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Up then
      ImGui.Text("Vehicle Up (x, y, z, w = 0):")
      ImGui.Text(tostring(Vectors.Vehicle.Up.x))
      ImGui.Text(tostring(Vectors.Vehicle.Up.y))
      ImGui.Text(tostring(Vectors.Vehicle.Up.z))
    end
    ImGui.PopStyleColor() --PSC.2
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem("Vehicle Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.3
    ImGui.Separator()
    ImGui.Text("Is in a Vehicle:")
    ImGui.SameLine()
    if Vectors.Vehicle.isMounted then
      if Vectors.Vehicle.vehicleBaseObject == 0 then
        ImGui.Text("bike")
      elseif Vectors.Vehicle.vehicleBaseObject == 1 then
        ImGui.Text("car")
      elseif Vectors.Vehicle.vehicleBaseObject == 2 then
        ImGui.Text("tank")
      else
        ImGui.Text("vehicle")
      end
      ImGui.Text("Current Vehicle's ID")
      if Vectors.Vehicle.vehicleID then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.vehicleID.value))
      end
      ImGui.Separator()
      ImGui.Text("Vehicle Current Speed:")
      if Vectors.Vehicle.currentSpeed then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.currentSpeed))
      end
      ImGui.Separator()
      ImGui.Text("Active Camera Perspective in Vehicle:")
      if Vectors.Vehicle.activePerspective then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.activePerspective.value))
      end
      ImGui.Separator()
      ImGui.Text("Vehicle's Position:")
      if Vectors.Vehicle.Position then
        ImGui.Text(tostring(Vectors.Vehicle.Position.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Position.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Position.z))
      end
      ImGui.Separator()
      ImGui.Text("Wheels Positions:")
      if Vectors.Vehicle.Wheel.Position.Back.Left then
        ImGui.Text("Back Left")
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.z))
        ImGui.Text("Back Right")
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.z))
        ImGui.Text("Front Left")
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.z))
        ImGui.Text("Front Right")
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.z))
      end
      ImGui.Separator()
      ImGui.Text("Vehicle's Wheelbase:")
      if Vectors.Vehicle.Wheel.wheelbase then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.wheelbase))
      end
      ImGui.Separator()
      ImGui.Text("Vehicle Axes Midpoints' Positions:")
      if Vectors.Vehicle.Midpoint.Position.Back then
        ImGui.Text("Back Wheels' Axis")
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.z))
        ImGui.Text("Front Wheels' Axis")
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.z))
        ImGui.Text("Left Wheels' Axis")
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.z))
        ImGui.Text("Right Wheels' Axis")
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.z))
      end
      ImGui.Separator()
      ImGui.Text("Vehicle Bumpers Positions:")
      if Vectors.Vehicle.Bumper.Position.Back then
        ImGui.Text("Back")
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.z))
        ImGui.Text("Front")
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.z))
        ImGui.Text("Distance Between Bumpers:")
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.distance))
        ImGui.Text("Bumpers Offset From Wheels:")
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.offset))
      end
    else
      ImGui.Text("false")
    end
    ImGui.PopStyleColor() --PSC.3
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem("Screen Space Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.4
    ImGui.Text("Wheels Screen Space Positions:")
    if Vectors.Vehicle.Wheel.ScreenSpace.Back.Left then
      ImGui.Text("Back Left")
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.y))
      ImGui.Text("Back Right")
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.y))
      ImGui.Text("Front Left")
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.y))
      ImGui.Text("Front Right")
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.y))
    end
    if Vectors.Vehicle.Bumper.ScreenSpace.distance then
      ImGui.Separator()
      ImGui.Text("Bumpers Screen Space Distance:")
      ImGui.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distance))
      if Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation then
        ImGui.Text("Distance (Longtitude Axis) Rotation:")
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation))
      end
    end
    ImGui.Separator()
    ImGui.Text("Wheels' Axes Screen Data:")
    if Vectors.Vehicle.Axis.ScreenRotation.back then
      ImGui.Text("Back")
      ImGui.Text("Rotation:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.back))
      ImGui.Text("Length:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.back))
      ImGui.Text("Front")
      ImGui.Text("Rotation:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.front))
      ImGui.Text("Length:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.front))
      ImGui.Text("Left")
      ImGui.Text("Rotation:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.left))
      ImGui.Text("Length:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.left))
      ImGui.Text("Right")
      ImGui.Text("Rotation:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.right))
      ImGui.Text("Length:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.right))
    end
    ImGui.PopStyleColor() --PSC.4
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem("Masks Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.5
    ImGui.Text("Current HED Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.opacity then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.opacity))
    end
    ImGui.Text("Current HED Tracker Opacity:")
    if Vectors.VehMasks.HorizontalEdgeDown.opacityTracker then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.opacityTracker))
    end
    ImGui.Text("HED Fill/Tracker Toggle Value:")
    if Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue))
    end
    ImGui.Text("Current Masks Opacities:")
    if Vectors.VehMasks.Opacity.value then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.value))
      ImGui.Text("Mask 1")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.opacity))
      ImGui.Text("Mask 2")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.opacity))
      ImGui.Text("Mask 3")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.opacity))
      ImGui.Text("Mask 4")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.opacity))
    end
    ImGui.Text("Opacity Gain:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.Opacity.Def.gain))
    if Vectors.VehMasks.Opacity.delayTime then
      ImGui.Text("Opacity Transformation Delay Time:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.delayTime))
      ImGui.Text("Is Opacity Normalized:")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.isNormalized))
      if not Vectors.VehMasks.Opacity.isNormalized then
        ImGui.Text(tostring(Vectors.VehMasks.Opacity.normalizedValue))
      end
    end
    ImGui.Separator()
    ImGui.Text("HED Fill Lock:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.Base.fillLock))
    ImGui.Text("HED Tracker Position:")
    if Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y))
    end
    ImGui.Separator()
    ImGui.Text("Masks Positions:")
    if Vectors.VehMasks.Mask1.Position then
      ImGui.Text("Mask1")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.z))
      ImGui.Text("Mask2")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.z))
      ImGui.Text("Mask3")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.z))
      ImGui.Text("Mask4")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.z))
    end
    ImGui.Separator()
    ImGui.Text("HED Tracker Size (x, y):")
    if Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y))
    end
    ImGui.Separator()
    ImGui.Text("Masks Sizes:")
    if Vectors.VehMasks.Mask1.Size.x then
      ImGui.Text("Mask1 (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.y))
      ImGui.Text("Mask2 (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.y))
      ImGui.Text("Mask3 (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Size.y))
      ImGui.Text("Mask4 (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Size.y))
    end
    ImGui.Text("Cached Masks Sizes:")
    if Vectors.VehMasks.Mask2.Cache.Size.y then
      ImGui.Text("Mask1 (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Cache.Size.y))
      ImGui.Text("Mask2 (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Cache.Size.y))
      ImGui.Text("Mask3 (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Cache.Size.y))
      ImGui.Text("Mask4 (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Cache.Size.y))
    end
    ImGui.PopStyleColor() --PSC.5
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem("Player Data") then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.6
    ImGui.Text("Is Moving:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.PlayerPuppet.isMoving))
    ImGui.Text("Has a Weapon in Hand:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.PlayerPuppet.hasWeapon))
    ImGui.Text("Is Mounted:")
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Vehicle.isMounted))
    ImGui.Separator()
    ImGui.PopStyleColor() --PSC.6
    ImGui.EndTabItem()
  end
end

return Debug