local Contextual = {
  __NAME = "Contextual",
  __VERSION_NUMBER = 500,
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
    Menu = false,
  },
  CurrentStates = {
    isVehicleStatic = false,
    isVehicleDriving = false,
    isVehicleStaticCombat = false,
    isVehicleDrivingCombat = false,
    isStanding = false,
    isWalking = false,
    isSlowWalking = false,
    isSprinting = false,
    isSwimming = false,
    isCombat = false,
    isBraindance = false,
    isCinematic = false,
    isPhotoMode = false,
    isMenu = false,
  },
  FGEnabled = false,
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local Vectors = require("Modules/Vectors")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local UI = require("Modules/UI")

local UIText = Localization.UIText

-- local Translate = require("Modules/Translate")

local function GetUserSettings()
  UserSettings = {
    Toggles = Contextual.Toggles
  }

  return UserSettings
end

local function LoadUserSettings()
  Globals.MergeTables(Contextual, Settings.GetUserSettings("Contextual"))
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
  "\n" .. "Standing: " .. Capitalize(tostring(Contextual.CurrentStates.isStanding)) ..
  "\n" .. "Walking: " .. Capitalize(tostring(Contextual.CurrentStates.isWalking)) ..
  "\n" .. "SlowWalking: " .. Capitalize(tostring(Contextual.CurrentStates.isSlowWalking)) ..
  "\n" .. "Sprinting: " .. Capitalize(tostring(Contextual.CurrentStates.isSprinting)) ..
  "\n" .. "Swimming: " .. Capitalize(tostring(Contextual.CurrentStates.isSwimming)) ..
  "\n" .. "Combat: " .. Capitalize(tostring(Contextual.CurrentStates.isCombat)) ..
  "\n" .. "Braindance: " .. Capitalize(tostring(Contextual.CurrentStates.isBraindance)) ..
  "\n" .. "Cinematic: " .. Capitalize(tostring(Contextual.CurrentStates.isCinematic)) ..
  "\n" .. "PhotoMode: " .. Capitalize(tostring(Contextual.CurrentStates.isPhotoMode)) ..
  "\n" .. "Menu: " .. Capitalize(tostring(Contextual.CurrentStates.isMenu))
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
  return LocomotionState() ~= 1 and LocomotionState() ~= 3 and LocomotionState() ~= 4
end

-- Same as crouching
local function IsPlayerSlowWalking()
  return LocomotionState() == 3
end

local function IsPlayerSprinting()
  return LocomotionState() == 4
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

local function IsInMenu()
  local ui_System = Game.GetAllBlackboardDefs().UI_System
  return Game.GetBlackboardSystem():Get(ui_System):GetBool(ui_System.IsInMenu)
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
    Standing = Contextual.CurrentStates.isStanding,
    Walking = Contextual.CurrentStates.isWalking,
    SlowWalking = Contextual.CurrentStates.isSlowWalking,
    Sprinting = Contextual.CurrentStates.isSprinting,
    Swimming = Contextual.CurrentStates.isSwimming,
    Combat = Contextual.CurrentStates.isCombat,
    Braindance = Contextual.CurrentStates.isBraindance,
    Cinematic = Contextual.CurrentStates.isCinematic,
    Photomode = Contextual.CurrentStates.isPhotoMode,
    Menu = Contextual.CurrentStates.isMenu
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
  if Contextual.CurrentStates.isVehicleStaticCombat or (playerVehicle and IsPlayerInVehicleCombat(playerVehicle) and not Vectors.Shared.isMovingVehicle) then
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
  if Contextual.CurrentStates.isDrivingCombat or (playerVehicle and IsPlayerInVehicleCombat(playerVehicle) and Vectors.Shared.isMovingVehicle) then
    if not ShouldAffectFGState("Vehicle.DrivingCombat") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetStanding(feature)
  if Contextual.CurrentStates.isStanding or IsPlayerStanding() then
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
  if Contextual.CurrentStates.isSlowWalking or IsPlayerSlowWalking() then
    if not ShouldAffectFGState("SlowWalking") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetSprinting(feature)
  if Contextual.CurrentStates.isSprinting or IsPlayerSprinting() then
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

local function SetMenu(feature)
  if Contextual.CurrentStates.isMenu or IsInMenu() then
    -- Menus are exclusive, so no need to check for other states
    -- if not ShouldAffectFGState("Menu") then return end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

function HandleStaticAndDrivingStates()

  if Vectors.Shared.isMovingVehicle then
    Contextual.CurrentStates.isVehicleStatic = false
    Contextual.CurrentStates.isVehicleDriving = true
  else
    Contextual.CurrentStates.isVehicleStatic = true
    Contextual.CurrentStates.isVehicleDriving = false
  end

  -- Drive events are also present during photo mode and menu
  -- We need special handling here to turn on FG if those toggles are not checked
  if Contextual.CurrentStates.isPhotoMode then
    if Contextual.Toggles.Photomode then
      return
    else
      TurnOnFrameGen()
      return
    end
  end
  if Contextual.CurrentStates.isMenu then
    if Contextual.Toggles.Menu then
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

  LoadUserSettings()

  -- Turn on debug mode during development
  Globals.ModState.isDebug = true

  -- Get the current FG state whenever mod is loaded or reloaded from CET
  Contextual.FGEnabled = GetFrameGenState()

  Observe('PlayerPuppet', 'OnGameAttached', function()
    TurnOnFrameGen()
    Globals.PrintDebug(Contextual.__NAME, "Game started. FG Enabled (PlayerPuppet->OnGameAttached)")
    Contextual.CurrentStates.isMenu = false
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
    Contextual.CurrentStates.isStanding = false
    Contextual.CurrentStates.isWalking = false
    Contextual.CurrentStates.isSlowWalking = false
    Contextual.CurrentStates.isSprinting = false

    -- LocomotionEventsTransition events are also present during photo mode and menu
    -- We need special handling here to turn on FG if those toggles are not checked
    -- Need special handling for photo mode and menu
    if Contextual.CurrentStates.isPhotoMode then
      if Contextual.Toggles.Photomode then
        return
      else
        TurnOnFrameGen()
        return
      end
    end
    if Contextual.CurrentStates.isMenu then
      if Contextual.Toggles.Menu then
        return
      else
        TurnOnFrameGen()
        return
      end
    end

    local locomotionState = LocomotionState()

    if locomotionState == 1 then
      Contextual.CurrentStates.isStanding = true
    elseif  locomotionState == 3 then
      Contextual.CurrentStates.isSlowWalking = true
    elseif  locomotionState == 4 then
      Contextual.CurrentStates.isSprinting = true
    else
      -- There is no specific walking state, so let's assume everything else is walking
      Contextual.CurrentStates.isWalking = true
    end

    if Contextual.Toggles.Standing == true then
      if Contextual.CurrentStates.isStanding then
        TurnOffFrameGen()
      else
        TurnOnFrameGen()
      end
    end
    if Contextual.Toggles.Walking == true then
      if Contextual.CurrentStates.isWalking then
        TurnOffFrameGen()
      else
        TurnOnFrameGen()
      end
    end

    if Contextual.Toggles.SlowWalking then
      if Contextual.CurrentStates.isSlowWalking == true then
        TurnOffFrameGen()
      else
        TurnOnFrameGen()
      end
    end

    if Contextual.Toggles.Sprinting then
      if Contextual.CurrentStates.isSprinting == true then
        TurnOffFrameGen()
      else
        TurnOnFrameGen()
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

  ---------
  -- Menu
  ---------
  -- Start Menu
  Observe('SingleplayerMenuGameController', 'OnInitialize', function()
    Contextual.CurrentStates.isMenu = true

    if Contextual.Toggles.Menu == true then
      TurnOffFrameGen()
      Globals.PrintDebug(Contextual.__NAME, "Menu detected" .. ". FG Disabled (SingleplayerMenuGameController->OnInitialize)")
    end

  end)

  -- Different menus (inventory, map, etc.)
  Observe('gameuiPopupsManager', 'OnMenuUpdate', function(_, IsInMenu)
    Contextual.CurrentStates.isMenu = IsInMenu

    if Contextual.Toggles.Menu == true then
      if Contextual.CurrentStates.isMenu then
        TurnOffFrameGen()
        Globals.PrintDebug(Contextual.__NAME, "Menu detected" .. ". FG Disabled (gameuiPopupsManager->OnMenuUpdate)")
      end
      if not Contextual.CurrentStates.isMenu then
        -- Don't turn it back on if there are existing states with toggle features enabled
        if not ShouldAffectFGState("Menu") then
          TurnOnFrameGen()
          Globals.PrintDebug(Contextual.__NAME, "Menu no longer present" .. ". FG Enabled (gameuiPopupsManager->OnMenuUpdate)")
        else
          Globals.PrintDebug(Contextual.__NAME, "Menu no longer present but other states and toggles are present, so FG state won't change")
        end
      end
    end
  end)
end

function Contextual.OnOverlayOpen()
  -- Refresh UIText
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  -- No need to do translation at the moment to avoid error logs
  -- if Translate then
  --   Translate.SetTranslation("Modules/Contextual", nil)
  -- end
end

function Contextual.OnOverlayClose()
  SaveUserSettings()
end

function Contextual.DrawUI()

  local isVehicleStaticToggled, isVehicleDrivingToggled, isVehicleStaticCombatToggled, isVehicleDrivingCombatToggled, standingToggle, walkingToggle, slowWalkingToggle, sprintingToggle, swimmingToggle, combatToggle, braindanceToggle, cinematicToggle, photoModeToggle, menuToggle

  if UI.Std.BeginTabItem(UIText.Contextual.tabname) then
    if not Globals.ModState.isFGEnabled then
      UI.Std.Text("")
      UI.Ext.TextRed(UIText.Contextual.requirement)
      UI.Std.Text("")
      UI.ResetStatusBar()
      UI.Ext.StatusBar(UI.GetStatusBar())
      UI.Std.EndTabItem()
      return
    end

    UI.Ext.TextWhite(UIText.General.title_general)
    UI.Std.Separator()
    UI.Ext.TextWhite(UIText.Contextual.info)

    UI.Std.Text("")
    UI.Ext.TextWhite("Vehicle:")

    Contextual.Toggles.Vehicle.Static, isVehicleStaticToggled = UI.Ext.Checkbox.TextWhite("Static", Contextual.Toggles.Vehicle.Static, isVehicleStaticToggled)
    if isVehicleStaticToggled then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetVehicleStatic(Contextual.Toggles.Vehicle.Static)
    end

    Contextual.Toggles.Vehicle.Driving, isVehicleDrivingToggled = UI.Ext.Checkbox.TextWhite("Driving", Contextual.Toggles.Vehicle.Driving, isVehicleDrivingToggled)
    if isVehicleDrivingToggled then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetVehicleDriving(Contextual.Toggles.Vehicle.Driving)
    end

    Contextual.Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled = UI.Ext.Checkbox.TextWhite("Static Combat (Weapon Drawn)", Contextual.Toggles.Vehicle.StaticCombat, isVehicleStaticCombatToggled)
    if isVehicleStaticCombatToggled then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetVehicleStaticCombat(Contextual.Toggles.Vehicle.StaticCombat)
    end

    Contextual.Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled = UI.Ext.Checkbox.TextWhite("Driving Combat (Weapon Drawn)", Contextual.Toggles.Vehicle.DrivingCombat, isVehicleDrivingCombatToggled)
    if isVehicleDrivingCombatToggled then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetVehicleDrivingCombat(Contextual.Toggles.Vehicle.DrivingCombat)
    end

    Settings.SetSaved(false)
    UI.SetStatusBar(UIText.General.settings_saved)

    UI.Std.Separator()
    UI.Std.Text("")
    UI.Ext.TextWhite("General:")

    Contextual.Toggles.Standing, standingToggle = UI.Ext.Checkbox.TextWhite("Standing", Contextual.Toggles.Standing, standingToggle)
    if standingToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetStanding(Contextual.Toggles.Standing)
    end

    Contextual.Toggles.Walking, walkingToggle = UI.Ext.Checkbox.TextWhite("Walking (Default)", Contextual.Toggles.Walking, walkingToggle)
    if walkingToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetWalking(Contextual.Toggles.Walking)
    end

    Contextual.Toggles.SlowWalking, slowWalkingToggle = UI.Ext.Checkbox.TextWhite("Slow Walking (Toggle walking)", Contextual.Toggles.SlowWalking, slowWalkingToggle)
    if slowWalkingToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetSlowWalking(Contextual.Toggles.SlowWalking)
    end

    Contextual.Toggles.Sprinting, sprintingToggle = UI.Ext.Checkbox.TextWhite("Sprinting", Contextual.Toggles.Sprinting, sprintingToggle)
    if sprintingToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetSprinting(Contextual.Toggles.Sprinting)
    end

    Contextual.Toggles.Swimming, swimmingToggle = UI.Ext.Checkbox.TextWhite("Swimming", Contextual.Toggles.Swimming, swimmingToggle)
    if swimmingToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetSwimming(Contextual.Toggles.Swimming)
    end

    Contextual.Toggles.Combat, combatToggle = UI.Ext.Checkbox.TextWhite("Combat (Alert Status)", Contextual.Toggles.Combat, combatToggle)
    if combatToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetCombat(Contextual.Toggles.Combat)
    end

    Contextual.Toggles.Braindance, braindanceToggle = UI.Ext.Checkbox.TextWhite("Braindance", Contextual.Toggles.Braindance, braindanceToggle)
    if braindanceToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetBraindance(Contextual.Toggles.Braindance)
    end

    Contextual.Toggles.Cinematic, cinematicToggle = UI.Ext.Checkbox.TextWhite("Cinematic", Contextual.Toggles.Cinematic, cinematicToggle)
    if cinematicToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetCinematic(Contextual.Toggles.Cinematic)
    end

    Contextual.Toggles.Photomode, photoModeToggle = UI.Ext.Checkbox.TextWhite("Photo Mode", Contextual.Toggles.Photomode, photoModeToggle)
    if photoModeToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetPhotoMode(Contextual.Toggles.Photomode)
    end

    Contextual.Toggles.Menu, menuToggle = UI.Ext.Checkbox.TextWhite("Menus", Contextual.Toggles.Menu, menuToggle)
    if menuToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetMenu(Contextual.Toggles.Menu)
    end

    UI.Std.Separator()
    UI.Ext.TextWhite("Current States: ")
    UI.Ext.TextWhite(StringifyStates())

    UI.Std.Separator()

    local fgStatus = "Enabled"
    if Contextual.FGEnabled == true then
      fgStatus = "Enabled"
    else
      fgStatus = "Disabled"
    end

    UI.Ext.TextWhite("Frame Gen: " .. fgStatus)

    UI.Ext.StatusBar(UI.GetStatusBar())
    UI.Std.EndTabItem()
  end

end

return Contextual