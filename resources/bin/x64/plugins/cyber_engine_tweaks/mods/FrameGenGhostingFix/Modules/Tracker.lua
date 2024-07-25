local Tracker = {
  __NAME = "Tracker",
  __VERSION = { 5, 0, 0 },
}

local GamePerf = {
  averageFps = nil,
  currentFps = nil,
  gameDeltaTime = nil,
}

local GameState = {
  isGameLoaded = nil,
  isGamePaused = nil,
  isFrameGen = nil, -- a setting, doesn't need to btracked in real time
  isPreGame = nil,
}

local Player = {
  isDriver = nil,
  isMoving = nil,
  isWeapon = nil,
}

local Vehicle = {
  baseObject = nil,
  currentSpeed = nil,
  id = nil,
  isMounted = nil,
  isMoving = nil,
  isSupported = nil,
  isWeapon = nil,
  object = nil,
}

-- IsVehicleMoving-related
local IsVehicleMovingCheck = {
  delayTime = 1.5,
  remainingTime = nil,
  result = nil,
}

------------------
-- Global Getters and Setters for Tables
------------------

-- @return table
function Tracker.GetGamePerfTable()
  return GamePerf
end

-- @param currentFps
-- @param gamedeltaTime
--
-- @return None
function Tracker.SetGamePerfCurrent(currentFps, gameDeltaTime)
  GamePerf.currentFps = currentFps
  GamePerf.gameDeltaTime = gameDeltaTime
end

-- @param averageFps
--
-- @return None
function Tracker.SetGamePerfAverage(averageFps)
  GamePerf.averageFps = averageFps
end

-- @return table
function Tracker.GetGameStateTable()
  return GameState
end

-- @return table
function Tracker.GetPlayerTable()
  return Player
end

-- @return table
function Tracker.GetVehicleTable()
  return Vehicle
end

------------------
-- Global Specific Getters
------------------

-- a setting, doesn't need to tracked in real time - should be moved
-- @return boolean: `true` if frame generation is enabled in the game's settings
function Tracker.IsGameFrameGeneration()
  return GameOptions.GetBool("DLSSFrameGen", "Enable")
end

-- @return boolean: `true` if vehicle is mounted and player is a driver
function Tracker.IsPlayerDriver()
  return Vehicle.isDriver
end

-- @return boolean: `true` if player is moving on-foot
function Tracker.IsPlayerMoving()
  return Player.isMoving
end

-- @return boolean: `true` if player has weapon drawn (on-foot and in vehicle)
function Tracker.IsPlayerWeapon()
  return Player.isWeapon
end

-- @return class: `VehicleObject` if vehicle is mounted
function Tracker.GetVehicle()
  return Vehicle.object
end

-- @return number: `0` = bike, `1` = car, `2` = tank, `3` = AV or `4` = unknown, if vehicle is mounted
function Tracker.GetVehicleBaseObject()
  return Vehicle.baseObject
end

-- @return number: current speed of vehicle if is mounted
function Tracker.GetVehicleSpeed()
  return Vehicle.currentSpeed
end

-- @return boolean: `true` if vehicle is mounted
function Tracker.IsVehicleMounted()
  return Vehicle.isMounted
end

-- @return boolean: `true` if vehicle is mounted and is moving
function Tracker.IsVehicleMoving()
  return Vehicle.isMoving
end

-- @return boolean: `true` if vehicle is mounted and is in scope of the mod's logic
function Tracker.IsVehicleSupported()
  return Vehicle.isSupported
end

-- @return boolean: `true` if weaponized vehicle is mounted and has weapons drawn
function Tracker.IsVehicleWeapon()
  return Vehicle.isWeapon
end

------------------
-- Game State
------------------

local function SetGameLoaded(isLoaded)
  GameState.isGameLoaded = isLoaded
end

local function TrackGameState()
  GameState.isGamePaused = Game.GetSystemRequestsHandler():IsGamePaused()
  GameState.isPreGame = Game.GetSystemRequestsHandler():IsPreGame()
end

------------------
-- Player
------------------

local function TrackPlayer()
  local player = Game.GetPlayer()
  local trackedPlayer = Player

  trackedPlayer.isMoving = player:IsMoving() or nil
  trackedPlayer.isWeapon = Game.GetTransactionSystem():GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight")) and true or false
end

------------------
-- Vehicle
------------------


local function GetVehicleBaseObject(vehicle)
  if vehicle:IsA("vehicleBikeBaseObject") then return 0 end
  if vehicle:IsA("vehicleCarBaseObject") then return 1 end

  if vehicle:IsA("vehicleTankBaseObject") then return 2 end
  if vehicle:IsA('vehicleAVBaseObject') then return 3 end

  return 4
end

local function IsVehicleMoving(currentSpeed)
  -- checks if a vehicle isMoving for sure and resets ongoing check and returns true if so
  if currentSpeed > 1 or currentSpeed < -1 then
    IsVehicleMovingCheck.remainingTime = nil
    IsVehicleMovingCheck.result = true
    return true -- needs to return on every tick
  end

  -- as we aren't sure we check what previous tick returned and trigger a delayed speed check if returned true
  if IsVehicleMovingCheck.result == true and IsVehicleMovingCheck.remainingTime == nil then
    IsVehicleMovingCheck.TriggerDelay()
    return true -- needs to return on every tick
  end

  -- we check if there is the ongoing check, if so, we eexecute it and keep returning true until done
  if not IsVehicleMovingCheck.result then return false else return IsVehicleMovingCheck.ExecuteDelay(currentSpeed) end -- needs to return on every tick
end

function IsVehicleMovingCheck.TriggerDelay()
  IsVehicleMovingCheck.remainingTime = IsVehicleMovingCheck.delayTime
end

function IsVehicleMovingCheck.ExecuteDelay(currentSpeed)
  if IsVehicleMovingCheck.remainingTime == nil then return true end

  IsVehicleMovingCheck.remainingTime = IsVehicleMovingCheck.remainingTime - GamePerf.gameDeltaTime
    
  if IsVehicleMovingCheck.remainingTime <= 0 then
    IsVehicleMovingCheck.remainingTime = nil

    if currentSpeed < 1 and currentSpeed > -1 then
      IsVehicleMovingCheck.result = nil
      return false
    end
  end

  return true
end

local function IsVehicleSupported(vehicleBaseObject)
  if vehicleBaseObject == 0 or vehicleBaseObject == 1 then return true end

  return false
end

local function SetVehicleWeapon(isWeapon)
  Vehicle.isWeapon = isWeapon
end

local function TrackVehicle()
  local player = Game.GetPlayer()
  local vehicle = Game.GetMountedVehicle(player)
  local trackedVehicle = Vehicle

  trackedVehicle.isMounted = vehicle and true or false
  trackedVehicle.object = vehicle

  if not vehicle then
    trackedVehicle.currentSpeed = nil
    trackedVehicle.isMoving = nil
    Player.isDriver = nil
    return
  end

  trackedVehicle.baseObject = GetVehicleBaseObject(vehicle)
  trackedVehicle.id = vehicle:GetRecord():GetID().value
  trackedVehicle.isSupported = IsVehicleSupported(trackedVehicle.baseObject)
  trackedVehicle.currentSpeed = vehicle:GetCurrentSpeed()
  trackedVehicle.isMoving = IsVehicleMoving(trackedVehicle.currentSpeed)
  Player.isDriver = vehicle:IsPlayerDriver()
end

function Tracker.OnInitialize()
  -- Game State 
  Observe('QuestTrackerGameController', 'OnInitialize', function()
    SetGameLoaded(true)
  end)

  Observe('QuestTrackerGameController', 'OnUninitialize', function()
    SetGameLoaded(false)
  end)

  -- Vehicle
  -- gramern: I'm using those methods for masking and they're effective
  Observe('DriverCombatEvents', 'OnEnter', function()
    SetVehicleWeapon(true)
  end)

  Observe('DriverCombatEvents', 'OnExit', function()
    SetVehicleWeapon(false)
  end)

  Tracker.IsGameFrameGeneration()
end

function Tracker.OnUpdate()
  TrackGameState()

  if GameState.isGamePaused or GameState.isPreGame then return end
  TrackPlayer()
  TrackVehicle()
end

return Tracker