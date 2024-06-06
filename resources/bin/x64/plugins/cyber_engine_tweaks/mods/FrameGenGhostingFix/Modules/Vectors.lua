--FrameGen Ghosting Fix 4.8.0xl-alpha2

local Vectors = {
  Camera = {
    Forward = nil,
    ForwardTable = {
      Abs = {x=nil, y = nil, z = nil},
      Angle = {
        Vehicle = {
          Forward = {
            horizontalPlane = nil,
            medianPlane = nil,
          },
        }
      },
      DotProduct = {
        Vehicle = {
          forward = nil,
          forwardAbs = nil,
          right = nil,
          rightAbs = nil,
          up = nil,
          upAbs = nil
        }
      },
    },
    Right = nil,
    Up = nil,
  },
  PlayerBody = {
    dotProductMedian = nil,
    dotProductHorizontal = nil,
    Forward = nil,
    Position = nil
  },
  VehElements = {
    BikeSpeedometer = {
      Offset = {x=0.0, y=0.45, z=0.8},
      rotation = 180,
      Size = {x = 6120, y = 1600}
    },
    BikeHandlebars = {
      Left = {
        Offset = {x=-0.6, y=0.48, z=0.7},
        rotation = 0,
        Size = {x = 3000, y = 1800},
      },
      Right = {
        Offset = {x=0.6, y=0.48, z=0.7},
        rotation = 0,
        Size = {x = 3000, y = 1800},
      }
    },
    BikeWindshield = {
      Offset = {x=0.0, y=0.54, z=1},
      rotation = 0,
      Size = {x = 3600, y = 1200}
    },
    CarDoors = {
      Left = {
        Offset = {x=-1.2, y=0, z=0.55},
        rotation = 140,
        Size = {x = 3000, y = 2000},
      },
      Right = {
        Offset = {x=1.2, y=0, z=0.55},
        rotation = -160,
        Size = {x = 2250, y = 1500},
      },
    },
    CarSideMirrors = {
      Left = {
        Offset = {x=-1, y=0.65, z=0.45},
        rotation = 40,
        Size = {x = 1400, y = 1200},
      },
      Right = {
        Offset = {x=1.05, y=0.65, z=0.45},
        rotation = 145,
        Size = {x = 800, y = 800},
      },
    },
  },
  Screen = {
    aspectRatio = nil,
    currentFps = 0,
    Base = {x = 3840, y = 2160},
    Real = {x = nil, y = nil}
  },
  Vehicle = {
    activePerspective = nil,
    Axis = {
      ScreenRotation = {
        back = 0,
        front = 0,
        left = -90,
        longtitude = 0,
        longtitudeTest = 0,
        right = 90,
      },
      ScreenLength = {
        back = 0,
        front = 0,
        left = 0,
        right = 0,
      }
    },
    currentSpeed = nil,
    Bumper = {
      distance = nil,
      Position = {
        Back = nil,
        Front = nil,
      },
      offset = 0,
      screenDistance = 0,
      screenDistancePerp = 0,
      ScreenSpace = {
        Back = nil,
        Front = nil,
      },
    },
    Forward =  nil,
    hasWeapon = nil,
    isMounted = nil,
    lastPerspective = nil,
    Midpoint = {
      Position = {
        Back = nil,
        Front = nil,
        Left = nil,
        Right = nil,
      },
      ScreenSpace = {
        Left = nil,
        Right = nil,
      },
    },
    Position = nil,
    Right = nil,
    Up = nil,
    vehicleBaseObject = 0,
    vehicleID = nil,
    vehicleMaskingOn = true,
    vehicleRecord = nil,
    vehicleType = nil,
    Wheel = {
      Offset = {
        Bike = {
          Back = {
            Left = {x=-0.1, y=0, z=-1.2},
            Right = {x=0.1, y=0, z=-1.2}
          },
          Front = {
            Left = {x=-0.1, y=0, z=1.2},
            Right = {x=0.1, y=0, z=1.2}
          },
        },
        Car = {
          Back = {
            Left = {x=-1.3, y=0, z=-2},
            Right = {x=1.3, y=0, z=-2}
          },
          Front = {
            Left = {x=-1.3, y=0, z=2},
            Right = {x=1.3, y=0, z=2}
          },
        }
      },
      Position = {
        Back = {
          Left = nil,
          Right = nil,
        },
        Front = {
          Left = nil,
          Right = nil,
        },
      },
      ScreenSpace = {
        Back = {
          Left = nil,
          Right = nil,
        },
        Front = {
          Left = nil,
          Right = nil,
        },
      },
      wheelbase = 0,
    },
  },
  VehMasks = {
    AnchorPoint = {x = 0.5, y = 0.5},
    enabled = true,
    HorizontalEdgeDown = {
      AnchorPoint = {x = 0.5, y = 0.5},
      Margin = {
        Base = {left = 1920, top = 2280},
        left = 1920,
        Tracker = {x = 0, y = 0},
        top = 2280,
      },
      hedCornersPath = "fgfixcars/horizontaledgedowncorners",
      hedFillPath = "fgfixcars/horizontaledgedownfill",
      hedTrackerPath = "fgfixcars/horizontaledgedowntracker",
      opacity = 0,
      opacityMax = 0.03,
      opacityTracker = 0,
      Size = {
        Base = {x = 4240, y = 1480},
        MultiplyBy = {screen = 1},
        Tracker = {x = 0, y = 0},
        x = 4240,
        y = 1480
      },
      trackerToggleValue = 0,
      Visible = {
        Base = {
          corners = true,
          fill = false,
          tracker = true,
        },
        corners = true,
        fill = false,
        tracker = true,
      }
    },
    Mask1 = {
      AnchorPoint = {x = 0.5, y = 0.5},
      Cache = {
        Scale = {x = 100, y = 100},
        Shear = {x = 0, y = 0},
        Size = {x = 0, y = 0},
      },
      Def = {
        Offset = {x = 0, y = 0, z = 0},
        rotation = 0,
        Size = {x = 0, y = 0},
      },
      maskPath = "fgfixcars/mask1",
      Offset = {x=0, y=0, z=0},
      opacity = 0,
      Position = nil,
      rotation = 0,
      Scale = {x = 100, y = 100},
      Shear = {x = 0, y = 0},
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
      visible = true
    },
    Mask2 = {
      AnchorPoint = {x = 0.5, y = 0.5},
      Cache = {
        Scale = {x = 100, y = 100},
        Size = {x = 0, y = 0},
      },
      Def = {
        Offset = {x = 0, y = 0, z = 0},
        rotation = 0,
        Size = {x = 0, y = 0},
      },
      maskPath = "fgfixcars/mask2",
      Offset = {x=0, y=0, z=0},
      opacity = 0,
      Position = nil,
      rotation = 0,
      Scale = {x = 100, y = 100},
      Shear = {x = 0, y = 0},
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
      visible = true
    },
    Mask3 = {
      AnchorPoint = {x = 0.5, y = 0.5},
      Cache = {
        Scale = {x = 100, y = 100},
        Size = {x = 0, y = 0},
      },
      Def = {
        Offset = {x = 0, y = 0, z = 0},
        rotation = 0,
        Size = {x = 0, y = 0},
      },
      maskPath = "fgfixcars/mask3",
      Offset = {x=0, y=0, z=0},
      opacity = 0,
      Position = nil,
      rotation = 0,
      Scale = {x = 100, y = 100},
      Shear = {x = 0, y = 0},
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
      visible = true
    },
    Mask4 = {
      AnchorPoint = {x = 0.5, y = 0.5},
      Cache = {
        Scale = {x = 100, y = 100},
        Shear = {x = 0, y = 0},
        Size = {x = 0, y = 0},
      },
      Def = {
        Offset = {x = 0, y = 0, z = 0},
        rotation = 0,
        Size = {x = 0, y = 0},
      },
      maskPath = "fgfixcars/mask4",
      Offset = {x=0, y=0, z=0},
      opacity = 0,
      Position = nil,
      rotation = 0,
      Scale = {x = 100, y = 100},
      Shear = {x = 0, y = 0},
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
      visible = true
    },
    opacity = 0,
    opacityMax = 0.05
  },
}

function Vectors.AddVectors(vector1, vector2)
  local new4 = Vector4.new

  if type(vector1) == "number" then
    return new4(vector2.x + vector1, vector2.y + vector1, vector2.z + vector1, vector2.w + vector1)
  elseif type(vector2) == "number" then
    return new4(vector1.x + vector2, vector1.y + vector2, vector1.z + vector2, vector1.w + vector2)
  else
    return new4(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z, vector1.w + vector2.w)
  end
end

function Vectors.GetLineScreenSpaceIntersection(anchorPoint, angleDeg, intersectionHorizont)
  local new4 = Vector4.new
  local rad = math.rad
  local tan = math.tan
  local intersectionPoint = new4()

  local angleRad = rad(angleDeg)
  local slope = tan(angleRad)

  if slope == 0 then
    if anchorPoint.y == intersectionHorizont then
      return nil
    else
      return nil
    end
  end

  local yIntercept = anchorPoint.y - (slope * anchorPoint.x)

  intersectionPoint.x = (intersectionHorizont - yIntercept) / slope
  intersectionPoint.y = intersectionHorizont

  return intersectionPoint
end

function Vectors.GetLineScreenSpaceRotation(element1ScreenSpacePos, element2ScreenSpacePos)
  local pi = math.pi
  local atan = math.atan
  local deg = math.deg
  local angleDeg = 0
  local angleRad = 0

  local dx = element2ScreenSpacePos.x - element1ScreenSpacePos.x
  local dy = element2ScreenSpacePos.y - element1ScreenSpacePos.y

  if dx == 0 then
      if element2ScreenSpacePos.y > element1ScreenSpacePos.y then
          angleRad =  pi / 2
      else
          angleRad = 3 * pi / 2
      end
  end

  local slope = dy / dx

  angleRad = atan(slope)

  if dx < 0 then
    angleRad = angleRad + pi
  elseif dy < 0 then
    angleRad = angleRad + 2 * pi
  end

  angleDeg = deg(angleRad)

  return angleDeg
end

function Vectors.GetDotProduct(vector1, vector2)
  local x1, y1, z1 = vector1.x, vector1.y, vector1.z
  local x2, y2, z2 = vector2.x, vector2.y, vector2.z

  local dotProduct = (x1 * x2) + (y1 * y2) + (z1 * z2)

  return dotProduct
end

function Vectors.GetMidpointPosition(pos1, pos2)
  local new4 = Vector4.new
  local midpoint = new4()

  midpoint = {
    x = (pos1.x + pos2.x) / 2,
    y = (pos1.y + pos2.y) / 2,
    z = (pos1.z + pos2.z) / 2,
    w = 1
  }
  return midpoint
end

function Vectors.GetWorldPositionFromOffset(basePosition, offsetXYZ)
  local new4 = Vector4.new
  local newPosition = new4()

  local offsetX = Vectors.Vehicle.Right.x * offsetXYZ.x + Vectors.Vehicle.Forward.x * offsetXYZ.z
  local offsetY = Vectors.Vehicle.Right.y * offsetXYZ.x + Vectors.Vehicle.Forward.y * offsetXYZ.z
  local offsetZ = Vectors.Vehicle.Right.z * offsetXYZ.x + Vectors.Vehicle.Forward.z * offsetXYZ.z

  newPosition.x = basePosition.x + offsetX
  newPosition.y = basePosition.y + offsetY + Vectors.Vehicle.Up.y * offsetXYZ.y
  newPosition.z = basePosition.z + offsetZ + Vectors.Vehicle.Up.z * offsetXYZ.y
  newPosition.w = basePosition.w

  return newPosition
end

function Vectors.GetWorldToScreenSpace(pos)
  local new4 = Vector4.new
  local cameraSystem = Game.GetCameraSystem()

  local worldPosition = new4(pos.x, pos.y, pos.z, 1)
  local elementPos = cameraSystem:ProjectPoint(worldPosition)
  local halfX = Vectors.Screen.Base.x * 0.5
  local halfY = Vectors.Screen.Base.y * 0.5
  local screenPos = new4(halfX + halfX * elementPos.x, halfY - halfY * elementPos.y, 0, 0)

  return screenPos
end

function Vectors.IsMounted()
  local isMounted = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())

  if isMounted then
    Vectors.Vehicle.isMounted = true
  else
    Vectors.Vehicle.isMounted = nil
  end
end

function Vectors.HasWeapon()
  local hasWeapon = Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), TweakDBID.new("AttachmentSlots.WeaponRight"))

  if hasWeapon then
    Vectors.Vehicle.hasWeapon = true
  else
    Vectors.Vehicle.hasWeapon = false
  end
end

function Vectors.GetPlayerData()
  local player = Game.GetPlayer()

  if player then
    Vectors.PlayerBody.Position = player:GetWorldPosition()
    Vectors.HasWeapon()
    Vectors.IsMounted()
  end
end

function Vectors.GetVehicleBaseObject()
  if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 0
  elseif Vectors.Vehicle.vehicleType:IsA("vehicleCarBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 1
  elseif Vectors.Vehicle.vehicleType:IsA("vehicleTankBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 2
  else
    Vectors.Vehicle.vehicleBaseObject = 4
  end
end

function Vectors.GetVehicleRecord()
  Vectors.Vehicle.vehicleRecord = Vectors.Vehicle.vehicleType:GetRecord()
  Vectors.Vehicle.vehicleID = Vectors.Vehicle.vehicleRecord:GetID()
end

function Vectors.SetVehicleMaskingState()
  if Vectors.Vehicle.vehicleBaseObject == 0 or Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.Vehicle.vehicleMaskingOn = true
  else
    Vectors.Vehicle.vehicleMaskingOn = false
  end
end

function Vectors.GetBikeWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local new4 = Vector4.new
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false

  if not vehicle then
    Vectors.GetDefaultBikeWheelsPositions()
    return
  end

  local Back = vehicle:GetVehicleComponent():FindComponentByName("WheelAudioEmitterBack") or false

  if not Back then
    Vectors.GetDefaultBikeWheelsPositions()
    return
  end

  local Front = vehicle:GetVehicleComponent():FindComponentByName("WheelAudioEmitterFront")

  local BackPos = mtxTr(Back:GetLocalToWorld())
  local FrontPos = mtxTr(Front:GetLocalToWorld())

  BackPos = new4(BackPos.x, BackPos.y, Vectors.Vehicle.Position.z, BackPos.w)
  FrontPos = new4(FrontPos.x, FrontPos.y, Vectors.Vehicle.Position.z, FrontPos.w)

  Vectors.Vehicle.Wheel.Position.Back.Left = Vectors.GetWorldPositionFromOffset(BackPos, {x = -0.1, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Front.Left = Vectors.GetWorldPositionFromOffset(FrontPos, {x = -0.1, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Back.Right = Vectors.GetWorldPositionFromOffset(BackPos, {x = 0.1, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Front.Right = Vectors.GetWorldPositionFromOffset(FrontPos, {x = 0.1, y = 0, z = 0})

  Vectors.Vehicle.Wheel.wheelbase = dist(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Front.Left)
end

function Vectors.GetVehWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false

  if Vectors.Vehicle.vehicleBaseObject == 0 then
    Vectors.GetBikeWheelsPositions()
    return
  end

  if not vehicle then
    Vectors.GetDefaultCarWheelsPositions()
    return
  end

  local BackLeft = vehicle:GetVehicleComponent():FindComponentByName("back_left_tire") or false

  if not BackLeft then
    Vectors.GetDefaultCarWheelsPositions()
    return
  end

  local FrontLeft = vehicle:GetVehicleComponent():FindComponentByName("front_left_tire")
  local BackRight = vehicle:GetVehicleComponent():FindComponentByName("back_right_tire")
  local FrontRight = vehicle:GetVehicleComponent():FindComponentByName("front_right_tire")

  local BackLeftPos = mtxTr(BackLeft:GetLocalToWorld())
  local FrontLeftPos = mtxTr(FrontLeft:GetLocalToWorld())
  local BackRightPos = mtxTr(BackRight:GetLocalToWorld())
  local FrontRightPos = mtxTr(FrontRight:GetLocalToWorld())

  Vectors.Vehicle.Wheel.Position.Back.Left = Vectors.GetWorldPositionFromOffset(BackLeftPos, {x = -0.4, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Front.Left = Vectors.GetWorldPositionFromOffset(FrontLeftPos, {x = -0.4, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Back.Right = Vectors.GetWorldPositionFromOffset(BackRightPos, {x = 0.4, y = 0, z = 0})
  Vectors.Vehicle.Wheel.Position.Front.Right = Vectors.GetWorldPositionFromOffset(FrontRightPos, {x = 0.4, y = 0, z = 0})

  Vectors.Vehicle.Wheel.wheelbase = dist(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Front.Left)
end

function Vectors.GetDefaultBikeWheelsPositions()
  local dist = Vector4.Distance

  Vectors.Vehicle.Wheel.Position.Back.Left = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Bike.Back.Left)
  Vectors.Vehicle.Wheel.Position.Front.Left = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Bike.Front.Left)
  Vectors.Vehicle.Wheel.Position.Back.Right = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Bike.Back.Right)
  Vectors.Vehicle.Wheel.Position.Front.Right = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Bike.Front.Right)

  Vectors.Vehicle.Wheel.wheelbase = dist(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Front.Left)
end

function Vectors.GetDefaultCarWheelsPositions()
  local dist = Vector4.Distance

  Vectors.Vehicle.Wheel.Position.Back.Left = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Car.Back.Left)
  Vectors.Vehicle.Wheel.Position.Front.Left = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Car.Front.Left)
  Vectors.Vehicle.Wheel.Position.Back.Right = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Car.Back.Right)
  Vectors.Vehicle.Wheel.Position.Front.Right = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.Vehicle.Wheel.Offset.Car.Front.Right)

  Vectors.Vehicle.Wheel.wheelbase = dist(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Front.Left)
end

function Vectors.GetVehMidpointsPositions()
  Vectors.Vehicle.Midpoint.Position.Back = Vectors.GetMidpointPosition(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Back.Right)
  Vectors.Vehicle.Midpoint.Position.Front = Vectors.GetMidpointPosition(Vectors.Vehicle.Wheel.Position.Front.Left, Vectors.Vehicle.Wheel.Position.Front.Right)
  Vectors.Vehicle.Midpoint.Position.Left = Vectors.GetMidpointPosition(Vectors.Vehicle.Wheel.Position.Back.Left, Vectors.Vehicle.Wheel.Position.Front.Left)
  Vectors.Vehicle.Midpoint.Position.Right = Vectors.GetMidpointPosition(Vectors.Vehicle.Wheel.Position.Back.Right, Vectors.Vehicle.Wheel.Position.Front.Right)
end

function Vectors.GetVehBumpersPositions()
  local dist = Vector4.Distance
  local new4 = Vector4.new

  Vectors.Vehicle.Bumper.offset = Vectors.Vehicle.Wheel.wheelbase * 0.178
  local offsetBack = new4(0, 0, Vectors.Vehicle.Bumper.offset * -1.5, 1)
  local offsetFront = new4(0, 0, Vectors.Vehicle.Bumper.offset * 1.5, 1)

  if Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.Vehicle.Bumper.Position.Back = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Back, offsetBack)
    Vectors.Vehicle.Bumper.Position.Front = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Front, offsetFront)
    Vectors.Vehicle.Bumper.distance = dist(Vectors.Vehicle.Bumper.Position.Back, Vectors.Vehicle.Bumper.Position.Front)
  else
    Vectors.Vehicle.Bumper.Position.Back = Vectors.Vehicle.Midpoint.Position.Back
    Vectors.Vehicle.Bumper.Position.Front = Vectors.Vehicle.Midpoint.Position.Front
    Vectors.Vehicle.Bumper.distance = Vectors.Vehicle.Wheel.wheelbase
  end

end

function Vectors.GetVehWheelsScreenData()
  Vectors.Vehicle.Wheel.ScreenSpace.Back.Left = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Wheel.Position.Back.Left)
  Vectors.Vehicle.Wheel.ScreenSpace.Front.Left = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Wheel.Position.Front.Left)
  Vectors.Vehicle.Wheel.ScreenSpace.Back.Right = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Wheel.Position.Back.Right)
  Vectors.Vehicle.Wheel.ScreenSpace.Front.Right = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Wheel.Position.Front.Right)
end

function Vectors.GetVehBumpersScreenData()
  local dist = Vector4.Distance
  local new4 = Vector4.new

  Vectors.Vehicle.Bumper.ScreenSpace.Back = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Bumper.Position.Back)
  Vectors.Vehicle.Bumper.ScreenSpace.Front = Vectors.GetWorldToScreenSpace(Vectors.Vehicle.Bumper.Position.Front)
  Vectors.Vehicle.Bumper.screenDistance = dist(Vectors.Vehicle.Bumper.ScreenSpace.Back, Vectors.Vehicle.Bumper.ScreenSpace.Front)

  if Vectors.Vehicle.vehicleBaseObject == 1 then return end
  local bumperPerp = nil

  if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right >= 0 then
    bumperPerp = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Back, new4(Vectors.Vehicle.Bumper.distance, 0, 0, 0))
  else
    bumperPerp = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Back, new4(Vectors.Vehicle.Bumper.distance * -1, 0, 0, 0))
  end

  local bumperPerpProjection = Vectors.GetWorldToScreenSpace(bumperPerp)
  Vectors.Vehicle.Bumper.screenDistancePerp = dist(Vectors.Vehicle.Bumper.ScreenSpace.Back, bumperPerpProjection)
end

function Vectors.GetVehAxesScreenData()
  local dist = Vector4.Distance

  Vectors.Vehicle.Axis.ScreenLength.left = dist(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left, Vectors.Vehicle.Wheel.ScreenSpace.Front.Left)
  Vectors.Vehicle.Axis.ScreenLength.right = dist(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right, Vectors.Vehicle.Wheel.ScreenSpace.Back.Right)
  Vectors.Vehicle.Axis.ScreenRotation.left = Vectors.GetLineScreenSpaceRotation(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left, Vectors.Vehicle.Wheel.ScreenSpace.Front.Left)
  Vectors.Vehicle.Axis.ScreenRotation.right = Vectors.GetLineScreenSpaceRotation(Vectors.Vehicle.Wheel.ScreenSpace.Front.Right, Vectors.Vehicle.Wheel.ScreenSpace.Back.Right)

  if Vectors.Vehicle.vehicleBaseObject == 0 then return end
  Vectors.Vehicle.Axis.ScreenLength.back = dist(Vectors.Vehicle.Wheel.ScreenSpace.Back.Left, Vectors.Vehicle.Wheel.ScreenSpace.Back.Right)
  Vectors.Vehicle.Axis.ScreenLength.front = dist(Vectors.Vehicle.Wheel.ScreenSpace.Front.Left, Vectors.Vehicle.Wheel.ScreenSpace.Front.Right)
end

function Vectors.GetVehicleData()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false

  if Vectors.Vehicle.isMounted and vehicle then
    Vectors.Vehicle.Position = vehicle:GetWorldPosition()
    Vectors.Vehicle.Forward = vehicle:GetWorldForward()
    Vectors.Vehicle.Right = vehicle:GetWorldRight()
    Vectors.Vehicle.Up = vehicle:GetWorldUp()
    Vectors.Vehicle.vehicleType = vehicle
    Vectors.Vehicle.currentSpeed = vehicle:GetCurrentSpeed()
    Vectors.GetVehicleBaseObject()
    Vectors.GetVehicleRecord()
    Vectors.SetVehicleMaskingState()
  end
end

function Vectors.GetDerivativeVehicleData()
  if not Vectors.Vehicle.vehicleMaskingOn then return end
  Vectors.GetVehWheelsPositions()
  Vectors.GetVehMidpointsPositions()
  Vectors.GetVehBumpersPositions()
  Vectors.GetVehWheelsScreenData()
  Vectors.GetVehBumpersScreenData()
  Vectors.GetVehAxesScreenData()
end

function Vectors.GetCameraData()
  local abs = math.abs
  local cameraSystem = Game.GetCameraSystem()

  Vectors.Camera.Forward = cameraSystem:GetActiveCameraForward()
  Vectors.Camera.Right = cameraSystem:GetActiveCameraRight()
  Vectors.Camera.Up = cameraSystem:GetActiveCameraUp()

  Vectors.Camera.ForwardTable.Abs.z = abs(Vectors.Camera.Forward.z)
end

function Vectors.GetCameraAnglesVehicle()
  Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane = Vector4.GetAngleDegAroundAxis(Vectors.Camera.Forward, Vectors.Vehicle.Forward, Vectors.Vehicle.Up)
  Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane = Vector4.GetAngleDegAroundAxis(Vectors.Camera.Forward, Vectors.Vehicle.Forward, Vectors.Vehicle.Right)
end

function Vectors.GetActivePerspective()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false

  if vehicle and Vectors.Vehicle.isMounted and Vectors.Vehicle.currentSpeed ~= nil then
    if Vectors.Vehicle.currentSpeed > 0.1 or Vectors.Vehicle.currentSpeed < -0.1 then
      Vectors.GetLastPerspective()
      Vectors.Vehicle.activePerspective = vehicle:GetCameraManager():GetActivePerspective()
    end
  end
end

function Vectors.GetLastPerspective()
  Vectors.Vehicle.lastPerspective = Vectors.Vehicle.activePerspective
end

function Vectors.GetDotProducts()
  local abs = math.abs
  local dot = Vector4.Dot

  Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward = dot(Vectors.Vehicle.Forward, Vectors.Camera.Forward) or false

  if not Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward then
    Vectors.GetDotProductsBackup()
    return
  end

  Vectors.Camera.ForwardTable.DotProduct.Vehicle.right = dot(Vectors.Vehicle.Right, Vectors.Camera.Forward)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.up = dot(Vectors.Vehicle.Up, Vectors.Camera.Forward)

  Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up)
end

function Vectors.GetDotProductsBackup()
  local abs = math.abs

  Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward = Vectors.GetDotProduct(Vectors.Vehicle.Forward, Vectors.Camera.Forward)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.right = Vectors.GetDotProduct(Vectors.Vehicle.Right, Vectors.Camera.Forward)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.up = Vectors.GetDotProduct(Vectors.Vehicle.Up, Vectors.Camera.Forward)

  Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.right)
  Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs = abs(Vectors.Camera.ForwardTable.DotProduct.Vehicle.up)
end

function Vectors.ResizeVehHED(baseDimension, multiplier, isX)
  local floor = math.floor
  local max = math.max
  local newDimension = baseDimension

  if isX and Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen ~= 1 then
    newDimension = baseDimension * Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen
  end

  newDimension = newDimension * multiplier
  newDimension = floor(newDimension)

  if isX then
    newDimension = max(newDimension, 3888)
  end

  return newDimension
end

function Vectors.SetWindshieldDefault()
  Vectors.VehMasks.Mask2.Scale.x = 100
  Vectors.VehMasks.Mask2.Scale.y = 100
end

function Vectors.SaveCache()
  Vectors.VehMasks.Mask2.Cache.Scale.x = Vectors.VehMasks.Mask2.Scale.x
  Vectors.VehMasks.Mask2.Cache.Scale.y = Vectors.VehMasks.Mask2.Scale.y
end

function Vectors.ReadCache()
  Vectors.VehMasks.Mask2.Scale.x = Vectors.VehMasks.Mask2.Cache.Scale.x
  Vectors.VehMasks.Mask2.Scale.y = Vectors.VehMasks.Mask2.Cache.Scale.y
end

function Vectors.FlushSizeCache()
  local maxSize = 1000

  if Vectors.Vehicle.activePerspective ~= Vectors.Vehicle.lastPerspective or Vectors.VehMasks.Mask2.Cache.Size.y > maxSize then
    Vectors.VehMasks.Mask2.Cache.Size.y = 0
    Vectors.VehMasks.Mask3.Cache.Size.y = 0
  end
end

function Vectors.TransformByFPS()
  local min = math.min

  local trackerValue = (Vectors.Screen.currentFps - 30) * 0.01
  Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue = min(0.1, trackerValue)
end

function Vectors.TransformByPerspective()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 1, true)
    Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1)
  else
    Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.92, true)
    Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.2)
  end
end

function Vectors.TransformByVehBaseObject()
  if Vectors.Vehicle.isMounted and Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    return
  else
    if Vectors.Vehicle.vehicleBaseObject == 1 then
      Vectors.VehMasks.Mask1.Def = Vectors.VehElements.CarSideMirrors.Left
      Vectors.VehMasks.Mask2.Def = Vectors.VehElements.CarDoors.Left
      Vectors.VehMasks.Mask3.Def = Vectors.VehElements.CarDoors.Right
      Vectors.VehMasks.Mask4.Def = Vectors.VehElements.CarSideMirrors.Right
    else
      Vectors.VehMasks.Mask1.Def = Vectors.VehElements.BikeSpeedometer
      Vectors.VehMasks.Mask2.Def = Vectors.VehElements.BikeWindshield
      Vectors.VehMasks.Mask3.Def = Vectors.VehElements.BikeHandlebars.Left
      Vectors.VehMasks.Mask4.Def = Vectors.VehElements.BikeHandlebars.Right
    end
  end
end

function Vectors.TransformPositionBike()
  local new4 = Vector4.new

  --Mask1
  local mask1NewOffset = new4(0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * -0.1, Vectors.Vehicle.Bumper.offset * -6)
  Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Back, mask1NewOffset)

  --Mask4
  local mask4NewOffset = new4(0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 0.2, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.offset * -1)
  Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Front, mask4NewOffset)

  --Mask2
  local mask2NewOffset = new4(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * -0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward * Vectors.Vehicle.Bumper.distance * -0.6)
  Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Left, mask2NewOffset)

  --Mask3
  local mask3NewOffset = new4(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward * Vectors.Vehicle.Bumper.distance * -0.6)
  Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Right, mask3NewOffset)
end

function Vectors.TransformPositionCar()
  local new4 = Vector4.new

  --Mask1
  local mask1NewOffset = new4(0, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.offset * -0.5)
  --Mask4
  local mask4NewOffset = new4(0, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.offset * 0.5)

  if Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane >= 0 then
    --Mask1
    mask1NewOffset = new4(0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs * -0.5, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.offset * -0.5)
    --Mask4
    mask4NewOffset = new4(0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs * -0.5, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.offset * 0.5)
  end

  --Mask1
  Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Back, mask1NewOffset)
  --Mask4
  Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Bumper.Position.Front, mask4NewOffset)

  --Mask2
  local mask2NewOffset = nil

  if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right > -0.2 then
    mask2NewOffset = new4(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * -0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward * Vectors.Vehicle.Bumper.distance * -0.5)
    Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Left, mask2NewOffset)
  else
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
      mask2NewOffset = new4(0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.distance * -0.3)
      Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Wheel.Position.Back.Left, mask2NewOffset)
    else
      mask2NewOffset = new4(0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.distance * 0.3)
      Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Wheel.Position.Front.Left, mask2NewOffset)
    end
  end

  --Mask3
  local mask3NewOffset = nil

  if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right < 0.2 then
    mask3NewOffset = new4(Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward * Vectors.Vehicle.Bumper.distance * -0.5)
    Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Midpoint.Position.Right, mask3NewOffset)
  else
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
      mask3NewOffset = new4(-0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.distance * -0.3)
      Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Wheel.Position.Back.Right, mask3NewOffset)
    else
      mask3NewOffset = new4(-0.4, 0, Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * Vectors.Vehicle.Bumper.distance * 0.3)
      Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Wheel.Position.Front.Right, mask3NewOffset)
    end
  end
end

function Vectors.TransformPosition()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    if Vectors.Vehicle.vehicleBaseObject == 1 then
      Vectors.TransformPositionCar()
    else
      Vectors.TransformPositionBike()
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.VehMasks.Mask1.Def.Offset)
    
    --Mask2
    Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.VehMasks.Mask2.Def.Offset)

    --Mask3
    Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.VehMasks.Mask3.Def.Offset)

    --Mask4
    Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(Vectors.Vehicle.Position, Vectors.VehMasks.Mask4.Def.Offset)
  end
end

function Vectors.TransformScreenSpace()
  local max = math.max
  local min = math.min

    --HEDTracker
    if Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker then
      local newAngle = 0

      if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward >= 0 then
        Vectors.Vehicle.Axis.ScreenRotation.longtitude = Vectors.GetLineScreenSpaceRotation(Vectors.Vehicle.Bumper.ScreenSpace.Front, Vectors.Vehicle.Bumper.ScreenSpace.Back)
        local difference = Vectors.Vehicle.Axis.ScreenRotation.longtitude - 90
        difference = difference * 0.5
        newAngle = 90 + difference
                
        Vectors.Vehicle.Axis.ScreenRotation.longtitudeTest = newAngle

        Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker = Vectors.GetLineScreenSpaceIntersection(Vectors.Vehicle.Bumper.ScreenSpace.Back, newAngle, 2160)
      else
        Vectors.Vehicle.Axis.ScreenRotation.longtitude = Vectors.GetLineScreenSpaceRotation(Vectors.Vehicle.Bumper.ScreenSpace.Back, Vectors.Vehicle.Bumper.ScreenSpace.Front)
        local difference = 90 - Vectors.Vehicle.Axis.ScreenRotation.longtitude
        difference = difference * -0.5
        newAngle = 90 + difference

        Vectors.Vehicle.Axis.ScreenRotation.longtitudeTest = newAngle

        Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker = Vectors.GetLineScreenSpaceIntersection(Vectors.Vehicle.Bumper.ScreenSpace.Front, newAngle, 2160)
      end

      Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x = max(0, Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x)
      Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x = min(3840, Vectors.VehMasks.HorizontalEdgeDown.Margin.Tracker.x)
    end

    --Mask1  
    if Vectors.VehMasks.Mask1.visible then
      Vectors.VehMasks.Mask1.ScreenSpace = Vectors.GetWorldToScreenSpace(Vectors.VehMasks.Mask1.Position)
    end

    --Mask2
    if Vectors.VehMasks.Mask2.visible then
      Vectors.VehMasks.Mask2.ScreenSpace = Vectors.GetWorldToScreenSpace(Vectors.VehMasks.Mask2.Position)
    end

    --Mask3
    if Vectors.VehMasks.Mask3.visible then
      Vectors.VehMasks.Mask3.ScreenSpace = Vectors.GetWorldToScreenSpace(Vectors.VehMasks.Mask3.Position)
    end

    --Mask4
    if Vectors.VehMasks.Mask4.visible then
      Vectors.VehMasks.Mask4.ScreenSpace = Vectors.GetWorldToScreenSpace(Vectors.VehMasks.Mask4.Position)
    end
end

function Vectors.TransformWidthBike()
  local max = math.max
  local bumpersDistance = Vectors.Vehicle.Bumper.screenDistance
  local bumpersDistancePerp = Vectors.Vehicle.Bumper.screenDistancePerp

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x = max(bumpersDistance * 3, bumpersDistancePerp * 3)

    --Mask1
    Vectors.VehMasks.Mask1.Size.x = max(bumpersDistance * 1.2, bumpersDistancePerp * 1.2)

    --Mask4
    Vectors.VehMasks.Mask4.Size.x = max(bumpersDistance * 1.8, bumpersDistancePerp * 1.8)

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = max(bumpersDistance, bumpersDistancePerp * 0.35) * (4.5 + Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs)

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask2.Size.x
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.x

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask3.Def.Size.x

    --Mask4
    Vectors.VehMasks.Mask4.Size.x = Vectors.VehMasks.Mask4.Def.Size.x

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.x * (Vectors.VehMasks.Mask2.Scale.x * 0.01)
  end
end

function Vectors.TransformWidthCar()
  local abs = math.abs
  local max = math.max
  local min = math.min
  local backAxis = Vectors.Vehicle.Axis.ScreenLength.back
  local bumpersDistance = Vectors.Vehicle.Bumper.screenDistance
  local frontAxis = Vectors.Vehicle.Axis.ScreenLength.front
  local leftAxis = Vectors.Vehicle.Axis.ScreenLength.left
  local rightAxis = Vectors.Vehicle.Axis.ScreenLength.right

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.x = max(backAxis * 4, bumpersDistance)

    if Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane >= 0 then
      --Mask1
      Vectors.VehMasks.Mask1.Size.x = max(backAxis * 2, bumpersDistance * 0.5)

      --Mask4
      Vectors.VehMasks.Mask4.Size.x = max(frontAxis * 2, bumpersDistance * 0.5)
    else
      if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward >= 0 then
        --Mask1
        Vectors.VehMasks.Mask1.Size.x = min(backAxis * 3, backAxis * abs(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane) * 0.4)
        Vectors.VehMasks.Mask1.Size.x = max(Vectors.VehMasks.Mask1.Size.x, backAxis * 2)
      else
        --Mask4
        Vectors.VehMasks.Mask4.Size.x = min(frontAxis * 3, frontAxis * abs(Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane) * 0.4)
        Vectors.VehMasks.Mask4.Size.x = max(Vectors.VehMasks.Mask4.Size.x, frontAxis * 2)
      end
    end

    --Mask2
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right > -0.2 then
      Vectors.VehMasks.Mask2.Size.x = max(backAxis * 0.5, leftAxis * (3 + Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
    else
      Vectors.VehMasks.Mask2.Size.x = bumpersDistance
    end

    --Mask3
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right < 0.2 then
      Vectors.VehMasks.Mask3.Size.x = max(backAxis * 0.5, rightAxis * (3 + Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs))
    else
      Vectors.VehMasks.Mask3.Size.x = bumpersDistance
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.x

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.x

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask3.Def.Size.x

    --Mask4
    Vectors.VehMasks.Mask4.Size.x = Vectors.VehMasks.Mask4.Def.Size.x
  end
end

function Vectors.TransformWidth()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.TransformWidthCar()
  else
    Vectors.TransformWidthBike()
  end
end

function Vectors.TransformHeightBike()
  local abs = math.abs
  local max = math.max
  local min = math.min
  local bumpersDistance = Vectors.Vehicle.Bumper.screenDistance
  local bumpersDistancePerp = Vectors.Vehicle.Bumper.screenDistancePerp

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y = 1650

    --Mask1
    Vectors.VehMasks.Mask1.Size.y = max(bumpersDistance * 1.2, bumpersDistancePerp * 1.2)

    --Mask4
    Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask1.Size.y

    --Mask2
    Vectors.VehMasks.Mask2.Size.y = max(bumpersDistance * 1.5, bumpersDistancePerp * 1.5)

    --Mask3
    Vectors.VehMasks.Mask3.Size.y = Vectors.VehMasks.Mask2.Size.y
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.y

    --Mask3
    Vectors.VehMasks.Mask3.Size.y = Vectors.VehMasks.Mask3.Def.Size.y

    --Mask4
    Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask4.Def.Size.y

    -- --Mask2
    Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.y * (Vectors.VehMasks.Mask2.Scale.y * 0.01)
  end
end

function Vectors.TransformHeightCar()
  local max = math.max
  local min = math.min
  local backAxis = Vectors.Vehicle.Axis.ScreenLength.back
  local frontAxis = Vectors.Vehicle.Axis.ScreenLength.front
  local bumpersDistance = Vectors.Vehicle.Bumper.screenDistance

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y = 1650

    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
      --Mask1
      Vectors.VehMasks.Mask1.Size.y = max(backAxis * 1.5, bumpersDistance) * (1 + (Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs ^ 0.5) * 0.7)

      --Mask4
      Vectors.VehMasks.Mask4.Size.y = bumpersDistance
    else
      --Mask1
      Vectors.VehMasks.Mask1.Size.y = bumpersDistance

      --Mask4
      Vectors.VehMasks.Mask4.Size.y = max(frontAxis * 1.5, bumpersDistance) * (1 + Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 0.4)
    end

    --Mask2
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right > -0.2 then
      Vectors.VehMasks.Mask2.Cache.Size.y = max(Vectors.VehMasks.Mask2.Cache.Size.y, backAxis)
      Vectors.VehMasks.Mask2.Size.y = min(Vectors.VehMasks.Mask2.Cache.Size.y, Vectors.VehMasks.Mask2.Cache.Size.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 3)
      Vectors.VehMasks.Mask2.Size.y = max(Vectors.VehMasks.Mask2.Size.y, backAxis * 0.5)
    else
      Vectors.VehMasks.Mask2.Size.y = max(backAxis, frontAxis)
    end

    --Mask3
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right < 0.2 then
      Vectors.VehMasks.Mask3.Cache.Size.y = max(Vectors.VehMasks.Mask3.Cache.Size.y, backAxis)
      Vectors.VehMasks.Mask3.Size.y = min(Vectors.VehMasks.Mask3.Cache.Size.y, Vectors.VehMasks.Mask3.Cache.Size.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 3)
      Vectors.VehMasks.Mask3.Size.y = max(Vectors.VehMasks.Mask3.Size.y, backAxis * 0.5)
    else
      Vectors.VehMasks.Mask3.Size.y = max(backAxis, frontAxis)
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.y

    --Mask2
    Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.y

    --Mask3
    Vectors.VehMasks.Mask3.Size.y = Vectors.VehMasks.Mask3.Def.Size.y

    --Mask4
    Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask4.Def.Size.y
  end
end

function Vectors.TransformHeight()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.TransformHeightCar()
  else
    Vectors.TransformHeightBike()
  end
end

function Vectors.TransformRotationBike()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    Vectors.VehMasks.Mask1.rotation = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane * -1

    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs < 0.05 and Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs > 0.9 then
      --Mask2
      Vectors.VehMasks.Mask2.rotation = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane - 90

      --Mask3
      Vectors.VehMasks.Mask3.rotation = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane + 90
    else
      --Mask2
      Vectors.VehMasks.Mask2.rotation = Vectors.Vehicle.Axis.ScreenRotation.left

      --Mask3
      Vectors.VehMasks.Mask3.rotation = Vectors.Vehicle.Axis.ScreenRotation.right
    end

    --Mask4
    Vectors.VehMasks.Mask4.rotation = Vectors.VehMasks.Mask1.rotation
  else
    local steeringBarRotation = Vectors.GetLineScreenSpaceRotation(Vectors.VehMasks.Mask3.ScreenSpace, Vectors.VehMasks.Mask4.ScreenSpace)

    --Mask1
    Vectors.VehMasks.Mask1.rotation = Vectors.VehMasks.Mask1.Def.rotation + steeringBarRotation

    --Mask2
    Vectors.VehMasks.Mask2.rotation = Vectors.VehMasks.Mask2.Def.rotation + steeringBarRotation

    --Mask3
    Vectors.VehMasks.Mask3.rotation = Vectors.VehMasks.Mask3.Def.rotation + steeringBarRotation

    --Mask4
    Vectors.VehMasks.Mask4.rotation = Vectors.VehMasks.Mask4.Def.rotation + steeringBarRotation
  end
end

function Vectors.TransformRotationCar()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    Vectors.VehMasks.Mask1.rotation = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane * -1

    --Mask2
    Vectors.VehMasks.Mask2.rotation = Vectors.Vehicle.Axis.ScreenRotation.left

    --Mask3
    Vectors.VehMasks.Mask3.rotation = Vectors.Vehicle.Axis.ScreenRotation.right

    --Mask4
    Vectors.VehMasks.Mask4.rotation = Vectors.VehMasks.Mask1.rotation
  else
    --Mask1
    Vectors.VehMasks.Mask1.rotation = Vectors.VehMasks.Mask1.Def.rotation

    --Mask2
    Vectors.VehMasks.Mask2.rotation = Vectors.VehMasks.Mask2.Def.rotation

    --Mask3
    Vectors.VehMasks.Mask3.rotation = Vectors.VehMasks.Mask3.Def.rotation

    --Mask4
    Vectors.VehMasks.Mask4.rotation = Vectors.VehMasks.Mask4.Def.rotation
  end
end

function Vectors.TransformRotation()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.TransformRotationCar()
  else
    Vectors.TransformRotationBike()
  end
end

function Vectors.TransformShearCar()
  if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
    --Mask1
    Vectors.VehMasks.Mask1.Shear.y = Vectors.Camera.ForwardTable.DotProduct.Vehicle.right
    Vectors.VehMasks.Mask1.Cache.Shear.y = Vectors.VehMasks.Mask1.Shear.y

    --Mask4
    Vectors.VehMasks.Mask4.Shear.y = Vectors.Camera.ForwardTable.DotProduct.Vehicle.right
    Vectors.VehMasks.Mask4.Cache.Shear.y = Vectors.VehMasks.Mask1.Cache.Shear.y

    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward < 0.5 then
      --Mask1
      Vectors.VehMasks.Mask1.Shear.y = Vectors.VehMasks.Mask1.Cache.Shear.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs * 2

      --Mask4
      Vectors.VehMasks.Mask4.Shear.y = Vectors.VehMasks.Mask4.Cache.Shear.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs * 2
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Shear.y = Vectors.Camera.ForwardTable.DotProduct.Vehicle.right * -1
    Vectors.VehMasks.Mask1.Cache.Shear.y = Vectors.VehMasks.Mask1.Shear.y

    --Mask4
    Vectors.VehMasks.Mask4.Shear.y = Vectors.Camera.ForwardTable.DotProduct.Vehicle.right  * -1
    Vectors.VehMasks.Mask4.Cache.Shear.y = Vectors.VehMasks.Mask1.Cache.Shear.y

    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > -0.5 then
      --Mask1
      Vectors.VehMasks.Mask1.Shear.y = Vectors.VehMasks.Mask1.Cache.Shear.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs * 2

      --Mask4
      Vectors.VehMasks.Mask4.Shear.y = Vectors.VehMasks.Mask4.Cache.Shear.y * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs * 2
    end
  end
end

function Vectors.TransformShear()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP and Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.TransformShearCar()
  else
    Vectors.VehMasks.Mask1.Shear.y = 0
    Vectors.VehMasks.Mask4.Shear.y = 0
  end
end

function Vectors.TransformOpacityBike()
  local max = math.max
  local min = math.min
  local opacityForward = Vectors.VehMasks.opacity * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward * 0.8
  local opacityRight = Vectors.VehMasks.opacity * Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 1.5

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    Vectors.VehMasks.Mask1.opacity = max(0, opacityForward)

    --Mask2
    Vectors.VehMasks.Mask2.opacity = Vectors.VehMasks.opacity

    --Mask3
    Vectors.VehMasks.Mask3.opacity = Vectors.VehMasks.opacity

    --Mask4
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
      Vectors.VehMasks.Mask4.opacity = min(Vectors.VehMasks.opacity, opacityRight)
    else
      Vectors.VehMasks.Mask4.opacity = Vectors.VehMasks.opacity
    end

  else
    --Mask1
    Vectors.VehMasks.Mask1.opacity = Vectors.VehMasks.opacity

    --Mask2
    Vectors.VehMasks.Mask2.opacity = Vectors.VehMasks.opacity

    --Mask3
    Vectors.VehMasks.Mask3.opacity = Vectors.VehMasks.opacity

    --Mask4
    Vectors.VehMasks.Mask4.opacity = Vectors.VehMasks.opacity
  end
end

function Vectors.TransformOpacityCar()
  local max = math.max
  local min = math.min
  local opacityRight = Vectors.VehMasks.opacity * Vectors.Camera.ForwardTable.DotProduct.Vehicle.rightAbs * 1.5
  local opacityUp = Vectors.VehMasks.opacity * Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs * 2

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward < 0 then
      Vectors.VehMasks.Mask1.opacity = max(opacityUp, opacityRight)
      Vectors.VehMasks.Mask1.opacity = min(Vectors.VehMasks.opacityMax, Vectors.VehMasks.Mask1.opacity)
    else
      Vectors.VehMasks.Mask1.opacity = Vectors.VehMasks.opacity
    end

    --Mask2
    Vectors.VehMasks.Mask2.opacity = Vectors.VehMasks.opacity * 0.8

    --Mask3
    Vectors.VehMasks.Mask3.opacity = Vectors.VehMasks.opacity * 0.8

    --Mask4
    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward > 0 then
      Vectors.VehMasks.Mask4.opacity = max(opacityUp, opacityRight)
      Vectors.VehMasks.Mask4.opacity = min(Vectors.VehMasks.opacityMax, Vectors.VehMasks.Mask4.opacity)
    else
      Vectors.VehMasks.Mask4.opacity = Vectors.VehMasks.opacity
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.opacity = Vectors.VehMasks.opacity

    --Mask2
    Vectors.VehMasks.Mask2.opacity = Vectors.VehMasks.opacity

    --Mask3
    Vectors.VehMasks.Mask3.opacity = Vectors.VehMasks.opacity

    --Mask4
    Vectors.VehMasks.Mask4.opacity = Vectors.VehMasks.opacity
  end
end

function Vectors.TransformOpacity()
  local abs = math.abs
  local min = math.min
  local currentSpeedAbs = abs(Vectors.Vehicle.currentSpeed)

  if Vectors.VehMasks.opacity ~= 1 then
    Vectors.VehMasks.HorizontalEdgeDown.opacity = min(Vectors.VehMasks.HorizontalEdgeDown.opacityMax, currentSpeedAbs * 0.005)
    Vectors.VehMasks.opacity = min(Vectors.VehMasks.opacityMax, currentSpeedAbs * 0.01)
  end

  Vectors.VehMasks.HorizontalEdgeDown.opacityTracker = (Vectors.VehMasks.opacity + Vectors.VehMasks.HorizontalEdgeDown.opacity) * 0.5

  if Vectors.Vehicle.vehicleBaseObject == 1 then
    Vectors.TransformOpacityCar()
  else
    Vectors.TransformOpacityBike()
  end
end

function Vectors.TransformVehMasks()
  Vectors.TransformByFPS()
  Vectors.TransformByPerspective()
  Vectors.TransformByVehBaseObject()
  Vectors.TransformPosition()
  Vectors.TransformScreenSpace()
  Vectors.TransformWidth()
  Vectors.TransformHeight()
  Vectors.TransformRotation()
  Vectors.TransformShear()
  Vectors.TransformOpacity()
end

function Vectors.SetVisibleVehMasks()
  Vectors.VehMasks.HorizontalEdgeDown.Visible.corners = Vectors.VehMasks.HorizontalEdgeDown.Visible.Base.corners

  if Vectors.Vehicle.activePerspective == vehicleCameraPerspective.FPP then
    if Vectors.Vehicle.vehicleBaseObject == 0 and Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward < 0.4 then
      Vectors.VehMasks.Mask1.visible = false
      Vectors.VehMasks.Mask2.visible = false
      Vectors.VehMasks.Mask3.visible = false
      Vectors.VehMasks.Mask4.visible = false
    else
      Vectors.VehMasks.Mask1.visible = true
      Vectors.VehMasks.Mask2.visible = true
      Vectors.VehMasks.Mask3.visible = true
      Vectors.VehMasks.Mask4.visible = true
    end

    if Vectors.Vehicle.vehicleBaseObject == 0 and Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane >= 5 then
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = true
    elseif Vectors.Vehicle.vehicleBaseObject == 0 and Vectors.Vehicle.hasWeapon then
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = true
    elseif Vectors.Vehicle.vehicleBaseObject == 1 and Vectors.Vehicle.hasWeapon and Vectors.Camera.ForwardTable.DotProduct.Vehicle.right < 0 then
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = true
    else
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = Vectors.VehMasks.HorizontalEdgeDown.Visible.Base.fill
    end

    Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker = false
  else
    Vectors.VehMasks.Mask1.visible = true
    Vectors.VehMasks.Mask2.visible = true
    Vectors.VehMasks.Mask3.visible = true
    Vectors.VehMasks.Mask4.visible = true

    if Vectors.Camera.ForwardTable.DotProduct.Vehicle.up > Vectors.VehMasks.HorizontalEdgeDown.trackerToggleValue then
      Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker = false
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = true
    else
      Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker = Vectors.VehMasks.HorizontalEdgeDown.Visible.Base.tracker
      Vectors.VehMasks.HorizontalEdgeDown.Visible.fill = Vectors.VehMasks.HorizontalEdgeDown.Visible.Base.fill
    end
  end
end

function Vectors.ProjectVehicleMasks()
  if Vectors.Vehicle.isMounted and Vectors.VehMasks.enabled then
    Vectors.GetVehicleData()
    Vectors.GetDotProducts()
    Vectors.GetCameraAnglesVehicle()
    Vectors.GetDerivativeVehicleData()
    Vectors.GetActivePerspective()
    Vectors.FlushSizeCache()
    Vectors.SetVisibleVehMasks()
    Vectors.TransformVehMasks()
  end
end

return Vectors