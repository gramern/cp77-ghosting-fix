local Tracker = {
  __NAME = "Tracker",
  __VERSION = { 5, 0, 0 },
}

local ModState = {
  isOpenWindow = false,
  isFirstRun = false,
  isFrameGen = false,
  isNewInstall = false,
  isReady = true,
}

local GameState = {
  isFrameGen = nil,
  isGameLoaded = nil,
  isGamePaused = nil,
  isPreGame = nil,
}

local GamePerf = {
  averageFps = nil,
  currentFps = nil,
  gameDeltaTime = nil,
}

local Player = {
  isDriver = nil,
  isMoving = nil,
  isWeapon = nil,
}

local Vehicle = {
  baseObject = nil,
  currentSpeed = nil,
  isMounted = nil,
  isMoving = nil,
  isSupported = nil,
  isWeapon = nil,
}

-- IsVehicleMoving-related
local IsVehicleMovingCheck = {
  delayTime = 1.5,
  remainingTime = nil,
  result = nil,
}

----------------------------------------------------------------------------------------------------------------------
-- Global Getters for Tracker's Tables
----------------------------------------------------------------------------------------------------------------------
------------------
-- Mod State

-- @return table; The ModState table containg real-time configuration of the mod
function Tracker.GetModStateTable()
  return ModState
end

------------------
-- GameState

-- @return table
function Tracker.GetGameStateTable()
  return GameState
end

------------------
-- GamePerf

-- @return table
function Tracker.GetGamePerfTable()
  return GamePerf
end

------------------
-- Player

-- @return table
function Tracker.GetPlayerTable()
  return Player
end

------------------
-- Vehicle

-- @return table
function Tracker.GetVehicleTable()
  return Vehicle
end

----------------------------------------------------------------------------------------------------------------------
-- Specific Setters for Tracker's Tables
----------------------------------------------------------------------------------------------------------------------
------------------
-- Mod State

-- @param `isReady`: boolean; The mod's ready state to set (`true` if the mod is ready, `false` otherwise).
--
-- @return None
function Tracker.SetModReady(isReady)
  ModState.isReady = isReady
end

-- @param `isFirstRun`: boolean; The first run state to set (`true` if it's the first run, `false` otherwise). Performs related actions: sets isNewInstall to `true` if `true` retrievied.
--
-- @return None
function Tracker.SetModFirstRun(isFirstRun)
  ModState.isFirstRun = isFirstRun
  if not isFirstRun then return end
  Tracker.SetNewInstall(true)
end

-- @param `isFirstRun`: boolean; The current DLSS Enabler's FG state to set (`true` if it's enabled, `false` otherwise).
--
-- @return None
function Tracker.SetModFrameGeneration(isEnabled)
  ModState.isFrameGen = isEnabled
end

-- @param `isNewInstall`: boolean; The mod's new install state to set (`true` if it's a new install, `false` otherwise). Logs a message if `true`.
--
-- @return None
function Tracker.SetModNewInstall(isNewInstall)
  ModState.isNewInstall = isNewInstall
  if not isNewInstall or ModState.isFirstRun then return end
end

-- @param `isOpenWindow`: boolean; The open window state to set (`true` to open the window, `false` to close it).
--
-- @return None
function Tracker.SetModOpenWindow(isOpenWindow)
  ModState.isOpenWindow = isOpenWindow
end

------------------
-- GamePerf

-- @param `currentFps`: number;
-- @param `gamedeltaTime`: number;
--
-- @return None
function Tracker.SetGamePerfCurrent(currentFps, gameDeltaTime)
  GamePerf.currentFps = currentFps
  GamePerf.gameDeltaTime = gameDeltaTime
end

-- @param `averageFps`: number;
--
-- @return None
function Tracker.SetGamePerfAverage(averageFps)
  GamePerf.averageFps = averageFps
end

----------------------------------------------------------------------------------------------------------------------
-- Specific Getters For Tracker's Tables
----------------------------------------------------------------------------------------------------------------------
------------------
-- Mod State

-- @return boolean: `true` if frame generation is enabled in DLSS Enabler and is in-game
--
-- NOTE: Disable logging for 'dlss-enabler-bridge-2077.dll' to avoid excessive logging when calling this function frequently
function Tracker.IsModFrameGeneration()
  if GameState.isPreGame then return false end

  -- return ModState.isFrameGen -- to be uncommented once Contextaul pass info to Tracker
  return DLSSEnabler_GetFrameGenerationState() -- to be deleted once Contextaul pass info to Tracker
end

-- @return boolean: `true` if this is the first run of the mod
function Tracker.IsModFirstRun()
  return ModState.isFirstRun
end

-- @return boolean: `true` if the mod is ready for operation
function Tracker.IsModReady()
  return ModState.isReady
end

-- @return boolean: `true` if the current installation of the mod is new
function Tracker.IsModNewInstall()
  return ModState.isNewInstall
end

-- @return boolean: `true` is the mod's window is opened
function Tracker.IsModOpenWindow()
  return ModState.isOpenWindow
end

------------------
-- GameState

-- @return boolean: `true` if player or vehicle are tracked (monitored)
function Tracker.IsGameReady()
  return GameState.isGameLoaded and not (GameState.isGamePaused or GameState.isPreGame)
end

-- @return boolean: `true` if frame generation is enabled in the game's settings (checks for OnInitialize and OnOverlayOpen, not tracked in real time)
function Tracker.IsGameFrameGeneration()
  return GameState.isFrameGen
end

-- @return boolean: `true` if game is loaded to the gameplay
function Tracker.IsGameLoaded()
  return GameState.isGameLoaded
end

-- @return boolean: `true` if game is loaded to the gameplay and is paused
function Tracker.IsGamePaused()
  return GameState.isGamePaused
end

-- @return boolean: `true` if game is in the main menu and not in the gameplay)
function Tracker.IsGamePreGame()
  return GameState.isPreGame
end

------------------
-- GamePerf

-- @return number;
function Tracker.GetCurrentFPS()
  return GamePerf.currentFps
end

-- @return number;
function Tracker.GetGameDeltaTime()
  return GamePerf.gameDeltaTime
end

------------------
-- Player

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

------------------
-- Vehicle

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

----------------------------------------------------------------------------------------------------------------------
-- Game State Local Functions
----------------------------------------------------------------------------------------------------------------------

local function SetGameFrameGeneration(isEnabled)
  GameState.isFrameGen = isEnabled
end

local function SetGameLoaded(isLoaded)
  GameState.isGameLoaded = isLoaded
end

local function TrackGameState()
  GameState.isGamePaused = Game.GetSystemRequestsHandler():IsGamePaused()
  GameState.isPreGame = Game.GetSystemRequestsHandler():IsPreGame()
end

----------------------------------------------------------------------------------------------------------------------
-- Player Local Functions
----------------------------------------------------------------------------------------------------------------------

local function TrackPlayer()
  local player = Game.GetPlayer()
  local trackedPlayer = Player

  trackedPlayer.isMoving = player:IsMoving() or nil
  trackedPlayer.isWeapon = Game.GetTransactionSystem():GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight")) and true or false
end

----------------------------------------------------------------------------------------------------------------------
-- Vehicle Local Functions
----------------------------------------------------------------------------------------------------------------------

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

  if not vehicle then
    trackedVehicle.isMounted = false
    trackedVehicle.currentSpeed = nil
    trackedVehicle.isMoving = nil
    Player.isDriver = nil
    return
  end

  trackedVehicle.isMounted = vehicle and true
  trackedVehicle.baseObject = GetVehicleBaseObject(vehicle)
  trackedVehicle.isSupported = IsVehicleSupported(trackedVehicle.baseObject)
  trackedVehicle.currentSpeed = vehicle:GetCurrentSpeed()
  trackedVehicle.isMoving = IsVehicleMoving(trackedVehicle.currentSpeed)
  Player.isDriver = vehicle:IsPlayerDriver()
end

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

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

  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))
end

function Tracker.OnOverlayOpen()
  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))
end

function Tracker.OnUpdate()
  TrackGameState()

  if not Tracker.IsGameReady() then return end
  TrackPlayer()
  TrackVehicle()
end

return Tracker