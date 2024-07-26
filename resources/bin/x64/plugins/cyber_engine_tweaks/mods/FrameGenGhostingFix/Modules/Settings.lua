local Settings = {
  __NAME = "Settings",
  __VERSION = { 5, 0, 0 },
  isSaved = nil,
}

local ModSettings = {
  isDebug = false,
  isDebugUI = false,
  isHelp = true,
  isFGEnabled = true,
  isKeepWindow = false,
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local Localization = require("Modules/Localization")

local LogText = Localization.LogText

-- @param `isDebug`: boolean; The debug setting to set (`true` for debug mode, `false` for normal mode).
--
-- @return None
function Settings.SetDebug(isDebug)
  ModSettings.isDebug = isDebug
end

-- @return boolean `true` if the mod is currently in debug mode
function Settings.IsDebug()
  return ModSettings.isDebug
end

-- @param `isDebugUI`: boolean; The debug UI state to set (`true` for debug UI visble, `false` for invisble).
--
-- @return None
function Settings.SetDebugUI(isDebugUI)
  ModSettings.isDebugUI = isDebugUI
end

-- @return boolean: `true` if the mod is currently in debug UI visible mode
function Settings.IsDebugUI()
  return ModSettings.isDebugUI
end

-- @param `isHelp`: boolean; The help setting to set (`true` for help mode, `false` for normal mode).
--
-- @return None
function Settings.SetHelp(isHelp)
  ModSettings.isHelp = isHelp
end

-- @return boolean `true` if the mod is currently in help mode
function Settings.IsHelp()
  return ModSettings.isHelp
end

-- @param `isFGEnabled`: boolean; The DLSS Enabler's FG state to set (`true` for FG enabled, `false` for otherwise).
--
-- @return boolean" `true` if operation is succesful
function Settings.SetFrameGeneration(isFGEnabled)
  local result = DLSSEnabler_SetFrameGenerationState(isFGEnabled)

  if result then
    ModSettings.isFGEnabled = isFGEnabled
  else
    Globals.Print(Settings.__NAME, "Couldn't set Frame Generation using API.")
  end
end

-- @return boolean: `true` for DLSS Enabler's FG enabled
function Settings.IsFrameGeneration()
  return ModSettings.isFGEnabled
end

-- @param `isKeepWindow`: boolean; The keep window state to set (`true` to keep the window open, `false` to allow it to close, prioritized over isOpenWindow).
--
-- @return None
function Settings.SetKeepWindow(isKeepWindow)
  ModSettings.isKeepWindow = isKeepWindow
end

-- @return boolean: `true` for keep the window open
function Settings.IsKeepWindow()
  return ModSettings.isKeepWindow
end

-- @param `isSaved`: boolean; Tells the mod is settings should be saved OnOverlayClose (`false` to not save, `true` to save).
--
-- @return None
function Settings.SetSaved(isSaved)
  Settings.isSaved = isSaved
end

-- @return boolean: `true` if Settings are set to save user_settings.json OnOverlayClose
function Settings.IsSaved()
  return Settings.isSaved
end

function Settings.WriteUserSettings(moduleName,contents)
  if not contents or not moduleName then Globals.Print(moduleName,"Can't write to user settings") end --debug
  if contents == nil then return end

  local copiedContents = Globals.Deepcopy(contents)

  UserSettings[moduleName] = copiedContents

  Settings.SetSaved(false)
end

function Settings.GetUserSettings(moduleName)
  -- if not moduleName or UserSettings[moduleName] == nil then Globals.Print(moduleName,"Can't get user settings.") return nil end --debug
  if not moduleName or UserSettings[moduleName] == nil then return nil end

  return UserSettings[moduleName]
end

function Settings.LoadFile()
  local file = io.open("user_settings.json", "r")

  if file then
    local userSettingsContents = file:read("*a")
    file:close()
    UserSettings = json.decode(userSettingsContents)

    local version = UserSettings.Version or false

    if not version or not Globals.VersionCompare(Globals.VersionStringToTable(version)) then
      Globals.SetNewInstall(true)
    end

    ModSettings.isDebug = UserSettings.Globals and UserSettings.Globals.isDebug or false
    ModSettings.isDebugUI = UserSettings.Globals and UserSettings.Globals.isDebugUI or false
    ModSettings.isFGEnabled = UserSettings.Globals and UserSettings.Globals.isFGEnabled or true
    ModSettings.isHelp = UserSettings.Globals and UserSettings.Globals.isHelp or true
    ModSettings.isKeepWindow = UserSettings.Globals and UserSettings.Globals.isKeepWindow or false

    Globals.Print(Settings.__NAME,LogText.settings_loaded)
    return true
  else
    Globals.SetFirstRun(true)
    Globals.Print(Settings.__NAME,LogText.settings_fileNotFound)
  end
end

function Settings.SaveFile()
  if Settings.isSaved or Settings.isSaved == nil then return end
  if UserSettings == nil then Globals.Print(Settings.__NAME,LogText.settings_notSavedToFile) return end

  Settings.WriteUserSettings("ModSettings", ModSettings)

  Settings.WriteUserSettings("Version", FrameGenGhostingFix.GetVersion(true))

  local userSettingsContents = json.encode(UserSettings)
  local file = io.open("user_settings.json", "w+")

  if file and userSettingsContents ~= nil then
    file:write(userSettingsContents)
    file:close()

    file = io.open("user_settings.json", "r")

    if file then
      file:close()

      Settings.SetSaved(true)
      Globals.Print(Settings.__NAME,LogText.settings_savedToFile)
    else
      Settings.SetSaved(false)
      Globals.Print(Settings.__NAME,LogText.settings_notSavedToFile)
    end
  else
    Settings.SetSaved(false)
    Globals.Print(Settings.__NAME,LogText.settings_notSavedToFile)
  end
end

function Settings.OnInitialize()
  Settings.LoadFile()
end

function Settings.OnOverlayClose()
  Settings.SaveFile()
end

return Settings