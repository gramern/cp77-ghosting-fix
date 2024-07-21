local Contextual = {
  __NAME = "Contextual",
  __VERSION_NUMBER = 500,
  Toggles = {
    Vehicle = {
      Static = false,
      Driving = false,
      Combat = false,
    },
    Combat = false,
    Cinematic = false,
    Photomode = false,
    Menu = false,
  },
  CurrentStates = {
    isVehicle = false,
    isVehicleStatic = false,
    isVehicleDriving = false,
    isVehicleCombat = false,
    isCombat = false,
    isCinematic = false,
    isPhotoMode = false,
    isMenu = false,
  },
  FGEnabled = false,
}

local UserSettings = {}

local Config = require("Modules/Config")
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
  Config.MergeTables(Contextual, Settings.GetUserSettings("Contextual"))
end

local function SaveUserSettings()
  Settings.WriteUserSettings("Contextual", GetUserSettings())
end

local function TurnOnFrameGen()
  -- Only call external DLSSEnablerSetFrameGeneration method once to avoid overhead
  if Contextual.FGEnabled == false then
    DLSSEnablerSetFrameGeneration(true)
    Contextual.FGEnabled = true
  end
end

local function TurnOffFrameGen()
  -- Only call external DLSSEnablerSetFrameGeneration method once to avoid overhead
  if Contextual.FGEnabled == true then
    DLSSEnablerSetFrameGeneration(false)
    Contextual.FGEnabled = false
  end
end

local function GetFrameGenState()
  return DLSSEnablerGetFrameGenerationState()
end

-- Make the first letter capital
local function Capitalize(str)
  return (str:gsub("^%l", string.upper))
end

local function StringifyStates()
  return "Vehicle: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicle)) ..
  "\n" .. "VehicleStatic: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleStatic)) ..
  "\n" .. "VehicleDriving: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleDriving)) ..
  "\n" .. "VehicleCombat: " .. Capitalize(tostring(Contextual.CurrentStates.isVehicleCombat)) ..
  "\n" .. "Combat: " .. Capitalize(tostring(Contextual.CurrentStates.isCombat)) ..
  "\n" .. "Cinematic: " .. Capitalize(tostring(Contextual.CurrentStates.isCinematic)) ..
  "\n" .. "PhotoMode: " .. Capitalize(tostring(Contextual.CurrentStates.isPhotoMode)) ..
  "\n" .. "Menu: " .. Capitalize(tostring(Contextual.CurrentStates.isMenu))
end

local function GetPlayerVehicle()
  local playerVehicle = GetMountedVehicle(GetPlayer())
  if not playerVehicle then
    Config.Print("Player vehicle cannot be retreived. Subsequent vehicle operations won't work", nil, nil, Contextual.__NAME)
  end

  return playerVehicle
end

local function IsInVehicle()
  local playerVehicle = GetPlayerVehicle()
  if not playerVehicle then return false end
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
	local sceneTier = Game.GetPlayer().GetSceneTier(Game.GetPlayer())
  -- Tier5_Cinematic
	return sceneTier == 5
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

local function SetVehicleStatic(feature)
  local playerVehicle = GetPlayerVehicle()

  if Contextual.CurrentStates.isVehicleStatic or (playerVehicle and IsPlayerVehicleStatic(playerVehicle)) then
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

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
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetVehicleCombat(feature)
  local playerVehicle = GetPlayerVehicle()

  if Contextual.CurrentStates.isVehicleCombat and playerVehicle and IsPlayerVehicleDriving(playerVehicle) then
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCombat(feature)
  if Contextual.CurrentStates.isCombat or (IsInCombat() and not IsInVehicle()) then
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetCinematic(feature)
  if Contextual.CurrentStates.isCinematic or IsInCinematic() then
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end


local function SetPhotoMode(feature)
  if Contextual.CurrentStates.isPhotoMode or IsInPhotoMode()  then
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Menu and Contextual.CurrentStates.isMenu then
      return
    end

    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

local function SetMenu(feature)
  if Contextual.CurrentStates.isMenu or IsInMenu() then
    if Contextual.Toggles.Vehicle.Static and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleStatic then
      return
    end
    if Contextual.Toggles.Vehicle.Driving and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleDriving then
      return
    end
    if Contextual.Toggles.Vehicle.Combat and Contextual.CurrentStates.isVehicle and Contextual.CurrentStates.isVehicleCombat then
      return
    end
    if Contextual.Toggles.Combat and Contextual.CurrentStates.isCombat then
      return
    end
    if Contextual.Toggles.Cinematic and Contextual.CurrentStates.isCinematic then
      return
    end
    if Contextual.Toggles.Photomode and Contextual.CurrentStates.isPhotoMode then
      return
    end
    if feature == true then
      TurnOffFrameGen()
    else
      TurnOnFrameGen()
    end
  end
end

function HandleStaticAndDrivingStates()
  local playerVehicle = GetPlayerVehicle()

  if IsPlayerVehicleStatic(playerVehicle) then
    Contextual.CurrentStates.isVehicleStatic = true
    Contextual.CurrentStates.isVehicleDriving = false
  else
    Contextual.CurrentStates.isVehicleStatic = false
    Contextual.CurrentStates.isVehicleDriving = true
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

  -- Get the current FG state whenever mod is loaded or reloaded from CET
  Contextual.FGEnabled = GetFrameGenState()

  Observe('PlayerPuppet', 'OnGameAttached', function()
    TurnOnFrameGen()
    Config.Print("Game started. Frame Gen is enabled (PlayerPuppet->OnGameAttached)", nil, nil, Contextual.__NAME)
    Contextual.CurrentStates.isMenu = false
  end)

  -- This will prove useful in future to set contexts based on camera perspective
  -- Observe('VehicleTransition', 'RequestToggleVehicleCamera', function() end)

  -----------
  -- Vehicle
  -----------
  Observe('DriveEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle.Static == true and IsInVehicle() then
      TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (DriveEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  -- These methods are essential to make sure frame gen is turned on when weapon is drawn (so transitioning to combat)
  Observe('DriveEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle.Static == true then
      TurnOnFrameGen()
      Config.Print("Player is in vehicle but switching to combat. Frame Gen is enabled (DriveEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriveEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle.Static == true then
      TurnOnFrameGen()
      Config.Print("Player is in vehicle but switching to combat. Frame Gen is enabled (DriveEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  Observe('EnteringEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle.Static == true and IsInVehicle() then
      TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (EnteringEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle.Static == true then
      TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (EnteringEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- These have reverse operations
  Observe('ExitingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle.Static == true then
      TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle.Static == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle.Static == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  ----------------------
  -- Static and Driving
  ----------------------
  -- This is not triggered when weapon is drawn (so essentially vehicle combat mode)
  -- So it won't set static and driving states during it
  -- DriverCombatEvents->OnUpdate will handle vehicle combat static and driving events
  Observe('DriveEvents', 'OnUpdate', function()
    HandleStaticAndDrivingStates()
  end)

  ------------------
  -- Vehicle Combat
  ------------------
  -- These events are fired the moment weapon is drawn or holster inside the vehicle (even if the alert status is not yet combat)
  Observe('DriverCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOffFrameGen()
      Config.Print("Vehicle combat detected. Frame Gen is disabled (DriverCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriverCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (DriverCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriverCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (DriverCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriverCombatEvents', 'OnUpdate', function()
    HandleStaticAndDrivingStates()
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  Observe('EnteringCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOffFrameGen()
      Config.Print("Vehicle combat detected. Frame Gen is disabled (EnteringCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (EnteringCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (EnteringCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- These have reverse operations
  Observe('ExitingCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.Vehicle.Combat == true and IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  ----------
  -- Combat
  ----------
  -- These events occur when Alert status (on top right below the map) is set to Combat
  -- This is different from vehicle combat mode (which is only about whether player is using weapons inside the vehicle regardless of the alert status)
  Observe('CombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = true
    if Contextual.Toggles.Combat == true and not IsInVehicle() then
      TurnOffFrameGen()
      Config.Print("Combat mode detected. Frame Gen is disabled (CombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  -- These have reverse operations
  Observe('CombatExitingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatExitingEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatExitingEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not IsInVehicle() then
      TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  Observe("PlayerPuppet", "OnCombatStateChanged", function ()
		Contextual.CurrentStates.isCombat = IsInCombat()

    if Contextual.Toggles.Combat == true then
      if Contextual.CurrentStates.isCombat and not IsInVehicle() then
        TurnOffFrameGen()
        Config.Print("Combat mode detected. Frame Gen is disabled (PlayerPuppet->OnCombatStateChanged)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isCombat and not IsInVehicle() then
        TurnOnFrameGen()
        Config.Print("Combat mode is no longer present. Frame Gen is enabled (PlayerPuppet->OnCombatStateChanged)", nil, nil, Contextual.__NAME)
      end
    end
	end)

  -------------
  -- Cinematic
  -------------
  Observe("PlayerPuppet", "OnSceneTierChange", function (sceneTier)

		Contextual.CurrentStates.isCinematic = sceneTier == 5 or IsInCinematic()

    if Contextual.Toggles.isCinematic == true then
      if Contextual.CurrentStates.isCinematic then
        TurnOffFrameGen()
        Config.Print("Cinematic detected. Frame Gen is disabled (PlayerPuppet->OnSceneTierChange)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isCinematic then
        TurnOnFrameGen()
        Config.Print("Cinematic no longer present. Frame Gen is enabled (PlayerPuppet->OnSceneTierChange)", nil, nil, Contextual.__NAME)
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
      Config.Print("Photo mode detected" .. ". Frame Gen is disabled (gameuiPhotoModeMenuController->OnShow)", nil, nil, Contextual.__NAME)
    end
  end)

  Observe('gameuiPhotoModeMenuController', 'OnHide', function()
    Contextual.CurrentStates.isPhotoMode = false

    if Contextual.Toggles.Photomode == true then
      TurnOnFrameGen()
      Config.Print("Photo mode no longer preset" .. ". Frame Gen is enabled (gameuiPhotoModeMenuController->OnHide)", nil, nil, Contextual.__NAME)
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
      Config.Print("Menu detected" .. ". Frame Gen is disabled (SingleplayerMenuGameController->OnInitialize)", nil, nil, Contextual.__NAME)
    end

  end)

  -- Different menus (inventory, map, etc.)
  Observe('gameuiPopupsManager', 'OnMenuUpdate', function(_, IsInMenu)
    Contextual.CurrentStates.isMenu = IsInMenu

    if Contextual.Toggles.Menu == true then
      if Contextual.CurrentStates.isMenu or IsInMenu() then
        TurnOffFrameGen()
        Config.Print("Menu detected" .. ". Frame Gen is disabled (gameuiPopupsManager->OnMenuUpdate)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isMenu or not IsInMenu() then
        TurnOnFrameGen()
        Config.Print("Menu no longer present" .. ". Frame Gen is enabled (gameuiPopupsManager->OnMenuUpdate)", nil, nil, Contextual.__NAME)
      end
    end
  end)

  SaveUserSettings()
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

function Contextual.DrawUI()

  local isVehicleStaticToggled, isVehicleDrivingToggled, isVehicleCombatToggled, combatToggle, cinematicToggle, photoModeToggle, menuToggle

  if UI.Std.BeginTabItem(UIText.Contextual.tabname) then
    if not Config.ModState.isFGEnabled then
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

    Contextual.Toggles.Vehicle.Combat, isVehicleCombatToggled = UI.Ext.Checkbox.TextWhite("Combat (Weapon Drawn)", Contextual.Toggles.Vehicle.Combat, isVehicleCombatToggled)
    if isVehicleCombatToggled then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetVehicleCombat(Contextual.Toggles.Vehicle.Combat)
    end

    Settings.SetSaved(false)
    UI.SetStatusBar(UIText.General.settings_saved)

    UI.Std.Separator()
    UI.Std.Text("")
    UI.Ext.TextWhite("General:")

    Contextual.Toggles.Combat, combatToggle = UI.Ext.Checkbox.TextWhite("Combat (Status)", Contextual.Toggles.Combat, combatToggle)
    if combatToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      SetCombat(Contextual.Toggles.Combat)
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