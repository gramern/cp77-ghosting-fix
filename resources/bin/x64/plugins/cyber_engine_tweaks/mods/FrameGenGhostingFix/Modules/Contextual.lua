local Contextual = {
  __NAME = "Contextual",
  __VERSION_NUMBER = 500,
  Toggles = {
    Vehicle = false,
    VehicleCombat = false,
    Combat = false,
    Cinematic = false,
    Photomode = false,
    Menu = false,
  },
  CurrentStates = {
    isVehicle = false,
    isVehicleCombat = false,
    isCombat = false,
    isCinematic = false,
    isPhotoMode = false,
    isMenu = false,
  }
}

local UserSettings = {}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local UI = require("Modules/UI")

local UIText = Localization.UIText

-- local Translate = require("Modules/Translate")

function Contextual.GetUserSettings()
  UserSettings = {
    Toggles = Contextual.Toggles
  }

  return UserSettings
end

function Contextual.LoadUserSettings()
  Config.MergeTables(Contextual, Settings.GetUserSettings("Contextual"))
end

function Contextual.SaveUserSettings()
  Settings.WriteUserSettings("Contextual", Contextual.GetUserSettings())
end

function Contextual.TurnOnFrameGen()
  DLSSEnablerSetFrameGeneration(true)
end

function Contextual.TurnOffFrameGen()
  DLSSEnablerSetFrameGeneration(false)
end

function Contextual.StringifyStates()
  return "isVehicle: " .. tostring(Contextual.CurrentStates.isVehicle) ..
  "\n" .. "isVehicleCombat: " ..tostring(Contextual.CurrentStates.isVehicleCombat) ..
  "\n" .. "isCombat: " ..tostring(Contextual.CurrentStates.isCombat) ..
  "\n" .. "isCinematic: " ..tostring(Contextual.CurrentStates.isCinematic) ..
  "\n" .. "isPhotoMode: " ..tostring(Contextual.CurrentStates.isPhotoMode) ..
  "\n" .. "isMenu: " ..tostring(Contextual.CurrentStates.isMenu)
end

function Contextual.IsPlayerDrivingVehicle()
  local playerVehicle = GetMountedVehicle(GetPlayer())
  if not playerVehicle then return false end
  if playerVehicle:IsA('vehicleAVBaseObject') then return false end
  if playerVehicle:IsA('vehicleTankBaseObject') then return false end
  return playerVehicle:IsPlayerDriver()
end

function Contextual.IsInCombat()
	local combatState = tonumber(EnumInt(Game.GetPlayer().GetCurrentCombatState(Game.GetPlayer())))
  -- InCombat
	return combatState == 1
end

function Contextual.IsInMenu()
  local ui_System = Game.GetAllBlackboardDefs().UI_System
  return Game.GetBlackboardSystem():Get(ui_System):GetBool(ui_System.IsInMenu)
end

function Contextual.IsInPhotoMode()
  local photoMode = Game.GetAllBlackboardDefs().PhotoMode
  return Game.GetBlackboardSystem():Get(photoMode):GetBool(photoMode.IsActive)
end

function Contextual.IsInCinematic()
	local sceneTier = Game.GetPlayer().GetSceneTier(Game.GetPlayer())
  -- Tier5_Cinematic
	return sceneTier == 5
end

-- Not used currently but may be helpful in the future
function Contextual.IsInHostileZone()
	local zoneType = tonumber(EnumInt(Game.GetPlayer():GetCurrentSecurityZoneType(Game.GetPlayer())))
	return zoneType == 3 or zoneType == 4
end

-- Not used currently but may be helpful in the future
function Contextual.IsWeaponDrawn()
	return Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), "AttachmentSlots.WeaponRight") ~= nil
end

function Contextual.OnInitialize()

  Contextual.LoadUserSettings()

  Observe('PlayerPuppet', 'OnGameAttached', function()
    Contextual.TurnOnFrameGen()
    Contextual.CurrentStates.isMenu = false
  end)

  -----------
  -- Vehicle
  -----------
  Observe('DriveEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (DriveEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  -- These two events are triggered when players gets into vehicle combat, so we don't want to make isVehicle false
  
  -- Observe('DriveEvents', 'OnExit', function()
  --   Contextual.CurrentStates.isVehicle = false
  --   if Contextual.Toggles.Vehicle == true then
  --     Contextual.TurnOnFrameGen()
  --     Config.Print("Player is no longer in vehicle. Frame Gen is enabled (DriveEvents->OnExit)", nil, nil, Contextual.__NAME)
  --   end
  -- end)
  -- Observe('DriveEvents', 'OnForcedExit', function()
  --   Contextual.CurrentStates.isVehicle = false
  --   if Contextual.Toggles.Vehicle == true then
  --     Contextual.TurnOnFrameGen()
  --     Config.Print("Player is no longer in vehicle. Frame Gen is enabled (DriveEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
  --   end
  -- end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  Observe('EnteringEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (EnteringEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicle = true
    if Contextual.Toggles.Vehicle == true then
      Contextual.TurnOffFrameGen()
      Config.Print("Player is in vehicle. Frame Gen is disabled (EnteringEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- These have reverse operations
  Observe('ExitingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle == true then
      Contextual.TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicle = false
    if Contextual.Toggles.Vehicle == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Player is no longer in vehicle. Frame Gen is enabled (ExitingEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  ------------------
  -- Vehicle Combat
  ------------------
  -- These events are fired the moment weapon is drawn or holster inside the vehicle (even if the alert status is not yet combat)
  Observe('DriverCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOffFrameGen()
      Config.Print("Vehicle combat detected. Frame Gen is disabled (DriverCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriverCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (DriverCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('DriverCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (DriverCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  Observe('EnteringCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOffFrameGen()
      Config.Print("Vehicle combat detected. Frame Gen is disabled (EnteringCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (EnteringCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('EnteringCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = true
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (EnteringCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- These have reverse operations
  Observe('ExitingCombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingCombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('ExitingCombatEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isVehicleCombat = false
    if Contextual.Toggles.VehicleCombat == true and Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Vehicle no longer in combat. Frame Gen is enabled (ExitingCombatEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  ----------
  -- Combat
  ----------
  Observe('CombatEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = true
    if Contextual.Toggles.Combat == true and not Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOffFrameGen()
      Config.Print("Combat mode detected. Frame Gen is disabled (CombatEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)

  -- in case the above events don't trigger (need more testing to rule out redundant events)
  -- These have reverse operations
  Observe('CombatExitingEvents', 'OnEnter', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnEnter)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatExitingEvents', 'OnExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnExit)", nil, nil, Contextual.__NAME)
    end
  end)
  Observe('CombatExitingEvents', 'OnForcedExit', function()
    Contextual.CurrentStates.isCombat = false
    if Contextual.Toggles.Combat == true and not Contextual.IsPlayerDrivingVehicle() then
      Contextual.TurnOnFrameGen()
      Config.Print("Combat mode is no longer present. Frame Gen is enabled (CombatExitingEvents->OnForcedExit)", nil, nil, Contextual.__NAME)
    end
  end)

  Observe("PlayerPuppet", "OnCombatStateChanged", function ()
		Contextual.CurrentStates.isCombat = Contextual.IsInCombat()

    if Contextual.Toggles.Combat == true then
      if Contextual.CurrentStates.isCombat and not Contextual.IsPlayerDrivingVehicle() then
        Contextual.TurnOffFrameGen()
        Config.Print("Combat mode detected. Frame Gen is disabled (PlayerPuppet->OnCombatStateChanged)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isCombat and not Contextual.IsPlayerDrivingVehicle() then
        Contextual.TurnOnFrameGen()
        Config.Print("Combat mode is no longer present. Frame Gen is enabled (PlayerPuppet->OnCombatStateChanged)", nil, nil, Contextual.__NAME)
      end
    end
	end)

  -------------
  -- Cinematic
  -------------
  Observe("PlayerPuppet", "OnSceneTierChange", function (sceneTier)

		Contextual.CurrentStates.isCinematic = Contextual.IsInCinematic()

    if Contextual.Toggles.isCinematic == true then
      if Contextual.CurrentStates.isCinematic then
        Contextual.TurnOffFrameGen()
        Config.Print("Cinematic detected: " .. tostring(sceneTier) .. ". Frame Gen is disabled (PlayerPuppet->OnSceneTierChange)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isCinematic then
        Contextual.TurnOnFrameGen()
        Config.Print("Cinematic no longer present: " .. tostring(sceneTier) .. ". Frame Gen is enabled (PlayerPuppet->OnSceneTierChange)", nil, nil, Contextual.__NAME)
      end
    end
	end)

  ---------------
  -- Photo Mode
  ---------------
  Observe('gameuiPhotoModeMenuController', 'OnShow', function()
    Contextual.CurrentStates.isPhotoMode = true

    if Contextual.Toggles.Photomode == true then
      Contextual.TurnOffFrameGen()
      Config.Print("Photo mode detected" .. ". Frame Gen is disabled (gameuiPhotoModeMenuController->OnShow)", nil, nil, Contextual.__NAME)
    end
  end)

  Observe('gameuiPhotoModeMenuController', 'OnHide', function()
    Contextual.CurrentStates.isPhotoMode = false

    if Contextual.Toggles.Photomode == true then
      Contextual.TurnOnFrameGen()
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
      Contextual.TurnOffFrameGen()
      Config.Print("Menu detected" .. ". Frame Gen is disabled (SingleplayerMenuGameController->OnInitialize)", nil, nil, Contextual.__NAME)
    end

  end)

  -- Different menus (inventory, map, etc.)
  Observe('gameuiPopupsManager', 'OnMenuUpdate', function(_, IsInMenu)
    Contextual.CurrentStates.isMenu = IsInMenu

    if Contextual.Toggles.Menu == true then
      if Contextual.CurrentStates.isMenu or Contextual.IsInMenu() then
        Contextual.TurnOffFrameGen()
        Config.Print("Menu detected" .. ". Frame Gen is disabled (gameuiPopupsManager->OnMenuUpdate)", nil, nil, Contextual.__NAME)
      end
      if not Contextual.CurrentStates.isMenu or not Contextual.IsInMenu() then
        Contextual.TurnOnFrameGen()
        Config.Print("Menu no longer present" .. ". Frame Gen is enabled (gameuiPopupsManager->OnMenuUpdate)", nil, nil, Contextual.__NAME)
      end
    end
  end)

  -- just in case the game doesn't trigger OnExit/OnForcedExit events for some reason
  Observe('PlayerPuppet', 'OnWeaponEquipEvent', function()
    Contextual.TurnOnFrameGen()
  end)
end

function Contextual.SetVehicle(feature)
  if Contextual.CurrentStates.isVehicle or (Contextual.IsPlayerDrivingVehicle() and Contextual.IsInCombat()) then
    if feature == true then

      if Contextual.Toggles.VehicleCombat and Contextual.CurrentStates.isVehicleCombat then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
end

function Contextual.SetVehicleCombat(feature)
  if Contextual.CurrentStates.isVehicleCombat or (Contextual.IsPlayerDrivingVehicle() and Contextual.IsInCombat()) then
    if feature == true then

      if Contextual.Toggles.Vehicle and Contextual.CurrentStates.isVehicle then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
end

function Contextual.SetCombat(feature)
  if Contextual.CurrentStates.isCombat or (Contextual.IsInCombat() and not Contextual.IsPlayerDrivingVehicle()) then
    if feature == true then

      if Contextual.Toggles.Vehicle and Contextual.CurrentStates.isVehicle then
        return
      end
      if Contextual.Toggles.VehicleCombat and Contextual.CurrentStates.isVehicleCombat then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
end

function Contextual.SetCinematic(feature)
  if Contextual.CurrentStates.isCinematic or Contextual.IsInCinematic() then
    if feature == true then

      if Contextual.Toggles.Vehicle and Contextual.CurrentStates.isVehicle then
        return
      end
      if Contextual.Toggles.VehicleCombat and Contextual.CurrentStates.isVehicleCombat then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
end


function Contextual.SetPhotoMode(feature)
  if Contextual.CurrentStates.isPhotoMode or Contextual.IsInPhotoMode()  then
    if feature == true then

      if Contextual.Toggles.Vehicle and Contextual.CurrentStates.isVehicle then
        return
      end
      if Contextual.Toggles.VehicleCombat and Contextual.CurrentStates.isVehicleCombat then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
end

function Contextual.SetMenu(feature)
  if Contextual.CurrentStates.isMenu or Contextual.IsInMenu() then
    if feature == true then

      if Contextual.Toggles.Vehicle and Contextual.CurrentStates.isVehicle then
        return
      end
      if Contextual.Toggles.VehicleCombat and Contextual.CurrentStates.isVehicleCombat then
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

      Contextual.TurnOffFrameGen()
    else
      Contextual.TurnOnFrameGen()
    end
  end
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
  local vehicleToggle, combatToggle, vehicleCombatToggle, cinematicToggle, photoModeToggle, menuToggle

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

    Contextual.Toggles.Vehicle, vehicleToggle = UI.Ext.Checkbox.TextWhite("Vehicle", Contextual.Toggles.Vehicle, vehicleToggle)
    if vehicleToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetVehicle(Contextual.Toggles.Vehicle)
    end

    Contextual.Toggles.VehicleCombat, vehicleCombatToggle = UI.Ext.Checkbox.TextWhite("Vehicle Combat", Contextual.Toggles.VehicleCombat, vehicleCombatToggle)
    if vehicleCombatToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetVehicleCombat(Contextual.Toggles.VehicleCombat)
    end

    Contextual.Toggles.Combat, combatToggle = UI.Ext.Checkbox.TextWhite("Combat", Contextual.Toggles.Combat, combatToggle)
    if combatToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetCombat(Contextual.Toggles.Combat)
    end

    Contextual.Toggles.Cinematic, cinematicToggle = UI.Ext.Checkbox.TextWhite("Cinematic", Contextual.Toggles.Cinematic, cinematicToggle)
    if cinematicToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetCinematic(Contextual.Toggles.Cinematic)
    end

    Contextual.Toggles.Photomode, photoModeToggle = UI.Ext.Checkbox.TextWhite("Photo Mode", Contextual.Toggles.Photomode, photoModeToggle)
    if photoModeToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetPhotoMode(Contextual.Toggles.Photomode)
    end

    Contextual.Toggles.Menu, menuToggle = UI.Ext.Checkbox.TextWhite("Menus", Contextual.Toggles.Menu, menuToggle)
    if menuToggle then
      Settings.SetSaved(false)
      UI.SetStatusBar(UIText.General.settings_saved)
      Contextual.SetMenu(Contextual.Toggles.Menu)
    end

    UI.Std.Separator()
    UI.Ext.TextWhite("Current Event States: ")
    UI.Ext.TextWhite(Contextual.StringifyStates())

    UI.Ext.StatusBar(UI.GetStatusBar())
    UI.Std.EndTabItem()
  end

end

return Contextual