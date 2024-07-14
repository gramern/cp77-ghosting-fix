local Vectors = {
  __NAME = "Vectors",
  __VERSION_NUMBER = 500,
  MaskingGlobal = {
    masksController = nil,
    vehicles = true,
  },
  Camera = {
    activePerspective = nil,
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
    fov = nil,
    lastPerspective = nil,
    Right = nil,
    Up = nil,
  },
  PlayerPuppet = {
    dotProductMedian = nil,
    dotProductHorizontal = nil,
    Hands = {
      Position = {
        Left = nil,
        Right = nil,
      }
    },
    hasWeapon = nil,
    isMoving = nil,
    Forward = nil,
    Position = nil
  },
  VehElements = {
    BikeSpeedometer = {
      Offset = {x=0.0, y=0.45, z=0.8},
      rotation = 180,
      Size = {x = 6120, y = 1600},
      visible = true,
    },
    BikeHandlebars = {
      Left = {
        Offset = {x=-0.6, y=0.48, z=0.7},
        rotation = 0,
        Size = {x = 3000, y = 1800},
        visible = true,
      },
      Right = {
        Offset = {x=0.6, y=0.48, z=0.7},
        rotation = 0,
        Size = {x = 3000, y = 1800},
        visible = true,
      }
    },
    BikeWindshield = {
      Offset = {x=0.0, y=0.54, z=1},
      rotation = 0,
      Size = {x = 3600, y = 1200},
      visible = true,
    },
    CarDoors = {
      Left = {
        Offset = {x=-1.2, y=0, z=0.55},
        rotation = 140,
        Size = {x = 3000, y = 2000},
        visible = true,
      },
      Right = {
        Offset = {x=1.2, y=0, z=0.55},
        rotation = -160,
        Size = {x = 2250, y = 1500},
        visible = true,
      },
    },
    CarSideMirrors = {
      Left = {
        Offset = {x=-1, y=0.65, z=0.45},
        rotation = 40,
        Size = {x = 1400, y = 1200},
        visible = true,
      },
      Right = {
        Offset = {x=1.05, y=0.65, z=0.45},
        rotation = 145,
        Size = {x = 800, y = 800},
        visible = true,
      },
    },
  },
  Screen = {
    Edge = {
      down = 2160,
      left = 0,
      right = 3840,
    },
    Factor = {width = 1, height = 1},
    Space = {width = 3840, height = 2160},
    type = 169,
  },
  Vehicle = {
    Axis = {
      ScreenRotation = {
        back = 0,
        front = 0,
        left = -90,
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
      ScreenSpace = {
        Back = nil,
        distance = 0,
        distanceLineRotation = 0,
        Front = nil,
      },
    },
    Forward =  nil,
    isMounted = nil,
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
    vehicleBaseObject = 4,
    vehicleID = nil,
    vehicleTypeKnown = true,
    vehicleRecord = nil,
    vehicleType = nil,
    Wheel = {
      Offset = {
        Bike = {
          Back = {
            Left = {x=0, y=0, z=-1.2},
            Right = {x=0, y=0, z=-1.2}
          },
          Front = {
            Left = {x=0, y=0, z=1.2},
            Right = {x=0, y=0, z=1.2}
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
      wheelbaseScreen = 0,
      wheelbaseScreenPerp = 0,
    },
  },
  VehMasks = {
    AnchorPoint = {x = 0.5, y = 0.5},
    enabled = true,
    HorizontalEdgeDown = {
      AnchorPoint = {x = 0.5, y = 0.5},
      hedCornersPath = "fgfix/horizontaledgedowncorners",
      hedFillPath = "fgfix/horizontaledgedownfill",
      hedTrackerPath = "fgfix/horizontaledgedowntracker",
      ScreenSpace = {
        Def = {x = 1920, y = 2280},
        x = 1920,
        Tracker = {x = 0, y = 0},
        y = 2280,
      },
      Opacity = {
        Def = {
          max = 0.03
        },
        tracker = 0,
        value = 0
      },
      Rotation = {
        tracker = 0,
      },
      Size = {
        Def = {
          lock = false,
          x = 4240,
          y = 1480
        },
        Tracker = {x = 0, y = 0},
        x = 4240,
        y = 1480
      },
      Visible = {
        Def = {
          corners = true,
          fill = true,
          fillLock = false,
          tracker = true,
        },
        corners = true,
        fill = false,
        fillToggleValue = 0,
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
        visible = true,
      },
      maskPath = "fgfix/mask1",
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
        visible = true,
      },
      maskPath = "fgfix/mask2",
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
        visible = true,
      },
      maskPath = "fgfix/mask3",
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
        visible = true,
      },
      maskPath = "fgfix/mask4",
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
    MaskEditor1 = {
      maskPath = "fgfix/mask_editor1",
      rotation = 0,
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
    },
    MaskEditor2 = {
      maskPath = "fgfix/mask_editor2",
      rotation = 0,
      Size = {x = 0, y = 0},
      ScreenSpace = {x = 0, y = 0},
    },
    Opacity = {
      Def = {
        delayDuration = 1,
        delayThreshold = 0.95,
        gain = 1,
        max = 0.05,
        speedFactor = 0.01,
        stepFactor = 0.1
      },
      value = 0,
      delayedValue = 0,
      delayTime = 0,
      isDelayed = false,
      isNormalized = true,
      normalizedValue = 0,
      speedValue = 0,
    }
  },
}

local Config = require("Modules/Config")

--Universal methods start here----------------------------------------------------------------------------------------------------------------------

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

function Vectors.GetLineIntersectionScreenSpace(anchorPoint, angleDeg, intersectionHorizont)
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

function Vectors.GetLineRotationScreenSpace(element1ScreenSpacePos, element2ScreenSpacePos)
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
  local screenEdge = Vectors.Screen.Edge
  local screenSpace = Vectors.Screen.Space

  local worldPosition = new4(pos.x, pos.y, pos.z, 1)
  local elementPos = cameraSystem:ProjectPoint(worldPosition)
  local halfX = screenSpace.width * 0.5
  local halfY = screenSpace.height * 0.5
  local screenPos = new4((halfX + halfX * elementPos.x) + screenEdge.left, halfY - halfY * elementPos.y, 0, 0)

  return screenPos
end

function Vectors.ResizeHED(baseDimension, multiplier, isX)
  local floor = math.floor
  local max = math.max
  local newDimension = baseDimension
  local screenFactor = Vectors.Screen.Factor

  if isX and screenFactor.width ~= 1 then
    newDimension = baseDimension * screenFactor.width
  end

  newDimension = newDimension * multiplier
  newDimension = floor(newDimension)

  if isX then
    newDimension = max(newDimension, 3888)
  end

  return newDimension
end

--Universal methods end here----------------------------------------------------------------------------------------------------------------------
--Data gathering methods start here----------------------------------------------------------------------------------------------------------------------

function Vectors.IsMounted()
  local isMounted = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())
  local print

  if isMounted then
    Vectors.Vehicle.isMounted = true
    print = true
  else
    Vectors.Vehicle.isMounted = nil
    print = false
  end

  return print
end

function Vectors.IsMoving()
  local isMoving = Game.GetPlayer():IsMoving()

  Vectors.PlayerPuppet.isMoving = isMoving

  return isMoving
end

function Vectors.HasWeapon()
  local hasWeapon = Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), TweakDBID.new("AttachmentSlots.WeaponRight"))
  local print

  if hasWeapon then
    Vectors.PlayerPuppet.hasWeapon = true
    print = true
  else
    Vectors.PlayerPuppet.hasWeapon = false
    print = false
  end

  return print
end

local function GetPlayerData()
  local player = Game.GetPlayer()

  if player then
    Vectors.PlayerPuppet.Position = player:GetWorldPosition()
    Vectors.IsMounted()
    Vectors.IsMoving()
    Vectors.HasWeapon()
  end
end

local function GetCameraData()
  local abs = math.abs
  local cameraSystem = Game.GetCameraSystem()

  Vectors.Camera.fov = cameraSystem:GetActiveCameraFOV()

  Vectors.Camera.Forward = cameraSystem:GetActiveCameraForward()
  Vectors.Camera.Right = cameraSystem:GetActiveCameraRight()
  Vectors.Camera.Up = cameraSystem:GetActiveCameraUp()

  Vectors.Camera.ForwardTable.Abs.z = abs(Vectors.Camera.Forward.z)
end

function Vectors.GetActivePerspective()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local currentSpeed = Vectors.Vehicle.currentSpeed

  if vehicle and Vectors.Vehicle.isMounted and currentSpeed ~= nil then
      Vectors.Camera.lastPerspective = Vectors.Camera.activePerspective
      Vectors.Camera.activePerspective = vehicle:GetCameraManager():GetActivePerspective()

      return Vectors.Camera.activePerspective
  end
end

function Vectors.GetVehicleBaseObject()
  if not Vectors.Vehicle.isMounted then return end

  if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 0
  elseif Vectors.Vehicle.vehicleType:IsA("vehicleCarBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 1
  elseif Vectors.Vehicle.vehicleType:IsA("vehicleTankBaseObject") then
    Vectors.Vehicle.vehicleBaseObject = 2
  else
    Vectors.Vehicle.vehicleBaseObject = 4
  end

  return Vectors.Vehicle.vehicleBaseObject
end

function Vectors.GetVehicleRecord()
  if not Vectors.Vehicle.isMounted then return end

  Vectors.Vehicle.vehicleRecord = Vectors.Vehicle.vehicleType:GetRecord()
  Vectors.Vehicle.vehicleID = Vectors.Vehicle.vehicleRecord:GetID()

  return Vectors.Vehicle.vehicleRecord
end

function Vectors.IsVehicleKnown()
  if not Vectors.Vehicle.isMounted then return end

  local baseObject = Vectors.Vehicle.vehicleBaseObject
  local print

  if baseObject == 0 or baseObject == 1 then
    Vectors.Vehicle.vehicleTypeKnown = true
    print = true
  else
    Vectors.Vehicle.vehicleTypeKnown = false
    print = false
  end

  return print
end

local function GetDefaultBikeWheelsPositions()
  local dist = Vector4.Distance
  local wheelPos = Vectors.Vehicle.Wheel.Position
  local vehOffsetBike = Vectors.Vehicle.Wheel.Offset.Bike
  local vehPos = Vectors.Vehicle.Position

  wheelPos.Back.Left = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Back.Left)
  wheelPos.Front.Left = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Front.Left)
  wheelPos.Back.Right = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Back.Right)
  wheelPos.Front.Right = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Front.Right)

  Vectors.Vehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetDefaultCarWheelsPositions()
  local dist = Vector4.Distance
  local wheelPos = Vectors.Vehicle.Wheel.Position
  local vehOffsetCar = Vectors.Vehicle.Wheel.Offset.Car
  local vehPos = Vectors.Vehicle.Position

  wheelPos.Back.Left = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Back.Left)
  wheelPos.Front.Left = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Front.Left)
  wheelPos.Back.Right = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Back.Right)
  wheelPos.Front.Right = Vectors.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Front.Right)

  Vectors.Vehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetBikeWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local new4 = Vector4.new
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local wheelPos = Vectors.Vehicle.Wheel.Position

  if not vehicle then
    GetDefaultBikeWheelsPositions()
    return
  end

  local Back = vehicle:GetVehicleComponent():FindComponentByName("WheelAudioEmitterBack") or false

  if not Back then
    GetDefaultBikeWheelsPositions()
    return
  end

  local Front = vehicle:GetVehicleComponent():FindComponentByName("WheelAudioEmitterFront")

  local BackPos = mtxTr(Back:GetLocalToWorld())
  local FrontPos = mtxTr(Front:GetLocalToWorld())

  BackPos = new4(BackPos.x, BackPos.y, Vectors.Vehicle.Position.z, BackPos.w)
  FrontPos = new4(FrontPos.x, FrontPos.y, Vectors.Vehicle.Position.z, FrontPos.w)

  wheelPos.Back.Left = BackPos
  wheelPos.Front.Left = FrontPos
  wheelPos.Back.Right = BackPos
  wheelPos.Front.Right = FrontPos

  -- local simVehPosZ = (BackPos.z + FrontPos.z) / 2
  -- local diffVehPosZ = simVehPosZ - Vectors.Vehicle.Position.z

  -- Vectors.Vehicle.Wheel.Position.Back.Left = Vectors.GetWorldPositionFromOffset(BackPos, {x = 0, y = diffVehPosZ, z = 0})
  -- Vectors.Vehicle.Wheel.Position.Front.Left = Vectors.GetWorldPositionFromOffset(FrontPos, {x = -0, y = diffVehPosZ, z = 0})
  -- Vectors.Vehicle.Wheel.Position.Back.Right = Vectors.GetWorldPositionFromOffset(BackPos, {x = 0, y = diffVehPosZ, z = 0})
  -- Vectors.Vehicle.Wheel.Position.Front.Right = Vectors.GetWorldPositionFromOffset(FrontPos, {x = 0, y = diffVehPosZ, z = 0})

  Vectors.Vehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetVehWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local wheelPos = Vectors.Vehicle.Wheel.Position

  if Vectors.Vehicle.vehicleBaseObject == 0 then
    GetBikeWheelsPositions()
    return
  end

  if not vehicle then
    GetDefaultCarWheelsPositions()
    return
  end

  local BackLeft = vehicle:GetVehicleComponent():FindComponentByName("back_left_tire") or false

  if not BackLeft then
    GetDefaultCarWheelsPositions()
    return
  end

  local FrontLeft = vehicle:GetVehicleComponent():FindComponentByName("front_left_tire")
  local BackRight = vehicle:GetVehicleComponent():FindComponentByName("back_right_tire")
  local FrontRight = vehicle:GetVehicleComponent():FindComponentByName("front_right_tire")

  local BackLeftPos = mtxTr(BackLeft:GetLocalToWorld())
  local FrontLeftPos = mtxTr(FrontLeft:GetLocalToWorld())
  local BackRightPos = mtxTr(BackRight:GetLocalToWorld())
  local FrontRightPos = mtxTr(FrontRight:GetLocalToWorld())

  wheelPos.Back.Left = Vectors.GetWorldPositionFromOffset(BackLeftPos, {x = -0.4, y = 0, z = 0})
  wheelPos.Front.Left = Vectors.GetWorldPositionFromOffset(FrontLeftPos, {x = -0.4, y = 0, z = 0})
  wheelPos.Back.Right = Vectors.GetWorldPositionFromOffset(BackRightPos, {x = 0.4, y = 0, z = 0})
  wheelPos.Front.Right = Vectors.GetWorldPositionFromOffset(FrontRightPos, {x = 0.4, y = 0, z = 0})

  Vectors.Vehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetVehMidpointsPositions()
  local midpointPos = Vectors.Vehicle.Midpoint.Position
  local wheelPos = Vectors.Vehicle.Wheel.Position

  midpointPos.Back = Vectors.GetMidpointPosition(wheelPos.Back.Left, wheelPos.Back.Right)
  midpointPos.Front = Vectors.GetMidpointPosition(wheelPos.Front.Left, wheelPos.Front.Right)
  midpointPos.Left = Vectors.GetMidpointPosition(wheelPos.Back.Left, wheelPos.Front.Left)
  midpointPos.Right = Vectors.GetMidpointPosition(wheelPos.Back.Right, wheelPos.Front.Right)
end

local function GetVehBumpersPositions()
  local dist = Vector4.Distance
  local new4 = Vector4.new
  local bumperOffset = Vectors.Vehicle.Bumper.offset
  local bumperPos = Vectors.Vehicle.Bumper.Position
  local midpointPos = Vectors.Vehicle.Midpoint.Position

  local offsetBack = nil
  local offsetFront = nil

  if Vectors.Vehicle.vehicleBaseObject == 0 then
    bumperOffset = Vectors.Vehicle.Wheel.wheelbase
    offsetBack = new4(0, 0, bumperOffset * -1, 1)
    offsetFront = new4(0, 0, bumperOffset, 1)
  else
    bumperOffset = Vectors.Vehicle.Wheel.wheelbase * 0.178
    offsetBack = new4(0, 0, bumperOffset * -2, 1)
    offsetFront = new4(0, 0, bumperOffset * 1.5, 1)
  end

  bumperPos.Back = Vectors.GetWorldPositionFromOffset(midpointPos.Back, offsetBack)
  bumperPos.Front = Vectors.GetWorldPositionFromOffset(midpointPos.Front, offsetFront)
  Vectors.Vehicle.Bumper.distance = dist(bumperPos.Back, bumperPos.Front)
end

local function GetVehWheelsScreenData()
  local dist = Vector4.Distance
  local new4 = Vector4.new
  local wheelPos = Vectors.Vehicle.Wheel.Position
  local wheelScreen = Vectors.Vehicle.Wheel.ScreenSpace
  local wheelbase = Vectors.Vehicle.Wheel.wheelbase

  wheelScreen.Back.Left = Vectors.GetWorldToScreenSpace(wheelPos.Back.Left)
  wheelScreen.Front.Left = Vectors.GetWorldToScreenSpace(wheelPos.Front.Left)
  wheelScreen.Back.Right = Vectors.GetWorldToScreenSpace(wheelPos.Back.Right)
  wheelScreen.Front.Right = Vectors.GetWorldToScreenSpace(wheelPos.Front.Right)

  if Vectors.Vehicle.vehicleBaseObject == 1 then return end
  Vectors.Vehicle.Wheel.wheelbaseScreen = dist(wheelScreen.Back.Left, wheelScreen.Front.Left)
  local wheelbasePerp = nil

  if Vectors.Camera.ForwardTable.DotProduct.Vehicle.right >= 0 then
    wheelbasePerp = Vectors.GetWorldPositionFromOffset(wheelPos.Back.Left, new4(wheelbase, 0, 0, 0))
  else
    wheelbasePerp = Vectors.GetWorldPositionFromOffset(wheelPos.Back.Left, new4(wheelbase * -1, 0, 0, 0))
  end

  local wheelbasePerpProjection = Vectors.GetWorldToScreenSpace(wheelbasePerp)
  Vectors.Vehicle.Wheel.wheelbaseScreenPerp = dist(wheelScreen.Back.Left, wheelbasePerpProjection)
end

local function GetVehBumpersScreenData()
  local dist = Vector4.Distance
  local bumperPos = Vectors.Vehicle.Bumper.Position
  local bumperScreen = Vectors.Vehicle.Bumper.ScreenSpace

  bumperScreen.Back = Vectors.GetWorldToScreenSpace(bumperPos.Back)
  bumperScreen.Front = Vectors.GetWorldToScreenSpace(bumperPos.Front)
  bumperScreen.distance = dist(bumperScreen.Back, bumperScreen.Front)
  bumperScreen.distanceLineRotation = Vectors.GetLineRotationScreenSpace(bumperScreen.Back, bumperScreen.Front)
end

local function GetVehAxesScreenData()
  local dist = Vector4.Distance
  local axisLength = Vectors.Vehicle.Axis.ScreenLength
  local axisRotation = Vectors.Vehicle.Axis.ScreenRotation
  local baseObject = Vectors.Vehicle.vehicleBaseObject
  local wheelScreen = Vectors.Vehicle.Wheel.ScreenSpace

  axisLength.left = dist(wheelScreen.Back.Left, wheelScreen.Front.Left)
  axisLength.right = dist(wheelScreen.Front.Right, wheelScreen.Back.Right)
  axisRotation.left = Vectors.GetLineRotationScreenSpace(wheelScreen.Back.Left, wheelScreen.Front.Left)
  axisRotation.right = Vectors.GetLineRotationScreenSpace(wheelScreen.Front.Right, wheelScreen.Back.Right)

  if baseObject == 0 then return end
  axisLength.back = dist(wheelScreen.Back.Left, wheelScreen.Back.Right)
  axisLength.front = dist(wheelScreen.Front.Left, wheelScreen.Front.Right)
end

local function GetVehicleData()
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
    Vectors.IsVehicleKnown()
  end
end

local function GetDerivativeVehicleData()
  if not Vectors.Vehicle.vehicleTypeKnown then return end
  GetVehWheelsPositions()
  GetVehMidpointsPositions()
  GetVehBumpersPositions()
  GetVehWheelsScreenData()
  GetVehBumpersScreenData()
  GetVehAxesScreenData()
end

local function GetCameraAnglesVehicle()
  local angleVeh = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward

  angleVeh.horizontalPlane = Vector4.GetAngleDegAroundAxis(Vectors.Camera.Forward, Vectors.Vehicle.Forward, Vectors.Vehicle.Up)
  angleVeh.medianPlane = Vector4.GetAngleDegAroundAxis(Vectors.Camera.Forward, Vectors.Vehicle.Forward, Vectors.Vehicle.Right)
end

local function GetDotProductsBackup()
  local abs = math.abs
  local cameraForward = Vectors.Camera.Forward
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle

  dotVeh.forward = Vectors.GetDotProduct(Vectors.Vehicle.Forward, cameraForward)
  dotVeh.right = Vectors.GetDotProduct(Vectors.Vehicle.Right, cameraForward)
  dotVeh.up = Vectors.GetDotProduct(Vectors.Vehicle.Up, cameraForward)

  dotVeh.forwardAbs = abs(dotVeh.forward)
  dotVeh.rightAbs = abs(dotVeh.right)
  dotVeh.upAbs = abs(dotVeh.up)
end

local function GetDotProducts()
  local abs = math.abs
  local dot = Vector4.Dot
  local cameraForward = Vectors.Camera.Forward
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle

  dotVeh.forward = dot(Vectors.Vehicle.Forward, cameraForward) or false

  if not dotVeh.forward then
    GetDotProductsBackup()
    return
  end

  dotVeh.right = dot(Vectors.Vehicle.Right, cameraForward)
  dotVeh.up = dot(Vectors.Vehicle.Up, cameraForward)

  dotVeh.forwardAbs = abs(dotVeh.forward)
  dotVeh.rightAbs = abs(dotVeh.right)
  dotVeh.upAbs = abs(dotVeh.up)
end

--Data gathering methods end here----------------------------------------------------------------------------------------------------------------------
--Transformation methods start here----------------------------------------------------------------------------------------------------------------------

--Transform By

local function TransformByFPS()
  local min = math.min

  local fillToggleValue = (FrameGenGhostingFix.GameState.currentFps - 30) * 0.01
  Vectors.VehMasks.HorizontalEdgeDown.Visible.fillToggleValue = min(0.1, fillToggleValue)
end

local function TransformByPerspective()
  local hedSize = Vectors.VehMasks.HorizontalEdgeDown.Size

  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    hedSize.x = hedSize.Def.x
    hedSize.y = hedSize.Def.y
  else
    hedSize.x = Vectors.ResizeHED(hedSize.Def.x, 0.92, true)
    hedSize.y = Vectors.ResizeHED(hedSize.Def.y, 1.2)
  end
end

local function TransformByVehBaseObject()
  local vehElements = Vectors.VehElements

  if Vectors.Vehicle.isMounted and Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    return
  else
    if Vectors.Vehicle.vehicleBaseObject == 1 then
      Vectors.VehMasks.Mask1.Def = vehElements.CarSideMirrors.Left
      Vectors.VehMasks.Mask2.Def = vehElements.CarDoors.Left
      Vectors.VehMasks.Mask3.Def = vehElements.CarDoors.Right
      Vectors.VehMasks.Mask4.Def = vehElements.CarSideMirrors.Right
    else
      Vectors.VehMasks.Mask1.Def = vehElements.BikeSpeedometer
      Vectors.VehMasks.Mask2.Def = vehElements.BikeHandlebars.Left
      Vectors.VehMasks.Mask3.Def = vehElements.BikeHandlebars.Right
      Vectors.VehMasks.Mask4.Def = vehElements.BikeWindshield
    end
  end
end

--Transform Properties

local function TransformPositionBike()
  local new4 = Vector4.new
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local midpointPos = Vectors.Vehicle.Midpoint.Position
  local wheelbase = Vectors.Vehicle.Wheel.wheelbase

  --Mask1
  local mask1NewOffset = nil
  if dotVeh.forward >= 0 then
    mask1NewOffset = new4(0, dotVeh.rightAbs * 0.5, 0.4)
  else
    mask1NewOffset = new4(0, 0.5 , 0.4)
  end
  Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Left, mask1NewOffset)

  --Mask4
  local mask4NewOffset = nil
  if dotVeh.forward >= 0 then
    mask4NewOffset = new4(0, 0, wheelbase)
  else
    mask4NewOffset = new4(0, 0, wheelbase * -1)
  end
  Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Left, mask4NewOffset)

  --Mask2
  local mask2NewOffset = new4(dotVeh.rightAbs * -0.4, dotVeh.rightAbs * -0.5, dotVeh.forward * wheelbase * -0.6)
  Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Left, mask2NewOffset)

  --Mask3
  local mask3NewOffset = new4(dotVeh.rightAbs * 0.4, dotVeh.rightAbs * -0.5, dotVeh.forward * wheelbase * -0.6)
  Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Right, mask3NewOffset)
end

local function TransformPositionCar()
  local new4 = Vector4.new
  local bumper = Vectors.Vehicle.Bumper
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local medianPlane = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane
  local midpointPos = Vectors.Vehicle.Midpoint.Position
  local wheelbase = Vectors.Vehicle.Wheel.wheelbase

  --Mask1
  local mask1NewOffset = new4(0, 0, dotVeh.rightAbs * bumper.offset * -0.5)
  --Mask4
  local mask4NewOffset = new4(0, 0, dotVeh.rightAbs * bumper.offset * 0.5)

  if medianPlane >= 0 then
    --Mask1
    mask1NewOffset = new4(0, dotVeh.upAbs * -0.5, dotVeh.rightAbs * bumper.offset * -0.5)
    --Mask4
    mask4NewOffset = new4(0, dotVeh.upAbs * -0.5, dotVeh.rightAbs * bumper.offset * 0.5)
  end

  --Mask1
  Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(bumper.Position.Back, mask1NewOffset)
  --Mask4
  Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(bumper.Position.Front, mask4NewOffset)

  local wheelbaseFactor
  if wheelbase < 1.6 then
    wheelbaseFactor = -0.2
  elseif wheelbase < 2 then
    wheelbaseFactor = 0
  else
    wheelbaseFactor = 0.2
  end

  --Mask2
  local mask2NewOffset = nil
  mask2NewOffset = new4(dotVeh.rightAbs * wheelbaseFactor * -1, dotVeh.rightAbs * -0.5, dotVeh.forward * bumper.distance * -0.5)
  Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Left, mask2NewOffset)

  --Mask3
  local mask3NewOffset = nil
  mask3NewOffset = new4(dotVeh.rightAbs * wheelbaseFactor, dotVeh.rightAbs * -0.5, dotVeh.forward * bumper.distance * -0.5)
  Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(midpointPos.Right, mask3NewOffset)
end

local function TransformPosition()
  local vehiclePos = Vectors.Vehicle.Position

  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    if Vectors.Vehicle.vehicleBaseObject == 1 then
      TransformPositionCar()
    else
      TransformPositionBike()
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Position = Vectors.GetWorldPositionFromOffset(vehiclePos, Vectors.VehMasks.Mask1.Def.Offset)
    
    --Mask2
    Vectors.VehMasks.Mask2.Position = Vectors.GetWorldPositionFromOffset(vehiclePos, Vectors.VehMasks.Mask2.Def.Offset)

    --Mask3
    Vectors.VehMasks.Mask3.Position = Vectors.GetWorldPositionFromOffset(vehiclePos, Vectors.VehMasks.Mask3.Def.Offset)

    --Mask4
    Vectors.VehMasks.Mask4.Position = Vectors.GetWorldPositionFromOffset(vehiclePos, Vectors.VehMasks.Mask4.Def.Offset)
  end
end

local function TransformScreenSpaceBike()
  local max = math.max
  local min = math.min
  local new4 = Vector4.new
  local activePerspective = Vectors.Camera.activePerspective
  local axisRotation = Vectors.Vehicle.Axis.ScreenRotation
  local bumperScreen = Vectors.Vehicle.Bumper.ScreenSpace
  local dotForward = Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward
  local screenEdge = Vectors.Screen.Edge
  local wheelScreen = Vectors.Vehicle.Wheel.ScreenSpace

  --HEDTracker
  if Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker then
    if activePerspective ~= vehicleCameraPerspective.TPPFar then
      local newAngle = 0

      if dotForward >= 0 then
        local difference = axisRotation.right - 90
        difference = difference * 0.5
        newAngle = 90 + difference

        Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = Vectors.GetLineIntersectionScreenSpace(wheelScreen.Back.Left, newAngle, screenEdge.down)
      else
        local difference = 90 - axisRotation.left
        difference = difference * -0.5
        newAngle = 90 + difference

        Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = Vectors.GetLineIntersectionScreenSpace(wheelScreen.Front.Left, newAngle, screenEdge.down)
      end

      Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x = max(screenEdge.left, Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x)
      Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x = min(screenEdge.right, Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x)
    else
      if dotForward >= 0 then
        Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = new4(bumperScreen.Back.x, screenEdge.down, 0, 0)
      else
        Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = new4(bumperScreen.Front.x, screenEdge.down, 0, 0)
      end
    end
  end
end

local function TransformScreenSpaceCar()
  local max = math.max
  local min = math.min
  local bumperScreen = Vectors.Vehicle.Bumper.ScreenSpace
  local dotForward = Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward
  local screenEdge = Vectors.Screen.Edge

  --HEDTracker
  if Vectors.VehMasks.HorizontalEdgeDown.Visible.tracker then
    local newAngle = 0

    if dotForward >= 0 then
      bumperScreen.distanceLineRotationFB = Vectors.GetLineRotationScreenSpace(bumperScreen.Front, bumperScreen.Back)
      local difference = bumperScreen.distanceLineRotationFB - 90
      difference = difference * 0.5
      newAngle = 90 + difference

      Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = Vectors.GetLineIntersectionScreenSpace(bumperScreen.Back, newAngle, screenEdge.down)
    else
      local difference = 90 - bumperScreen.distanceLineRotation
      difference = difference * -0.5
      newAngle = 90 + difference

      Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker = Vectors.GetLineIntersectionScreenSpace(bumperScreen.Front, newAngle, screenEdge.down)
    end

    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x = max(screenEdge.left, Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x)
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x = min(screenEdge.right, Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.x)
  end
end

local function TransformScreenSpace()
  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    if Vectors.Vehicle.vehicleBaseObject == 1 then
      TransformScreenSpaceCar()
    else
      TransformScreenSpaceBike()
    end
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

local function TransformWidthBike()
  local max = math.max
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local hedSize = Vectors.VehMasks.HorizontalEdgeDown.Size
  local wheelbaseScreen = Vectors.Vehicle.Wheel.wheelbaseScreen
  local wheelbaseScreenPerp = Vectors.Vehicle.Wheel.wheelbaseScreenPerp

  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    --HED
    local newHEDx = max(0.92, dotVeh.forwardAbs ^ 0.5)
    hedSize.x = Vectors.ResizeHED(hedSize.Def.x, newHEDx, true)

    --HEDTracker
    hedSize.Tracker.x = max(wheelbaseScreen * 4, wheelbaseScreenPerp * 4)

    --Mask1
    Vectors.VehMasks.Mask1.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp)

    --Mask4
    if dotVeh.forward >= 0 then
      Vectors.VehMasks.Mask4.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp * 0.75)
    else
      Vectors.VehMasks.Mask4.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp * 1.5)
    end

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = max(wheelbaseScreen * (1 + dotVeh.rightAbs) * 3, wheelbaseScreenPerp * (1 + dotVeh.upAbs) * 1.5)

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask2.Size.x
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.x

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.x

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask3.Def.Size.x

    --Mask4
    Vectors.VehMasks.Mask4.Size.x = Vectors.VehMasks.Mask4.Def.Size.x * (Vectors.VehMasks.Mask4.Scale.x * 0.01)
  end
end

local function TransformWidthCar()
  local abs = math.abs
  local max = math.max
  local min = math.min
  local activePerspective = Vectors.Camera.activePerspective
  local axisLength = Vectors.Vehicle.Axis.ScreenLength
  local bumpersScreenDistance = Vectors.Vehicle.Bumper.ScreenSpace.distance
  local currentSpeed = Vectors.Vehicle.currentSpeed
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local hedSize = Vectors.VehMasks.HorizontalEdgeDown.Size
  local medianAngle = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --HED
    if not hedSize.Def.lock then
      local newHEDx = max(0.92, dotVeh.forwardAbs ^ 0.5)
      hedSize.x = Vectors.ResizeHED(hedSize.Def.x, newHEDx, true)
    end
  
    --HEDTracker
    local hedTrackerSizeX = max(axisLength.back * 4, bumpersScreenDistance * 3)
    hedSize.Tracker.x = hedTrackerSizeX * (1 + dotVeh.rightAbs)

    if medianAngle <= 0 and dotVeh.forwardAbs >= 0.9 then
      --Mask1
      local mask1Size = min(axisLength.back * 2.5, axisLength.back * abs(medianAngle) * 0.4)
      Vectors.VehMasks.Mask1.Size.x = max(mask1Size, axisLength.back * 2)
    elseif medianAngle <= 0 and dotVeh.forward <= -0.9 then
      --Mask4
      local mask4Size = min(axisLength.front * 2.5, axisLength.front * abs(medianAngle) * 0.4)
      Vectors.VehMasks.Mask4.Size.x = max(mask4Size, axisLength.front * 2)
    else
      --Mask1
      Vectors.VehMasks.Mask1.Size.x = max(axisLength.back * 2, bumpersScreenDistance * 0.5)

      --Mask4
      Vectors.VehMasks.Mask4.Size.x = max(axisLength.front * 2, bumpersScreenDistance * 0.5)
    end

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = max(axisLength.back * 0.5, axisLength.left * (4 + dotVeh.forwardAbs))

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = max(axisLength.back * 0.5, axisLength.right * (4 + dotVeh.forwardAbs))
  else
    --Mask1
    if currentSpeed <= 50 then
      Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.x
    else
      Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.x * (0.5 + (currentSpeed * 0.015))
    end

    --Mask2
    Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.x

    --Mask3
    Vectors.VehMasks.Mask3.Size.x = Vectors.VehMasks.Mask3.Def.Size.x

    --Mask4
    if currentSpeed <= 50 then
      Vectors.VehMasks.Mask4.Size.x = Vectors.VehMasks.Mask4.Def.Size.x
    else
      Vectors.VehMasks.Mask4.Size.x = Vectors.VehMasks.Mask4.Def.Size.x * (0.5 + (currentSpeed * 0.01))
    end
  end
end

local function TransformWidth()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    TransformWidthCar()
  else
    TransformWidthBike()
  end
end

local function TransformHeightBike()
  local max = math.max
  local activePerspective = Vectors.Camera.activePerspective
  local bumperScreen = Vectors.Vehicle.Bumper.ScreenSpace
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local hedTrackerSize = Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker
  local wheelbaseScreen = Vectors.Vehicle.Wheel.wheelbaseScreen
  local wheelbaseScreenPerp = Vectors.Vehicle.Wheel.wheelbaseScreenPerp

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    if activePerspective == vehicleCameraPerspective.TPPFar then
      if dotVeh.forward >= 0 then
        hedTrackerSize.y = max(700, (Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y - bumperScreen.Back.y) * 3)
      else
        hedTrackerSize.y = max(700, (Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.Tracker.y - bumperScreen.Front.y) * 3)
      end
    else
      hedTrackerSize.y = 700
    end

    --Mask1
    if dotVeh.forward >= 0 then
      Vectors.VehMasks.Mask1.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 0.5)
    else
      Vectors.VehMasks.Mask1.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 3)
    end

    
    local mask23Size = max(wheelbaseScreen * 1.5, wheelbaseScreenPerp * 1.5)
    local mask23SizeMax = max(wheelbaseScreen * 2.5, mask23Size)

    if dotVeh.right >= 0 then
      --Mask2
      Vectors.VehMasks.Mask2.Size.y = mask23SizeMax

      --Mask3
      Vectors.VehMasks.Mask3.Size.y = max(mask23Size, mask23SizeMax * dotVeh.upAbs)
    else
      --Mask2
      Vectors.VehMasks.Mask2.Size.y = max(mask23Size, mask23SizeMax * dotVeh.upAbs)

      --Mask3
      Vectors.VehMasks.Mask3.Size.y = mask23SizeMax
    end

    --Mask4
    if dotVeh.forward >= 0 then
      Vectors.VehMasks.Mask4.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 0.5)
    else
      Vectors.VehMasks.Mask4.Size.y = wheelbaseScreen * 2
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.y
  
    --Mask2
    Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.y

    --Mask3
    Vectors.VehMasks.Mask3.Size.y = Vectors.VehMasks.Mask3.Def.Size.y

    --Mask4
    Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask4.Def.Size.y * (Vectors.VehMasks.Mask4.Scale.y * 0.01)
  end
end

local function TransformHeightCar()
  local max = math.max
  local activePerspective = Vectors.Camera.activePerspective
  local axisLength = Vectors.Vehicle.Axis.ScreenLength
  local bumpersScreenDistance = Vectors.Vehicle.Bumper.ScreenSpace.distance
  local currentSpeed = Vectors.Vehicle.currentSpeed
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local wheelbase = Vectors.Vehicle.Wheel.wheelbase


  if activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Size.Tracker.y = 1650

    if dotVeh.forward > 0 then
      --Mask1
      Vectors.VehMasks.Mask1.Size.y = max(axisLength.back * 2.5, bumpersScreenDistance * 1.5) * (1 + (dotVeh.rightAbs ^ 0.5))

      --Mask4
      Vectors.VehMasks.Mask4.Size.y = max(axisLength.back * 2, bumpersScreenDistance) * max(dotVeh.upAbs * 1.5, dotVeh.rightAbs)
    else
      --Mask1
      Vectors.VehMasks.Mask1.Size.y = bumpersScreenDistance * (1 + dotVeh.rightAbs * 0.5)

      --Mask4
      Vectors.VehMasks.Mask4.Size.y = max(axisLength.front * 1.5, bumpersScreenDistance) * (1 + dotVeh.rightAbs * 0.4)
    end

    local wheelbaseFactor
    if wheelbase < 3 then
      wheelbaseFactor = 1.4
    elseif wheelbase < 3.5 then
      wheelbaseFactor = 1.2
    else
      wheelbaseFactor = 0.8
    end

    --Mask2
    if dotVeh.right > -0.2 then
      local mask2Size = max(axisLength.back * 0.8, axisLength.front * 0.8)
      Vectors.VehMasks.Mask2.Size.y = max(bumpersScreenDistance * wheelbaseFactor, mask2Size)
    else
      Vectors.VehMasks.Mask2.Size.y = max(axisLength.back, axisLength.front)
    end

    --Mask3
    if dotVeh.right < 0.2 then
      local mask3Size = max(axisLength.back * 0.8, axisLength.front * 0.8)
      Vectors.VehMasks.Mask3.Size.y = max(bumpersScreenDistance * wheelbaseFactor, mask3Size)
    else
      Vectors.VehMasks.Mask3.Size.y = max(axisLength.back, axisLength.front)
    end
  else
    --Mask1
    if currentSpeed <= 50 then
      Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.y
    else
      Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.y * (0.5 + (currentSpeed * 0.025))
    end
    
    --Mask2
    Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.y

    --Mask3
    Vectors.VehMasks.Mask3.Size.y = Vectors.VehMasks.Mask3.Def.Size.y

    --Mask4
    if currentSpeed <= 50 then
      Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask4.Def.Size.y
    else
      Vectors.VehMasks.Mask4.Size.y = Vectors.VehMasks.Mask4.Def.Size.y * (0.5 + (currentSpeed * 0.015))
    end
  end
end

local function TransformHeight()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    TransformHeightCar()
  else
    TransformHeightBike()
  end
end

local function TransformRotationBike()
  local activePerspective = Vectors.Camera.activePerspective
  local axisRotation = Vectors.Vehicle.Axis.ScreenRotation
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local horizontalAngle = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane
  local mask2Screen = Vectors.VehMasks.Mask2.ScreenSpace
  local mask3Screen = Vectors.VehMasks.Mask3.ScreenSpace

  if activePerspective ~= vehicleCameraPerspective.FPP then

    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker = 180

    --Mask1
    Vectors.VehMasks.Mask1.rotation = 90 + axisRotation.right

    if dotVeh.right < 0.05 and dotVeh.forward > 0.9 then
      --Mask2
      Vectors.VehMasks.Mask2.rotation = horizontalAngle - 90

      --Mask3
      Vectors.VehMasks.Mask3.rotation = horizontalAngle + 90
    else
      --Mask2
      Vectors.VehMasks.Mask2.rotation = axisRotation.left

      --Mask3
      Vectors.VehMasks.Mask3.rotation = axisRotation.right
    end

    --Mask4
    if dotVeh.forward >= 0 then
      Vectors.VehMasks.Mask4.rotation = 90 + axisRotation.left
    else
      Vectors.VehMasks.Mask4.rotation = 90 + axisRotation.right
    end
  else
    local steeringBarRotation = Vectors.GetLineRotationScreenSpace(mask2Screen, mask3Screen)

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

local function TransformRotationCar()
  local activePerspective = Vectors.Camera.activePerspective
  local axisRotation = Vectors.Vehicle.Axis.ScreenRotation
  local bumpersRotation = Vectors.Vehicle.Bumper.ScreenSpace.distanceLineRotation
  local dotForwardAbs = Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs
  local horizontalAngle = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.horizontalPlane

  if activePerspective ~= vehicleCameraPerspective.FPP then

    --HEDTracker
    Vectors.VehMasks.HorizontalEdgeDown.Rotation.tracker = 0

    --Mask1
    if dotForwardAbs >= 0.9 then
      Vectors.VehMasks.Mask1.rotation = horizontalAngle * -1
    else
      Vectors.VehMasks.Mask1.rotation = 90 + bumpersRotation
    end

    --Mask2
    Vectors.VehMasks.Mask2.rotation = axisRotation.left

    --Mask3
    Vectors.VehMasks.Mask3.rotation = axisRotation.right

    --Mask4
    Vectors.VehMasks.Mask4.rotation = horizontalAngle * -1
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

local function TransformRotation()
  if Vectors.Vehicle.vehicleBaseObject == 1 then
    TransformRotationCar()
  else
    TransformRotationBike()
  end
end

local function TransformShearCar()
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle

  -- Mask1
  Vectors.VehMasks.Mask1.Shear.y = 0

  if dotVeh.forward > 0 then
    --Mask4
    Vectors.VehMasks.Mask4.Shear.y = dotVeh.right * 0.5
    Vectors.VehMasks.Mask4.Cache.Shear.y = Vectors.VehMasks.Mask4.Shear.y

    if dotVeh.forward < 0.5 then
      Vectors.VehMasks.Mask4.Shear.y = Vectors.VehMasks.Mask4.Cache.Shear.y * dotVeh.forwardAbs * 2
    end
  else
    --Mask4
    Vectors.VehMasks.Mask4.Shear.y = dotVeh.right * -1
    Vectors.VehMasks.Mask4.Cache.Shear.y = Vectors.VehMasks.Mask4.Shear.y

    if dotVeh.forward > -0.5 then
      Vectors.VehMasks.Mask4.Shear.y = Vectors.VehMasks.Mask4.Cache.Shear.y * dotVeh.forwardAbs * 2
    end
  end
end

local function TransformShear()
  local activePerspective = Vectors.Camera.activePerspective
  local baseObject = Vectors.Vehicle.vehicleBaseObject

  if activePerspective ~= vehicleCameraPerspective.FPP and baseObject == 1 then
    TransformShearCar()
  else
    Vectors.VehMasks.Mask1.Shear.y = 0
    Vectors.VehMasks.Mask4.Shear.y = 0
  end
end

local function TransformOpacityBike()
  local max = math.max
  local min = math.max
  local activePerspective = Vectors.Camera.activePerspective
  local dotForward = Vectors.Camera.ForwardTable.DotProduct.Vehicle.forward
  local opacityValue = Vectors.VehMasks.Opacity.value
  local opacityForwardAbs = opacityValue * Vectors.Camera.ForwardTable.DotProduct.Vehicle.forwardAbs
  local opacityUpAbs = opacityValue * Vectors.Camera.ForwardTable.DotProduct.Vehicle.upAbs

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    if dotForward >= 0 then
      Vectors.VehMasks.Mask1.opacity = opacityValue * 0.75
    else
      Vectors.VehMasks.Mask1.opacity = opacityValue
    end

    --Mask2
    Vectors.VehMasks.Mask2.opacity = opacityValue

    --Mask3
    Vectors.VehMasks.Mask3.opacity = opacityValue

    --Mask4
    local mask4Opacity = max(opacityUpAbs, opacityForwardAbs)
    Vectors.VehMasks.Mask4.opacity = min(opacityValue, mask4Opacity) * 0.75
  else
    --Mask1
    Vectors.VehMasks.Mask1.opacity = opacityValue * 0.75

    --Mask2
    Vectors.VehMasks.Mask2.opacity = opacityValue * 0.75

    --Mask3
    Vectors.VehMasks.Mask3.opacity = opacityValue * 0.75

    --Mask4
    Vectors.VehMasks.Mask4.opacity = opacityValue
  end
end

local function TransformOpacityCar()
  local max = math.max
  local min = math.min
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local opacityGain = Vectors.VehMasks.Opacity.Def.gain
  local opacityValue = Vectors.VehMasks.Opacity.value
  local opacityRightAbs = opacityValue * dotVeh.rightAbs
  local opacityUpAbs = opacityValue * dotVeh.upAbs

  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    if dotVeh.forward < 0 then
      local mask1Opacity = max(opacityUpAbs * 2, opacityRightAbs * 1.5) * opacityGain
      Vectors.VehMasks.Mask1.opacity = min(opacityValue, mask1Opacity)
    else
      Vectors.VehMasks.Mask1.opacity = opacityValue
    end

    --Mask2
    if dotVeh.right > -0.2 or dotVeh.forward < -0.6 then
      local mask2Opacity = max(opacityUpAbs * 2, opacityRightAbs * 3) * opacityGain
      Vectors.VehMasks.Mask2.opacity = min(opacityValue, mask2Opacity)
    else
      local mask2Opacity = opacityUpAbs * 2 * opacityGain
      Vectors.VehMasks.Mask2.opacity = min(opacityValue, mask2Opacity)
    end

    --Mask3
    if dotVeh.right < 0.2 or dotVeh.forward < -0.6 then
      local mask3Opacity = max(opacityUpAbs * 2, opacityRightAbs * 3) * opacityGain
      Vectors.VehMasks.Mask3.opacity = min(opacityValue, mask3Opacity)
    else
      local mask3Opacity = opacityUpAbs * 2 * opacityGain
      Vectors.VehMasks.Mask3.opacity = min(opacityValue, mask3Opacity)
    end
    
    --Mask4
    if dotVeh.forward > 0 then
      local mask4Opacity = max(opacityUpAbs * 2, opacityRightAbs * 1.5) * opacityGain
      Vectors.VehMasks.Mask4.opacity = min(opacityValue, mask4Opacity)
    else
      Vectors.VehMasks.Mask4.opacity = opacityValue
    end
  else
    --Mask1
    Vectors.VehMasks.Mask1.opacity = opacityValue

    --Mask2
    Vectors.VehMasks.Mask2.opacity = opacityValue

    --Mask3
    Vectors.VehMasks.Mask3.opacity = opacityValue

    --Mask4
    Vectors.VehMasks.Mask4.opacity = opacityValue
  end
end

local function SetNormalizeOpacity()
  local opacity = Vectors.VehMasks.Opacity

  opacity.isNormalized = false
  opacity.normalizedValue = opacity.delayedValue
end

local function CancelNormalizeOpacity()
  Vectors.VehMasks.Opacity.isNormalized = true
end

local function NormalizeOpacity()
  local opacity = Vectors.VehMasks.Opacity

  if opacity.isNormalized then return end

  if opacity.speedValue > opacity.normalizedValue then
    CancelNormalizeOpacity()
    return
  end

  local opacityStep = opacity.Def.max * opacity.Def.stepFactor

  opacity.normalizedValue = opacity.normalizedValue - opacityStep
  opacity.value = opacity.normalizedValue

  if opacity.normalizedValue > opacity.speedValue then return end
  CancelNormalizeOpacity()
end

local function SetDelayTransformOpacity()
  local opacity = Vectors.VehMasks.Opacity

  opacity.isDelayed = true
  opacity.delayedValue = opacity.Def.max * opacity.Def.delayThreshold
end

local function ResetDelayTransformOpacity()
  Vectors.VehMasks.Opacity.deltaFrames = 0
  Vectors.VehMasks.Opacity.delayTime = 0
end

local function CancelDelayTransformOpacity()
  Vectors.VehMasks.Opacity.isDelayed = false
end

local function DelayTransformOpacity()
  local opacity = Vectors.VehMasks.Opacity

  if not opacity.isDelayed then return end

  if opacity.speedValue > opacity.delayedValue then
    ResetDelayTransformOpacity()
    return
  end

  opacity.value = opacity.delayedValue
  opacity.delayTime = opacity.delayTime + FrameGenGhostingFix.GameState.gameDeltaTime

  if opacity.delayTime <= opacity.Def.delayDuration then return end
  ResetDelayTransformOpacity()
  CancelDelayTransformOpacity()
  SetNormalizeOpacity()
end

local function TransformOpacity()
  local abs = math.abs
  local floor = math.floor
  local min = math.min
  local currentSpeedAbs = abs(Vectors.Vehicle.currentSpeed)
  local currentSpeedAbsInt = floor(currentSpeedAbs)
  local opacity = Vectors.VehMasks.Opacity
  local opacityHED = Vectors.VehMasks.HorizontalEdgeDown.Opacity

  if opacity.Def.max ~= 1 then
    opacityHED.value = min(opacityHED.Def.max, currentSpeedAbsInt * 0.005)
    opacity.speedValue = min(opacity.Def.max, currentSpeedAbsInt * opacity.Def.speedFactor)
    opacity.value = opacity.speedValue

    if opacity.speedValue >= opacity.Def.max then
      SetDelayTransformOpacity()
    end

    DelayTransformOpacity()
    NormalizeOpacity()
  else
    opacityHED.value = opacityHED.Def.max
    opacity.value = opacity.Def.max
  end

  opacityHED.tracker = (opacity.value + opacityHED.value) * 0.5

  if Vectors.Vehicle.vehicleBaseObject == 1 then
    TransformOpacityCar()
  else
    TransformOpacityBike()
  end
end

function Vectors.TransformVisibility()
  local baseObject = Vectors.Vehicle.vehicleBaseObject
  local dotVeh = Vectors.Camera.ForwardTable.DotProduct.Vehicle
  local maskingVeh = Vectors.MaskingGlobal.vehicles
  local hasWeapon = Vectors.PlayerPuppet.hasWeapon
  local hedVisible = Vectors.VehMasks.HorizontalEdgeDown.Visible
  local medianAngle = Vectors.Camera.ForwardTable.Angle.Vehicle.Forward.medianPlane

  hedVisible.corners = hedVisible.Def.corners
  hedVisible.tracker = hedVisible.Def.tracker

  if Vectors.Camera.activePerspective ~= vehicleCameraPerspective.FPP then
    Vectors.VehMasks.Mask1.visible = true
    Vectors.VehMasks.Mask2.visible = true
    Vectors.VehMasks.Mask3.visible = true
    Vectors.VehMasks.Mask4.visible = true

    if dotVeh.up > hedVisible.fillToggleValue then
      hedVisible.fill = hedVisible.Def.fill
    else
      hedVisible.fill = hedVisible.Def.fillLock
    end

    if baseObject == 0 and hedVisible.Def.fillLock then
      hedVisible.tracker = false
    end
  else
    if baseObject == 0 and dotVeh.forward < 0.4 then
      Vectors.VehMasks.Mask1.visible = false
      Vectors.VehMasks.Mask2.visible = false
      Vectors.VehMasks.Mask3.visible = false
      Vectors.VehMasks.Mask4.visible = false
    else
      Vectors.VehMasks.Mask1.visible = Vectors.VehMasks.Mask1.Def.visible
      Vectors.VehMasks.Mask2.visible = Vectors.VehMasks.Mask2.Def.visible
      Vectors.VehMasks.Mask3.visible = Vectors.VehMasks.Mask3.Def.visible
      Vectors.VehMasks.Mask4.visible = Vectors.VehMasks.Mask4.Def.visible
    end

    if baseObject == 0 and medianAngle >= 0 then
      hedVisible.fill = hedVisible.Def.fill
    elseif baseObject == 0 and hasWeapon then
      hedVisible.fill = hedVisible.Def.fill
    elseif baseObject == 1 and hasWeapon and dotVeh.right < -0.1 then
      hedVisible.fill = hedVisible.Def.fill
    else
      hedVisible.fill = hedVisible.Def.fillLock
    end

    hedVisible.tracker = false
  end

  if maskingVeh then return end
  hedVisible.corners = false
  hedVisible.fill = false
  hedVisible.tracker = false
  Vectors.VehMasks.Mask1.visible = false
  Vectors.VehMasks.Mask2.visible = false
  Vectors.VehMasks.Mask3.visible = false
  Vectors.VehMasks.Mask4.visible = false
end

function Vectors.TransformVehMasks()
  Vectors.TransformVisibility()
  if not Vectors.MaskingGlobal.vehicles then return end
  TransformByFPS()
  TransformByPerspective()
  TransformByVehBaseObject()
  TransformPosition()
  TransformScreenSpace()
  TransformWidth()
  TransformHeight()
  TransformRotation()
  TransformShear()
  TransformOpacity()
end

--Transformation methods end here----------------------------------------------------------------------------------------------------------------------

function Vectors.OnUpdate()
  GetPlayerData()
  GetCameraData()
  if not Vectors.Vehicle.isMounted then return end
  Vectors.GetActivePerspective()
  GetVehicleData()
  GetDotProducts()
  GetCameraAnglesVehicle()
  GetDerivativeVehicleData()
  Vectors.TransformVehMasks()
end

function Vectors.OnInitialize()
  Vectors.ApplyMasksController()
  Vectors.ApplyScreen()
  Vectors.ApplyScreenSpaceHed()
  Vectors.ApplySizeHed()
  Vectors.ApplyPreset()
end

function Vectors.OnOverlayOpen()
  Vectors.ApplyMasksController()
  Vectors.ApplyScreen()
  Vectors.ApplyScreenSpaceHed()
  Vectors.ApplySizeHed()
  Vectors.ApplyPreset()
end

function Vectors.ApplyMasksController()
  Vectors.MaskingGlobal.masksController = Config.GetMasksController()

  if Vectors.MaskingGlobal.masksController ~= Config.GetLegacyController() then return end

  local widgets = Config.GetWidgets()

  Vectors.VehMasks.HorizontalEdgeDown.hedCornersPath = widgets.hedCorners
  Vectors.VehMasks.HorizontalEdgeDown.hedFillPath = widgets.hedFill
  Vectors.VehMasks.HorizontalEdgeDown.hedTrackerPath = widgets.hedTracker
  Vectors.VehMasks.Mask1.maskPath = widgets.mask1
  Vectors.VehMasks.Mask2.maskPath = widgets.mask2
  Vectors.VehMasks.Mask3.maskPath = widgets.mask3
  Vectors.VehMasks.Mask4.maskPath = widgets.mask4
  Vectors.VehMasks.MaskEditor1.maskPath = widgets.maskEditor1
  Vectors.VehMasks.MaskEditor2.maskPath = widgets.maskEditor2
end

function Vectors.ApplyScreen()
  local screen = Config.GetScreen()

  Vectors.Screen.Edge = screen.Edge
  Vectors.Screen.Factor = screen.Factor
  Vectors.Screen.Space = screen.Space
  Vectors.Screen.type = screen.type
end

function Vectors.ApplyScreenSpaceHed()
  local hedScreenSpace = Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace
  local screenType = Vectors.Screen.type

  if screenType == 169 or screenType == 219 or screenType == 329 then
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x = hedScreenSpace.Def.x
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y = hedScreenSpace.Def.y
  elseif screenType == 43 then
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x = 1920
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y = 2640
  elseif screenType == 1610 then
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.x = 1920
    Vectors.VehMasks.HorizontalEdgeDown.ScreenSpace.y = 2400
  end
end

function Vectors.ApplySizeHed()
  Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Def.x, 1, true)
end

--self:FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible)

function Vectors.ApplyPreset()
  local cname = CName.new
  local new2 = Vector2.new

  local masksController = Vectors.MaskingGlobal.masksController
  local vehMasks = Vectors.VehMasks

  local hed = vehMasks.HorizontalEdgeDown
  local mask1 = vehMasks.Mask1
  local mask2 = vehMasks.Mask2
  local mask3 = vehMasks.Mask3
  local mask4 = vehMasks.Mask4

  local hedCornersPath = cname(hed.hedCornersPath)
  local hedFillPath = cname(hed.hedFillPath)
  local hedTrackerPath = cname(hed.hedTrackerPath)
  local mask1Path = cname(mask1.maskPath)
  local mask2Path = cname(mask2.maskPath)
  local mask3Path = cname(mask3.maskPath)
  local mask4Path = cname(mask4.maskPath)

  local Preset = Config.GetWhiteBoard("Presets")
  
  Vectors.MaskingGlobal.vehicles = Preset.MaskingGlobal.vehicles

  Config.SafeMergeTables(Vectors,Preset.Vectors)

  if masksController then
    --TPP Car
    Override(masksController, 'OnFrameGenGhostingFixCameraTPPCarEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    --TPPFar Car
    Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarCarEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    --FPP Car
    Override(masksController, 'OnFrameGenGhostingFixCameraFPPCarEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    --TPP Bike
    Override(masksController, 'OnFrameGenGhostingFixCameraTPPBikeEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    --TPPFar Bike
    Override(masksController, 'OnFrameGenGhostingFixCameraTPPFarBikeEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    --FPP Bike
    Override(masksController, 'OnFrameGenGhostingFixCameraFPPBikeEvent', function(self)
      self:FrameGenGhostingFixSetSimpleTransformation(hedCornersPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.corners)
      self:FrameGenGhostingFixSetSimpleTransformation(hedFillPath, new2({X = hed.ScreenSpace.x, Y = hed.ScreenSpace.y}), new2({X = hed.Size.x, Y = hed.Size.y}), hed.Opacity.value, hed.Visible.fill)
      self:FrameGenGhostingFixSetTransformation(hedTrackerPath, new2({X = hed.ScreenSpace.Tracker.x, Y = hed.ScreenSpace.Tracker.y}), new2({X = hed.Size.Tracker.x, Y = hed.Size.Tracker.y}), hed.Rotation.tracker, new2({X = 0, Y = 0}), new2({X = 0.5, Y = 0.5}), hed.Opacity.tracker, hed.Visible.tracker)
      self:FrameGenGhostingFixSetTransformation(mask1Path, new2({X = mask1.ScreenSpace.x, Y = mask1.ScreenSpace.y}), new2({X = mask1.Size.x, Y = mask1.Size.y}), mask1.rotation, new2({X = mask1.Shear.x, Y = mask1.Shear.y}), new2({X = mask1.AnchorPoint.x, Y = mask1.AnchorPoint.y}), mask1.opacity, mask1.visible)
      self:FrameGenGhostingFixSetTransformation(mask2Path, new2({X = mask2.ScreenSpace.x, Y = mask2.ScreenSpace.y}), new2({X = mask2.Size.x, Y = mask2.Size.y}), mask2.rotation, new2({X = mask2.Shear.x, Y = mask2.Shear.y}), new2({X = mask2.AnchorPoint.x, Y = mask2.AnchorPoint.y}), mask2.opacity, mask2.visible)
      self:FrameGenGhostingFixSetTransformation(mask3Path, new2({X = mask3.ScreenSpace.x, Y = mask3.ScreenSpace.y}), new2({X = mask3.Size.x, Y = mask3.Size.y}), mask3.rotation, new2({X = mask3.Shear.x, Y = mask3.Shear.y}), new2({X = mask3.AnchorPoint.x, Y = mask3.AnchorPoint.y}), mask3.opacity, mask3.visible)
      self:FrameGenGhostingFixSetTransformation(mask4Path, new2({X = mask4.ScreenSpace.x, Y = mask4.ScreenSpace.y}), new2({X = mask4.Size.x, Y = mask4.Size.y}), mask4.rotation, new2({X = mask4.Shear.x, Y = mask4.Shear.y}), new2({X = mask4.AnchorPoint.x, Y = mask4.AnchorPoint.y}), mask4.opacity, mask4.visible)
    end)

    Override(masksController, 'FrameGenFrameGenGhostingFixVehicleToggleEvent', function(self, wrappedMethod)
      local originalFunction = wrappedMethod()

      if Vectors.MaskingGlobal.vehicles then return originalFunction end
      self:FrameGenGhostingFixVehicleToggle(false)
    end)
  end
end

return Vectors