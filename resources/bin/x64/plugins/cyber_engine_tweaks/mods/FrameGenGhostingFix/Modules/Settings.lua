local Settings ={
  __NAME = "Settings",
  __VERSION_NUMBER = 500,
  isSaved = nil,
}

local UserSettings = {}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")

local LogText = Localization.LogText

function Settings.SetSaved(boolean)
  Settings.isSaved = boolean
end

function Settings.IsSaved()
  return Settings.isSaved
end

local function Translate(legacyUserSettings)
  local userSettings = {
    Calculate = {
      Blocker = {},
      Corners = {},
      Vignette = {
        ScreenPosition = {},
        Scale = {}
      }
    },
    Contextual = {
      Toggles = {
        Vehicle = nil,
        VehicleCombat = nil,
        Combat = nil,
        Cutscenes = nil,
        Photomode = nil,
        Menu = nil,
      }
    },
    Config = {
      version = nil,
      keepWindow = nil,
      isFGEnabled = nil,
    },
    VectorsCustomize = {
      Bike = {
        Windshield = {
          Scale = {}
        }
      }
    },
    Presets = {
      selectedPreset = nil,
    }
  }

  userSettings.Calculate.Blocker.onAim = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.enabledBlockerAimOnFoot or false
  userSettings.Calculate.Corners.onWeapon = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.enabledOnFoot or false
  userSettings.Calculate.Vignette.onAim = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.enabledVignetteAimOnFoot or false
  userSettings.Calculate.Vignette.permament = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.enabledVignettePermamentOnFoot or false
  userSettings.Calculate.Vignette.onWeapon = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.enabledVignetteOnFoot or false
  userSettings.Calculate.Vignette.ScreenPosition.x = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.vignetteFootMarginLeft or 100
  userSettings.Calculate.Vignette.ScreenPosition.y = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.vignetteFootMarginTop or 80
  userSettings.Calculate.Vignette.Scale.x = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.vignetteFootSizeX or 120
  userSettings.Calculate.Vignette.Scale.y = legacyUserSettings.FPPOnFoot and legacyUserSettings.FPPOnFoot.vignetteFootSizeY or 120

  userSettings.VectorsCustomize.Bike.Windshield.Scale.x = legacyUserSettings.FPPBikeWindshield and legacyUserSettings.FPPBikeWindshield.width or 100
  userSettings.VectorsCustomize.Bike.Windshield.Scale.y = legacyUserSettings.FPPBikeWindshield and legacyUserSettings.FPPBikeWindshield.height or 100

  userSettings.Config.keepWindow = legacyUserSettings.General and legacyUserSettings.General.enabledWindow or false

  return userSettings
end

function Settings.WriteUserSettings(moduleName,contents)
  if not contents or not moduleName then Config.Print("Can't write to user settings",nil,nil,moduleName) end --debug
  if contents == nil then return end

  local copiedContents = Config.Deepcopy(contents)

  UserSettings[moduleName] = copiedContents

  Settings.SetSaved(false)
end

function Settings.GetUserSettings(moduleName)
  -- if not moduleName or UserSettings[moduleName] == nil then Config.Print("Can't get user settings.",nil,nil,moduleName) return nil end --debug
  if not moduleName or UserSettings[moduleName] == nil then return nil end

  return UserSettings[moduleName]
end

function Settings.LoadFile()
  local file = io.open("user_settings.json", "r")

  if file then
    local userSettingsContents = file:read("*a")
    file:close()
    UserSettings = json.decode(userSettingsContents)

    local version = UserSettings.Config and UserSettings.Config.ModState and UserSettings.Config.ModState.version or false

    if not version then
      UserSettings = Translate(UserSettings)
      Config.SetNewInstall(true)
    end

    Config.ModState.keepWindow = UserSettings.Config and UserSettings.Config.keepWindow or false

    Config.Print(LogText.settings_loaded,nil,nil,Settings.__NAME)
    return true
  else
    Config.SetFirstRun(true)
    Config.Print(LogText.settings_fileNotFound,nil,nil,Settings.__NAME)
  end
end

function Settings.SaveFile()
  if Settings.isSaved or Settings.isSaved == nil then return end
  if UserSettings == nil then Config.Print(LogText.settings_notSavedToFile,nil,nil,Settings.__NAME) return end

  Settings.WriteUserSettings("Config",{
    ModState = {
      keepWindow = Config.ModState.keepWindow,
      isFGEnabled = Config.ModState.isFGEnabled,
      version = Config.__VERSION_NUMBER,
  }})

  local userSettingsContents = json.encode(UserSettings)
  local file = io.open("user_settings.json", "w+")

  if file and userSettingsContents ~= nil then
    file:write(userSettingsContents)
    file:close()

    file = io.open("user_settings.json", "r")

    if file then
      file:close()

      Settings.SetSaved(true)
      Config.Print(LogText.settings_savedToFile,nil,nil,Settings.__NAME)
    else
      Settings.SetSaved(false)
      Config.Print(LogText.settings_notSavedToFile,nil,nil,Settings.__NAME)
    end
  else
    Settings.SetSaved(false)
    Config.Print(LogText.settings_notSavedToFile,nil,nil,Settings.__NAME)
  end
end

function Settings.OnInitialize()
  Settings.LoadFile()
end

function Settings.OnOverlayClose()
  Settings.SaveFile()
end

return Settings