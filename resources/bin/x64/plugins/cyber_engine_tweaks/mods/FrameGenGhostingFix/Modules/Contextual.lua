local Contextual = {
  __NAME = "Contextual",
  __VERSION = { 5, 0, 0 },
  Toggles = {
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
  },
  CurrentStates = {
    isVehicleStatic = false,
    isVehicleDriving = false,
    isVehicleStaticCombat = false,
    isVehicleDrivingCombat = false,
    isStandingCrouching = false,
    isWalking = false,
    isSlowWalkingCrouchWalking = false,
    isSprintingCrouchSprinting = false,
    isSwimming = false,
    isCombat = false,
    isBraindance = false,
    isCinematic = false,
    isPhotoMode = false,
  },
  FGEnabled = false,
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Tracker = require("Modules/Tracker")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")

local ContextualText = Localization.GetContextualText()
local GeneralText = Localization.GetGeneralText()

local function GetUserSettings()
  local userSettings = {
    Toggles = Contextual.Toggles
  }

  return userSettings
end

local function LoadUserSettings(userSettings)
  if not userSettings or userSettings == nil then return end

  Globals.MergeTables(Contextual, userSettings)
end

local function SaveUserSettings()
  Settings.WriteUserSettings("Contextual", GetUserSettings())
end

local function TurnOnFrameGen()
  -- Only call external DLSSEnabler_SetFrameGeneration method once to avoid overhead
  if Contextual.FGEnabled == false then
    DLSSEnabler_SetFrameGenerationState(true)
    Contextual.FGEnabled = true
  end
end

local function TurnOffFrameGen()
  -- Only call external DLSSEnabler_SetFrameGeneration method once to avoid overhead
  if Contextual.FGEnabled == true then
    DLSSEnabler_SetFrameGenerationState(false)
    Contextual.FGEnabled = false
  end
end

local function GetFrameGenState()
  return DLSSEnabler_GetFrameGenerationState()
end

-- Make the first letter capital
local function Capitalize(str)
  return (str:gsub("^%l", string.upper))
end

local function StringifyStates()
  return "VehicleStatic: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleStatic)) ..
  "\n" .. "VehicleDriving: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleDriving)) ..
  "\n" .. "VehicleStaticCombat: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleStaticCombat)) ..
  "\n" .. "VehicleDrivingCombat: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleDrivingCombat)) ..
  "\n" .. "StandingCrouching: " .. Capitalize(tostring(Contextual.CurrentStates.isStandingCrouching)) ..
  "\n" .. "Walking: " .. Capitalize(tostring(Contextual.CurrentStates.isWalking)) ..
  "\n" .. "SlowWalkingCrouchWalking: " .. Capitalize(tostring(Contextual.CurrentStates.isSlowWalkingCrouchWalking)) ..
  "\n" .. "SprintingCrouchSprinting: " .. Capitalize(tostring(Contextual.CurrentStates.isSprintingCrouchSprinting)) ..
  "\n" .. "Swimming: " .. Capitalize(tostring(Contextual.CurrentStates.isSwimming)) ..
  "\n" .. "Combat: " .. Capitalize(tostring(Contextual.CurrentStates.isCombat)) ..
  "\n" .. "Braindance: " .. Capitalize(tostring(Contextual.CurrentStates.isBraindance)) ..
  "\n" .. "Cinematic: " .. Capitalize(tostring(Contextual.CurrentStates.isCinematic)) ..
  "\n" .. "PhotoMode: " .. Capitalize(tostring(Contextual.CurrentStates.isPhotoMode))
end

local function GetPlayerVehicle()
  local playerVehicle = GetMountedVehicle(GetPlayer())
  if not playerVehicle then
    Globals.PrintDebug(Contextual.__NAME, "Player vehicle cannot be retreived. Subsequent vehicle operations won't work.")
  end
  return playerVehicle
end

local function IsInVehicle(playerVehicle)
  if playerVehicle:IsA('vehicleAVBaseObject') then return false end
  if playerVehicle:IsA('vehicleTankBaseObject') then return false end
  return playerVehicle:IsPlayerDriver()
end

local function IsPlayerVehicleStatic(playerVehicle)
  local currentSpeed = playerVehicle:GetCurrentSpeed()
  if currentSpeed == nil or currentSpeed > 1 then return false end
  if currentSpeed ~= nil and currentSpeed < 1 then
    return true
  end
end

local function IsPlayerVehicleDriving(playerVehicle)
  local currentSpeed = playerVehicle:GetCurrentSpeed()
  if currentSpeed == nil or currentSpeed < 1 then return false end
  if currentSpeed ~= nil and currentSpeed > 1 then
    return true
  end
end

-- gramern: this doesn't work with weaponized vehicles as I tested, so to get general Vehicle Combat would be: 
-- Tracker.IsPlayerWeapon() and Tracker.IsVehicleMounted() (for hand weapons drawn while in vehicle) or Tracker.IsVehicleWeapon (for vehicle weapons drawn)
local function IsPlayerInVehicleCombat(playerVehicle)
  local player = Game.GetPlayer()
  if IsInVehicle(playerVehicle) and player:GetActiveWeapon() ~= nil then return true end
  return false
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

local function IsPlayerStanding()
  return LocomotionState() == 1
end

local function IsPlayerWalking()
  return LocomotionState() ~= 1 and LocomotionState() ~= 4 and LocomotionState() ~= 30 and Tracker.IsPlayerMoving()
end

-- Same as crouching
local function IsPlayerSlowWalking()
  return LocomotionState() == 3
end

local function IsPlayerSprinting()
  return LocomotionState() == 4 or LocomotionState() == 30
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
      Static = Contextual.CurrentStates.isVehicleStatic,
      Driving = Contextual.CurrentStates.isVehicleDriving,
      StaticCombat = Contextual.CurrentStates.isVehicleStaticCombat,
      DrivingCombat = Contextual.CurrentStates.isVehicleDrivingCombat,
    },
    Standing = Contextual.CurrentStates.isStandingCrouching,
    Walking = Contextual.CurrentStates.isWalking,
    SlowWalking = Contextual.CurrentStates.isSlowWalkingCrouchWalking,
    Sprinting = Contextual.CurrentStates.isSprintingCrouchSprinting,
    Swimming = Contextual.CurrentStates.isSwimming,
    Combat = Contextual.CurrentStates.isCombat,
    Braindance = Contextual.CurrentStates.isBraindance,
    Cinematic = Contextual.CurrentStates.isCinematic,
    Photomode = Contextual.CurrentStates.isPhotoMode,
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
        if Contextual.Toggles.Vehicle[vehicleToggle] and vehicleValue then
          Globals.PrintDebug(Contextual.__NAME, "Vehicle State '" .. vehicleToggle .. "' is present and currently toggled. FG state will not change.")
          return false
        end
      end
    else
      if Contextual.Toggles[toggle] and value then
        Globals.PrintDebug(Contextual.__NAME, "State '" .. toggle .. "' is present and currently toggled. FG state will not change.")
        return false
      end
    end
  end

  return true
end

local function SetVehicleStatic(feature)
  local playerVehicle = GetPlayerVehicle()
  if Contextual.CurrentStates.isVehicleStatic or (playerVehicle and IsPlayerVehicleStatic(playerVehicle)) then
    if not ShouldAffectFGState("Vehicle.Static") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleDriving(feature)
  local playerVehicle = GetPlayerVehicle()
  if Contextual.CurrentStates.isVehicleDriving or (playerVehicle and IsPlayerVehicleDriving(playerVehicle)) then
    if not ShouldAffectFGState("Vehicle.Driving") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleStaticCombat(feature)
  local playerVehicle = GetPlayerVehicle()
  if Contextual.CurrentStates.isVehicleStaticCombat or (playerVehicle and IsPlayerInVehicleCombat(playerVehicle) and not Tracker.IsVehicleMoving()) then
    if not ShouldAffectFGState("Vehicle.StaticCombat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleDrivingCombat(feature)
  local playerVehicle = GetPlayerVehicle()
  if Contextual.CurrentStates.isDrivingCombat or (playerVehicle and IsPlayerInVehicleCombat(playerVehicle) and Tracker.IsVehicleMoving()) then
    if not ShouldAffectFGState("Vehicle.DrivingCombat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetStanding(feature)
  -- V is in Standing state even when Player is in Vehicle because LocomotionEventsTransition events still trigger
  local playerVehicle = GetPlayerVehicle()
  if playerVehicle ~= nil then return end

  if Contextual.CurrentStates.isStandingCrouching or IsPlayerStanding() then
    if not ShouldAffectFGState("Standing") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetWalking(feature)
  if Contextual.CurrentStates.isWalking or IsPlayerWalking() then
    if not ShouldAffectFGState("Walking") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSlowWalking(feature)
  if Contextual.CurrentStates.isSlowWalkingCrouchWalking or IsPlayerSlowWalking() then
    if not ShouldAffectFGState("SlowWalking") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSprinting(feature)
  if Contextual.CurrentStates.isSprintingCrouchSprinting or IsPlayerSprinting() then
    if not ShouldAffectFGState("Sprinting") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSwimming(feature)
  if Contextual.CurrentStates.isSwimming or IsPlayerSwimming() then
    if not ShouldAffectFGState("Swimming") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCombat(feature)
  if Contextual.CurrentStates.isCombat or IsInCombat() then
    if not ShouldAffectFGState("Combat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetBraindance(feature)
  if Contextual.CurrentStates.isBraindance or IsPlayerInBraindance() then
    if not ShouldAffectFGState("Braindance") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCinematic(feature)
  if Contextual.CurrentStates.isCinematic or IsInCinematic() then
    if not ShouldAffectFGState("Cinematic") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end


local function SetPhotoMode(feature)
  if Contextual.CurrentStates.isPhotoMode or IsInPhotoMode()  then
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
    Contextual.CurrentStates.isVehicleStatic = false
    Contextual.CurrentStates.isVehicleDriving = true
  else
    Contextual.CurrentStates.isVehicleStatic = true
    Contextual.CurrentStates.isVehicleDriving = false
  end

  -- Drive events are also present during photo mode
  -- We need special handling here to turn on FG if those toggles are not checked
  if Contextual.CurrentStates.isPhotoMode then
    if Contextual.Toggles.Photomode then
      return
    else
      TurnOnFrameGen()
      return
    end
  end

  if Contextual.Toggles.Vehicle.Static == true then
    if Contextual.CurrentStates.isVehicleStatic then
      TurnOffFrameGen()
    else
      if not Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicleDriving then
        TurnOnFrameGen()
      end
    end
  end

  if Contextual.Toggles.Vehicle.Driving == true then
    if Contextual.CurrentStates.isVehicleDriving then
      TurnOffFrameGen()
    else
      if not Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicleStatic then
        TurnOnFrameGen()
      end
    end
  end
end

function Contextual.OnInitialize()

  LoadUserSettings(Settings.GetUserSettings("Contextual"))

  -- Turn on debug mode during development
  Settings.SetDebugMode(true)

  -- Get the current FG state whenever mod is loaded or reloaded from CET
  Contextual.FGEnabled = GetFrameGenState()

  Observe('PlayerPuppet', 'OnGameAttached', function()
    TurnOnFrameGen()
    Globals.PrintDebug(Contextual.__NAME, "Game started. FG Enabled (PlayerPuppet->OnGameAttached)")
  end)

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
    if Contextual.CurrentStates.isVehicleStaticCombat == true then
      if Contextual.Toggles.Vehicle.StaticCombat then
        TurnOnFrameGen()
      end
      Contextual.CurrentStates.isVehicleStaticCombat = false
    end
    if Contextual.CurrentStates.isVehicleDrivingCombat == true then
      if Contextual.Toggles.Vehicle.DrivingCombat then
        TurnOnFrameGen()
      end
      Contextual.CurrentStates.isVehicleDrivingCombat = false
    end

    -- Turn on framegen if it was disabled outside vehicle
    if Contextual.Toggles.Standing == true then
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
    if Contextual.CurrentStates.isVehicleStatic then
      Contextual.CurrentStates.isVehicleStaticCombat = true
      Contextual.CurrentStates.isVehicleDrivingCombat = false
    end

    if Contextual.CurrentStates.isVehicleDriving then
      Contextual.CurrentStates.isVehicleDrivingCombat = true
      Contextual.CurrentStates.isVehicleStaticCombat = false
    end

    if Contextual.Toggles.Vehicle.StaticCombat == true then
      if Contextual.CurrentStates.isVehicleStaticCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) detected. FG Disabled (DriverCombatEvents->OnUpdate)")
      else
        -- Make sure the vehice static combat state is not overlapped with vehicle driving combat state
        if not Contextual.CurrentStates.isVehicleDrivingCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
        if not Contextual.Toggles.Vehicle.DrivingCombat and Contextual.CurrentStates.isVehicleDrivingCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (static) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
      end
    end

    if Contextual.Toggles.Vehicle.DrivingCombat == true then
      if Contextual.CurrentStates.isVehicleDrivingCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) detected. FG Disabled (DriverCombatEvents->OnUpdate)")
      else
        -- Make sure the vehice driving combat state is not overlapped with vehicle static combat state
        if not Contextual.CurrentStates.isVehicleStaticCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
        if not Contextual.Toggles.Vehicle.StaticCombat and Contextual.CurrentStates.isVehicleStaticCombat then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Vehicle combat (driving) no longer detected. FG Enabled (DriverCombatEvents->OnUpdate)")
        end
      end
    end
  end)

  ----------
  -- Combat
  ----------
  -- These events occur when Alert status (on top right below the map) is set to Combat
  -- This is different from vehicle combat mode (which is only about whether player is using weapons inside the vehicle regardless of the alert status)
  Observe('CombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = true
    if Contextual.Toggles.Combat == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode detected. FG Disabled (CombatEvents->OnEnter)")
    end
  end)
  Observe('CombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatEvents->OnExit)")
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  -- These have reverse operations
  Observe('CombatExitingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnEnter)")
    end
  end)
  Observe('CombatExitingEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnExit)")
    end
  end)
  Observe('CombatExitingEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (CombatExitingEvents->OnForcedExit)")
    end
  end)

  Observe("PlayerPuppet", "OnCombatStateChanged", function ()
		Contextual.CurrentStates.isCombat = IsInCombat()
    if Contextual.Toggles.Combat == true then
      if Contextual.CurrentStates.isCombat then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Combat mode detected. FG Disabled (PlayerPuppet->OnCombatStateChanged)")
      end
      if not Contextual.CurrentStates.isCombat then
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Combat mode is no longer present. FG Enabled (PlayerPuppet->OnCombatStateChanged)")
      end
    end
	end)

  -------------------------------------------------
  -- Standing, Walking, Slow Walking and Sprinting
  -------------------------------------------------
  Observe('LocomotionEventsTransition', 'OnUpdate', function()
    -- LocomotionEventsTransition events are also present during photo mode
    -- We need special handling to turn on FG when photo mode toggle is not checked
    if Contextual.CurrentStates.isPhotoMode then
      if Contextual.Toggles.Photomode then
        return
      else
        TurnOnFrameGen()
        return
      end
    end

    local locomotionState = LocomotionState()
    if locomotionState == 1 then
      Contextual.CurrentStates.isStandingCrouching = true
      Contextual.CurrentStates.isWalking = false
      Contextual.CurrentStates.isSlowWalkingCrouchWalking = false
      Contextual.CurrentStates.isSprintingCrouchSprinting = false
    elseif locomotionState == 3 then
      if Tracker.IsPlayerMoving() then
        -- Player is crouching and moving slowly
        Contextual.CurrentStates.isSlowWalkingCrouchWalking = true
        Contextual.CurrentStates.isStandingCrouching = false
      else
        -- Player is crouching (but not moving) so we track it as standing as well
        Contextual.CurrentStates.isStandingCrouching = true
        Contextual.CurrentStates.isSlowWalkingCrouchWalking = false
      end
      Contextual.CurrentStates.isWalking = false
      Contextual.CurrentStates.isSprintingCrouchSprinting = false
    elseif locomotionState == 4 or locomotionState == 30 then
      Contextual.CurrentStates.isSprintingCrouchSprinting = true
      Contextual.CurrentStates.isStandingCrouching = false
      Contextual.CurrentStates.isWalking = false
      Contextual.CurrentStates.isSlowWalkingCrouchWalking = false
    else
      Contextual.CurrentStates.isStandingCrouching = false
      Contextual.CurrentStates.isWalking = false
      Contextual.CurrentStates.isSlowWalkingCrouchWalking = false
      Contextual.CurrentStates.isSprintingCrouchSprinting = false
    end

    -- There is no specific walking locomotion state
    if Tracker.IsPlayerMoving() then
      if locomotionState ~= 4 and locomotionState ~= 30 then
        if Contextual.CurrentStates.isSprintingCrouchSprinting then
          Contextual.CurrentStates.isWalking = true
        else
          Contextual.CurrentStates.isWalking = false
        end
      end
    end

    -- Only process standing logic when V is out of vehicle
    if Contextual.Toggles.Standing == true and GetMountedVehicle(GetPlayer()) == nil then
      if Contextual.CurrentStates.isStandingCrouching then
        TurnOffFrameGen()
      else
        -- if not (Contextual.Toggles.Standing and Contextual.CurrentStates.isStandingCrouching)
        if not (Contextual.Toggles.Walking and Contextual.CurrentStates.isWalking)
        and not (Contextual.Toggles.SlowWalking and Contextual.CurrentStates.isSlowWalkingCrouchWalking)
        and not (Contextual.Toggles.Sprinting and Contextual.CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end
    
    if Contextual.Toggles.Walking == true then
      if Contextual.CurrentStates.isWalking then
        TurnOffFrameGen()
      else
        if not (Contextual.Toggles.Standing and Contextual.CurrentStates.isStandingCrouching)
        -- and not (Contextual.Toggles.Walking and Contextual.CurrentStates.isWalking)
        and not (Contextual.Toggles.SlowWalking and Contextual.CurrentStates.isSlowWalkingCrouchWalking)
        and not (Contextual.Toggles.Sprinting and Contextual.CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end

    if Contextual.Toggles.SlowWalking then
      if Contextual.CurrentStates.isSlowWalkingCrouchWalking == true then
        TurnOffFrameGen()
      else
        if not (Contextual.Toggles.Standing and Contextual.CurrentStates.isStandingCrouching)
        and not (Contextual.Toggles.Walking and Contextual.CurrentStates.isWalking)
        -- and not (Contextual.Toggles.SlowWalking and Contextual.CurrentStates.isSlowWalkingCrouchWalking)
        and not (Contextual.Toggles.Sprinting and Contextual.CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end

    if Contextual.Toggles.Sprinting then
      if Contextual.CurrentStates.isSprintingCrouchSprinting == true then
        TurnOffFrameGen()
      else
        if not (Contextual.Toggles.Standing and Contextual.CurrentStates.isStandingCrouching)
        and not (Contextual.Toggles.Walking and Contextual.CurrentStates.isWalking)
        and not (Contextual.Toggles.SlowWalking and Contextual.CurrentStates.isSlowWalkingCrouchWalking) then
        -- and not (Contextual.Toggles.Sprinting and Contextual.CurrentStates.isSprintingCrouchSprinting) then
          TurnOnFrameGen()
        end
      end
    end

  end)

  ------------
  -- Swimming
  ------------
  Observe('SwimmingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isSwimming = true
    if Contextual.Toggles.Swimming == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Player is swimming. FG Disabled (SwimmingEvents->OnEnter)")
    end
  end)
  Observe('SwimmingEvents', 'OnExit', function()
    Contextual.CurrentStates.isSwimming = false
    if Contextual.Toggles.Swimming == true then
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

    Contextual.CurrentStates.isBraindance = isActive

    if Contextual.Toggles.Braindance == true then
      if Contextual.CurrentStates.isBraindance then
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

    Contextual.CurrentStates.isCinematic = false

    if sceneTier == 5 or IsInCinematic() then
		  Contextual.CurrentStates.isCinematic = true
    end

    if Contextual.Toggles.isCinematic == true then
      if Contextual.CurrentStates.isCinematic then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Cinematic detected. FG Disabled (PlayerPuppet->OnSceneTierChange)")
      end
      if not Contextual.CurrentStates.isCinematic then
        TurnOnFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Cinematic no longer present. FG Enabled (PlayerPuppet->OnSceneTierChange)")
      end
    end
	end)

  ---------------
  -- Photo Mode
  ---------------
  Observe('gameuiPhotoModeMenuController', 'OnShow', function()
    Contextual.CurrentStates.isPhotoMode = true

    if Contextual.Toggles.Photomode == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Photo mode detected" .. ". FG Disabled (gameuiPhotoModeMenuController->OnShow)")
    end
  end)

  Observe('gameuiPhotoModeMenuController', 'OnHide', function()
    Contextual.CurrentStates.isPhotoMode = false

    if Contextual.Toggles.Photomode == true then
      TurnOnFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Photo mode no longer preset" .. ". FG Enabled (gameuiPhotoModeMenuController->OnHide)")
    end
  end)

end

function Contextual.DrawUI()

  local isVehicleStaticToggled, isVehicleDrivingToggled, isVehicleStaticCombatToggled, isVehicleDrivingCombatToggled, standingToggle, walkingToggle, slowWalkingToggle, sprintingToggle, swimmingToggle, combatToggle, braindanceToggle, cinematicToggle, photoModeToggle

  if ImGui.BeginTabItem(ContextualText.tabname) then
    if not Settings.IsFrameGeneration() then
      ImGui.Text("")
      ImGuiExt.TextRed(ContextualText.requirement, true)
      ImGui.Text("")
      ImGuiExt.ResetStatusBar()

      ImGui.EndTabItem()
      return
    end

    ImGuiExt.Text(GeneralText.title_general)
    ImGui.Separator()
    ImGuiExt.Text(ContextualText.info, true)

    ImGui.Text("")
    ImGuiExt.Text(ContextualText.groupOnFoot)
    ImGui.Separator()

    Contextual.Toggles.Standing, standingToggle = ImGuiExt.Checkbox(ContextualText.onFootStanding, Contextual.Toggles.Standing, standingToggle)
    if standingToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetStanding(Contextual.Toggles.Standing)
    end

    Contextual.Toggles.Walking, walkingToggle = ImGuiExt.Checkbox(ContextualText.onFootWalk, Contextual.Toggles.Walking, walkingToggle)
    if walkingToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetWalking(Contextual.Toggles.Walking)
    end

    Contextual.Toggles.SlowWalking, slowWalkingToggle = ImGuiExt.Checkbox(ContextualText.onFootSlowWalk, Contextual.Toggles.SlowWalking, slowWalkingToggle)
    if slowWalkingToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetSlowWalking(Contextual.Toggles.SlowWalking)
    end

    Contextual.Toggles.Sprinting, sprintingToggle = ImGuiExt.Checkbox(ContextualText.onFootSprint, Contextual.Toggles.Sprinting, sprintingToggle)
    if sprintingToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetSprinting(Contextual.Toggles.Sprinting)
    end

    Contextual.Toggles.Swimming, swimmingToggle = ImGuiExt.Checkbox(ContextualText.onFootSwimming, Contextual.Toggles.Swimming, swimmingToggle)
    if swimmingToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetSwimming(Contextual.Toggles.Swimming)
    end

    ImGui.Text("")
    ImGuiExt.Text(ContextualText.groupVehicles)
    ImGui.Separator()

    Contextual.Toggles.Vehicle.Static, isVehicleStaticToggled = ImGuiExt.Checkbox(ContextualText.vehiclesStatic, Contextual.Toggles.Vehicle.Static, isVehicleStaticToggled)
    if isVehicleStaticToggled then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetVehicleStatic(Contextual.Toggles.Vehicle.Static)
    end

    Contextual.Toggles.Vehicle.Driving, isVehicleDrivingToggled = ImGuiExt.Checkbox(ContextualText.vehiclesDriving, Contextual.Toggles.Vehicle.Driving, isVehicleDrivingToggled)
    if isVehicleDrivingToggled then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetVehicleDriving(Contextual.Toggles.Vehicle.Driving)
    end

    Contextual.Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled = ImGuiExt.Checkbox(ContextualText.vehiclesStaticWeapon, Contextual.Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled)
    if isVehicleStaticCombatToggled then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetVehicleStaticCombat(Contextual.Toggles.Vehicle.StaticCombat)
    end

    Contextual.Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled = ImGuiExt.Checkbox(ContextualText.vehiclesDrivingWeapon, Contextual.Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled)
    if isVehicleDrivingCombatToggled then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetVehicleDrivingCombat(Contextual.Toggles.Vehicle.DrivingCombat)
    end

    ImGui.Text("")
    ImGuiExt.Text(ContextualText.groupOther)
    ImGui.Separator()

    Contextual.Toggles.Braindance, braindanceToggle = ImGuiExt.Checkbox(ContextualText.braindance, Contextual.Toggles.Braindance, braindanceToggle)
    if braindanceToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetBraindance(Contextual.Toggles.Braindance)
    end

    Contextual.Toggles.Cinematic, cinematicToggle = ImGuiExt.Checkbox(ContextualText.cinematics, Contextual.Toggles.Cinematic, cinematicToggle)
    if cinematicToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetCinematic(Contextual.Toggles.Cinematic)
    end

    Contextual.Toggles.Combat, combatToggle = ImGuiExt.Checkbox(ContextualText.combat, Contextual.Toggles.Combat, combatToggle)
    if combatToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetCombat(Contextual.Toggles.Combat)
    end

    Contextual.Toggles.Photomode, photoModeToggle = ImGuiExt.Checkbox(ContextualText.photoMode, Contextual.Toggles.Photomode, photoModeToggle)
    if photoModeToggle then
      SaveUserSettings()
      ImGuiExt.SetStatusBar(GeneralText.settings_saved)
      SetPhotoMode(Contextual.Toggles.Photomode)
    end

    if Settings.IsDebugMode() then
      ImGui.Text("")
      ImGuiExt.Text("Current States:")
      ImGui.Separator()
      ImGuiExt.Text(StringifyStates())

      ImGui.Separator()

      local fgStatus = "Enabled"
      if Contextual.FGEnabled == true then
        fgStatus = "Enabled"
      else
        fgStatus = "Disabled"
      end

      ImGuiExt.Text("Table Frame Gen State: " .. fgStatus)

      ImGui.Separator()

      local realTimeState = tostring(GetFrameGenState())
      ImGuiExt.Text("Real-Time Frame Gen State: " .. realTimeState)
    end

    ImGui.EndTabItem()
  end

end

return Contextual