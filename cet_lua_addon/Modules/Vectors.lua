--FrameGen Ghosting Fix 4.1.4

local Vectors = {
  Camera = {
    convergenceRound = nil,
    dotProduct = nil,
    Forward = nil,
    forwardXDiffAbs = nil,
    forwardZDiffAbs = nil,
    forwardZRound = nil,
    Right = nil,
    Up = nil
  },
  VehElements = {
    BikeHandlebars = {
      MultiplyBy = {FPP = 1},
      Offset = {x=0.0, y=0.48, z=0.85},
      Size = {
        Increment = {x = 32, y = 48},
        Max = {x = 10540, y = 4000},
        Min = {x = 7680, y = 1600},
      },
    },
    BikeWheelFront = {
      MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
      Offset = {x=0, y=0.6, z=0.5},
      Size = {
        Increment = {x = 3, y = 4},
        Max = {x = 1600, y = 1400},
        Min = {x = 1300, y = 1200},
      },
    },
    BikeWheelRear = {
      MultiplyBy = {TPPClose = 1.7, TPPMedium = 1.3, TPPFar = 1},
      Offset = {x=0, y=0.5, z=-0.6},
      Size = {
        Increment = {x = 2, y = 4},
        Max = {x = 1300, y = 1400},
        Min = {x = 1100, y = 1200},
      },
    },
    BikeWindshield = {
      MultiplyBy = {FPP = 1},
      Offset = {x=0.0, y=0.56, z=1},
      Size = {
        Increment = {x = 3, y = 8},
        Min = {x = 2400, y = 1200},
      },
    },
    CarDiffuser = {
      MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
      Offset = {x=0, y=0.2, z=-1.8},
      Size = {
        Increment = {x = 3, y = 8},
        Max = {x = 1500, y = 1300},
        Min = {x = 1200, y = 900},
      },
    },
    CarFrontBumper = {
      MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
      Offset = {x=0, y=0.2, z=2.0},
      Size = {
        Increment = {x = 3, y = 16},
        Max = {x = 1600, y = 1700},
        Min = {x = 1300, y = 900},
      },
    },
    CarSideMirrors= {
      Left = {
        MultiplyBy = {FPP = 1},
        Offset = {x=-0.95, y=0.65, z=0.45},
        Size = {
          Increment = {x = 3, y = 8},
          Min = {x = 1400, y = 1200},
        },
      },
      Right = {
        MultiplyBy = {FPP = 1},
        Offset = {x=1.05, y=0.7, z=0.45},
        Size = {
          Increment = {x = 3, y = 8},
          Min = {x = 800, y = 800},
        },
      },
    },
  },
  Screen = {
    aspectRatio = nil,
    Base = {x = 3840, y = 2160},
    Real = {x = nil, y = nil}
  },
  Vehicle = {
    activePerspective = nil,
    currentSpeed = nil,
    Forward =  nil,
    hasWeapon = nil,
    isDriver = nil,
    isMounted = nil,
    Position = nil,
    Right = nil,
    Up = nil,
    vehicleType = nil,
  },
  VehMasks = {
    AnchorPoint = {x = 0.5, y = 0.25, yMin = 0.25, yMax = 0.3, yIncrement = 0.001},
    enabled = true,
    HorizontalEdgeDown = {
      Margin = {
        Base = {left = 1920, top = 2280},
        left = 1920,
        top = 2280,
      },
      Size = {
        Base = {x = 4240, y = 1480},
        MultiplyBy = {screen = 1},
        x = 4240,
        y = 1480
      },
      visible = true
    },
    Mask1 = {
      Def = {
        MultiplyBy = {FPP = 1, TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
        Offset = {x=0, y=0, z=2},
        Size = {
          Increment = {x = 3, y = 8},
          Max = {x = 1400, y = 1200},
          Min = {x = 1100, y = 800},
        },
      },
      multiplyFactor = 1,
      Position = nil,
      Scale = {x = 100, y = 100},
      CachedScale = {x = 100, y = 100},
      Size = {x = nil, y = nil},
      ScreenSpace = {x = nil, y = nil},
      visible = true
    },
    Mask2 = {
      Def = {
        MultiplyBy = {FPP = 1, TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
        Offset = {x=0, y=-0, z=-1.6},
        Size = {
          Increment = {x = 3, y = 8},
          Max = {x = 1400, y = 1200},
          Min = {x = 1100, y = 800},
        },
      },
      multiplyFactor = 1,
      Position = nil,
      Scale = {x = 100, y = 100},
      CachedScale = {x = 100, y = 100},
      Size = {x = nil, y = nil},
      ScreenSpace = {x = nil, y = nil},
      visible = true
    },
  }
}

function Vectors.GetCameraData()
  Vectors.Camera.Forward = Game.GetCameraSystem():GetActiveCameraForward()
  Vectors.Camera.Right = Game.GetCameraSystem():GetActiveCameraRight()
  Vectors.Camera.Up = Game.GetCameraSystem():GetActiveCameraUp()
end

function Vectors.IsMounted()
  if Game['GetMountedVehicle;GameObject'](Game.GetPlayer()) then
    Vectors.Vehicle.isMounted = true
  else
    Vectors.Vehicle.isMounted = nil
  end
end

-- function Vectors.IsDriver()
--   local isDriver = Game['GetMountedVehicle;GameObject'](Game.GetPlayer()):IsPlayerDriver()
--   if isDriver then
--     Vectors.Vehicle.isDriver = isDriver
--   else
--     Vectors.Vehicle.isDriver = false
--   end
-- end

-- function Vectors.HasWeapon()
--   local hasWeapon = Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), TweakDBID.new("AttachmentSlots.WeaponRight"))
--   if hasWeapon then
--     Vectors.Vehicle.hasWeapon = true
--   else
--     Vectors.Vehicle.hasWeapon = false
--   end
-- end

function Vectors.GetVehicleData()
  if Vectors.Vehicle.isMounted then
    Vectors.Vehicle.Position = Game.GetMountedVehicle(Game.GetPlayer()):GetWorldPosition()
    Vectors.Vehicle.Forward = Game.GetMountedVehicle(Game.GetPlayer()):GetWorldForward()
    Vectors.Vehicle.Right = Game.GetMountedVehicle(Game.GetPlayer()):GetWorldRight()
    Vectors.Vehicle.Up = Game.GetMountedVehicle(Game.GetPlayer()):GetWorldUp()
    Vectors.Vehicle.vehicleType = Game.GetMountedVehicle(Game.GetPlayer())
    Vectors.Vehicle.currentSpeed = Game.GetMountedVehicle(Game.GetPlayer()):GetCurrentSpeed()
    -- Vectors.IsDriver()
    -- Vectors.HasWeapon()
  end
end

function Vectors.GetActivePerspective()
  if Vectors.Vehicle.isMounted and Vectors.Vehicle.currentSpeed ~= nil and Vectors.Vehicle.currentSpeed > 0.1 then
    Vectors.Vehicle.activePerspective = Game.GetMountedVehicle(Game.GetPlayer()):GetCameraManager():GetActivePerspective()
  end
end

function Vectors.DimensionsByVehType()
  if Vectors.Vehicle.isMounted and Vectors.Vehicle.activePerspective then
    if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
      Vectors.VehMasks.Mask2.Def = Vectors.VehElements.BikeWheelRear
      Vectors.VehMasks.Mask1.Def = Vectors.VehElements.BikeWheelFront
    else
      Vectors.VehMasks.Mask2.Def = Vectors.VehElements.CarDiffuser
      Vectors.VehMasks.Mask1.Def = Vectors.VehElements.CarFrontBumper
    end
  end
end

function Vectors.DimensionsByPersp()
  if Vectors.Vehicle.isMounted and Vectors.Vehicle.activePerspective then
    if Vectors.Vehicle.activePerspective == vehicleCameraPerspective.FPP then
      Vectors.VehMasks.Mask2.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.FPP
      Vectors.VehMasks.Mask1.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.FPP
      if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
        Vectors.VehMasks.Mask2.Def = Vectors.VehElements.BikeHandlebars
        Vectors.VehMasks.Mask1.Def = Vectors.VehElements.BikeWindshield
      else
        Vectors.VehMasks.Mask2.Def = Vectors.VehElements.CarSideMirrors.Right
        Vectors.VehMasks.Mask1.Def = Vectors.VehElements.CarSideMirrors.Left
      end
    else
      if Vectors.Vehicle.activePerspective == vehicleCameraPerspective.TPPClose or Vectors.Vehicle.activePerspective == vehicleCameraPerspective.DriverCombatClose then
        Vectors.VehMasks.Mask2.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPClose
        Vectors.VehMasks.Mask1.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPClose
      elseif Vectors.Vehicle.activePerspective == vehicleCameraPerspective.TPPFar or Vectors.Vehicle.activePerspective == vehicleCameraPerspective.DriverCombatFar then
        Vectors.VehMasks.Mask2.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPFar
        Vectors.VehMasks.Mask1.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPFar
      else
        Vectors.VehMasks.Mask2.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPMedium
        Vectors.VehMasks.Mask1.multiplyFactor = Vectors.VehMasks.Mask2.Def.MultiplyBy.TPPMedium
      end
    end
  end
end

function Vectors.DotProduct(forward1, forward2)
  local x1, y1, z1 = forward1.x, forward1.y, forward1.z
  local x2, y2, z2 = forward2.x, forward2.y, forward2.z

  local dotProduct = (x1 * x2) + (y1 * y2) + (z1 * z2)

  return dotProduct
end

function Vectors.CalculateElementPos(offset)
  local offsetX = Vectors.Vehicle.Right.x * offset.x + Vectors.Vehicle.Forward.x * offset.z
  local offsetY = Vectors.Vehicle.Right.y * offset.x + Vectors.Vehicle.Forward.y * offset.z
  local offsetZ = Vectors.Vehicle.Right.z * offset.x + Vectors.Vehicle.Forward.z * offset.z

  local elementPosX = Vectors.Vehicle.Position.x + offsetX
  local elementPosY = Vectors.Vehicle.Position.y + offsetY + Vectors.Vehicle.Up.y * offset.y
  local elementPosZ = Vectors.Vehicle.Position.z + offsetZ + Vectors.Vehicle.Up.z * offset.y
  local elementPosW = Vectors.Vehicle.Position.w

  local elementPos = Vector4.new(elementPosX, elementPosY, elementPosZ, elementPosW)

  return elementPos
end

function Vectors.WorldToScreenSpace(pos)
  local elementPos = Game.GetCameraSystem():ProjectPoint(Vector4.new(pos.x, pos.y, pos.z, 1))
  local halfX = Vectors.Screen.Base.x * 0.5
  local halfY = Vectors.Screen.Base.y * 0.5
  local screenPos = Vector4.new(halfX + halfX * elementPos.x, halfY - halfY * elementPos.y, 0, 0)

  return screenPos
end

function Vectors.ResizeVehHED(baseDimension, multiplier, isX)
  local newDimension = baseDimension

  if isX and Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen ~= 1 then
    newDimension = baseDimension * Vectors.VehMasks.HorizontalEdgeDown.Size.MultiplyBy.screen
  end

  newDimension = newDimension * multiplier
  newDimension = math.floor(newDimension)

  if isX then
    newDimension = math.max(newDimension, 3888)
  end

  return newDimension
end

function Vectors.ResizeBikeWindshieldMask()
  Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.Min.x*(Vectors.VehMasks.Mask1.Scale.x/100.0)
  Vectors.VehMasks.Mask1.Size.x = (math.floor(Vectors.VehMasks.Mask1.Size.x+0.5))
  Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.Min.y*(Vectors.VehMasks.Mask1.Scale.y/100.0)
  Vectors.VehMasks.Mask1.Size.y = (math.floor(Vectors.VehMasks.Mask1.Size.y+0.5))
end

function Vectors.SaveCache()
  Vectors.VehMasks.Mask1.CachedScale.x = Vectors.VehMasks.Mask1.Scale.x
  Vectors.VehMasks.Mask1.CachedScale.y = Vectors.VehMasks.Mask1.Scale.y
end

function Vectors.ReadCache()
  Vectors.VehMasks.Mask1.Scale.x = Vectors.VehMasks.Mask1.CachedScale.x
  Vectors.VehMasks.Mask1.Scale.y = Vectors.VehMasks.Mask1.CachedScale.y
end

function Vectors.SetWindshieldDefault()
  Vectors.VehMasks.Mask1.Scale.x = 100
  Vectors.VehMasks.Mask1.Scale.y = 100
  Vectors.ResizeBikeWindshieldMask()
end

function Vectors.ResizeVehMasks()
  local convergence = Vectors.Camera.dotProduct * 100
  Vectors.Camera.convergenceRound = math.floor(convergence+0.5)
  local convergenceAbs = math.abs(Vectors.Camera.convergenceRound)

  local forwardZ = Vectors.Camera.Forward.z * 100
  Vectors.Camera.forwardZRound = math.floor(forwardZ+0.5)
  local forwardZAbs = math.abs(Vectors.Camera.forwardZRound)

  local forwardXDiff = (Vectors.Vehicle.Forward.x - Vectors.Camera.Forward.x) * 100
  forwardXDiff = math.floor(forwardXDiff)
  Vectors.Camera.forwardXDiffAbs = math.abs(forwardXDiff)

  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    if convergenceAbs > 0 then
      Vectors.VehMasks.Mask2.Size.x = (Vectors.VehMasks.Mask2.Def.Size.Min.x * Vectors.VehMasks.Mask2.multiplyFactor) + ((100 - convergenceAbs) * (Vectors.VehMasks.Mask2.Def.Size.Increment.x * Vectors.VehMasks.Mask2.multiplyFactor))
      Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.Min.x + ((100 - convergenceAbs) * Vectors.VehMasks.Mask1.Def.Size.Increment.x)
      if Vectors.Camera.convergenceRound < 0 then
        Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.Min.x + ((100 + convergenceAbs) * Vectors.VehMasks.Mask1.Def.Size.Increment.x * 2)
      end
      Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin
    else
      Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.Min.x + ((100 - convergenceAbs) * Vectors.VehMasks.Mask2.Def.Size.Increment.x)
      Vectors.VehMasks.Mask1.Size.x = (Vectors.VehMasks.Mask1.Def.Size.Min.x * Vectors.VehMasks.Mask1.multiplyFactor) + ((100 - convergenceAbs) * (Vectors.VehMasks.Mask1.Def.Size.Increment.x * Vectors.VehMasks.Mask1.multiplyFactor))
      Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin
    end

    if forwardZ > 0 then
      Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.Min.y + (forwardZAbs * Vectors.VehMasks.Mask2.Def.Size.Increment.y)
      Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin + (forwardZAbs * Vectors.VehMasks.AnchorPoint.yIncrement * 3)
      Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top - 60
      Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.1)
      Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.95, true)
      if forwardZ > 10 then
        Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top - 120
        Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.2)
        Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.9, true)
      end
    else
      if forwardZ <= -50 then
        Vectors.VehMasks.Mask2.Size.x = (Vectors.VehMasks.Mask2.Def.Size.Min.x * Vectors.VehMasks.Mask2.multiplyFactor)
        if Vectors.Camera.convergenceRound <= -10 then
          if Vectors.Camera.convergenceRound <= -20 then
            Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.Min.x + ((100 - convergenceAbs) * (Vectors.VehMasks.Mask2.Def.Size.Increment.x * Vectors.VehMasks.Mask2.multiplyFactor))
          else
            Vectors.VehMasks.Mask2.Size.x = (Vectors.VehMasks.Mask2.Def.Size.Min.x * Vectors.VehMasks.Mask2.multiplyFactor) + ((100 - convergenceAbs) * (Vectors.VehMasks.Mask2.Def.Size.Increment.x * Vectors.VehMasks.Mask2.multiplyFactor))
          end
          Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.Min.y + ((forwardZAbs - 50) * Vectors.VehMasks.Mask2.Def.Size.Increment.y * 7)
        else
          Vectors.VehMasks.Mask2.Size.y = Vectors.VehMasks.Mask2.Def.Size.Min.y + ((forwardZAbs - 50) * Vectors.VehMasks.Mask2.Def.Size.Increment.y)
        end
        if Vectors.VehMasks.Mask1.multiplyFactor == 1 then
          Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.Min.y + ((forwardZAbs - 50) * Vectors.VehMasks.Mask1.Def.Size.Increment.y)
        else
          Vectors.VehMasks.Mask1.Size.y = (Vectors.VehMasks.Mask1.Def.Size.Min.y * Vectors.VehMasks.Mask1.multiplyFactor * 0.76) + ((forwardZAbs - 50) * Vectors.VehMasks.Mask1.Def.Size.Increment.y)
        end
        Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin + ((forwardZAbs - 50) * Vectors.VehMasks.AnchorPoint.yIncrement * 3)
      else
        Vectors.VehMasks.Mask2.Size.x = (Vectors.VehMasks.Mask2.Def.Size.Min.x * Vectors.VehMasks.Mask2.multiplyFactor) + ((100 - convergenceAbs) * (Vectors.VehMasks.Mask2.Def.Size.Increment.x * Vectors.VehMasks.Mask2.multiplyFactor))
        if Vectors.VehMasks.Mask1.multiplyFactor == 1 then
          Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.Min.y
        else
          Vectors.VehMasks.Mask1.Size.y = (Vectors.VehMasks.Mask1.Def.Size.Min.y * Vectors.VehMasks.Mask1.multiplyFactor * 0.76)
        end
        Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin
      end
      Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top
      Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1)
      Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 1, true)
    end

    if convergence < 0 then
      Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin + (convergenceAbs * Vectors.VehMasks.AnchorPoint.yIncrement * 3)
    end
  else
    if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
      if Vectors.Camera.convergenceRound > 30 then
        if Vectors.Camera.forwardXDiffAbs > 3 and Vectors.Vehicle.Forward.z < 0.10 then
          Vectors.VehMasks.Mask2.Size.x =  Vectors.VehMasks.Mask2.Def.Size.Min.x + ((Vectors.Camera.forwardXDiffAbs - 5) * Vectors.VehMasks.Mask2.Def.Size.Increment.x)
          Vectors.VehMasks.Mask2.Size.x = math.min(Vectors.VehMasks.Mask2.Size.x,Vectors.VehElements.BikeHandlebars.Size.Max.x)
          Vectors.VehMasks.Mask2.Size.y =  Vectors.VehMasks.Mask2.Def.Size.Min.y + ((Vectors.Camera.forwardXDiffAbs - 5) * Vectors.VehMasks.Mask2.Def.Size.Increment.y)
          Vectors.VehMasks.Mask2.Size.y = math.min(Vectors.VehMasks.Mask2.Size.y,Vectors.VehElements.BikeHandlebars.Size.Max.y)
        else
          Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.Min.x
          Vectors.VehMasks.Mask2.Size.y =  Vectors.VehMasks.Mask2.Def.Size.Min.y
        end
      else
        Vectors.VehMasks.Mask2.Size.x = 0
        Vectors.VehMasks.Mask2.Size.y = 0
      end
      Vectors.ResizeBikeWindshieldMask()
      Vectors.VehMasks.AnchorPoint.y = 0.5
      Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top - 60
      Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.2)
      Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.95, true)
    elseif Vectors.Vehicle.vehicleType:IsA("vehicleCarBaseObject") then
      Vectors.VehMasks.Mask2.Size.x = Vectors.VehMasks.Mask2.Def.Size.Min.x
      Vectors.VehMasks.Mask2.Size.y =  Vectors.VehMasks.Mask2.Def.Size.Min.y
      Vectors.VehMasks.Mask1.Size.x = Vectors.VehMasks.Mask1.Def.Size.Min.x
      Vectors.VehMasks.Mask1.Size.y = Vectors.VehMasks.Mask1.Def.Size.Min.y
      Vectors.VehMasks.AnchorPoint.y = Vectors.VehMasks.AnchorPoint.yMin
      Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top + 60
      if Vectors.Camera.Forward.z < - 0.05 and Vectors.Camera.convergenceRound < 97 then
        Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.6)
        Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.98, true)
      else
        Vectors.VehMasks.HorizontalEdgeDown.Size.y = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.y, 1.2)
        Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 0.95, true)
      end
    else
      Vectors.VehMasks.HorizontalEdgeDown.Margin.top = Vectors.VehMasks.HorizontalEdgeDown.Margin.Base.top + 120
      Vectors.VehMasks.HorizontalEdgeDown.Size.x = Vectors.ResizeVehHED(Vectors.VehMasks.HorizontalEdgeDown.Size.Base.x, 1.2, true)
    end
  end
end

function Vectors.SetVisibleVehMasks()
  if Vectors.Vehicle.activePerspective ~= vehicleCameraPerspective.FPP then
    Vectors.VehMasks.Mask2.visible = true
    Vectors.VehMasks.Mask1.visible = true
    if Vectors.Camera.Forward.z < -0.85 then
      Vectors.VehMasks.HorizontalEdgeDown.visible = false
    else
      Vectors.VehMasks.HorizontalEdgeDown.visible = true
    end
  else
    if Vectors.Vehicle.vehicleType:IsA("vehicleBikeBaseObject") then
      Vectors.VehMasks.Mask2.visible = true
      Vectors.VehMasks.Mask1.visible = true
      if Vectors.Camera.Forward.z < 0.05 then
        Vectors.VehMasks.HorizontalEdgeDown.visible = true
      else
        Vectors.VehMasks.HorizontalEdgeDown.visible = false
      end
    elseif Vectors.Vehicle.vehicleType:IsA("vehicleCarBaseObject") then
      Vectors.VehMasks.Mask2.visible = true
      Vectors.VehMasks.Mask1.visible = true
      if Vectors.Camera.Forward.z < - 0.05 and Vectors.Camera.convergenceRound < 97 then
        Vectors.VehMasks.HorizontalEdgeDown.visible = true
      else
        Vectors.VehMasks.HorizontalEdgeDown.visible = false
      end
    else
      Vectors.VehMasks.Mask2.visible = false
      Vectors.VehMasks.Mask1.visible = false
      Vectors.VehMasks.HorizontalEdgeDown.visible = false
    end
  end
end

function Vectors.ProjectMasks()
  Vectors.GetCameraData()

  if Vectors.Vehicle.isMounted and Vectors.VehMasks.enabled then
    Vectors.GetVehicleData()
    Vectors.DimensionsByVehType()
    Vectors.Camera.dotProduct = Vectors.DotProduct(Vectors.Vehicle.Forward, Vectors.Camera.Forward)
    Vectors.GetActivePerspective()
    Vectors.DimensionsByPersp()
    Vectors.ResizeVehMasks()
    Vectors.SetVisibleVehMasks()

    if Vectors.VehMasks.Mask2.visible then
      Vectors.VehMasks.Mask2.Position = Vectors.CalculateElementPos(Vectors.VehMasks.Mask2.Def.Offset)
      local mask2Pos = Vectors.WorldToScreenSpace(Vectors.VehMasks.Mask2.Position)
      Vectors.VehMasks.Mask2.ScreenSpace.x = mask2Pos.x
      Vectors.VehMasks.Mask2.ScreenSpace.y = mask2Pos.y
    end

    if Vectors.VehMasks.Mask1.visible then
      Vectors.VehMasks.Mask1.Position = Vectors.CalculateElementPos(Vectors.VehMasks.Mask1.Def.Offset)
      local mask1Pos = Vectors.WorldToScreenSpace(Vectors.VehMasks.Mask1.Position)
      Vectors.VehMasks.Mask1.ScreenSpace.x = mask1Pos.x
      Vectors.VehMasks.Mask1.ScreenSpace.y = mask1Pos.y
    end
  end
end

return Vectors
