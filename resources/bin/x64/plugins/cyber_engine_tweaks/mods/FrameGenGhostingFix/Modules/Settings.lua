local Settings = {
  __NAME = "Settings",
  __VERSION = { 5, 0, 0 },
}

local ModSettings = {
  isDebugMode = false,
  isDebugView = false,
  isHelp = true,
  isFGEnabled = true,
  isKeepWindow = false,
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local Localization = require("Modules/Localization")

local LogText = Localization.LogText

------------------
-- Save To File Reqests
------------------

local isSaveRequest = nil

-- @return boolean: `true` if Settings are set to save user_settings.json OnOverlayClose
function Settings.IsSaveRequest()
  return isSaveRequest
end

local function ResetSaveRequest()
  isSaveRequest = false
end

local function SaveRequest()
  isSaveRequest = true
end

------------------
-- Mod Settings
------------------

local function LoadModSettings()
  local version = UserSettings.Version or false

  if not version or not Globals.VersionCompare(Globals.VersionStringToTable(version)) then
    Globals.SetNewInstall(true)
  end

  ModSettings.isDebugMode = UserSettings.DebugMode or false
  ModSettings.isDebugView = UserSettings.DebugView or false
  ModSettings.isFGEnabled = UserSettings.FrameGen or true
  ModSettings.isHelp = UserSettings.Help or true
  ModSettings.isKeepWindow = UserSettings.KeepWindow or false

  Globals.Print(Settings.__NAME,LogText.settings_loaded)
end

local function SaveModSettings()
  local modSettings = {
    DebugMode = ModSettings.isDebugMode,
    DebugView = ModSettings.isDebugView,
    FrameGen = ModSettings.isDebugView,
    Help = ModSettings.isHelp,
    KeepWindow = ModSettings.isKeepWindow
  }

  Settings.WriteUserSettings("ModSettings", modSettings)

  Settings.WriteUserSettings("Version", FrameGenGhostingFix.GetVersion(true))
end

-- @param `isDebugMode`: boolean; The debug setting to set (`true` for debug mode, `false` for normal mode).
--
-- @return None
function Settings.SetDebugMode(isDebugMode)
  ModSettings.isDebugMode = isDebugMode
  SaveRequest()
end

-- @return boolean `true` if the mod is currently in debug mode
function Settings.IsDebugMode()
  return ModSettings.isDebugMode
end

-- @param `isDebugView`: boolean; The debug UI state to set (`true` for debug UI visble, `false` for invisble).
--
-- @return None
function Settings.SetDebugView(isDebugView)
  ModSettings.isDebugView = isDebugView
  SaveRequest()
end

-- @return boolean: `true` if the mod is currently in debug UI visible mode
function Settings.IsDebugView()
  return ModSettings.isDebugView
end

-- @param `isHelp`: boolean; The help setting to set (`true` for help mode, `false` for normal mode).
--
-- @return None
function Settings.SetHelp(isHelp)
  ModSettings.isHelp = isHelp
  SaveRequest()
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
    SaveRequest()
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
  SaveRequest()
end

-- @return boolean: `true` for keep the window open
function Settings.IsKeepWindow()
  return ModSettings.isKeepWindow
end

------------------
-- UserSettings
------------------

--- Writes to the UserSettings table and sets a global save reqest to the file on CET overlay close.
--
-- @param `moduleName`: string; The name of the module for which settings are being written.
-- @param `contents`: table; The settings to be written for the module.
--
-- @return None; 
function Settings.WriteUserSettings(moduleName, contents)
  if not moduleName or not contents then Globals.PrintDebug(Settings.__NAME, "Can't write to user settings") return end --debug

  local copiedContents = Globals.Deepcopy(contents)

  UserSettings[moduleName] = copiedContents

  SaveRequest()
end

-- @param `moduleName`: string; The name of the module for which settings are being retrieved.
--
-- @return table | nil; Returns the user settings for the specified module if they exist, otherwise returns nil
function Settings.GetUserSettings(moduleName)
  if not moduleName or UserSettings[moduleName] == nil then return nil end

  return UserSettings[moduleName]
end

------------------
-- File Handling
------------------

-- @return None
local function LoadFile()
  local file = io.open("user_settings.json", "r")

  if file then
    local userSettingsContents = file:read("*a")
    file:close()
    UserSettings = json.decode(userSettingsContents)

    LoadModSettings()
  else
    Globals.SetFirstRun(true)
    Globals.Print(Settings.__NAME,LogText.settings_fileNotFound)
  end
end

-- @return None
local function SaveFile()
  if not isSaveRequest then return end -- file won't be saved without change to the UserSettings table
  if UserSettings == nil then Globals.PrintDebug(Settings.__NAME,LogText.settings_notSavedToFile) return end

  SaveModSettings()

  local userSettingsContents = json.encode(UserSettings)
  local file = io.open("user_settings.json", "w+")

  if file and userSettingsContents ~= nil then
    file:write(userSettingsContents)
    file:close()

    ResetSaveRequest()
    Globals.Print(Settings.__NAME,LogText.settings_savedToFile)
  else
    ResetSaveRequest()
    Globals.PrintError(Settings.__NAME,LogText.settings_notSavedToFile)
  end
end

------------------
-- On... registers
------------------

function Settings.OnInitialize()
  LoadFile()
end

function Settings.OnOverlayClose()
  SaveFile()
end

return Settings