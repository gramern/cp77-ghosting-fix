local Tracker = {
  __NAME = "Tracker",
  __VERSION = { 5, 0, 2 },
}

local GameState = {
  isFrameGen = nil,
  isGameLoaded = nil,
  isGamePaused = nil,
  isPreGame = nil,
}

local GameStateEvents = {
  gameLoaded = false,
  gamePaused = false,
  gameUnpaused = false,
}

local GameStateEventsBoard = {}

local GamePerf = {
  averageFps = nil,
  currentFps = nil,
  gameDeltaTime = nil,
}

local ModState = {
  isDynamicFrameGen = false,
  isFirstRun = false,
  isFrameGen = false,
  isNewInstall = false,
  isOpenWindow = false,
  isReady = true,
}

local Player = {
  isDriver = false,
  isMoving = false,
  isWeapon = false,
}

local Vehicle = {
  baseObject = nil,
  currentSpeed = 0,
  isMounted = false,
  isMoving = false,
  isSupported = false,
  isWeapon = false,
}

local IsVehicleMovingCheck = {
  delayTime = 1.5,
  remainingTime = nil,
  result = nil,
}

local Globals = require("Modules/Globals")

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
  Tracker.SetModNewInstall(true)
end

-- @param `isEnabled`: boolean; The current DLSS Enabler's FG state to set (`true` if it's enabled, `false` otherwise).
--
-- @return None
function Tracker.SetModFrameGeneration(isEnabled)
  ModState.isFrameGen = isEnabled

  -- Globals.PrintDebug(Tracker.__NAME, "Set Mod Frame Generation State to:", isEnabled)
end

-- @param `isEnabled`: boolean; The current DLSS Enabler's Dynamic FG state to set (`true` if it's enabled, `false` otherwise).
--
-- @return None
function Tracker.SetModDynamicFrameGeneration(isEnabled)
  ModState.isDynamicFrameGen = isEnabled

  -- Globals.PrintDebug(Tracker.__NAME, "Set Mod DynamicFrame Generation State to:", isEnabled)
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


------------------
-- GameState

-- @param `isLoaded`: boolean;
--
-- @return boolean: `true` if game can be set to loaded (isPreGame = `false`)
function Tracker.SetGameLoaded(isLoaded)
  if GameState.isPreGame then
    GameState.isGameLoaded = false
    GameStateEvents.gameLoaded = false

    return false
  end

  GameState.isGameLoaded = isLoaded

  if not isLoaded then
    GameStateEvents.gameLoaded = isLoaded
  end

  return true
end

----------------------------------------------------------------------------------------------------------------------
-- Specific Getters For Tracker's Tables
----------------------------------------------------------------------------------------------------------------------
------------------
-- Mod State

-- @return boolean: `true` if dynamic frame generation is enabled in DLSS Enabler, as retrieved in a last check
function Tracker.IsModDynamicFrameGeneration()
  return ModState.isDynamicFrameGen
end

-- @return boolean: `true` if frame generation is enabled in DLSS Enabler and is in-game
function Tracker.IsModFrameGeneration()
  if GameState.isPreGame or not GameState.isGameLoaded then return false end

  return ModState.isFrameGen
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
  return Player.isDriver
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

local function TrackGameState()
  GameState.isGamePaused = Game.GetSystemRequestsHandler():IsGamePaused()
  GameState.isPreGame = Game.GetSystemRequestsHandler():IsPreGame()
end

----------------------------------------------------------------------------------------------------------------------
-- Game State Events
----------------------------------------------------------------------------------------------------------------------

-- @paran `gameState`: string; Game state event's name to fire callback on. Available: `gamePaused`, `gameUnpaused`
-- @param `key`: string; A unique identifier for the event.
-- @param `callback`: function; The function to be called when the event fires.
-- @param `...`: any; Optional parameters to be passed to the callback function.
--
-- @return None
function Tracker.SetCallbackOnGameStateChange(gameState, key, callback, ...)
  gameState = tostring(gameState)
  key = tostring(key)

  if GameStateEventsBoard[gameState] and GameStateEventsBoard[gameState][key] then Globals.PrintError(Tracker.__NAME, key, "exists for OnGameStateChange:", gameState) return end

  local parameters = {...}

  GameStateEventsBoard[gameState] = GameStateEventsBoard[gameState] or {}

  GameStateEventsBoard[gameState][key] = {
    callback = callback,
    parameters = parameters
  }

  Globals.PrintDebug(Tracker.__NAME, "Set Callback", key, "for OnGameStateChange:", gameState)
end

-- @paran `gameState`: string; Game state event's name to fire set callbacks on. Available: `gamePaused`, `gameUnpaused`
--
-- @return None
local function ExecuteCallbackOnGameStateChange(gameState)
  gameState = tostring(gameState)

  if not next(GameStateEventsBoard) or  GameStateEventsBoard[gameState] == nil then return end

  for _, event in pairs(GameStateEventsBoard[gameState]) do
    if event.parameters then
      event.callback(unpack(event.parameters))
    else
      event.callback()
    end

    Globals.PrintDebug(Tracker.__NAME, "Callback fired:", _, "OnGameStateChange:", gameState)
  end
end

local function OnGamePaused()
  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

  Tracker.SetModFrameGeneration(false)

  ExecuteCallbackOnGameStateChange('gamePaused')
end

local function OnGameUnpaused()
  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

  Tracker.SetModFrameGeneration(DLSSEnabler_GetFrameGenerationState())

  Tracker.SetModDynamicFrameGeneration(DLSSEnabler_GetDynamicFrameGenerationState())

  ExecuteCallbackOnGameStateChange('gameUnpaused')
end

local function TrackGameStateEvents()
  if GameState.isGamePaused then
    if GameStateEvents.gamePaused then return end

    OnGamePaused()
    GameStateEvents.gamePaused = true
  else
    --- deactivating for now, may turn out handy later (needs activation and OnGameLoaded func)
    -- if GameState.isGameLoaded then
    --   if not GameStateEvents.gameLoaded then
    --     OnGameLoaded()
    --     GameStateEvents.gameLoaded = true

    --     -- Globals.PrintDebug(Tracker.__NAME, "Game Loaded.")
    --   end
    -- end

    if not GameStateEvents.gamePaused then return end

    -- set to fire with a delay to ensure accurate results
    Globals.SetDelay(1, 'TrackerOnGameUnpasued', OnGameUnpaused)
    GameStateEvents.gamePaused = false
  end
end

----------------------------------------------------------------------------------------------------------------------
-- Player Local Functions
----------------------------------------------------------------------------------------------------------------------

local function TrackPlayer()
  local player = Game.GetPlayer()
  local trackedPlayer = Player

  trackedPlayer.isMoving = player and player:IsMoving() or false --added isMoving since Game.GetPlayer():IsMoving throws nil sometimes when added to onUpdate
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
    trackedVehicle.currentSpeed = 0
    trackedVehicle.isMoving = false
    Player.isDriver = false
    return
  end

  trackedVehicle.isMounted = true
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
  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

  --Game / Mod State
  Observe('QuestTrackerGameController', 'OnInitialize', function()
    Tracker.SetGameLoaded(true)

    SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

    Tracker.SetModFrameGeneration(DLSSEnabler_GetFrameGenerationState())

    Tracker.SetModDynamicFrameGeneration(DLSSEnabler_GetDynamicFrameGenerationState())
  end)

  Observe('QuestTrackerGameController', 'OnUninitialize', function()
    Tracker.SetGameLoaded(false)

    SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

    Tracker.SetModFrameGeneration(false)
  end)

  -- Vehicle
  Observe('DriverCombatEvents', 'OnEnter', function()
    SetVehicleWeapon(true)
  end)

  Observe('DriverCombatEvents', 'OnExit', function()
    SetVehicleWeapon(false)
  end)
end

function Tracker.OnOverlayOpen()
  SetGameFrameGeneration(GameOptions.GetBool("DLSSFrameGen", "Enable"))

  if not Tracker.IsGameReady() then return end

  Tracker.SetModFrameGeneration(DLSSEnabler_GetFrameGenerationState())

  Tracker.SetModDynamicFrameGeneration(DLSSEnabler_GetDynamicFrameGenerationState())
end

function Tracker.OnUpdate()
  TrackGameState()

  TrackGameStateEvents()

  if not Tracker.IsGameReady() then return end

  TrackPlayer()

  TrackVehicle()
end

return Tracker