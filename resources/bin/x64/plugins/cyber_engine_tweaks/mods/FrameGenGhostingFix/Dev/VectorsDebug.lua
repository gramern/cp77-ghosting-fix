local VectorsDebug = {
  __NAME = "VectorsDebug",
  __VERSION = { 5, 0, 0 },
}

local ImGuiExt = require("Modules/ImGuiExt")
local Tracker = require("Modules/Tracker")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

local MaskingGlobalData = Vectors.GetMaskingGlobalData()
local CameraData = Vectors.GetCameraData()
local VehicleData = Vectors.GetVehicleData()
local VehMasksData = Vectors.GetVehMasksData()

function VectorsDebug.DrawUI()
  if Vectors or VectorsCustomize then
    if ImGui.BeginTabItem("Vectors General") then

      ImGuiExt.Text("Masks Controller:")
      
      if Vectors then
        ImGuiExt.Text("For Vectors Module")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(MaskingGlobalData.masksController))
      end
      if VectorsCustomize then
        ImGuiExt.Text("For VectorsCustomize Module")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VectorsCustomize.GetMasksController()))
      end

      ImGui.Separator()

      ImGuiExt.Text("Masking enabled:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(MaskingGlobalData.vehicles))

      ImGui.Separator()

      ImGuiExt.Text("Masks Paths:")

      if VehMasksData.HorizontalEdgeDown.hedCornersPath then
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedCornersPath))
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedFillPath))
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedTrackerPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask1.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask2.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask3.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask4.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.MaskEditor1.maskPath))
      end

      ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Vectors Camera") then

      ImGuiExt.Text("Camera Forward:")
      if CameraData.Forward then
        ImGuiExt.Text("Active Camera FOV:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(CameraData.fov))

        ImGui.Separator()

        ImGuiExt.Text("DotProduct Vehicle Forward:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.forward))
        ImGuiExt.Text("DotProduct Vehicle Forward Absolute:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.forwardAbs))
        ImGuiExt.Text("DotProduct Vehicle Right:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.right))
        ImGuiExt.Text("DotProduct Vehicle Right Absolute:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.rightAbs))
        ImGuiExt.Text("DotProduct Vehicle Up:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.up))
        ImGuiExt.Text("DotProduct Vehicle Up Absolute:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.DotProduct.Vehicle.upAbs))
        ImGui.Separator()
        ImGuiExt.Text("Camera Forward Angle:")
        ImGuiExt.Text("Vehicle Forward Horizontal Plane:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.Angle.Vehicle.Forward.horizontalPlane))
        ImGuiExt.Text("Vehicle Forward Median Plane:")
        ImGuiExt.Text(tostring(CameraData.ForwardTable.Angle.Vehicle.Forward.medianPlane))
        ImGui.Separator()
        ImGuiExt.Text("Camera Forward Z:")
        ImGuiExt.Text(tostring(CameraData.Forward.z))
      end

      ImGui.Separator()

      if CameraData.Forward then
        ImGuiExt.Text("Camera Forward (x, y, z, w = 0):")
        ImGuiExt.Text(tostring(CameraData.Forward.x))
        ImGuiExt.Text(tostring(CameraData.Forward.y))
        ImGuiExt.Text(tostring(CameraData.Forward.z))
      end

      ImGui.Separator()

      if CameraData.Right then
        ImGuiExt.Text("Camera Right (x, y, z, w = 0):")
        ImGuiExt.Text(tostring(CameraData.Right.x))
        ImGuiExt.Text(tostring(CameraData.Right.y))
        ImGuiExt.Text(tostring(CameraData.Right.z))
      end

      ImGui.Separator()

      if CameraData.Up then
        ImGuiExt.Text("Camera Up (x, y, z, w = 0):")
        ImGuiExt.Text(tostring(CameraData.Up.x))
        ImGuiExt.Text(tostring(CameraData.Up.y))
        ImGuiExt.Text(tostring(CameraData.Up.z))
      end

      ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Vectors Vehicle") then

      ImGuiExt.Text("Is in a Vehicle:")
      ImGui.SameLine()
      if Tracker.IsVehicleMounted() then
        if Tracker.GetVehicleBaseObject() == 0 then
          ImGuiExt.Text("bike")
        elseif Tracker.GetVehicleBaseObject() == 1 then
          ImGuiExt.Text("car")
        elseif Tracker.GetVehicleBaseObject() == 2 then
          ImGuiExt.Text("tank")
        elseif Tracker.GetVehicleBaseObject() == 3 then
          ImGuiExt.Text("AV")
        else
          ImGuiExt.Text("unknown")
        end

        ImGuiExt.Text("Current Vehicle's ID")
        if VehicleData.vehicleID then
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.vehicleID.value))
        end

        ImGui.Separator()

        ImGuiExt.Text("Vehicle Current Speed:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Tracker.GetVehicleSpeed()))

        ImGuiExt.Text("Is Vehicle Moving:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(Tracker.IsVehicleMoving()))

        ImGui.Separator()

        ImGuiExt.Text("Active Camera Perspective:")
        if CameraData.activePerspective then
          ImGui.SameLine()
          ImGuiExt.Text(tostring(CameraData.activePerspective.value))
        end

        ImGui.Separator()

        ImGuiExt.Text("Vehicle's Position:")
        if VehicleData.Position then
          ImGuiExt.Text(tostring(VehicleData.Position.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Position.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Position.z))
        end

        ImGui.Separator()

        if VehicleData.Forward then
          ImGuiExt.Text("Vehicle Forward (x, y, z, w = 0):")
          ImGuiExt.Text(tostring(VehicleData.Forward.x))
          ImGuiExt.Text(tostring(VehicleData.Forward.y))
          ImGuiExt.Text(tostring(VehicleData.Forward.z))
        end
  
        ImGui.Separator()
  
        if VehicleData.Right then
          ImGuiExt.Text("Vehicle Right (x, y, z, w = 0):")
          ImGuiExt.Text(tostring(VehicleData.Right.x))
          ImGuiExt.Text(tostring(VehicleData.Right.y))
          ImGuiExt.Text(tostring(VehicleData.Right.z))
        end
  
        ImGui.Separator()
        
        if VehicleData.Up then
          ImGuiExt.Text("Vehicle Up (x, y, z, w = 0):")
          ImGuiExt.Text(tostring(VehicleData.Up.x))
          ImGuiExt.Text(tostring(VehicleData.Up.y))
          ImGuiExt.Text(tostring(VehicleData.Up.z))
        end

        ImGui.Separator()

        ImGuiExt.Text("Wheels Positions:")
        if VehicleData.Wheel.Position.Back.Left then
          ImGuiExt.Text("Back Left")
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Left.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Left.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Left.z))
          ImGuiExt.Text("Back Right")
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Right.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Right.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Back.Right.z))
          ImGuiExt.Text("Front Left")
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Left.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Left.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Left.z))
          ImGuiExt.Text("Front Right")
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Right.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Right.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.Position.Front.Right.z))
        end

        ImGui.Separator()

        ImGuiExt.Text("Vehicle's Wheelbase:")
        if VehicleData.Wheel.wheelbase then
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Wheel.wheelbase))
        end

        ImGui.Separator()

        ImGuiExt.Text("Vehicle Axes Midpoints' Positions:")
        if VehicleData.Midpoint.Position.Back then
          ImGuiExt.Text("Back Wheels' Axis")
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Back.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Back.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Back.z))
          ImGuiExt.Text("Front Wheels' Axis")
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Front.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Front.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Front.z))
          ImGuiExt.Text("Left Wheels' Axis")
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Left.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Left.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Left.z))
          ImGuiExt.Text("Right Wheels' Axis")
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Right.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Right.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Midpoint.Position.Right.z))
        end

        ImGui.Separator()

        ImGuiExt.Text("Vehicle Bumpers Positions:")
        if VehicleData.Bumper.Position.Back then
          ImGuiExt.Text("Back")
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Back.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Back.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Back.z))
          ImGuiExt.Text("Front")
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Front.x))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Front.y))
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.Position.Front.z))
          ImGuiExt.Text("Distance Between Bumpers:")
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.distance))
          ImGuiExt.Text("Bumpers Offset From Wheels:")
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.offset))
        end
      else
        ImGuiExt.Text("false")
      end

      ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Vectors Screen Space") then

      ImGuiExt.Text("Wheels Screen Space Positions:")
      if VehicleData.Wheel.ScreenSpace.Back.Left then
        ImGuiExt.Text("Back Left")
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Back.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Back.Left.y))
        ImGuiExt.Text("Back Right")
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Back.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Back.Right.y))
        ImGuiExt.Text("Front Left")
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Front.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Front.Left.y))
        ImGuiExt.Text("Front Right")
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Front.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Wheel.ScreenSpace.Front.Right.y))
      end

      if VehicleData.Bumper.ScreenSpace.distance then
        ImGui.Separator()
        ImGuiExt.Text("Bumpers Screen Space Distance:")
        ImGuiExt.Text(tostring(VehicleData.Bumper.ScreenSpace.distance))

        if VehicleData.Bumper.ScreenSpace.distanceLineRotation then
          ImGuiExt.Text("Distance (Longtitude Axis) Rotation:")
          ImGui.SameLine()
          ImGuiExt.Text(tostring(VehicleData.Bumper.ScreenSpace.distanceLineRotation))
        end
      end

      ImGui.Separator()

      ImGuiExt.Text("Wheels' Axes Screen Data:")
      if VehicleData.Axis.ScreenRotation.back then
        ImGuiExt.Text("Back")
        ImGuiExt.Text("Rotation:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenRotation.back))
        ImGuiExt.Text("Length:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenLength.back))
        ImGuiExt.Text("Front")
        ImGuiExt.Text("Rotation:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenRotation.front))
        ImGuiExt.Text("Length:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenLength.front))
        ImGuiExt.Text("Left")
        ImGuiExt.Text("Rotation:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenRotation.left))
        ImGuiExt.Text("Length:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenLength.left))
        ImGuiExt.Text("Right")
        ImGuiExt.Text("Rotation:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenRotation.right))
        ImGuiExt.Text("Length:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehicleData.Axis.ScreenLength.right))
      end

      ImGui.EndTabItem()
    end

    if ImGui.BeginTabItem("Vectors Masks") then

      ImGuiExt.Text("Current HED Opacity:")
      if VehMasksData.HorizontalEdgeDown.Opacity.value then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Opacity.value))
      end

      ImGuiExt.Text("Current HED Tracker Opacity:")
      if VehMasksData.HorizontalEdgeDown.Opacity.tracker then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Opacity.tracker))
      end

      ImGuiExt.Text("HED Fill Toggle Value:")
      if VehMasksData.HorizontalEdgeDown.Visible.fillToggleValue then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Visible.fillToggleValue))
      end

      ImGuiExt.Text("Current Masks Opacities:")
      if VehMasksData.Opacity.value then
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Opacity.value))
        ImGuiExt.Text("Mask 1")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask1.opacity))
        ImGuiExt.Text("Mask 2")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask2.opacity))
        ImGuiExt.Text("Mask 3")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask3.opacity))
        ImGuiExt.Text("Mask 4")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask4.opacity))
      end

      ImGuiExt.Text("Opacity Gain:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(VehMasksData.Opacity.Def.gain))

      if VehMasksData.Opacity.delayTime then
        ImGuiExt.Text("Opacity Transformation Delay Time:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Opacity.delayTime))
        ImGuiExt.Text("Is Opacity Normalized:")
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Opacity.isNormalized))

        if not VehMasksData.Opacity.isNormalized then
          ImGuiExt.Text(tostring(VehMasksData.Opacity.normalizedValue))
        end
      end

      ImGui.Separator()

      ImGuiExt.Text("HED Fill Lock:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Visible.Def.fillLock))

      ImGuiExt.Text("HED Tracker Position:")
      if VehMasksData.HorizontalEdgeDown.ScreenSpace.Tracker then
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.ScreenSpace.Tracker.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.ScreenSpace.Tracker.y))
      end

      ImGui.Separator()

      ImGuiExt.Text("Masks Positions:")
      if VehMasksData.Mask1.Position then
        ImGuiExt.Text("Mask1")
        ImGuiExt.Text(tostring(VehMasksData.Mask1.Position.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask1.Position.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask1.Position.z))
        ImGuiExt.Text("Mask2")
        ImGuiExt.Text(tostring(VehMasksData.Mask2.Position.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask2.Position.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask2.Position.z))
        ImGuiExt.Text("Mask3")
        ImGuiExt.Text(tostring(VehMasksData.Mask3.Position.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask3.Position.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask3.Position.z))
        ImGuiExt.Text("Mask4")
        ImGuiExt.Text(tostring(VehMasksData.Mask4.Position.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask4.Position.y))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.Mask4.Position.z))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vehicles HED Mask Size:")
      if VehMasksData.HorizontalEdgeDown.Size.x then
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Size.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Size.y))
      end

      ImGuiExt.Text("HED Size Lock:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Size.Def.lock))

      ImGuiExt.Text("HED Tracker Size (x, y):")
      if VehMasksData.HorizontalEdgeDown.Size.Tracker then
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Size.Tracker.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.Size.Tracker.y))
      end

      ImGui.Separator()

      ImGuiExt.Text("Masks Sizes:")
      if VehMasksData.Mask1.Size.x then
        ImGuiExt.Text("Mask1 (x, y)")
        ImGuiExt.Text(tostring(VehMasksData.Mask1.Size.x))
        ImGuiExt.Text(tostring(VehMasksData.Mask1.Size.y))
        ImGuiExt.Text("Mask2 (x, y)")
        ImGuiExt.Text(tostring(VehMasksData.Mask2.Size.x))
        ImGuiExt.Text(tostring(VehMasksData.Mask2.Size.y))
        ImGuiExt.Text("Mask3 (x, y)")
        ImGuiExt.Text(tostring(VehMasksData.Mask3.Size.x))
        ImGuiExt.Text(tostring(VehMasksData.Mask3.Size.y))
        ImGuiExt.Text("Mask4 (x, y)")
        ImGuiExt.Text(tostring(VehMasksData.Mask4.Size.x))
        ImGuiExt.Text(tostring(VehMasksData.Mask4.Size.y))
      end

      ImGui.EndTabItem()
    end
  else
    if ImGui.BeginTabItem("Vectors General") then

      ImGuiExt.Text("No Vectors module found")

      ImGui.EndTabItem()
    end
  end
end

return VectorsDebug