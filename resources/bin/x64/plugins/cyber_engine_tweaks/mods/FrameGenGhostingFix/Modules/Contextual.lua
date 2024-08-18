local Contextual = {
  __NAME = "Contextual",
  __VERSION = { 5, 1, 4 },
}

local isDebug = nil

local isDLSSEnabler
local versionDLSSEnabler
local versionRequired

local FGEnabled = false

-- keeps current context to avoid unwanted context changes for sudden switches between locamotion states
local isOnHold = false
local timeOnHold = 0

local Contexts = {
  Sightseeing = false,
  SlowPacedAndCinematics = false,
  FastPaced = false,
  MyOwn = false,
  BaseFps = 0,
}

local CurrentStates = {
  isVehicleStatic = false,
  isVehicleDriving = false,
  isVehicleStaticCombat = false,
  isVehicleDrivingCombat = false,
  isStandingCrouching = false,
  isWalkingCrouchWalking = false,
  isSprintingCrouchSprinting = false,
  isSlowWalking = false,
  isSwimming = false,
  isCombat = false,
  isBraindance = false,
  isCinematic = false,
  isPhotoMode = false,
}

local Toggles = {
  Vehicle = {
    Static = false,
    Driving = false,
    StaticCombat = false,
    DrivingCombat = false,
  },
  Standing = false,
  Walking = false,
  SlowWalking = false,
  Sprinting = false,
  Swimming = false,
  Combat = false,
  Braindance = false,
  Cinematic = false,
  Photomode = false,
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Tracker = require("Modules/Tracker")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")

local ContextualText = Localization.GetContextualText()
local GeneralText = Localization.GetGeneralText()
local SettingsText = Localization.GetSettingsText()

------------------
-- User Settings
------------------

local function GetUserSettings()
  local userSettings = {
    Contexts = Contexts,
    Toggles = Toggles,
  }

  return userSettings
end

local function LoadUserSettings(userSettings)
  if not userSettings or userSettings == nil then return end

  Globals.SafeMergeTables(Contexts, userSettings.Contexts)
  Globals.SafeMergeTables(Toggles, userSettings.Toggles)
end

local function SaveUserSettings()
  Settings.WriteUserSettings("Contextual", GetUserSettings())
end

------------------
-- Local Debug Mode Setter
------------------

-- @param `isDebugMode`: boolean; Sets internal debug variable to `true` or `false`
--
-- @return None
function SetDebugMode(isDebugMode)
  isDebug = isDebugMode
end

------------------
-- Getters
------------------

-- @return number;
function Contextual.GetBaseFpsContext()
  return Contexts.BaseFps
end

------------------
-- Main Logic Starts Here
------------------

local function TurnOffFrameGen()
  if not Tracker.IsGameReady() then return end

  -- Only call external DLSSEnabler_SetFrameGeneration method once to avoid overhead
  if FGEnabled == true then
    DLSSEnabler_SetFrameGenerationState(false)
    FGEnabled = false
    Tracker.SetModFrameGeneration(false)
  end
end

local function TurnOnFrameGen()
  if not Tracker.IsGameReady() then return end

  -- Community Request: adding global FG disable on Contexts.BaseFps ~= 0
  if Tracker.GetCurrentFpsInteger() and Tracker.GetCurrentFpsInteger() < Contexts.BaseFps then return end

  -- Only call external DLSSEnabler_SetFrameGeneration method once to avoid overhead
  if FGEnabled == false then
    DLSSEnabler_SetFrameGenerationState(true)
    FGEnabled = true
    Tracker.SetModFrameGeneration(true)
  end
end

local function InitializeFrameGenState()
  FGEnabled = DLSSEnabler_GetFrameGenerationState()

  if Contexts.BaseFps then
    TurnOnFrameGen()
  end

  if Toggles.Standing then
    TurnOffFrameGen()
  end

  Globals.PrintDebug(Contextual.__NAME, "Frame Generation set to initial state:", FGEnabled)
end

function ToggleFrameGenOnBaseFpsContext()
  if Tracker.GetCurrentFpsInteger() and Tracker.GetCurrentFpsInteger() < Contexts.BaseFps then
    TurnOffFrameGen()
  else
    TurnOnFrameGen()
  end
end

local function KeepOnHold(timeSeconds)
  if isOnHold then
    timeOnHold = timeOnHold - Tracker.GetGameDeltaTime()

    if timeOnHold > 0 then return end
  
    isOnHold = false

    if not isDebug then return end
    local msg = "[" .. FrameGenGhostingFix.__NAME .. "] [Debug] [" .. Contextual.__NAME .. "] Previous context released."
    print(msg)
    spdlog.debug(msg)
  else
    isOnHold = true
    timeOnHold = timeSeconds

    if not isDebug then return end
    local msg = "[" .. FrameGenGhostingFix.__NAME .. "] [Debug] [" .. Contextual.__NAME .. "] Keeping previous context on hold for: " .. timeSeconds .. " seconds."
    print(msg)
    spdlog.debug(msg)
  end
end

-- Make the first letter capital
local function Capitalize(str)
  return (str:gsub("^%l", string.upper))
end

local function StringifyStates()
  return "VehicleStatic: " .. Capitalize(tostring(CurrentStates.isVehicleStatic)) ..
  "\n" .. "VehicleDriving: " .. Capitalize(tostring(CurrentStates.isVehicleDriving)) ..
  "\n" .. "VehicleStaticCombat: " .. Capitalize(tostring(CurrentStates.isVehicleStaticCombat)) ..
  "\n" .. "VehicleDrivingCombat: " .. Capitalize(tostring(CurrentStates.isVehicleDrivingCombat)) ..
  "\n" .. "Standing: " .. Capitalize(tostring(CurrentStates.isStandingCrouching)) ..
  "\n" .. "WalkingCrouchWalking: " .. Capitalize(tostring(CurrentStates.isWalkingCrouchWalking)) ..
  "\n" .. "SprintingCrouchSprinting: " .. Capitalize(tostring(CurrentStates.isSprintingCrouchSprinting)) ..
  "\n" .. "SlowWalking: " .. Capitalize(tostring(CurrentStates.isSlowWalking)) ..
  "\n" .. "Swimming: " .. Capitalize(tostring(CurrentStates.isSwimming)) ..
  "\n" .. "Combat: " .. Capitalize(tostring(CurrentStates.isCombat)) ..
  "\n" .. "Braindance: " .. Capitalize(tostring(CurrentStates.isBraindance)) ..
  "\n" .. "Cinematic: " .. Capitalize(tostring(CurrentStates.isCinematic)) ..
  "\n" .. "PhotoMode: " .. Capitalize(tostring(CurrentStates.isPhotoMode))
end

local function GetPlayerVehicle()
  local playerVehicle = GetMountedVehicle(GetPlayer())
  if not playerVehicle then
    Globals.PrintDebug(Contextual.__NAME, "Player vehicle cannot be retreived. Subsequent vehicle operations won't work.")
  end
  return playerVehicle
end

local function OnPlayerDriverEvent()
  CurrentStates.isStandingCrouching = false
  CurrentStates.isWalkingCrouchWalking = false
  CurrentStates.isSprintingCrouchSprinting = false
  CurrentStates.isSlowWalking = false
end

local function IsPlayerInVehicleCombat()
  if Tracker.IsVehicleMounted() and Tracker.IsPlayerWeapon() or Tracker.IsVehicleWeapon() then return true end
end

local function IsPlayerSwimming()
  local player = Game.GetPlayer()
  if player == nil then return false end
  return player:IsSwimming()
end

-- NotInBaseLocomotion = 0
-- Stand = 1
-- AimWalk = 2
-- Crouch = 3
-- Sprint = 4
-- Slide = 5
-- SlideFall = 6
-- Dodge = 7
-- Climb = 8
-- Vault = 9
-- Ladder = 10
-- LadderSprint = 11
-- LadderSlide = 12
-- LadderJump = 13
-- Fall = 14
-- AirThrusters = 15
-- AirHover = 16
-- SuperheroFall = 17
-- Jump = 18
-- DoubleJump = 19
-- ChargeJump = 20
-- HoverJump = 21
-- DodgeAir = 22
-- RegularLand = 23
-- HardLand = 24
-- VeryHardLand = 25
-- DeathLand = 26
-- SuperheroLand = 27
-- SuperheroLandRecovery = 28
-- Knockdown = 29
-- CrouchSprint = 30
-- Felled = 31
function LocomotionState()
  local player = Game.GetPlayer()
  if not player then
    return 0
  end

  local blackboardDefs = Game.GetAllBlackboardDefs()
  local blackboardSystem = Game.GetBlackboardSystem()
  local blackboardPSM = blackboardSystem:GetLocalInstanced(player:GetEntityID(), blackboardDefs.PlayerStateMachine)
  return blackboardPSM:GetInt(blackboardDefs.PlayerStateMachine.LocomotionDetailed)
end

--- gramern: this turns out redundant since Tracker.IsPlaerMoving() is goin on anyway and locomotion state = 1 isn't the one to trust
-- local function IsPlayerStandingCrouching()
--   return not Tracker.IsPlayerMoving()
-- end

-- gramern: Changed logic for "Walking" sice the game seems to report some locomotion states wrongly and despite Tracker.IsPlayerMoving() = true, "Walking" state didn't trigger
-- gramern: Added "Crouch Walking" to "Walking"
local function IsPlayerWalking()
  return Tracker.IsPlayerMoving() and LocomotionState() ~= 4 and LocomotionState() ~= 30 or Tracker.IsPlayerMoving() and Game.GetPlayer().inCrouch and LocomotionState() ~= 30
end

-- gramern: Separated "Slow Walking" from "Crouch Walking", since there is no exclusive state for "Crouch Slow Walking":
-- new states:
-- Standing
-- Walking/Crouch Walking
-- Sprinting/Crouch Spriting
-- SlowWalking
local function IsPlayerSlowWalking()
  return LocomotionState() == 3 and not Game.GetPlayer().inCrouch
end

-- gramern: Added Tracker.IsPlayerMoving() as an additional check it seems to be more robust than locomotion states
local function IsPlayerSprinting()
  return Tracker.IsPlayerMoving() and LocomotionState() == 4 or LocomotionState() == 4 and LocomotionState() == 18 or LocomotionState() == 30 or LocomotionState() == 22
end

local function IsPlayerInBraindance()
  local blackboardDefs = Game.GetAllBlackboardDefs()
  local blackboardBD = Game.GetBlackboardSystem():Get(blackboardDefs.Braindance)

  return blackboardBD:GetBool(blackboardDefs.Braindance.IsActive)
end

local function IsInCombat()
	local combatState = tonumber(EnumInt(Game.GetPlayer().GetCurrentCombatState(Game.GetPlayer())))
  -- InCombat
	return combatState == 1
end

local function IsInPhotoMode()
  local photoMode = Game.GetAllBlackboardDefs().PhotoMode
  return Game.GetBlackboardSystem():Get(photoMode):GetBool(photoMode.IsActive)
end

local function IsInCinematic()
  local player = Game.GetPlayer()

  -- This one shows inaccurate results (i.e., the last scene tier when player was active)
	-- local sceneTier = Game.GetPlayer().GetSceneTier(player)

  local blackboardDefs = Game.GetAllBlackboardDefs()
  local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(player:GetEntityID(), blackboardDefs.PlayerStateMachine)

  -- Tier5_Cinematic
	return blackboardPSM:GetInt(blackboardDefs.PlayerStateMachine.SceneTier) == 5
end

-- Not used currently but may be helpful in the future
local function IsInHostileZone()
	local zoneType = tonumber(EnumInt(Game.GetPlayer():GetCurrentSecurityZoneType(Game.GetPlayer())))
	return zoneType == 3 or zoneType == 4
end

-- Not used currently but may be helpful in the future
local function IsWeaponDrawn()
	return Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), "AttachmentSlots.WeaponRight") ~= nil
end

local function ShouldAffectFGState(feature)
  local stateMap = {
    Vehicle = {
      Static = CurrentStates.isVehicleStatic,
      Driving = CurrentStates.isVehicleDriving,
      StaticCombat = CurrentStates.isVehicleStaticCombat,
      DrivingCombat = CurrentStates.isVehicleDrivingCombat,
    },
    Standing = CurrentStates.isStandingCrouching,
    Walking = CurrentStates.isWalkingCrouchWalking,
    SlowWalking = CurrentStates.isSlowWalking,
    Sprinting = CurrentStates.isSprintingCrouchSprinting,
    Swimming = CurrentStates.isSwimming,
    Combat = CurrentStates.isCombat,
    Braindance = CurrentStates.isBraindance,
    Cinematic = CurrentStates.isCinematic,
    Photomode = CurrentStates.isPhotoMode,
  }

  if string.find(feature, "%.") then
    local first, second
    first, second = feature:match"([^.]*).(.*)"
    -- delete the key
    stateMap[first][second] = nil
  else
    -- delete the key
    stateMap[feature] = nil
  end

  for toggle, value in pairs(stateMap) do
    if toggle == "Vehicle" then
      for vehicleToggle, vehicleValue in pairs(stateMap.Vehicle) do
        if Toggles.Vehicle[vehicleToggle] and vehicleValue then
          Globals.PrintDebug(Contextual.__NAME, "Vehicle State '" .. vehicleToggle .. "' is present and currently toggled. FG state will not change.")
          return false
        end
      end
    else
      if Toggles[toggle] and value then
        Globals.PrintDebug(Contextual.__NAME, "State '" .. toggle .. "' is present and currently toggled. FG state will not change.")
        return false
      end
    end
  end

  return true
end

local function SetVehicleStatic(feature)
  if CurrentStates.isVehicleStatic or not Tracker.IsVehicleMoving() then
    if not ShouldAffectFGState("Vehicle.Static") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleDriving(feature)
  if CurrentStates.isVehicleDriving or Tracker.IsVehicleMoving() then
    if not ShouldAffectFGState("Vehicle.Driving") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleStaticCombat(feature)
  if CurrentStates.isVehicleStaticCombat or IsPlayerInVehicleCombat() and not Tracker.IsVehicleMoving() then
    if not ShouldAffectFGState("Vehicle.StaticCombat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleDrivingCombat(feature)
  if CurrentStates.isDrivingCombat or IsPlayerInVehicleCombat() and Tracker.IsVehicleMoving() then
    if not ShouldAffectFGState("Vehicle.DrivingCombat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetStandingCrouching(feature)
  -- V is in Standing state even when Player is in Vehicle because LocomotionEventsTransition events still trigger
  local playerVehicle = GetPlayerVehicle()
  if playerVehicle ~= nil then return end

  if CurrentStates.isStandingCrouching then
    if not ShouldAffectFGState("Standing") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetWalking(feature)
  if CurrentStates.isWalkingCrouchWalking or IsPlayerWalking() then
    if not ShouldAffectFGState("Walking") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSlowWalking(feature)
  if CurrentStates.isSlowWalking or IsPlayerSlowWalking() then
    if not ShouldAffectFGState("SlowWalking") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSprinting(feature)
  if CurrentStates.isSprintingCrouchSprinting or IsPlayerSprinting() then
    if not ShouldAffectFGState("Sprinting") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSwimming(feature)
  if CurrentStates.isSwimming or IsPlayerSwimming() then
    if not ShouldAffectFGState("Swimming") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCombat(feature)
  if CurrentStates.isCombat or IsInCombat() then
    if not ShouldAffectFGState("Combat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetBraindance(feature)
  if CurrentStates.isBraindance or IsPlayerInBraindance() then
    if not ShouldAffectFGState("Braindance") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCinematic(feature)
  if CurrentStates.isCinematic or IsInCinematic() then
    if not ShouldAffectFGState("Cinematic") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end


local function SetPhotoMode(feature)
  if CurrentStates.isPhotoMode or IsInPhotoMode()  then
    -- Photo mode is exclusive, so no need to check for other states
    -- if not ShouldAffectFGState("PhotoMode") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

function HandleStaticAndDrivingStates()
  if Tracker.IsVehicleMoving() then
    CurrentStates.isVehicleStatic = false
    CurrentStates.isVehicleDriving = true
    CurrentStates.isVehicleStaticCombat = false
    CurrentStates.isVehicleDrivingCombat = false
  else
    CurrentStates.isVehicleStatic = true
    CurrentStates.isVehicleDriving = false
  end

  -- Drive events are also present during photo mode
  -- We need special handling here to turn on FG if those toggles are not checked
  if CurrentStates.isPhotoMode then
    if Toggles.Photomode then
      return
    else
      TurnOnFrameGen()
      return
    end
  end

  if Toggles.Vehicle.Static == true then
    if CurrentStates.isVehicleStatic then
      TurnOffFrameGen()
    else
      if not Toggles.Vehicle.Driving and CurrentStates.isVehicleDriving then
        TurnOnFrameGen()
      end
    end
  end

  if Toggles.Vehicle.Driving == true then
    if CurrentStates.isVehicleDriving then
      TurnOffFrameGen()
    else
      if not Toggles.Vehicle.Static and CurrentStates.isVehicleStatic then
        TurnOnFrameGen()
      end
    end
  end
end

---------------
-- Context groups togglers
---------------

local function ResetToggles(togglesTable)
  for state, v in pairs(togglesTable) do
    if type(v) == "table" then
      ResetToggles(v)
    else
      togglesTable[state] = false
    end
  end
end

local function ToggleSightseeing()
  SetStandingCrouching(Contexts.Sightseeing)
  Toggles.Standing = Contexts.Sightseeing
  SetSlowWalking(Contexts.Sightseeing)
  Toggles.SlowWalking = Contexts.Sightseeing
  SetPhotoMode(Contexts.Sightseeing)
  Toggles.Photomode = Contexts.Sightseeing

  if Toggles.Standing and
    Toggles.SlowWalking and
    Toggles.Photomode then

    Contexts.Sightseeing = true
  else
    Contexts.Sightseeing = false
  end
end

local function ToggleSlowPaced()
  SetWalking(Contexts.SlowPacedAndCinematics)
  Toggles.Walking = Contexts.SlowPacedAndCinematics
  SetSwimming(Contexts.SlowPacedAndCinematics)
  Toggles.Swimming = Contexts.SlowPacedAndCinematics
  SetVehicleStatic(Contexts.SlowPacedAndCinematics)
  Toggles.Vehicle.Static = Contexts.SlowPacedAndCinematics
  SetBraindance(Contexts.SlowPacedAndCinematics)
  Toggles.Braindance = Contexts.SlowPacedAndCinematics
  SetCinematic(Contexts.SlowPacedAndCinematics)
  Toggles.Cinematic = Contexts.SlowPacedAndCinematics

  if Toggles.Walking and
    Toggles.Swimming and
    Toggles.Vehicle.Static and
    Toggles.Braindance and
    Toggles.Cinematic then

    Contexts.SlowPacedAndCinematics = true
  else
    Contexts.SlowPacedAndCinematics = false
  end
end

local function ToggleFastPaced()
  SetSprinting(Contexts.FastPaced)
  Toggles.Sprinting = Contexts.FastPaced
  SetVehicleDriving(Contexts.FastPaced)
  Toggles.Vehicle.Driving = Contexts.FastPaced
  SetVehicleStaticCombat(Contexts.FastPaced)
  Toggles.Vehicle.StaticCombat = Contexts.FastPaced
  SetVehicleDrivingCombat(Contexts.FastPaced)
  Toggles.Vehicle.DrivingCombat = Contexts.FastPaced
  SetCombat(Contexts.FastPaced)
  Toggles.Combat = Contexts.FastPaced

  if Toggles.Sprinting and
    Toggles.Vehicle.Driving and
    Toggles.Vehicle.StaticCombat and
    Toggles.Vehicle.DrivingCombat and
    Toggles.Combat then

    Contexts.FastPaced = true
  else
    Contexts.FastPaced = false
  end
end

local function ToggleMyOwn()
  ResetToggles(Toggles)
  ToggleSightseeing()
  ToggleSlowPaced()
  ToggleFastPaced()
end

---------------
-- On... registers
--------------- 

function Contextual.OnInitialize()
  if not FrameGenGhostingFix.IsContextual() then return end

  LoadUserSettings(Settings.GetUserSettings("Contextual"))

  isDLSSEnabler = FrameGenGhostingFix.IsDLSSEnablerCompatible()

  if not isDLSSEnabler then
    versionDLSSEnabler = FrameGenGhostingFix.GetDLSSEnablerVersion()
  end

  Tracker.SetCallbackOnGameStateChange('gameLoaded', 'ContextualInitalizeFrameGenState', Globals.SetDelay, FrameGenGhostingFix.GetFpsCalculationInterval() + 0.5, 'ContextualInitalizeFrameGenState', InitializeFrameGenState)

  -- This will prove useful in future to set contexts based on camera perspective
  -- Observe('VehicleTransition', 'RequestToggleVehicleCamera', function() end)

  ------------------------------
  -- Vehicle Static and Driving
  ------------------------------
  -- DriveEvents events are not triggered when weapon is drawn (so essentially vehicle combat mode)
  -- So it won't update static combat and driving combat states (which will be handled by DriverCombatEvents->OnUpdate)
  Observe('DriveEvents', 'OnUpdate', function()
    -- When DriveEvents->OnUpdate is triggered, it means vehicle is no longer in combat mode (so it's equivalent to DriverCombatEvents->OnExit state)
    -- We need to make sure vehicle combat states are reverted
    if CurrentStates.isVehicleStaticCombat == true then
      if Toggles.Vehicle.StaticCombat then
        TurnOnFrameGen()
      end
      CurrentStates.isVehicleStaticCombat = false
    end
    if CurrentStates.isVehicleDrivingCombat == true then
      if Toggles.Vehicle.DrivingCombat then
        TurnOnFrameGen()
      end
      CurrentStates.isVehicleDrivingCombat = false
    end

    -- Turn on framegen if it was disabled outside vehicle
    if Toggles.Standing == true then
      TurnOnFrameGen()
    end
    
    HandleStaticAndDrivingStates()
  end)

  ------------------
  -- Vehicle Combat
  ------------------
  -- These events are fired the moment weapon is drawn when player is in vehicle (even if the alert status is not yet combat)
  -- We need to track static and driving states here because DriveEvents->OnUpdate is not triggered during vehicle combat
  Observe('DriverCombatEvents', 'OnUpdate', function()
    HandleStaticAndDrivingStates()

    -- Vehicle static combat and driving combat states are mutually exclusive, so they can't be true at once
    if CurrentStates.isVehicleStatic then
      CurrentStates.isVehicleStaticCombat = true
      CurrentStates.isVehicleDrivingCombat = false
    end

    if CurrentStates.isVehicleDriving then
      CurrentStates.isVehicleDrivingCombat = true
      CurrentStates.isVehicleStaticCombat = false
    end

    if Toggles.Vehicle.StaticCombat == true then
      if CurrentStates.isVehicleStaticCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) detected. FG Disabled (DriverCombatEvents->OnUpdate)")
      else
        -- Make sure the vehice static combat state is not overlapped with vehicle driving combat state
        if not CurrentStates.isVehicleDrivingCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
        if not Toggles.Vehicle.DrivingCombat and CurrentStates.isVehicleDrivingCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
      end
    end

    if Toggles.Vehicle.DrivingCombat == true then
      if CurrentStates.isVehicleDrivingCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) detected. FG Disabled (DriverCombatEvents->OnUpdate)")
      else
        -- Make sure the vehice driving combat state is not overlapped with vehicle static combat state
        if not CurrentStates.isVehicleStaticCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
        if not Toggles.Vehicle.StaticCombat and CurrentStates.isVehicleStaticCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
      end
    end
  end)

  ----------
  -- Vehicle Mounting/Unmounting
  ----------

  Observe('hudCarController', 'OnUnmountingEvent', function()
    CurrentStates.isVehicleStatic = false
    CurrentStates.isVehicleDriving = false
    CurrentStates.isVehicleStaticCombat = false
    CurrentStates.isVehicleDrivingCombat = false
  end)

  ----------
  -- Combat
  ----------
  -- These events occur when Alert status (on top right below the map) is set to Combat
  -- This is different from vehicle combat mode (which is only about whether player is using weapons inside the vehicle regardless of the alert status)
  Observe('CombatEvents', 'OnEnter', function()
    CurrentStates.isCombat = true
    if Toggles.Combat == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode detected. FG Disabled (CombatEvents->OnEnter)")
    end
  end)
  Observe('CombatEvents', 'OnExit', function()
    CurrentStates.isCombat = false
    if Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatEvents->OnExit)")
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  -- These have reverse operations
  Observe('CombatExitingEvents', 'OnEnter', function()
    CurrentStates.isCombat = false
    if Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnEnter)")
    end
  end)
  Observe('CombatExitingEvents', 'OnExit', function()
    CurrentStates.isCombat = false
    if Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnExit)")
    end
  end)
  Observe('CombatExitingEvents', 'OnForcedExit', function()
    CurrentStates.isCombat = false
    if Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnForcedExit)")
    end
  end)

  Observe("PlayerPuppet", "OnCombatStateChanged", function ()
		CurrentStates.isCombat = IsInCombat()
    if Toggles.Combat == true then
      if CurrentStates.isCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Combat mode detected. FG Disabled (PlayerPuppet->OnCombatStateChanged)")
      end
      if not CurrentStates.isCombat then
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (PlayerPuppet->OnCombatStateChanged)")
      end
    end
	end)

  -------------------------------------------------
  -- Standing, Walking, Slow Walking and Sprinting
  -------------------------------------------------
  ---
  Observe('LocomotionEventsTransition', 'OnUpdate', function()

    -- Community Request: adding global FG disable on Contexts.BaseFps ~= 0
    if Contexts.BaseFps ~= 0 then
      ToggleFrameGenOnBaseFpsContext()
    end

    -- LocomotionEventsTransition OnUpdate fires up also when in a vehicle
    if Tracker.IsPlayerDriver() then OnPlayerDriverEvent() return end

    -- LocomotionEventsTransition events are also present during photo mode
    -- We need special handling to turn on FG when photo mode toggle is not checked
    if CurrentStates.isPhotoMode then
      if Toggles.Photomode then
        return
      else
        TurnOnFrameGen()
        return
      end
    end

    local locomotionState = LocomotionState()
    
    -- Slide = 5
    -- SlideFall = 6
    -- Dodge = 7
    -- Jump = 18
    -- DoubleJump = 19
    -- ChargeJump = 20
    -- HoverJump = 21
    -- DodgeAir = 22
    if locomotionState == 5 or
        locomotionState == 6 or
        locomotionState == 7 or
        locomotionState == 18 or
        locomotionState == 19 or
        locomotionState == 20 or
        locomotionState == 21 or
        locomotionState == 22 or
        isOnHold
        then
          KeepOnHold(2)
          return -- early return to continue previous states on sliding, dodging and jumping
        end
    

    if not Tracker.IsPlayerMoving() then
      CurrentStates.isStandingCrouching = true
      CurrentStates.isWalkingCrouchWalking = false
      CurrentStates.isSprintingCrouchSprinting = false
      CurrentStates.isSlowWalking = false
    else
      CurrentStates.isStandingCrouching = false

      if locomotionState == 3 then
        if Game.GetPlayer().inCrouch then
          CurrentStates.isWalkingCrouchWalking = true
          CurrentStates.isSprintingCrouchSprinting = false
          CurrentStates.isSlowWalking = false
        else
          CurrentStates.isWalkingCrouchWalking = false
          CurrentStates.isSprintingCrouchSprinting = false
          CurrentStates.isSlowWalking = true
        end
      elseif locomotionState == 4 or locomotionState == 30 then
        CurrentStates.isWalkingCrouchWalking = false
        CurrentStates.isSprintingCrouchSprinting = true
        CurrentStates.isSlowWalking = false
      else
        CurrentStates.isWalkingCrouchWalking = true
        CurrentStates.isSprintingCrouchSprinting = false
        CurrentStates.isSlowWalking = false
      end
    end

    -- gramern: separating Player slow-paced contexts from Combat - since Combat should be considered a fast-paced activity seprately and those states should not impact it
    -- Only process standing logic when V is out of vehicle
    if Toggles.Standing == true then
      if CurrentStates.isStandingCrouching then
        if not Toggles.Combat and IsInCombat() then
          TurnOnFrameGen()
          -- Globals.PrintDebug(Contextual.__NAME, "Player is in Combat. FG remains Enabled while on-foot.")
          return
        end
        
        TurnOffFrameGen()
      else
        -- if not (Toggles.Standing and CurrentStates.isStandingCrouching)
        if not (Toggles.Walking and CurrentStates.isWalkingCrouchWalking)
        and not (Toggles.SlowWalking and CurrentStates.isSlowWalking)
        and not (Toggles.Sprinting and CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end
    
    if Toggles.Walking == true then
      if CurrentStates.isWalkingCrouchWalking then
        if not Toggles.Combat and IsInCombat() then
          TurnOnFrameGen()
          -- Globals.PrintDebug(Contextual.__NAME, "Player is in Combat. FG remains Enabled while on-foot.")
          return
        end

        TurnOffFrameGen()
      else
        if not (Toggles.Standing and CurrentStates.isStandingCrouching)
        -- and not (Toggles.Walking and CurrentStates.isWalkingCrouchWalking)
        and not (Toggles.SlowWalking and CurrentStates.isSlowWalking)
        and not (Toggles.Sprinting and CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end

    if Toggles.SlowWalking then 
      if CurrentStates.isSlowWalking == true then
        if not Toggles.Combat and IsInCombat() then
          TurnOnFrameGen()
          -- Globals.PrintDebug(Contextual.__NAME, "Player is in Combat. FG remains Enabled while on-foot.")
          return
        end

        TurnOffFrameGen()
      else
        if not (Toggles.Standing and CurrentStates.isStandingCrouching)
        and not (Toggles.Walking and CurrentStates.isWalkingCrouchWalking)
        -- and not (Toggles.SlowWalking and CurrentStates.isSlowWalking)
        and not (Toggles.Sprinting and CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end

    if Toggles.Sprinting then
      if CurrentStates.isSprintingCrouchSprinting == true then
        if not Toggles.Combat and IsInCombat() then
          TurnOnFrameGen()
          -- Globals.PrintDebug(Contextual.__NAME, "Player is in Combat. FG remains Enabled while on-foot.")
          return
        end

        TurnOffFrameGen()
      else
        if not (Toggles.Standing and CurrentStates.isStandingCrouching)
        and not (Toggles.Walking and CurrentStates.isWalkingCrouchWalking)
        and not (Toggles.SlowWalking and CurrentStates.isSlowWalking) then
        -- and not (Toggles.Sprinting and CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end
  end)

  ------------
  -- Swimming
  ------------
  Observe('SwimmingEvents', 'OnEnter', function()
    CurrentStates.isSwimming = true
    if Toggles.Swimming == true then
      if not Toggles.Combat and IsInCombat() then
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Player is swimming while in Combat. FG Enabled (SwimmingEvents->OnEnter)")
        return
      end

      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Player is swimming. FG Disabled (SwimmingEvents->OnEnter)")
    end
  end)
  Observe('SwimmingEvents', 'OnExit', function()
    CurrentStates.isSwimming = false
    if Toggles.Swimming == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Player is no longer swimming. FG Enabled (SwimmingEvents->OnExit)")
    end
  end)

  --------------
  -- Braindance
  --------------
  Observe('BraindanceGameController', 'OnIsActiveUpdated', function(_, isActive)

    if type(isActive) ~= 'boolean' then
      isActive = _
    end

    CurrentStates.isBraindance = isActive

    if Toggles.Braindance == true then
      if CurrentStates.isBraindance then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Player is braindance. FG Disabled (BraindanceGameController->OnIsActiveUpdated)")
      else
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Player is no longer in braindance. FG Enabled (BraindanceGameController->OnIsActiveUpdated)")
      end
    end
  end)

  -------------
  -- Cinematic
  -------------
  Observe("PlayerPuppet", "OnSceneTierChange", function (_, sceneTier)
    Globals.PrintDebug(Contextual.__NAME, "Scene Tier change detected: " .. tostring(sceneTier))

    CurrentStates.isCinematic = false

    if sceneTier == 5 or IsInCinematic() then
		  CurrentStates.isCinematic = true
    end

    if Toggles.Cinematic == true then
      if CurrentStates.isCinematic then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Cinematic detected. FG Disabled (PlayerPuppet->OnSceneTierChange)")
      end
      if not CurrentStates.isCinematic then
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Cinematic no longer present. FG Enabled (PlayerPuppet->OnSceneTierChange)")
      end
    end
	end)

  ---------------
  -- Photo Mode
  ---------------
  Observe('gameuiPhotoModeMenuController', 'OnShow', function()
    CurrentStates.isPhotoMode = true

    if Toggles.Photomode == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Photo mode detected" .. ". FG Disabled (gameuiPhotoModeMenuController->OnShow)")
    end
  end)

  Observe('gameuiPhotoModeMenuController', 'OnHide', function()
    CurrentStates.isPhotoMode = false

    if Toggles.Photomode == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Photo mode no longer preset" .. ". FG Enabled (gameuiPhotoModeMenuController->OnHide)")
    end
  end)

end

function Contextual.OnOverlayClose()
  SetDebugMode(Settings.IsDebugMode())
end

---------------
-- Local UI
--------------- 

function Contextual.DrawUI()
  if not FrameGenGhostingFix.IsContextual() then return end

  local baseFpsCalcInterval
  local contextSightseeingToggle, contextSlowPacedAndCinematicsToggle, contextFastPacedToggle, contextMyOwnToggle, contextBaseFpsSliderToggle, baseFpsCalcIntervalToggle
  local isVehicleStaticToggled, isVehicleDrivingToggled, isVehicleStaticCombatToggled, isVehicleDrivingCombatToggled, standingToggle, walkingToggle, slowWalkingToggle, sprintingToggle, swimmingToggle, combatToggle, braindanceToggle, cinematicToggle, photoModeToggle

  if ImGui.BeginTabItem(ContextualText.tab_name_contextual) then

    if not isDLSSEnabler then
      if not versionRequired then
        --moved it here, as it can't concat onInit for some reason
        versionRequired = table.concat(FrameGenGhostingFix.__DLSS_ENABLER_VERSION_MIN, ".")
      end

      ImGui.Text("")
      ImGuiExt.TextRed(ContextualText.info_bad_enabler_version, true)
      ImGui.Text("")
      ImGuiExt.TextRed(ContextualText.info_found_enabler_version)
      ImGui.SameLine()
      ImGuiExt.TextRed((versionDLSSEnabler or "Unknown"))
      ImGuiExt.TextRed(GeneralText.info_required)
      ImGui.SameLine()
      ImGuiExt.TextRed(versionRequired)
      ImGui.Text("")
      ImGuiExt.ResetStatusBar()

      ImGui.EndTabItem()
      return
    end

    if not Tracker.IsGameFrameGeneration() then
      ImGui.Text("")
      ImGuiExt.Text(SettingsText.info_game_frame_gen_required, true)
      ImGui.Text("")
      ImGuiExt.ResetStatusBar()

      ImGui.EndTabItem()
      return
    end

    if Tracker.IsModDynamicFrameGeneration() then
      ImGui.Text("")
      ImGuiExt.TextRed(ContextualText.info_dynamic_frame_gen_forbidden, true)
      ImGui.Text("")
      ImGuiExt.TextRed(GeneralText.info_reopen_overlay, true)
      ImGui.Text("")
      ImGuiExt.ResetStatusBar()

      ImGui.EndTabItem()
      return
    end

    ImGuiExt.Text(GeneralText.group_overview)
    ImGui.Separator()
    ImGuiExt.Text(ContextualText.info_overview, true)
    ImGuiExt.SetTooltip(ContextualText.info_contextual)
    ImGui.Text("")
    ImGuiExt.Text(ContextualText.info_select_context, true)
    ImGui.Text("")
    ImGuiExt.TextColor(GeneralText.info_important, 1, 0.85, 0.31, 1, true)
    ImGuiExt.Text(ContextualText.info_contextual_requirements, true)
    ImGuiExt.SetTooltip(ContextualText.info_dynamic_frame_gen_forbidden)
    ImGui.Text("")
    ImGuiExt.Text(ContextualText.group_contexts)
    ImGui.Separator()

    if not Contexts.MyOwn then
      Contexts.Sightseeing, contextSightseeingToggle = ImGuiExt.Checkbox(ContextualText.chk_context_sightseeing, Contexts.Sightseeing, contextSightseeingToggle)
      if contextSightseeingToggle then
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        ToggleSightseeing()
        SaveUserSettings()
      end
      ImGuiExt.SetTooltip(ContextualText.tooltip_context_sightseeing)

      Contexts.SlowPacedAndCinematics, contextSlowPacedAndCinematicsToggle = ImGuiExt.Checkbox(ContextualText.chk_context_slow_paced, Contexts.SlowPacedAndCinematics, contextSlowPacedAndCinematicsToggle)
      if contextSlowPacedAndCinematicsToggle then
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        ToggleSlowPaced()
        SaveUserSettings()
      end
      ImGuiExt.SetTooltip(ContextualText.tooltip_context_slow_paced)

      Contexts.FastPaced, contextFastPacedToggle = ImGuiExt.Checkbox(ContextualText.chk_context_fast_paced, Contexts.FastPaced, contextFastPacedToggle)
      if contextFastPacedToggle then
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        ToggleFastPaced()
        SaveUserSettings()
      end
      ImGuiExt.SetTooltip(ContextualText.tooltip_context_fast_paced)
    end

    Contexts.MyOwn, contextMyOwnToggle = ImGuiExt.Checkbox(ContextualText.chk_context_my_own, Contexts.MyOwn, contextMyOwnToggle)
    if contextMyOwnToggle then
      if Contexts.MyOwn then
        SaveUserSettings()
        ToggleMyOwn()
        Globals.SetFallback('Contextual', Toggles, 'SelectedToggles')
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
      else
        Toggles = Globals.SafeMergeTables(Toggles, Globals.GetFallback('Contextual', 'SelectedToggles'))
        ToggleSightseeing()
        ToggleSlowPaced()
        ToggleFastPaced()
      end

      SaveUserSettings()
      ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
    end
    ImGuiExt.SetTooltip(ContextualText.tooltip_context_my_own)

    if Contexts.MyOwn then
      ImGui.Text("")
      ImGuiExt.Text(ContextualText.group_on_foot)
      ImGui.Separator()

      Toggles.Standing, standingToggle = ImGuiExt.Checkbox(ContextualText.chk_on_foot_standing, Toggles.Standing, standingToggle)
      if standingToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetStandingCrouching(Toggles.Standing)
      end

      Toggles.Walking, walkingToggle = ImGuiExt.Checkbox(ContextualText.chk_on_foot_walking, Toggles.Walking, walkingToggle)
      if walkingToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetWalking(Toggles.Walking)
      end

      Toggles.Sprinting, sprintingToggle = ImGuiExt.Checkbox(ContextualText.chk_on_foot_sprinting, Toggles.Sprinting, sprintingToggle)
      if sprintingToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetSprinting(Toggles.Sprinting)
      end

      Toggles.SlowWalking, slowWalkingToggle = ImGuiExt.Checkbox(ContextualText.chk_on_foot_slow_walking, Toggles.SlowWalking, slowWalkingToggle)
      if slowWalkingToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetSlowWalking(Toggles.SlowWalking)
      end

      Toggles.Swimming, swimmingToggle = ImGuiExt.Checkbox(ContextualText.chk_on_foot_swimming, Toggles.Swimming, swimmingToggle)
      if swimmingToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetSwimming(Toggles.Swimming)
      end

      ImGui.Text("")
      ImGuiExt.Text(ContextualText.group_vehicles)
      ImGui.Separator()

      Toggles.Vehicle.Static, isVehicleStaticToggled = ImGuiExt.Checkbox(ContextualText.chk_vehicles_static, Toggles.Vehicle.Static, isVehicleStaticToggled)
      if isVehicleStaticToggled then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetVehicleStatic(Toggles.Vehicle.Static)
      end

      Toggles.Vehicle.Driving, isVehicleDrivingToggled = ImGuiExt.Checkbox(ContextualText.chk_vehicles_driving, Toggles.Vehicle.Driving, isVehicleDrivingToggled)
      if isVehicleDrivingToggled then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetVehicleDriving(Toggles.Vehicle.Driving)
      end

      Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled = ImGuiExt.Checkbox(ContextualText.chk_vehicles_static_weapon, Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled)
      if isVehicleStaticCombatToggled then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetVehicleStaticCombat(Toggles.Vehicle.StaticCombat)
      end

      Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled = ImGuiExt.Checkbox(ContextualText.chk_vehicles_driving_weapon, Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled)
      if isVehicleDrivingCombatToggled then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetVehicleDrivingCombat(Toggles.Vehicle.DrivingCombat)
      end

      ImGui.Text("")
      ImGuiExt.Text(ContextualText.group_other)
      ImGui.Separator()

      Toggles.Braindance, braindanceToggle = ImGuiExt.Checkbox(ContextualText.chk_braindance, Toggles.Braindance, braindanceToggle)
      if braindanceToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetBraindance(Toggles.Braindance)
      end

      Toggles.Cinematic, cinematicToggle = ImGuiExt.Checkbox(ContextualText.chk_cinematics, Toggles.Cinematic, cinematicToggle)
      if cinematicToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetCinematic(Toggles.Cinematic)
      end

      Toggles.Combat, combatToggle = ImGuiExt.Checkbox(ContextualText.chk_combat, Toggles.Combat, combatToggle)
      if combatToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetCombat(Toggles.Combat)
      end

      Toggles.Photomode, photoModeToggle = ImGuiExt.Checkbox(ContextualText.chk_photo_mode, Toggles.Photomode, photoModeToggle)
      if photoModeToggle then
        SaveUserSettings()
        ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        SetPhotoMode(Toggles.Photomode)
      end
    end

    ImGui.Text("")
    ImGuiExt.Text(ContextualText.group_base_fps)
    ImGui.Separator()
    ImGuiExt.Text(ContextualText.info_context_base_fps, true)
    ImGui.Text("")

    ImGuiExt.Text(ContextualText.info_context_base_fps_state)
    ImGui.SameLine()
    if Contexts.BaseFps == 0 then
      ImGuiExt.Text(GeneralText.info_disabled)
    else
      ImGuiExt.Text(GeneralText.info_enabled)
    end

    ImGui.Text("")

    ImGuiExt.Text(ContextualText.slider_context_base_fps_threshold)

    Contexts.BaseFps, contextBaseFpsSliderToggle = ImGui.SliderFloat("##BaseFps", Contexts.BaseFps, 0, 200, "%.0f")
    if contextBaseFpsSliderToggle then
      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(ContextualText.tooltip_context_base_fps)

    ImGuiExt.Text(ContextualText.slider_base_fps_calc_interval)

    baseFpsCalcInterval, baseFpsCalcIntervalToggle = ImGui.SliderFloat("##CalcInterval", FrameGenGhostingFix.GetFpsCalculationInterval(), 0.5, 2, "%.1f")
    if baseFpsCalcIntervalToggle then
      FrameGenGhostingFix.SetFpsCalculationInterval(baseFpsCalcInterval)
      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(ContextualText.tooltip_base_fps_calc_interval)

    if Settings.IsDebugMode() then
      ImGui.Text("")
      ImGui.Separator()

      local realTimeVehicleMoving = tostring(Tracker.IsVehicleMoving())
      ImGuiExt.Text("Real-Time Tracker.IsVehicleMoving(): " .. realTimeVehicleMoving)

      local realTimePlayerMoving = tostring(Tracker.IsPlayerMoving())
      ImGuiExt.Text("Real-Time Tracker.IsPlayerMoving(): " .. realTimePlayerMoving)

      ImGui.Separator()

      ImGuiExt.Text("Current States:")
      ImGui.Separator()
      ImGuiExt.Text(StringifyStates())

      ImGui.Separator()

      local fgStatus = GeneralText.info_enabled

      if FGEnabled == true then
        fgStatus = GeneralText.info_enabled
      else
        fgStatus = GeneralText.info_disabled
      end

      ImGuiExt.Text("Contextual Frame Gen State: " .. fgStatus)

      ImGui.Separator()

      local realTimeState = GeneralText.info_disabled

      if Tracker.IsGameReady() then
        realTimeState = tostring(DLSSEnabler_GetFrameGenerationState())
      end

      ImGuiExt.Text("Real-Time Frame Gen State: " .. realTimeState)
    end

    ImGui.Text("")
    ImGui.EndTabItem()
  end

end

return Contextual