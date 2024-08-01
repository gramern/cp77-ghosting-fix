local Vectors = {
  __NAME = "Vectors",
  __VERSION = { 5, 0, 0 },
}

local MaskingGlobal = {
  masksController = nil,
  vehicles = true,
  isLiveViewContext = false,
}

local Screen = {
  Edge = {
    down = 2160,
    left = 0,
    right = 3840,
  },
  Factor = {width = 1, height = 1},
  Space = {width = 3840, height = 2160},
  type = 169,
}

local VehElementsDef = {
  BikeSpeedometer = {
    Offset = {x = 0.0, y = 0.8, z = 0.45},
    rotation = 180,
    Scale = {x = 100, y = 100},
    Size = {x = 6120, y = 1600},
    visible = true,
  },
  BikeHandlebars = {
    Left = {
      Offset = {x = -0.6, y = 0.7, z = 0.48},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 3000, y = 1800},
      visible = true,
    },
    Right = {
      Offset = {x = 0.6, y = 0.7, z = 0.48},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 3000, y = 1800},
      visible = true,
    }
  },
  BikeWindshield = {
    Offset = {x = 0.0, y = 1, z = 0.54},
    rotation = 0,
    Scale = {x = 100, y = 100},
    Size = {x = 3600, y = 1200},
    visible = true,
  },
  CarDoors = {
    Left = {
      Offset = {x = -1.2, y = 0.55, z = 0},
      rotation = 140,
      Scale = {x = 100, y = 100},
      Size = {x = 3000, y = 2000},
      visible = true,
    },
    Right = {
      Offset = {x = 1.2, y = 0.55, z = 0},
      rotation = -160,
      Scale = {x = 100, y = 100},
      Size = {x = 2250, y = 1500},
      visible = true,
    },
  },
  CarSideMirrors = {
    Left = {
      Offset = {x = -1, y = 0.45, z = 0.65},
      rotation = 40,
      Scale = {x = 100, y = 100},
      Size = {x = 1400, y = 1200},
      visible = true,
    },
    Right = {
      Offset = {x = 1.05, y = 0.45, z = 0.65},
      rotation = 145,
      Scale = {x = 100, y = 100},
      Size = {x = 800, y = 800},
      visible = true,
    },
  },
}

local CameraData = {
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
  fovFactorFPP = nil,
  Right = nil,
  Up = nil,
}

local VehicleData = {
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
  vehicleID = nil,
  vehicleRecord = nil,
  vehicleType = nil,
  Wheel = {
    Offset = {
      Bike = {
        Back = {
          Left = {x = 0, y = -1.2, z = 0},
          Right = {x = 0, y = -1.2, z = 0}
        },
        Front = {
          Left = {x = 0, y = 1.2, z = 0},
          Right = {x = 0, y = 1.2, z = 0}
        },
      },
      Car = {
        Back = {
          Left = {x = -1.3, y = -2, z = 0},
          Right = {x = 1.3, y = -2, z = 0}
        },
        Front = {
          Left = {x = -1.3, y = 2, z = 0},
          Right = {x = 1.3, y = 2, z = 0}
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
}

local CustomizeData = {
  Bike = {
    AllMasks = {
      FPP = { visible = true },
      TPP = { visible = true }
    },
    SideMasks = {
      Scale = {x = 100, y = 100},
    },
    Windshield = {
      Scale = {x = 100, y = 100},
    },
  },
  Car = {
    FrontMask = {
      visible = true,
    },
    RearMask = {
      visible = true,
    },
    SideMasks = {
      Scale = {x = 100, y = 100},
      visible = true,
    },
  }
}

local VehMasksData = {
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
        cornersLock = false,
        fill = true,
        fillLock = false,
        tracker = true,
      },
      corners = true,
      cornersLock = false,
      fill = false,
      fillToggleValue = 0,
      tracker = true,
    }
  },
  Mask1 = {
    AnchorPoint = {x = 0.5, y = 0.5},
    Def = {
      Offset = {x = 0, y = 0, z = 0},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 0, y = 0},
      visible = true,
    },
    maskPath = "fgfix/mask1",
    Offset = {x = 0, y = 0, z = 0},
    opacity = 0,
    Position = nil,
    rotation = 0,
    Shear = {x = 0, y = 0},
    Size = {x = 0, y = 0},
    ScreenSpace = {x = 0, y = 0},
    visible = true
  },
  Mask2 = {
    AnchorPoint = {x = 0.5, y = 0.5},
    Def = {
      Offset = {x = 0, y = 0, z = 0},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 0, y = 0},
      visible = true,
    },
    maskPath = "fgfix/mask2",
    Offset = {x = 0, y = 0, z = 0},
    opacity = 0,
    Position = nil,
    rotation = 0,
    Shear = {x = 0, y = 0},
    Size = {x = 0, y = 0},
    ScreenSpace = {x = 0, y = 0},
    visible = true
  },
  Mask3 = {
    AnchorPoint = {x = 0.5, y = 0.5},
    Def = {
      Offset = {x = 0, y = 0, z = 0},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 0, y = 0},
      visible = true,
    },
    maskPath = "fgfix/mask3",
    Offset = {x = 0, y = 0, z = 0},
    opacity = 0,
    Position = nil,
    rotation = 0,
    Shear = {x = 0, y = 0},
    Size = {x = 0, y = 0},
    ScreenSpace = {x = 0, y = 0},
    visible = true
  },
  Mask4 = {
    AnchorPoint = {x = 0.5, y = 0.5},
    Cache = {
      Shear = {x = 0, y = 0},
    },
    Def = {
      Offset = {x = 0, y = 0, z = 0},
      rotation = 0,
      Scale = {x = 100, y = 100},
      Size = {x = 0, y = 0},
      visible = true,
    },
    maskPath = "fgfix/mask4",
    Offset = {x = 0, y = 0, z = 0},
    opacity = 0,
    Position = nil,
    rotation = 0,
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
}

local TrackerData = {
  baseObject = nil,
  currentSpeed = 0,
}

-- Universal methods
local Universal = {}

-- Import
local Globals = require("Modules/Globals")
local Tracker = require("Modules/Tracker")

-- Math
local abs, atan, deg, floor, max, min, pi, rad, tan = math.abs, math.atan, math.deg, math.floor, math.max, math.min, math.pi, math.rad, math.tan

----------------------------------------------------------------------------------------------------------------------
--Table getters
----------------------------------------------------------------------------------------------------------------------

-- @return table;
function Vectors.GetMaskingGlobalData()
  return MaskingGlobal
end

-- @return table;
function Vectors.GetVehElementsDef()
  return VehElementsDef
end

-- @return table;
function Vectors.GetVehMasksData()
  return VehMasksData
end

-- @return table;
function Vectors.GetCameraData()
  return CameraData
end

-- @return table;
function Vectors.GetVehicleData()
  return VehicleData
end

----------------------------------------------------------------------------------------------------------------------
-- Universal methods
----------------------------------------------------------------------------------------------------------------------

function Universal.GetLineIntersectionScreenSpace(anchorPoint, angleDeg, intersectionHorizont)
  local new4 = Vector4.new
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

function Universal.GetLineRotationScreenSpace(element1ScreenSpacePos, element2ScreenSpacePos)
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

function Universal.GetDotProduct(vector1, vector2)
  local x1, y1, z1 = vector1.x, vector1.y, vector1.z
  local x2, y2, z2 = vector2.x, vector2.y, vector2.z

  local dotProduct = (x1 * x2) + (y1 * y2) + (z1 * z2)

  return dotProduct
end

function Universal.GetMidpointPosition(pos1, pos2)
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

function Universal.GetWorldPositionFromOffset(basePosition, offsetXYZ)
  local new4 = Vector4.new
  local newPosition = new4()
  local vecVehicle = VehicleData

  local offsetX = vecVehicle.Right.x * offsetXYZ.x + vecVehicle.Forward.x * offsetXYZ.y
  local offsetY = vecVehicle.Right.y * offsetXYZ.x + vecVehicle.Forward.y * offsetXYZ.y
  local offsetZ = vecVehicle.Right.z * offsetXYZ.x + vecVehicle.Forward.z * offsetXYZ.y

  newPosition.x = basePosition.x + offsetX
  newPosition.y = basePosition.y + offsetY + vecVehicle.Up.y * offsetXYZ.z
  newPosition.z = basePosition.z + offsetZ + vecVehicle.Up.z * offsetXYZ.z
  newPosition.w = basePosition.w

  return newPosition
end

function Universal.GetWorldToScreenSpace(pos)
  local new4 = Vector4.new
  local cameraSystem = Game.GetCameraSystem()
  local screen = Screen
  local screenEdge, screenSpace = screen.Edge, screen.Space

  local worldPosition = new4(pos.x, pos.y, pos.z, 1)
  local elementPos = cameraSystem:ProjectPoint(worldPosition)
  local halfX = screenSpace.width * 0.5
  local halfY = screenSpace.height * 0.5
  local screenPos = new4((halfX + halfX * elementPos.x) + screenEdge.left, halfY - halfY * elementPos.y, 0, 0)

  return screenPos
end

----------------------------------------------------------------------------------------------------------------------
-- Data gathering methods
----------------------------------------------------------------------------------------------------------------------

local function GetTrackerData()
  TrackerData.baseObject = Tracker.GetVehicleBaseObject()
  TrackerData.currentSpeed = Tracker.GetVehicleSpeed()
end

local function GetCameraData()
  local cameraSystem = Game.GetCameraSystem()

  CameraData.fov = cameraSystem:GetActiveCameraFOV()
  CameraData.fovFactorFPP = tan(rad(51 / 2)) / tan(rad(CameraData.fov / 2))

  CameraData.Forward = cameraSystem:GetActiveCameraForward()
  CameraData.Right = cameraSystem:GetActiveCameraRight()
  CameraData.Up = cameraSystem:GetActiveCameraUp()

  CameraData.ForwardTable.Abs.z = abs(CameraData.Forward.z)
end

local function GetActivePerspective()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local currentSpeed = TrackerData.currentSpeed

  if vehicle and currentSpeed ~= nil then
    CameraData.activePerspective = vehicle:GetCameraManager():GetActivePerspective()
  end
end

local function GetVehicleRecord()
  local vecVehicle = VehicleData

  vecVehicle.vehicleRecord = vecVehicle.vehicleType:GetRecord()
  vecVehicle.vehicleID = vecVehicle.vehicleRecord:GetID()
end

local function GetDefaultBikeWheelsPositions()
  local dist = Vector4.Distance
  local vecVehicle = VehicleData
  local wheelPos,vehOffsetBike, vehPos = vecVehicle.Wheel.Position, vecVehicle.Wheel.Offset.Bike, vecVehicle.Position

  wheelPos.Back.Left = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Back.Left)
  wheelPos.Front.Left = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Front.Left)
  wheelPos.Back.Right = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Back.Right)
  wheelPos.Front.Right = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetBike.Front.Right)

  vecVehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetDefaultCarWheelsPositions()
  local dist = Vector4.Distance
  local vecVehicle = VehicleData
  local wheelPos,vehOffsetCar, vehPos = vecVehicle.Wheel.Position, vecVehicle.Wheel.Offset.Car, vecVehicle.Position

  wheelPos.Back.Left = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Back.Left)
  wheelPos.Front.Left = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Front.Left)
  wheelPos.Back.Right = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Back.Right)
  wheelPos.Front.Right = Universal.GetWorldPositionFromOffset(vehPos, vehOffsetCar.Front.Right)

  vecVehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

-- Components names 'WheelAudioEmitterBack' and 'WheelAudioEmitterFront' found in the 'Let There Be Flight' mod by Jack Humbert
local function GetBikeWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local new4 = Vector4.new
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local vecVehicle = VehicleData
  local wheelPos = vecVehicle.Wheel.Position

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

  BackPos = new4(BackPos.x, BackPos.y, vecVehicle.Position.z, BackPos.w)
  FrontPos = new4(FrontPos.x, FrontPos.y, vecVehicle.Position.z, FrontPos.w)

  wheelPos.Back.Left = BackPos
  wheelPos.Front.Left = FrontPos
  wheelPos.Back.Right = BackPos
  wheelPos.Front.Right = FrontPos

  vecVehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetVehWheelsPositions()
  local dist = Vector4.Distance
  local mtxTr = Matrix.GetTranslation
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local vecVehicle = VehicleData
  local wheelPos = vecVehicle.Wheel.Position

  if TrackerData.baseObject == 0 then
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

  wheelPos.Back.Left = Universal.GetWorldPositionFromOffset(BackLeftPos, {x = -0.4, y = 0, z = 0})
  wheelPos.Front.Left = Universal.GetWorldPositionFromOffset(FrontLeftPos, {x = -0.4, y = 0, z = 0})
  wheelPos.Back.Right = Universal.GetWorldPositionFromOffset(BackRightPos, {x = 0.4, y = 0, z = 0})
  wheelPos.Front.Right = Universal.GetWorldPositionFromOffset(FrontRightPos, {x = 0.4, y = 0, z = 0})

  vecVehicle.Wheel.wheelbase = dist(wheelPos.Back.Left, wheelPos.Front.Left)
end

local function GetVehMidpointsPositions()
  local vecVehicle = VehicleData
  local midpointPos, wheelPos = vecVehicle.Midpoint.Position, vecVehicle.Wheel.Position

  midpointPos.Back = Universal.GetMidpointPosition(wheelPos.Back.Left, wheelPos.Back.Right)
  midpointPos.Front = Universal.GetMidpointPosition(wheelPos.Front.Left, wheelPos.Front.Right)
  midpointPos.Left = Universal.GetMidpointPosition(wheelPos.Back.Left, wheelPos.Front.Left)
  midpointPos.Right = Universal.GetMidpointPosition(wheelPos.Back.Right, wheelPos.Front.Right)
end

local function GetVehBumpersPositions()
  local dist = Vector4.Distance
  local new4 = Vector4.new
  local vecVehicle = VehicleData
  local bumper = VehicleData.Bumper
  local bumperPos = bumper.Position
  local midpointPos = vecVehicle.Midpoint.Position

  local offsetBack = nil
  local offsetFront = nil

  if TrackerData.baseObject == 0 then
    bumper.offset = vecVehicle.Wheel.wheelbase
    offsetBack = new4(0, bumper.offset * -1, 0, 1)
    offsetFront = new4(0, bumper.offset, 0, 1)
  else
    bumper.offset = vecVehicle.Wheel.wheelbase * 0.178
    offsetBack = new4(0, bumper.offset * -2, 0, 1)
    offsetFront = new4(0, bumper.offset * 1.5, 0, 1)
  end

  bumperPos.Back = Universal.GetWorldPositionFromOffset(midpointPos.Back, offsetBack)
  bumperPos.Front = Universal.GetWorldPositionFromOffset(midpointPos.Front, offsetFront)
  bumper.distance = dist(bumperPos.Back, bumperPos.Front)
end

local function GetVehWheelsScreenData()
  local dist = Vector4.Distance
  local new4 = Vector4.new
  local vecVehicle = VehicleData
  local wheelPos, wheelScreen, wheelbase = vecVehicle.Wheel.Position, vecVehicle.Wheel.ScreenSpace, vecVehicle.Wheel.wheelbase

  wheelScreen.Back.Left = Universal.GetWorldToScreenSpace(wheelPos.Back.Left)
  wheelScreen.Front.Left = Universal.GetWorldToScreenSpace(wheelPos.Front.Left)
  wheelScreen.Back.Right = Universal.GetWorldToScreenSpace(wheelPos.Back.Right)
  wheelScreen.Front.Right = Universal.GetWorldToScreenSpace(wheelPos.Front.Right)

  if TrackerData.baseObject == 1 then return end
  vecVehicle.Wheel.wheelbaseScreen = dist(wheelScreen.Back.Left, wheelScreen.Front.Left)
  local wheelbasePerp = nil

  if CameraData.ForwardTable.DotProduct.Vehicle.right >= 0 then
    wheelbasePerp = Universal.GetWorldPositionFromOffset(wheelPos.Back.Left, new4(wheelbase, 0, 0, 0))
  else
    wheelbasePerp = Universal.GetWorldPositionFromOffset(wheelPos.Back.Left, new4(wheelbase * -1, 0, 0, 0))
  end

  local wheelbasePerpProjection = Universal.GetWorldToScreenSpace(wheelbasePerp)
  vecVehicle.Wheel.wheelbaseScreenPerp = dist(wheelScreen.Back.Left, wheelbasePerpProjection)
end

local function GetVehBumpersScreenData()
  local dist = Vector4.Distance
  local bumper = VehicleData.Bumper
  local bumperPos, bumperScreen = bumper.Position, bumper.ScreenSpace

  bumperScreen.Back = Universal.GetWorldToScreenSpace(bumperPos.Back)
  bumperScreen.Front = Universal.GetWorldToScreenSpace(bumperPos.Front)
  bumperScreen.distance = dist(bumperScreen.Back, bumperScreen.Front)
  bumperScreen.distanceLineRotation = Universal.GetLineRotationScreenSpace(bumperScreen.Back, bumperScreen.Front)
end

local function GetVehAxesScreenData()
  local dist = Vector4.Distance
  local vecVehicle = VehicleData
  local axis, wheelScreen = vecVehicle.Axis, vecVehicle.Wheel.ScreenSpace
  local axisLength, axisRotation = axis.ScreenLength, axis.ScreenRotation

  axisLength.left = dist(wheelScreen.Back.Left, wheelScreen.Front.Left)
  axisLength.right = dist(wheelScreen.Front.Right, wheelScreen.Back.Right)
  axisRotation.left = Universal.GetLineRotationScreenSpace(wheelScreen.Back.Left, wheelScreen.Front.Left)
  axisRotation.right = Universal.GetLineRotationScreenSpace(wheelScreen.Front.Right, wheelScreen.Back.Right)

  if TrackerData.baseObject == 0 then return end
  axisLength.back = dist(wheelScreen.Back.Left, wheelScreen.Back.Right)
  axisLength.front = dist(wheelScreen.Front.Left, wheelScreen.Front.Right)
end

local function GetVehicleData()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player) or false
  local vecVehicle = VehicleData

  if vehicle then
    vecVehicle.Position = vehicle:GetWorldPosition()
    vecVehicle.Forward = vehicle:GetWorldForward()
    vecVehicle.Right = vehicle:GetWorldRight()
    vecVehicle.Up = vehicle:GetWorldUp()
    vecVehicle.vehicleType = vehicle
    GetVehicleRecord()
  end
end

local function GetDerivativeVehicleData()
  if not Tracker.IsVehicleSupported() then return end
  GetTrackerData()
  GetVehWheelsPositions()
  GetVehMidpointsPositions()
  GetVehBumpersPositions()
  GetVehWheelsScreenData()
  GetVehBumpersScreenData()
  GetVehAxesScreenData()
end

local function GetCameraAnglesVehicle()
  local angleVeh = CameraData.ForwardTable.Angle.Vehicle.Forward
  local vecVehicle = VehicleData

  angleVeh.horizontalPlane = Vector4.GetAngleDegAroundAxis(CameraData.Forward, vecVehicle.Forward, vecVehicle.Up)
  angleVeh.medianPlane = Vector4.GetAngleDegAroundAxis(CameraData.Forward, vecVehicle.Forward, vecVehicle.Right)
end

local function GetDotProductsBackup()
  
  local cameraForward, dotVeh = CameraData.Forward, CameraData.ForwardTable.DotProduct.Vehicle
  local vecVehicle = VehicleData

  dotVeh.forward = Universal.GetDotProduct(vecVehicle.Forward, cameraForward)
  dotVeh.right = Universal.GetDotProduct(vecVehicle.Right, cameraForward)
  dotVeh.up = Universal.GetDotProduct(vecVehicle.Up, cameraForward)

  dotVeh.forwardAbs = abs(dotVeh.forward)
  dotVeh.rightAbs = abs(dotVeh.right)
  dotVeh.upAbs = abs(dotVeh.up)
end

local function GetDotProducts()
  local dot = Vector4.Dot
  
  local cameraForward, dotVeh = CameraData.Forward, CameraData.ForwardTable.DotProduct.Vehicle
  local vecVehicle = VehicleData

  dotVeh.forward = dot(vecVehicle.Forward, cameraForward) or false

  if not dotVeh.forward then
    GetDotProductsBackup()
    return
  end

  dotVeh.right = dot(vecVehicle.Right, cameraForward)
  dotVeh.up = dot(vecVehicle.Up, cameraForward)

  dotVeh.forwardAbs = abs(dotVeh.forward)
  dotVeh.rightAbs = abs(dotVeh.right)
  dotVeh.upAbs = abs(dotVeh.up)
end

----------------------------------------------------------------------------------------------------------------------
-- Transformation methods
----------------------------------------------------------------------------------------------------------------------

local function SetSizeHED(baseDimension, multiplier, isX)
  local newDimension = baseDimension
  local screenFactor = Screen.Factor

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

local function SetVisibility(isVisible)
  local vehMasks = VehMasksData
  local hedVisible, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Visible, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  hedVisible.corners = isVisible
  hedVisible.fill = isVisible
  hedVisible.tracker = isVisible
  mask1.visible = isVisible
  mask2.visible = isVisible
  mask3.visible = isVisible
  mask4.visible = isVisible
end

local function SetVisibilityDef(isVisible)
  local vehMasks = VehMasksData
  local hedVisible, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Visible.Def, vehMasks.Mask1.Def, vehMasks.Mask2.Def, vehMasks.Mask3.Def, vehMasks.Mask4.Def

  hedVisible.corners = isVisible
  hedVisible.fill = isVisible
  hedVisible.tracker = isVisible
  mask1.visible = isVisible
  mask2.visible = isVisible
  mask3.visible = isVisible
  mask4.visible = isVisible
end

------------------------------------------
--Transform By

local function TransformByFPS()
  local fillToggleValue = (Tracker.GetCurrentFPS()- 30) * 0.01
  VehMasksData.HorizontalEdgeDown.Visible.fillToggleValue = min(0.1, fillToggleValue)
end

local function TransformByPerspective()
  local hedSize = VehMasksData.HorizontalEdgeDown.Size

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    hedSize.x = hedSize.Def.x
    hedSize.y = hedSize.Def.y
  else
    hedSize.x = SetSizeHED(hedSize.Def.x, 0.92, true)
    hedSize.y = SetSizeHED(hedSize.Def.y, 1.2)
  end
end

local function TransformByVehBaseObject()
  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vehElements = VehElementsDef

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    return
  else
    if TrackerData.baseObject == 1 then
      mask1.Def = vehElements.CarSideMirrors.Left
      mask2.Def = vehElements.CarDoors.Left
      mask3.Def = vehElements.CarDoors.Right
      mask4.Def = vehElements.CarSideMirrors.Right
    else
      mask1.Def = vehElements.BikeSpeedometer
      mask2.Def = vehElements.BikeHandlebars.Left
      mask3.Def = vehElements.BikeHandlebars.Right
      mask4.Def = vehElements.BikeWindshield
    end
  end
end

local function TransformByCustomization()
  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    if TrackerData.baseObject == 1 then
      mask1.Def.visible = CustomizeData.Bike.AllMasks.TPP.visible
      mask2.Def.visible = CustomizeData.Bike.AllMasks.TPP.visible
      mask3.Def.visible = CustomizeData.Bike.AllMasks.TPP.visible
      mask4.Def.visible = CustomizeData.Bike.AllMasks.TPP.visible

      mask2.Def.Scale = CustomizeData.Bike.SideMasks.Scale
      mask3.Def.Scale = CustomizeData.Bike.SideMasks.Scale
    else
      mask2.Def.visible = CustomizeData.Car.SideMasks.visible
      mask3.Def.visible = CustomizeData.Car.SideMasks.visible
      mask4.Def.visible = CustomizeData.Car.FrontMask.visible

      mask2.Def.Scale = CustomizeData.Car.SideMasks.Scale
      mask3.Def.Scale = CustomizeData.Car.SideMasks.Scale
    end
  else
    if TrackerData.baseObject == 1 then
      mask1.Def.visible = CustomizeData.Bike.AllMasks.FPP.visible
      mask2.Def.visible = CustomizeData.Bike.AllMasks.FPP.visible
      mask3.Def.visible = CustomizeData.Bike.AllMasks.FPP.visible
      mask4.Def.visible = CustomizeData.Bike.AllMasks.FPP.visible

      mask4.Def.Scale = CustomizeData.Bike.Windshield.Scale
    end
  end
end

------------------------------------------
--Transform Properties

local function TransformPositionBike()
  local new4 = Vector4.new
  local dotVeh = CameraData.ForwardTable.DotProduct.Vehicle

  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vehVehicle = VehicleData
  local midpointPos, wheelbase = vehVehicle.Midpoint.Position, vehVehicle.Wheel.wheelbase

  --Mask1
  local mask1NewOffset = nil
  if dotVeh.forward >= 0 then
    mask1NewOffset = new4(0, 0.4, dotVeh.rightAbs * 0.5)
  else
    mask1NewOffset = new4(0, 0.4, 0.5)
  end
  mask1.Position = Universal.GetWorldPositionFromOffset(midpointPos.Left, mask1NewOffset)

  --Mask4
  local mask4NewOffset = nil
  if dotVeh.forward >= 0 then
    mask4NewOffset = new4(0, wheelbase, 0)
  else
    mask4NewOffset = new4(0, wheelbase * -1, 0)
  end
  mask4.Position = Universal.GetWorldPositionFromOffset(midpointPos.Left, mask4NewOffset)

  --Mask2
  local mask2NewOffset = new4(dotVeh.rightAbs * -0.4, dotVeh.forward * wheelbase * -0.6, dotVeh.rightAbs * -0.5)
  mask2.Position = Universal.GetWorldPositionFromOffset(midpointPos.Left, mask2NewOffset)

  --Mask3
  local mask3NewOffset = new4(dotVeh.rightAbs * 0.4, dotVeh.forward * wheelbase * -0.6, dotVeh.rightAbs * -0.5)
  mask3.Position = Universal.GetWorldPositionFromOffset(midpointPos.Right, mask3NewOffset)
end

local function TransformPositionCar()
  local new4 = Vector4.new
  local cameraForwardTable = CameraData.ForwardTable
  local dotVeh, medianPlane = cameraForwardTable.DotProduct.Vehicle, cameraForwardTable.Angle.Vehicle.Forward.medianPlane

  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vehVehicle = VehicleData
  local bumper, midpointPos, wheelbase = vehVehicle.Bumper, vehVehicle.Midpoint.Position, vehVehicle.Wheel.wheelbase

  --Mask1
  local mask1NewOffset = new4(0, dotVeh.rightAbs * bumper.offset * -0.5, 0)
  --Mask4
  local mask4NewOffset = new4(0, dotVeh.rightAbs * bumper.offset * 0.5, 0)

  if medianPlane >= 0 then
    --Mask1
    mask1NewOffset = new4(0, dotVeh.rightAbs * bumper.offset * -0.5, dotVeh.upAbs * -0.5)
    --Mask4
    mask4NewOffset = new4(0, dotVeh.rightAbs * bumper.offset * 0.5, dotVeh.upAbs * -0.5)
  end

  --Mask1
  mask1.Position = Universal.GetWorldPositionFromOffset(bumper.Position.Back, mask1NewOffset)
  --Mask4
  mask4.Position = Universal.GetWorldPositionFromOffset(bumper.Position.Front, mask4NewOffset)

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
  mask2NewOffset = new4(dotVeh.rightAbs * wheelbaseFactor * -1, dotVeh.forward * bumper.distance * -0.5, dotVeh.rightAbs * -0.5)
  mask2.Position = Universal.GetWorldPositionFromOffset(midpointPos.Left, mask2NewOffset)

  --Mask3
  local mask3NewOffset = nil
  mask3NewOffset = new4(dotVeh.rightAbs * wheelbaseFactor, dotVeh.forward * bumper.distance * -0.5, dotVeh.rightAbs * -0.5)
  mask3.Position = Universal.GetWorldPositionFromOffset(midpointPos.Right, mask3NewOffset)
end

local function TransformPosition()
  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vehVehicle = VehicleData
  local vehiclePos = vehVehicle.Position

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    if TrackerData.baseObject == 1 then
      TransformPositionCar()
    else
      TransformPositionBike()
    end
  else
    --Mask1
    mask1.Position = Universal.GetWorldPositionFromOffset(vehiclePos, mask1.Def.Offset)
    
    --Mask2
    mask2.Position = Universal.GetWorldPositionFromOffset(vehiclePos, mask2.Def.Offset)

    --Mask3
    mask3.Position = Universal.GetWorldPositionFromOffset(vehiclePos, mask3.Def.Offset)

    --Mask4
    mask4.Position = Universal.GetWorldPositionFromOffset(vehiclePos, mask4.Def.Offset)
  end
end

local function TransformScreenSpaceBike()
  local new4 = Vector4.new
  
  local activePerspective, dotForward = CameraData.activePerspective, CameraData.ForwardTable.DotProduct.Vehicle.forward

  local screenEdge = Screen.Edge
  local hedScreenSpace = VehMasksData.HorizontalEdgeDown.ScreenSpace

  local vecVehicle = VehicleData
  local axisRotation, bumperScreen, wheelScreen = vecVehicle.Axis.ScreenRotation, vecVehicle.Bumper.ScreenSpace, vecVehicle.Wheel.ScreenSpace

  --HEDTracker
  if VehMasksData.HorizontalEdgeDown.Visible.tracker then
    if activePerspective ~= vehicleCameraPerspective.TPPFar then
      local newAngle = 0

      if dotForward >= 0 then
        local difference = axisRotation.right - 90
        difference = difference * 0.5
        newAngle = 90 + difference

        hedScreenSpace.Tracker = Universal.GetLineIntersectionScreenSpace(wheelScreen.Back.Left, newAngle, screenEdge.down)
      else
        local difference = 90 - axisRotation.left
        difference = difference * -0.5
        newAngle = 90 + difference

        hedScreenSpace.Tracker = Universal.GetLineIntersectionScreenSpace(wheelScreen.Front.Left, newAngle, screenEdge.down)
      end

      hedScreenSpace.Tracker.x = max(screenEdge.left, hedScreenSpace.Tracker.x)
      hedScreenSpace.Tracker.x = min(screenEdge.right, hedScreenSpace.Tracker.x)
    else
      if dotForward >= 0 then
        hedScreenSpace.Tracker = new4(bumperScreen.Back.x, screenEdge.down, 0, 0)
      else
        hedScreenSpace.Tracker = new4(bumperScreen.Front.x, screenEdge.down, 0, 0)
      end
    end
  end
end

local function TransformScreenSpaceCar()
  local dotForward = CameraData.ForwardTable.DotProduct.Vehicle.forward
  local screenEdge = Screen.Edge
  local hedScreenSpace = VehMasksData.HorizontalEdgeDown.ScreenSpace
  local bumperScreen = VehicleData.Bumper.ScreenSpace

  --HEDTracker
  if VehMasksData.HorizontalEdgeDown.Visible.tracker then
    local newAngle = 0

    if dotForward >= 0 then
      bumperScreen.distanceLineRotationFB = Universal.GetLineRotationScreenSpace(bumperScreen.Front, bumperScreen.Back)
      local difference = bumperScreen.distanceLineRotationFB - 90
      difference = difference * 0.5
      newAngle = 90 + difference

      hedScreenSpace.Tracker = Universal.GetLineIntersectionScreenSpace(bumperScreen.Back, newAngle, screenEdge.down)
    else
      local difference = 90 - bumperScreen.distanceLineRotation
      difference = difference * -0.5
      newAngle = 90 + difference

      hedScreenSpace.Tracker = Universal.GetLineIntersectionScreenSpace(bumperScreen.Front, newAngle, screenEdge.down)
    end

    hedScreenSpace.Tracker.x = max(screenEdge.left, hedScreenSpace.Tracker.x)
    hedScreenSpace.Tracker.x = min(screenEdge.right, hedScreenSpace.Tracker.x)
  end
end

local function TransformScreenSpace()
  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    if TrackerData.baseObject == 1 then
      TransformScreenSpaceCar()
    else
      TransformScreenSpaceBike()
    end
  end

  --Mask1  
  if mask1.visible then
    mask1.ScreenSpace = Universal.GetWorldToScreenSpace(mask1.Position)
  end

  --Mask2
  if mask2.visible then
    mask2.ScreenSpace = Universal.GetWorldToScreenSpace(mask2.Position)
  end

  --Mask3
  if mask3.visible then
    mask3.ScreenSpace = Universal.GetWorldToScreenSpace(mask3.Position)
  end

  --Mask4
  if mask4.visible then
    mask4.ScreenSpace = Universal.GetWorldToScreenSpace(mask4.Position)
  end
end

local function TransformWidthBike()
  
  local dotVeh, fovFactorFPP = CameraData.ForwardTable.DotProduct.Vehicle, CameraData.fovFactorFPP

  local vehMasks = VehMasksData
  local hedSize, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Size, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local wheel = VehicleData.Wheel
  local wheelbaseScreen, wheelbaseScreenPerp = wheel.wheelbaseScreen, wheel.wheelbaseScreenPerp

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    --HED
    local newHEDx = max(0.92, dotVeh.forwardAbs ^ 0.5)
    hedSize.x = SetSizeHED(hedSize.Def.x, newHEDx, true)

    --HEDTracker
    hedSize.Tracker.x = max(wheelbaseScreen * 4, wheelbaseScreenPerp * 4)

    --Mask1
    mask1.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp)

    --Mask4
    if dotVeh.forward >= 0 then
      mask4.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp * 0.75)
    else
      mask4.Size.x = max(wheelbaseScreen, wheelbaseScreenPerp * 1.5)
    end

    --Mask2
    mask2.Size.x = max(wheelbaseScreen * (1 + dotVeh.rightAbs) * 3, wheelbaseScreenPerp * (1 + dotVeh.upAbs) * 1.5)

    --Mask3
    mask3.Size.x = mask2.Size.x
  else
    --Mask1
    mask1.Size.x = mask1.Def.Size.x * fovFactorFPP

    --Mask2
    mask2.Size.x = mask2.Def.Size.x * fovFactorFPP

    --Mask3
    mask3.Size.x = mask3.Def.Size.x * fovFactorFPP

    --Mask4
    mask4.Size.x = mask4.Def.Size.x * (mask4.Def.Scale.x * 0.01) * fovFactorFPP
  end
end

local function TransformWidthCar()
  local currentSpeed = TrackerData.currentSpeed
  local cameraForwardTable = CameraData.ForwardTable
  local activePerspective, dotVeh, medianAngle = CameraData.activePerspective, cameraForwardTable.DotProduct.Vehicle, cameraForwardTable.Angle.Vehicle.Forward.medianPlane

  local vehMasks = VehMasksData
  local hedSize, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Size, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vecVehicle = VehicleData
  local axisLength, bumpersScreenDistance = vecVehicle.Axis.ScreenLength, vecVehicle.Bumper.ScreenSpace.distance

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --HED
    if not hedSize.Def.lock then
      local newHEDx = max(0.92, dotVeh.forwardAbs ^ 0.5)
      hedSize.x = SetSizeHED(hedSize.Def.x, newHEDx, true)
    end
  
    --HEDTracker
    local hedTrackerSizeX = max(axisLength.back * 4, bumpersScreenDistance * 3)
    hedSize.Tracker.x = hedTrackerSizeX * (1 + dotVeh.rightAbs)

    if medianAngle <= 0 and dotVeh.forwardAbs >= 0.9 then
      --Mask1
      local mask1Size = min(axisLength.back * 2.5, axisLength.back * abs(medianAngle) * 0.4)
      mask1.Size.x = max(mask1Size, axisLength.back * 2)
    elseif medianAngle <= 0 and dotVeh.forward <= -0.9 then
      --Mask4
      local mask4Size = min(axisLength.front * 2.5, axisLength.front * abs(medianAngle) * 0.4)
      mask4.Size.x = max(mask4Size, axisLength.front * 2)
    else
      --Mask1
      mask1.Size.x = max(axisLength.back * 2, bumpersScreenDistance * 0.5)

      --Mask4
      mask4.Size.x = max(axisLength.front * 2, bumpersScreenDistance * 0.5)
    end

    --Mask2
    mask2.Size.x = max(axisLength.back * 0.5, axisLength.left * (4 + dotVeh.forwardAbs))

    --Mask3
    mask3.Size.x = max(axisLength.back * 0.5, axisLength.right * (4 + dotVeh.forwardAbs))
  else
    --Mask1
    if currentSpeed <= 50 then
      mask1.Size.x = mask1.Def.Size.x
    else
      mask1.Size.x = mask1.Def.Size.x * (0.5 + (currentSpeed * 0.015))
    end

    --Mask2
    mask2.Size.x = mask2.Def.Size.x

    --Mask3
    mask3.Size.x = mask3.Def.Size.x

    --Mask4
    if currentSpeed <= 50 then
      mask4.Size.x = mask4.Def.Size.x
    else
      mask4.Size.x = mask4.Def.Size.x * (0.5 + (currentSpeed * 0.01))
    end
  end
end

local function TransformWidth()
  if TrackerData.baseObject == 1 then
    TransformWidthCar()
  else
    TransformWidthBike()
  end
end

local function TransformHeightBike()
  
  local dotVeh, fovFactorFPP = CameraData.ForwardTable.DotProduct.Vehicle, CameraData.fovFactorFPP

  local vehMasks = VehMasksData
  local hedSize, hedScreenSpace, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Size, vehMasks.HorizontalEdgeDown.ScreenSpace, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vecVehicle = VehicleData
  local bumperScreen = VehicleData.Bumper.ScreenSpace

  local wheel = vecVehicle.Wheel
  local wheelbaseScreen, wheelbaseScreenPerp = wheel.wheelbaseScreen, wheel.wheelbaseScreenPerp


  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    if CameraData.activePerspective == vehicleCameraPerspective.TPPFar then
      if dotVeh.forward >= 0 then
        hedSize.Tracker.y = max(700, (hedScreenSpace.Tracker.y - bumperScreen.Back.y) * 3)
      else
        hedSize.Tracker.y = max(700, (hedScreenSpace.Tracker.y - bumperScreen.Front.y) * 3)
      end
    else
      hedSize.Tracker.y = 700
    end

    --Mask1
    if dotVeh.forward >= 0 then
      mask1.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 0.5)
    else
      mask1.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 3)
    end

    
    local mask23Size = max(wheelbaseScreen * 1.5, wheelbaseScreenPerp * 1.5)
    local mask23SizeMax = max(wheelbaseScreen * 2.5, mask23Size)

    if dotVeh.right >= 0 then
      --Mask2
      mask2.Size.y = mask23SizeMax

      --Mask3
      mask3.Size.y = max(mask23Size, mask23SizeMax * dotVeh.upAbs)
    else
      --Mask2
      mask2.Size.y = max(mask23Size, mask23SizeMax * dotVeh.upAbs)

      --Mask3
      mask3.Size.y = mask23SizeMax
    end

    --Mask4
    if dotVeh.forward >= 0 then
      mask4.Size.y = max(wheelbaseScreen, wheelbaseScreenPerp * 0.5)
    else
      mask4.Size.y = wheelbaseScreen * 2
    end
  else
    --Mask1
    mask1.Size.y = mask1.Def.Size.y * fovFactorFPP
  
    --Mask2
    mask2.Size.y = mask2.Def.Size.y * fovFactorFPP

    --Mask3
    mask3.Size.y = mask3.Def.Size.y * fovFactorFPP

    --Mask4
    mask4.Size.y = mask4.Def.Size.y * (mask4.Def.Scale.y * 0.01) * fovFactorFPP
  end
end

local function TransformHeightCar()
  local currentSpeed = TrackerData.currentSpeed
  local activePerspective, dotVeh = CameraData.activePerspective, CameraData.ForwardTable.DotProduct.Vehicle

  local vehMasks = VehMasksData
  local hedSizeTracker, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Size.Tracker, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vecVehicle = VehicleData
  local axisLength, bumpersScreenDistance, wheelbase = vecVehicle.Axis.ScreenLength, vecVehicle.Bumper.ScreenSpace.distance, vecVehicle.Wheel.wheelbase

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --HEDTracker
    hedSizeTracker.y = 1650

    if dotVeh.forward > 0 then
      --Mask1
      mask1.Size.y = max(axisLength.back * 2.5, bumpersScreenDistance * 1.5) * (1 + (dotVeh.rightAbs ^ 0.5))

      --Mask4
      mask4.Size.y = max(axisLength.back * 2, bumpersScreenDistance) * max(dotVeh.upAbs * 1.5, dotVeh.rightAbs)
    else
      --Mask1
      mask1.Size.y = bumpersScreenDistance * (1 + dotVeh.rightAbs * 0.5)

      --Mask4
      mask4.Size.y = max(axisLength.front * 1.5, bumpersScreenDistance) * (1 + dotVeh.rightAbs * 0.4)
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
      mask2.Size.y = max(bumpersScreenDistance * wheelbaseFactor, mask2Size)
    else
      mask2.Size.y = max(axisLength.back, axisLength.front)
    end

    --Mask3
    if dotVeh.right < 0.2 then
      local mask3Size = max(axisLength.back * 0.8, axisLength.front * 0.8)
      mask3.Size.y = max(bumpersScreenDistance * wheelbaseFactor, mask3Size)
    else
      mask3.Size.y = max(axisLength.back, axisLength.front)
    end
  else
    --Mask1
    if currentSpeed <= 50 then
      mask1.Size.y = mask1.Def.Size.y
    else
      mask1.Size.y = mask1.Def.Size.y * (0.5 + (currentSpeed * 0.025))
    end
    
    --Mask2
    mask2.Size.y = mask2.Def.Size.y

    --Mask3
    mask3.Size.y = mask3.Def.Size.y

    --Mask4
    if currentSpeed <= 50 then
      mask4.Size.y = mask4.Def.Size.y
    else
      mask4.Size.y = mask4.Def.Size.y * (0.5 + (currentSpeed * 0.015))
    end
  end
end

local function TransformHeight()
  if TrackerData.baseObject == 1 then
    TransformHeightCar()
  else
    TransformHeightBike()
  end
end

local function TransformRotationBike()
  
  local cameraForwardTable = CameraData.ForwardTable
  local activePerspective, dotVeh, horizontalAngle = CameraData.activePerspective, cameraForwardTable.DotProduct.Vehicle, cameraForwardTable.Angle.Vehicle.Forward.horizontalPlane

  local vehMasks = VehMasksData
  local hed, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local axisRotation = VehicleData.Axis.ScreenRotation

  if activePerspective ~= vehicleCameraPerspective.FPP then

    --HEDTracker
    hed.Rotation.tracker = 180

    --Mask1
    mask1.rotation = 90 + axisRotation.right

    if dotVeh.right < 0.05 and dotVeh.forward > 0.9 then
      --Mask2
      mask2.rotation = horizontalAngle - 90

      --Mask3
      mask3.rotation = horizontalAngle + 90
    else
      --Mask2
      mask2.rotation = axisRotation.left

      --Mask3
      mask3.rotation = axisRotation.right
    end

    --Mask4
    if dotVeh.forward >= 0 then
      mask4.rotation = 90 + axisRotation.left
    else
      mask4.rotation = 90 + axisRotation.right
    end
  else
    local steeringBarRotation = Universal.GetLineRotationScreenSpace(mask2.ScreenSpace, mask3.ScreenSpace)

    --Mask1
    mask1.rotation = mask1.Def.rotation + steeringBarRotation

    --Mask2
    mask2.rotation = mask2.Def.rotation + steeringBarRotation

    --Mask3
    mask3.rotation = mask3.Def.rotation + steeringBarRotation

    --Mask4
    mask4.rotation = mask4.Def.rotation + steeringBarRotation
  end
end

local function TransformRotationCar()
  
  local cameraForwardTable = CameraData.ForwardTable
  local activePerspective, dotForwardAbs, horizontalAngle = CameraData.activePerspective, cameraForwardTable.DotProduct.Vehicle.forwardAbs, cameraForwardTable.Angle.Vehicle.Forward.horizontalPlane

  local vehMasks = VehMasksData
  local hed, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vehVehicle = VehicleData
  local axisRotation, bumpersRotation = vehVehicle.Axis.ScreenRotation, vehVehicle.Bumper.ScreenSpace.distanceLineRotation

  if activePerspective ~= vehicleCameraPerspective.FPP then

    --HEDTracker
    hed.Rotation.tracker = 0

    --Mask1
    if dotForwardAbs >= 0.9 then
      mask1.rotation = horizontalAngle * -1
    else
      mask1.rotation = 90 + bumpersRotation
    end

    --Mask2
    mask2.rotation = axisRotation.left

    --Mask3
    mask3.rotation = axisRotation.right

    --Mask4
    mask4.rotation = horizontalAngle * -1
  else
    --Mask1
    mask1.rotation = mask1.Def.rotation

    --Mask2
    mask2.rotation = mask2.Def.rotation

    --Mask3
    mask3.rotation = mask3.Def.rotation

    --Mask4
    mask4.rotation = mask4.Def.rotation
  end
end

local function TransformRotation()
  if TrackerData.baseObject == 1 then
    TransformRotationCar()
  else
    TransformRotationBike()
  end
end

local function TransformShearCar()
  local dotVeh = CameraData.ForwardTable.DotProduct.Vehicle

  local vehMasks = VehMasksData
  local mask1, mask4 = vehMasks.Mask1, vehMasks.Mask4

  -- Mask1
  mask1.Shear.y = 0

  if dotVeh.forward > 0 then
    --Mask4
    mask4.Shear.y = dotVeh.right * 0.5
    mask4.Cache.Shear.y = mask4.Shear.y

    if dotVeh.forward < 0.5 then
      mask4.Shear.y = mask4.Cache.Shear.y * dotVeh.forwardAbs * 2
    end
  else
    --Mask4
    mask4.Shear.y = dotVeh.right * -1
    mask4.Cache.Shear.y = mask4.Shear.y

    if dotVeh.forward > -0.5 then
      mask4.Shear.y = mask4.Cache.Shear.y * dotVeh.forwardAbs * 2
    end
  end
end

local function TransformShear()
  local activePerspective = CameraData.activePerspective

  local vehMasks = VehMasksData
  local mask1, mask4 = vehMasks.Mask1, vehMasks.Mask4

  if activePerspective ~= vehicleCameraPerspective.FPP and TrackerData.baseObject == 1 then
    TransformShearCar()
  else
    mask1.Shear.y = 0
    mask4.Shear.y = 0
  end
end

local function TransformOpacityBike()
  
  local activePerspective, dotForward, dotForwardAbs, dotUpAbs = CameraData.activePerspective, CameraData.ForwardTable.DotProduct.Vehicle.forward, CameraData.ForwardTable.DotProduct.Vehicle.forwardAbs, CameraData.ForwardTable.DotProduct.Vehicle.upAbs

  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local opacityValue = vehMasks.Opacity.value
  local opacityForwardAbs, opacityUpAbs = opacityValue * dotForwardAbs, opacityValue * dotUpAbs

  if activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    if dotForward >= 0 then
      mask1.opacity = opacityValue * 0.75
    else
      mask1.opacity = opacityValue
    end

    --Mask2
    mask2.opacity = opacityValue

    --Mask3
    mask3.opacity = opacityValue

    --Mask4
    local mask4Opacity = max(opacityUpAbs, opacityForwardAbs)
    mask4.opacity = min(opacityValue, mask4Opacity) * 0.75
  else
    --Mask1
    mask1.opacity = opacityValue * 0.75

    --Mask2
    mask2.opacity = opacityValue * 0.75

    --Mask3
    mask3.opacity = opacityValue * 0.75

    --Mask4
    mask4.opacity = opacityValue
  end
end

local function TransformOpacityCar()
  local dotVeh = CameraData.ForwardTable.DotProduct.Vehicle

  local vehMasks = VehMasksData
  local mask1, mask2, mask3, mask4 = vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local opacity = vehMasks.Opacity
  local opacityGain, opacityValue = opacity.Def.gain, opacity.value
  local opacityRightAbs, opacityUpAbs = opacityValue * dotVeh.rightAbs, opacityValue * dotVeh.upAbs

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then
    --Mask1
    if dotVeh.forward < 0 then
      local mask1Opacity = max(opacityUpAbs * 2, opacityRightAbs * 1.5) * opacityGain
      mask1.opacity = min(opacityValue, mask1Opacity)
    else
      mask1.opacity = opacityValue
    end

    --Mask2
    if dotVeh.right > -0.2 or dotVeh.forward < -0.6 then
      local mask2Opacity = max(opacityUpAbs * 2, opacityRightAbs * 3) * opacityGain
      mask2.opacity = min(opacityValue, mask2Opacity)
    else
      local mask2Opacity = opacityUpAbs * 2 * opacityGain
      mask2.opacity = min(opacityValue, mask2Opacity)
    end

    --Mask3
    if dotVeh.right < 0.2 or dotVeh.forward < -0.6 then
      local mask3Opacity = max(opacityUpAbs * 2, opacityRightAbs * 3) * opacityGain
      mask3.opacity = min(opacityValue, mask3Opacity)
    else
      local mask3Opacity = opacityUpAbs * 2 * opacityGain
      mask3.opacity = min(opacityValue, mask3Opacity)
    end
    
    --Mask4
    if dotVeh.forward > 0 then
      local mask4Opacity = max(opacityUpAbs * 2, opacityRightAbs * 1.5) * opacityGain
      mask4.opacity = min(opacityValue, mask4Opacity)
    else
      mask4.opacity = opacityValue
    end
  else
    --Mask1
    mask1.opacity = opacityValue

    --Mask2
    mask2.opacity = opacityValue

    --Mask3
    mask3.opacity = opacityValue

    --Mask4
    mask4.opacity = opacityValue
  end
end

local function SetNormalizeOpacity()
  local opacity = VehMasksData.Opacity

  opacity.isNormalized = false
  opacity.normalizedValue = opacity.delayedValue
end

local function CancelNormalizeOpacity()
  VehMasksData.Opacity.isNormalized = true
end

local function NormalizeOpacity()
  local opacity = VehMasksData.Opacity

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
  local opacity = VehMasksData.Opacity

  opacity.isDelayed = true
  opacity.delayedValue = opacity.Def.max * opacity.Def.delayThreshold
end

local function ResetDelayTransformOpacity()
  local opacity = VehMasksData.Opacity

  opacity.deltaFrames = 0
  opacity.delayTime = 0
end

local function CancelDelayTransformOpacity()
  VehMasksData.Opacity.isDelayed = false
end

local function DelayTransformOpacity()
  local opacity = VehMasksData.Opacity

  if not opacity.isDelayed then return end

  if opacity.speedValue > opacity.delayedValue then
    ResetDelayTransformOpacity()
    return
  end

  opacity.value = opacity.delayedValue
  opacity.delayTime = opacity.delayTime + Tracker.GetGameDeltaTime()

  if opacity.delayTime <= opacity.Def.delayDuration then return end
  ResetDelayTransformOpacity()
  CancelDelayTransformOpacity()
  SetNormalizeOpacity()
end

local function TransformOpacity()
  local currentSpeed = TrackerData.currentSpeed
  local currentSpeedAbs = abs(currentSpeed)
  local currentSpeedAbsInt = floor(currentSpeedAbs)
  local opacity = VehMasksData.Opacity
  local opacityHED = VehMasksData.HorizontalEdgeDown.Opacity

  if not MaskingGlobal.isLiveViewContext then
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

  if TrackerData.baseObject == 1 then
    TransformOpacityCar()
  else
    TransformOpacityBike()
  end
end

local function TransformVisibility()
  
  local cameraForwardTable, fov = CameraData.ForwardTable, CameraData.fov
  local dotVeh, medianAngle = cameraForwardTable.DotProduct.Vehicle, cameraForwardTable.Angle.Vehicle.Forward.medianPlane

  local isWeapon = Tracker.IsPlayerWeapon()

  local vehMasks = VehMasksData
  local hedVisible, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown.Visible, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local vecVehicle = VehicleData
  local baseObject, vehForward = TrackerData.baseObject, vecVehicle.Forward

  hedVisible.corners = hedVisible.Def.corners
  hedVisible.tracker = hedVisible.Def.tracker
  mask1.visible = mask1.Def.visible
  mask2.visible = mask2.Def.visible
  mask3.visible = mask3.Def.visible
  mask4.visible = mask4.Def.visible

  if CameraData.activePerspective ~= vehicleCameraPerspective.FPP then

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
      mask1.visible = false
      mask2.visible = false
      mask3.visible = false
      mask4.visible = false
    end

    if baseObject == 0 then
      if medianAngle >= 0 then
        hedVisible.fill = hedVisible.Def.fill
      elseif isWeapon then
        hedVisible.fill = hedVisible.Def.fill
      elseif dotVeh.forward > 0.98 and vehForward.z < -0.12 then
        hedVisible.fill = hedVisible.Def.fill
      elseif fov > 60 and dotVeh.forwardAbs > 0.65 then
        hedVisible.fill = hedVisible.Def.fill
      else
        hedVisible.fill = hedVisible.Def.fillLock
      end
    else
      if isWeapon and dotVeh.right < -0.1 then
        hedVisible.fill = hedVisible.Def.fill
      else
        hedVisible.fill = hedVisible.Def.fillLock
      end
    end

    hedVisible.tracker = false
  end
end

local function TransformVehMasks()
  -- TransformByCustomization()
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
  TransformVisibility()
end

----------------------------------------------------------------------------------------------------------------------
-- Appliers
----------------------------------------------------------------------------------------------------------------------

local function ApplyMasksController()
  MaskingGlobal.masksController = Globals.GetMasksController()
end

local function ApplyScreen()
  local screenData = Globals.GetScreenTable()
  local screen = Screen

  screen.Edge = screenData.Edge
  screen.Factor = screenData.Factor
  screen.Space = screenData.Space
  screen.type = screenData.type
end

local function ApplyScreenSpaceHed()
  local hedScreenSpace = VehMasksData.HorizontalEdgeDown.ScreenSpace
  local screenType = Screen.type

  if screenType == 169 or screenType == 219 or screenType == 329 then
    hedScreenSpace.x = hedScreenSpace.Def.x
    hedScreenSpace.y = hedScreenSpace.Def.y
  elseif screenType == 43 then
    hedScreenSpace.x = 1920
    hedScreenSpace.y = 2640
  elseif screenType == 1610 then
    hedScreenSpace.x = 1920
    hedScreenSpace.y = 2400
  end
end

local function ApplySizeHed()
  local hedSize = VehMasksData.HorizontalEdgeDown.Size

  hedSize.x = SetSizeHED(hedSize.Def.x, 1, true)
end

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

function Vectors.OnInitialize()
  ApplyMasksController()
  ApplyScreen()
  ApplyScreenSpaceHed()
  ApplySizeHed()
end

function Vectors.OnOverlayOpen()
  ApplyMasksController()
  ApplyScreen()
  ApplyScreenSpaceHed()
  ApplySizeHed()
end

function Vectors.OnUpdate()
  if not MaskingGlobal.vehicles then return end
  GetCameraData()
  GetActivePerspective()
  GetVehicleData()
  GetDotProducts()
  GetCameraAnglesVehicle()
  GetDerivativeVehicleData()
  TransformVehMasks()
end

----------------------------------------------------------------------------------------------------------------------
-- Masking State Control
----------------------------------------------------------------------------------------------------------------------

--- Returns the masking state (on/off) for vehicles.
--
-- @param None
--
-- @returnbooleans; The masking state for vehicles.
function Vectors.GetMaskingState()
  return MaskingGlobal.vehicles
end

--- Sets the masking state (on/off) for vehicles and enables/disables Vectors.OnUpdate() (enables it to/prevents it from gathering data and transforming masks). 
--
-- @param isMasking: boolean; The new masking state to set for vehicles.
--
-- @return maskingGlobalVehicles; The updated masking state for vehicles.
function Vectors.SetMaskingState(isMasking)
  MaskingGlobal.vehicles = isMasking

  SetVisibility(isMasking)

  return MaskingGlobal.vehicles
end

--- Toggles the masking state (on/off) for vehicles and enables/disables Vectors.OnUpdate() (enables it to/prevents it from gathering data and transforming masks). 
--
-- @param None
--
-- @return maskingGlobalVehicles; The updated masking state for vehicles.
function Vectors.ToggleMaskingState()
  if MaskingGlobal.vehicles then
    MaskingGlobal.vehicles = false
    SetVisibility(false)
  else
    MaskingGlobal.vehicles = true
    SetVisibility(true)
  end

  return MaskingGlobal.vehicles
end

----------------------------------------------------------------------------------------------------------------------
-- VehMasks Customization
----------------------------------------------------------------------------------------------------------------------
------------------------------------------
-- Visibility

-- HED

function Vectors.GetVisibilityHedCorners()
  return VehMasksData.HorizontalEdgeDown.Visible.Def.corners
end

function Vectors.SetVisibilityHedCorners(isVisible)
  VehMasksData.HorizontalEdgeDown.Visible.Def.corners = isVisible
end

function Vectors.GetVisibilityHedFill()
  return VehMasksData.HorizontalEdgeDown.Visible.Def.fill
end

function Vectors.SetVisibilityHedFill(isVisible)
  VehMasksData.HorizontalEdgeDown.Visible.Def.fill = isVisible
end

function Vectors.GetLockHedFill()
  return VehMasksData.HorizontalEdgeDown.Visible.Def.fillLock
end

function Vectors.SetLockHedFill(isLock)
  VehMasksData.HorizontalEdgeDown.Visible.Def.fillLock = isLock
end

function Vectors.GetVisibilityHedTracker()
  return VehMasksData.HorizontalEdgeDown.Visible.Def.tracker
end

function Vectors.SetVisibilityHedTracker(isVisible)
  VehMasksData.HorizontalEdgeDown.Visible.Def.tracker = isVisible
end

-- Masks

function Vectors.GetVisibilityAllMasks(baseObjectString, perspective)
  if baseObjectString == "bike" then
    local persp = CustomizeData.Bike.AllMasks[perspective]

    return persp.visible
  else
    local persp = CustomizeData.Car.AllMasks[perspective]

    return persp.visible
  end
end

function Vectors.SetVisibilityAllMasks(baseObjectString, perspective, isVisible)
  if baseObjectString == "bike" then
    local persp = CustomizeData.Bike.AllMasks[perspective]
    
    persp.visible = isVisible
  else
    local persp = CustomizeData.Car.AllMasks[perspective]

    persp.visible = isVisible
  end
end

function Vectors.GetVisibilityCarFrontMask()
  return CustomizeData.Car.FrontMask.visible
end

function Vectors.SetVisibilityCarFrontMask(isVisible)
  CustomizeData.Car.FrontMask.visible = isVisible
end

function Vectors.GetVisibilityCarSideMasks()
  return CustomizeData.Car.SideMasks.visible
end

function Vectors.SetVisibilityCarSideMasks(isVisible)
  CustomizeData.Car.SideMasks.visible = isVisible
end

function Vectors.GetVisibilityCarRearMask()
  return CustomizeData.Car.RearMask.visible
end

function Vectors.SetVisibilityCarRearMask(isVisible)
  CustomizeData.Car.RearMask.visible = isVisible
end

------------------------------------------
-- Scale

function Vectors.GetScaleSideMasks(baseObjectString)
  if baseObjectString == "bike" then
    return CustomizeData.Bike.SideMasks.Scale
  else
    return CustomizeData.Car.SideMasks.Scale
  end
end

function Vectors.SetScaleSideMasks(baseObjectString, axis, scale)
  if baseObjectString == "bike" then
    CustomizeData.Bike.SideMasks.Scale[axis] = scale
  else
    CustomizeData.Car.SideMasks.Scale[axis] = scale
  end
end

function Vectors.GetScaleBikeWindshield()
  return CustomizeData.Bike.Windshield.Scale
end

function Vectors.SetScaleBikeWindshield(axis, scale)
  CustomizeData.Bike.Windshield.Scale[axis] = scale
end

----------------------------------------------------------------------------------------------------------------------
-- Editor Context
----------------------------------------------------------------------------------------------------------------------

-- @param `isContext`: boolean; Sets on/off context for live view masks editing
--
-- @return None
function Vectors.SetLiveViewContext(isContext)
  MaskingGlobal.isLiveViewContext = isContext

  VehMasksData.HorizontalEdgeDown.Opacity.Def.max = 0
  VehMasksData.Opacity.Def.max = 0
end

-- @param `isLiveView`: boolean; Sets on/off live view masks editing for HED mask's part
-- @param `...`; string; HED's part name: may be `corners`, `fill`, `tracker`
--
-- @return None
function Vectors.SetLiveViewHed(isLiveView, ...)
  if not MaskingGlobal.isLiveViewContext then return end

  if isLiveView then
    VehMasksData.HorizontalEdgeDown.Opacity.Def.max = 1
    SetVisibilityDef(false)
  else
    VehMasksData.HorizontalEdgeDown.Opacity.Def.max = 0
  end

  local hedParts = {...}

  for _, hedPart in ipairs(hedParts) do
    if VehMasksData.HorizontalEdgeDown.Visible.Def[hedPart] ~= nil then
      VehMasksData.HorizontalEdgeDown.Visible.Def[hedPart] = isLiveView
      
      Globals.PrintDebug(Vectors.__NAME, "Setting LiveView:", hedPart, "=", VehMasksData.HorizontalEdgeDown.Visible.Def[hedPart])
    end
  end
end

-- @param `isLiveView`: boolean; Sets on/off live view masks editing for a vehicle's mask
-- @param `...`; string; HED's part name: may be `Mask1`, `Mask2`, `Mask3`, `Mask4`
--
-- @return None
function Vectors.SetLiveViewMask(isLiveView, ...)
  if not MaskingGlobal.isLiveViewContext then return end

  if isLiveView then
    VehMasksData.Opacity.Def.max = 1
    SetVisibilityDef(false)
  else
    VehMasksData.Opacity.Def.max = 0
  end

  local masks = {...}

  for _, mask in ipairs(masks) do
    if VehMasksData[mask] then
      VehMasksData[mask]["Def"]["visible"] = isLiveView

      Globals.PrintDebug(Vectors.__NAME, "Setting LiveView:", mask, "=", VehMasksData[mask]["Def"]["visible"])
    end
  end
end

-- HED

-- function Vectors.GetLockHedCorners()

-- end



-- function Vectors.SetLockHedCorners(isLock)

-- end

-- -- Scale

-- function Vectors.GetWidthHed()

-- end

-- function Vectors.SetWidthHed(scaleX)

-- end

----------------------------------------------------------------------------------------------------------------------
-- Presets Loader
----------------------------------------------------------------------------------------------------------------------

-- @param `presetTable`: table; Applies new preset loaded from the give `presetTable`.
--
-- @return None
function Vectors.LoadPreset(presetTable)
  local cname = CName.new
  local new2 = Vector2.new

  local masksController = MaskingGlobal.masksController

  local vehMasks = VehMasksData
  local hed, mask1, mask2, mask3, mask4 = vehMasks.HorizontalEdgeDown, vehMasks.Mask1, vehMasks.Mask2, vehMasks.Mask3, vehMasks.Mask4

  local hedCornersPath = cname(hed.hedCornersPath)
  local hedFillPath = cname(hed.hedFillPath)
  local hedTrackerPath = cname(hed.hedTrackerPath)
  local mask1Path = cname(mask1.maskPath)
  local mask2Path = cname(mask2.maskPath)
  local mask3Path = cname(mask3.maskPath)
  local mask4Path = cname(mask4.maskPath)

  if not presetTable or presetTable == nil then Globals.Print(Vectors.__NAME,"No preset found.") return end

  MaskingGlobal.vehicles = presetTable.MaskingGlobal.vehicles
  MaskingGlobal.isLiveViewContext = presetTable.MaskingGlobal.isLiveViewContext

  if not MaskingGlobal.vehicles then SetVisibility(false) return end

  Globals.SafeMergeTables(VehElementsDef, presetTable.Vectors.VehElements)
  Globals.SafeMergeTables(VehMasksData, presetTable.Vectors.VehMasks)

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

      if MaskingGlobal.vehicles then return originalFunction end
      self:FrameGenGhostingFixVehicleToggle(false)
    end)
  end
end

return Vectors