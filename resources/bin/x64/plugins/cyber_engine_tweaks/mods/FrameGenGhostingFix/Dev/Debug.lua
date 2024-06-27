local Debug = {
  __VERSION_NUMBER = 484,
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
local Localization = require("Modules/Localization")

local ImGui = ImGui
local ImGuiCol = ImGuiCol

function Debug.DebugUI()
  local UIText = Localization.UIText

  if ImGui.BeginTabItem(UIText.Debug.General.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.1
    ImGui.Text(UIText.Debug.General.topic_diagnostic)
    if Diagnostics then
      ImGui.Text(UIText.Debug.General.compatibility)
      ImGui.SameLine()
      ImGui.Text(tostring(Diagnostics.modscompatibility))
    else
      ImGui.Text(UIText.Debug.General.missing_diagnostic)
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.screen_resolution)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Resolution.width))
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Resolution.height))
    ImGui.Text(UIText.Debug.General.screen_aspect_ratio)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.aspectRatio))
    ImGui.Text(UIText.Debug.General.camera_fov)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Camera.fov))
    ImGui.Text(UIText.Debug.General.screen_aspect_factor)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.widthFactor))
    ImGui.Text(UIText.Debug.General.screen_space)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Space.width))
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Screen.Space.height))
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.pre_game)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isPreGame))
    ImGui.Text(UIText.Debug.General.loaded_game)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isGameLoaded))
    ImGui.Text(UIText.Debug.General.paused_game)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.isGamePaused))
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.current_fps)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.currentFps))
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.masked_controller)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.masksController))
    ImGui.Text(UIText.Debug.General.module_presets)
    ImGui.SameLine()
    ImGui.Text(tostring(Presets.masksController))
    ImGui.Text(UIText.Debug.General.module_settings)
    ImGui.SameLine()
    ImGui.Text(tostring(Settings.masksController))
    if Debug.ironsightController then
      ImGui.Text(UIText.Debug.General.init_file)
      ImGui.SameLine()
      ImGui.Text(tostring(Debug.ironsightController))
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.masked_controller_ready)
    ImGui.SameLine()
    ImGui.Text(tostring(Debug.masksControllerReady))
    ImGui.Text(UIText.Debug.General.module_vectors)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.masksControllerReady))
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.enabled_masking)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.enabled))
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.vehicle_mask)
    if Vectors.VehMasks.HorizontalEdgeDown.Size.x then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.y))
    end
    ImGui.Text(UIText.Debug.General.hed_toggle_value)
    if Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue))
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.foot_mask)
    if Calculate.FPPOnFoot.cornerDownLeftMargin then
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownLeftMargin))
      ImGui.SameLine()
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownRightMargin))
      ImGui.SameLine()
      ImGui.Text(tostring(Calculate.FPPOnFoot.cornerDownMarginTop))
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.General.mask_path)
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
  if ImGui.BeginTabItem(UIText.Debug.Vector.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.2
    ImGui.Text(UIText.Debug.Vector.camera)
    if Vectors.Camera.Forward then
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward))
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle_absolute)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle_right)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right))
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle_right_absolute)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs))
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle_up)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up))
      ImGui.Text(UIText.Debug.Vector.DotProduct.vehicle_up_absolute)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs))
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vector.camera_angle)
      ImGui.Text(UIText.Debug.Vector.vehicle_forward_horizontal)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
      ImGui.Text(UIText.Debug.Vector.vehicle_forward_median)
      ImGui.Text(tostring(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane))
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vector.camera_forward_z)
      ImGui.Text(tostring(Vectors.Camera.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Forward then
      ImGui.Text(UIText.Debug.Vector.camera_forward_xyz)
      ImGui.Text(tostring(Vectors.Camera.Forward.x))
      ImGui.Text(tostring(Vectors.Camera.Forward.y))
      ImGui.Text(tostring(Vectors.Camera.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Right then
      ImGui.Text(UIText.Debug.Vector.camera_right_xyz)
      ImGui.Text(tostring(Vectors.Camera.Right.x))
      ImGui.Text(tostring(Vectors.Camera.Right.y))
      ImGui.Text(tostring(Vectors.Camera.Right.z))
    end
    ImGui.Separator()
    if Vectors.Camera.Up then
      ImGui.Text(UIText.Debug.Vector.camera_up_xyz)
      ImGui.Text(tostring(Vectors.Camera.Up.x))
      ImGui.Text(tostring(Vectors.Camera.Up.y))
      ImGui.Text(tostring(Vectors.Camera.Up.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Forward then
      ImGui.Text(UIText.Debug.Vector.vehicle_forward_xyz)
      ImGui.Text(tostring(Vectors.Vehicle.Forward.x))
      ImGui.Text(tostring(Vectors.Vehicle.Forward.y))
      ImGui.Text(tostring(Vectors.Vehicle.Forward.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Right then
      ImGui.Text(UIText.Debug.Vector.vehicle_right_xyz)
      ImGui.Text(tostring(Vectors.Vehicle.Right.x))
      ImGui.Text(tostring(Vectors.Vehicle.Right.y))
      ImGui.Text(tostring(Vectors.Vehicle.Right.z))
    end
    ImGui.Separator()
    if Vectors.Vehicle.Up then
      ImGui.Text(UIText.Debug.Vector.vehicle_up_xyz)
      ImGui.Text(tostring(Vectors.Vehicle.Up.x))
      ImGui.Text(tostring(Vectors.Vehicle.Up.y))
      ImGui.Text(tostring(Vectors.Vehicle.Up.z))
    end
    ImGui.PopStyleColor() --PSC.2
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem(UIText.Debug.Vehicle.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.3
    ImGui.Separator()
    ImGui.Text(UIText.Debug.Vehicle.inside)
    ImGui.SameLine()
    if Vectors.Vehicle.isMounted then
      if Vectors.Vehicle.vehicleBaseObject == 0 then
        ImGui.Text(UIText.Debug.Vehicle.Mounted.bike)
      elseif Vectors.Vehicle.vehicleBaseObject == 1 then
        ImGui.Text(UIText.Debug.Vehicle.Mounted.car)
      elseif Vectors.Vehicle.vehicleBaseObject == 2 then
        ImGui.Text(UIText.Debug.Vehicle.Mounted.tank)
      else
        ImGui.Text(UIText.Debug.Vehicle.Mounted.unknown)
      end
      ImGui.Text(UIText.Debug.Vehicle.id)
      if Vectors.Vehicle.vehicleID then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.vehicleID.value))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.speed)
      if Vectors.Vehicle.currentSpeed then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.currentSpeed))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.perspective)
      if Vectors.Vehicle.activePerspective then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.activePerspective.value))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.position)
      if Vectors.Vehicle.Position then
        ImGui.Text(tostring(Vectors.Vehicle.Position.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Position.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Position.z))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.wheels_position)
      if Vectors.Vehicle.Wheel.Position.Back.Left then
        ImGui.Text(UIText.Debug.Vehicle.wheel_bl)
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Left.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_br)
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Back.Right.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_fl)
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Left.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_fr)
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.Position.Front.Right.z))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.wheel_base)
      if Vectors.Vehicle.Wheel.wheelbase then
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Wheel.wheelbase))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.wheel_axes_postion)
      if Vectors.Vehicle.Midpoint.Position.Back then
        ImGui.Text(UIText.Debug.Vehicle.wheel_axis_back)
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Back.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_axes_front)
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Front.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_axis_left)
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Left.z))
        ImGui.Text(UIText.Debug.Vehicle.wheel_axis_right)
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Midpoint.Position.Right.z))
      end
      ImGui.Separator()
      ImGui.Text(UIText.Debug.Vehicle.bumper_position)
      if Vectors.Vehicle.Bumper.Position.Back then
        ImGui.Text(UIText.Debug.Vehicle.bumper_back)
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Back.z))
        ImGui.Text(UIText.Debug.Vehicle.bumper_front)
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.x))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.y))
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.Position.Front.z))
        ImGui.Text(UIText.Debug.Vehicle.bumper_distance)
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.distance))
        ImGui.Text(UIText.Debug.Vehicle.bumper_offset)
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.offset))
      end
    else
      ImGui.Text(UIText.Debug.Vehicle.inside_negative_answer)
    end
    ImGui.PopStyleColor() --PSC.3
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem(UIText.Debug.ScreenSpace.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.4
    ImGui.Text(UIText.Debug.ScreenSpace.wheels_position)
    if Vectors.Vehicle.Wheel.ScreenSpace.Back.Left then
      ImGui.Text(UIText.Debug.Vehicle.wheel_bl)
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left.y))
      ImGui.Text(UIText.Debug.Vehicle.wheel_br)
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Back.Right.y))
      ImGui.Text(UIText.Debug.Vehicle.wheel_fl)
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left.y))
      ImGui.Text(UIText.Debug.Vehicle.wheel_fr)
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right.y))
    end
    if Vectors.Vehicle.Bumper.ScreenSpace.distance then
      ImGui.Separator()
      ImGui.Text(UIText.Debug.ScreenSpace.bumper_position)
      ImGui.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distance))
      if Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation then
        ImGui.Text(UIText.Debug.ScreenSpace.axis_rotation)
        ImGui.SameLine()
        ImGui.Text(tostring(Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation))
      end
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.ScreenSpace.axes_screen)
    if Vectors.Vehicle.Axis.ScreenRotation.back then
      ImGui.Text(UIText.Debug.back)
      ImGui.Text(UIText.Debug.rotation .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.back))
      ImGui.Text(UIText.Debug.length .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.back))
      ImGui.Text(UIText.Debug.front)
      ImGui.Text(UIText.Debug.rotation .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.front))
      ImGui.Text(UIText.Debug.length .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.front))
      ImGui.Text(UIText.Debug.left)
      ImGui.Text(UIText.Debug.rotation .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.left))
      ImGui.Text(UIText.Debug.length .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.left))
      ImGui.Text(UIText.Debug.right)
      ImGui.Text(UIText.Debug.rotation .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenRotation.right))
      ImGui.Text(UIText.Debug.length .. ":")
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.Vehicle.Axis.ScreenLength.right))
    end
    ImGui.PopStyleColor() --PSC.4
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem(UIText.Debug.Masks.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.5
    ImGui.Text(UIText.Debug.Masks.hed_opacity)
    if Vectors.VehMasks.HorizontalEdgeDown.opacity then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.opacity))
    end
    ImGui.Text(UIText.Debug.Masks.hed_tracker_opacity)
    if Vectors.VehMasks.HorizontalEdgeDown.opacityTracker then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.opacityTracker))
    end
    ImGui.Text(UIText.Debug.General.hed_toggle_value)
    if Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue))
    end
    ImGui.Text(UIText.Debug.Masks.opacity)
    if Vectors.VehMasks.Opacity.value then
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.value))
      ImGui.Text(UIText.Debug.Masks[1])
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.opacity))
      ImGui.Text(UIText.Debug.Masks[2])
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.opacity))
      ImGui.Text(UIText.Debug.Masks[3])
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.opacity))
      ImGui.Text(UIText.Debug.Masks[4])
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.opacity))
    end
    ImGui.Text(UIText.Debug.Masks.opacity_gain)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.Opacity.Def.gain))
    if Vectors.VehMasks.Opacity.delayTime then
      ImGui.Text(UIText.Debug.Masks.opacity_delay)
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.delayTime))
      ImGui.Text(UIText.Debug.Masks.opacity_normal)
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Opacity.isNormalized))
      if not Vectors.VehMasks.Opacity.isNormalized then
        ImGui.Text(tostring(Vectors.VehMasks.Opacity.normalizedValue))
      end
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.Masks.hed_fill)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock))
    ImGui.Text(UIText.Debug.Masks.hed_tracker)
    if Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y))
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.Masks.position)
    if Vectors.VehMasks.Mask1.Position then
      ImGui.Text(UIText.Debug.Masks[1] .. ":")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Position.z))
      ImGui.Text(UIText.Debug.Masks[2] .. ":")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Position.z))
      ImGui.Text(UIText.Debug.Masks[3] .. ":")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Position.z))
      ImGui.Text(UIText.Debug.Masks[4] .. ":")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.y))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Position.z))
    end
    ImGui.Separator()
    ImGui.Text(UIText.Debug.Masks.hed_tracker_size)
    if Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker then
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x))
      ImGui.SameLine()
      ImGui.Text(tostring(Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y))
    end
    ImGui.Separator()
    ImGui.Text()
    if Vectors.VehMasks.Mask1.Size.x then
      ImGui.Text(UIText.Debug.Masks[1] .. " (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Size.y))
      ImGui.Text(UIText.Debug.Masks[2] .. " (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Size.y))
      ImGui.Text(UIText.Debug.Masks[3] .. " (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Size.y))
      ImGui.Text(UIText.Debug.Masks[4] .. " (x, y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Size.x))
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Size.y))
    end
    ImGui.Text()
    if Vectors.VehMasks.Mask2.Cache.Size.y then
      ImGui.Text(UIText.Debug.Masks[1] .. " (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask1.Cache.Size.y))
      ImGui.Text(UIText.Debug.Masks[2] .. " (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask2.Cache.Size.y))
      ImGui.Text(UIText.Debug.Masks[3] .. " (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask3.Cache.Size.y))
      ImGui.Text(UIText.Debug.Masks[4] .. " (y)")
      ImGui.Text(tostring(Vectors.VehMasks.Mask4.Cache.Size.y))
    end
    ImGui.PopStyleColor() --PSC.5
    ImGui.EndTabItem()
  end
  if ImGui.BeginTabItem(UIText.Debug.Player.tabname) then
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.6
    ImGui.Text(UIText.Debug.Player.is_moving)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.PlayerPuppet.isMoving))
    ImGui.Text(UIText.Debug.Player.has_weapon)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.PlayerPuppet.hasWeapon))
    ImGui.Text(UIText.Debug.Player.is_mounted)
    ImGui.SameLine()
    ImGui.Text(tostring(Vectors.Vehicle.isMounted))
    ImGui.Separator()
    ImGui.PopStyleColor() --PSC.6
    ImGui.EndTabItem()
  end
end

return Debug