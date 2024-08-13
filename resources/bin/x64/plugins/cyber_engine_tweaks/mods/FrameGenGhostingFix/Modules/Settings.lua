local Settings = {
  __NAME = "Settings",
  __VERSION = { 5, 0, 0 },
}

local ModSettings = {}

local UserSettings = {}

local Globals = require("Modules/Globals")
local Localization = require("Modules/Localization")
local Tracker = require("Modules/Tracker")

local LogText = Localization.GetLogText()

------------------
-- Locl Reqests
------------------

local isSaveRequest = nil
local isLoadRequest = nil

-- @return boolean: `true` if Settings are set to save user-settings.json OnOverlayClose
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
-- File Version
------------------

local function CheckFileVersion(fileVersion)
  if not fileVersion or not Globals.VersionCompare(FrameGenGhostingFix.GetDLSSEnablerVersion(true), Globals.VersionStringToTable(fileVersion)) then
    Tracker.SetModNewInstall(true)
  end
end

------------------
-- Mod Settings
------------------

local function LoadModSettings(modSettings)
  ModSettings.isDebugMode = modSettings and modSettings.DebugMode or false
  ModSettings.isDebugView = modSettings and modSettings.DebugView or false
  ModSettings.isFGEnabled = modSettings and modSettings.FrameGen or true
  ModSettings.isHelp = modSettings and modSettings.Help or true
  ModSettings.isKeepWindow = modSettings and modSettings.KeepWindow or false
  ModSettings.isMessage = modSettings and modSettings.Message or false
  ModSettings.windowTheme = modSettings and modSettings.WindowTheme or "Crimson"
end

local function SaveModSettings()
  local modSettings = {
    DebugMode = ModSettings.isDebugMode,
    DebugView = ModSettings.isDebugView,
    FrameGen = ModSettings.isDebugView,
    Help = ModSettings.isHelp,
    KeepWindow = ModSettings.isKeepWindow,
    Message = ModSettings.isMessage,
    WindowTheme = ModSettings.windowTheme
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

-- @return boolean: `true` if the mod is currently in help mode
function Settings.IsHelp()
  return ModSettings.isHelp
end

-- @param `isFGEnabled`: boolean; The DLSS Enabler's FG state to set (`true` for FG enabled, `false` for otherwise).
--
-- @return boolean: `true` if operation is succesful
function Settings.SetModFrameGeneration(isFGEnabled)
  local result = DLSSEnabler_SetFrameGenerationState(isFGEnabled)

  if result then
    ModSettings.isFGEnabled = isFGEnabled

    Tracker.SetModFrameGeneration(isFGEnabled) -- update Tracker's value

    SaveRequest()
    return true
  else
    Globals.Print(Settings.__NAME, "Couldn't set Frame Generation using API.")
    return false
  end
end

-- @return boolean: `true` for DLSS Enabler's FG enabled
function Settings.IsModFrameGeneration()
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

-- @param `isDelivered`: boolean; Whether a message has been delivered to user.
--
-- @return None
function Settings.SetMessage(isDelivered)
  ModSettings.isMessage = isDelivered
  SaveRequest()
end

-- @return boolean: `true` if a message has been delivered to user.
function Settings.IsMessage()
  return ModSettings.isMessage
end

-- @return string; Selected Theme name
function Settings.GetTheme()
  return ModSettings.windowTheme
end

--- Saves the current theme based on the provided theme name.
--
-- @param `themeName`: string; The name of the theme to be applied.
--
-- @return None
function Settings.SetTheme(themeName)
  ModSettings.windowTheme = themeName

  SaveRequest()
end

------------------
-- UserSettings
------------------

--- Writes to the UserSettings table and sets a global save reqest to the file on CET overlay close.
--
-- @param `poolName`: string; The name for which settings are being written.
-- @param `contents`: table; The settings to be written for the module.
--
-- @return None; 
function Settings.WriteUserSettings(poolName, contents)
  if not poolName or not contents then Globals.PrintDebug(Settings.__NAME, "Can't write to user settings") return end --debug

  local copiedContents = Globals.Deepcopy(contents)

  UserSettings[poolName] = copiedContents

  SaveRequest()
end

-- @param `poolName`: string; The name for which settings are being retrieved. If no poolName, the whole UserSettings table.
--
-- @return table | nil; Returns the user settings for the specified module if they exist, otherwise returns nil
function Settings.GetUserSettings(poolName)
  if not poolName then
    return UserSettings or nil
  elseif UserSettings[poolName] == nil then return nil end

  return UserSettings[poolName]
end

------------------
-- File Handling
------------------

local function LoadFile()
  local userSettingsContents = Globals.Deepcopy(Globals.LoadJSON("user-settings"))

  if userSettingsContents then
    UserSettings = Globals.Deepcopy(userSettingsContents)

    Globals.Print(Settings.__NAME, LogText.settings_loaded)
    Globals.PrintDebug(Settings.__NAME, LogText.settings_loaded)
    return true
  else
    Tracker.SetModFirstRun(true)
    Globals.Print(Settings.__NAME, LogText.settings_file_not_found)
    return false
  end
end

local function SaveFile()
  if not isSaveRequest then return end -- file won't be saved without change to the UserSettings table
  if UserSettings == nil then Globals.PrintDebug(Settings.__NAME, LogText.settings_not_saved_to_file) return end

  SaveModSettings()

  local result = Globals.SaveJSON("user-settings", UserSettings)

  if result then
    ResetSaveRequest()
    Globals.Print(Settings.__NAME, LogText.settings_saved_to_file)
  else
    ResetSaveRequest()
    Globals.PrintError(Settings.__NAME, LogText.settings_not_saved_to_file)
  end
end

------------------
-- On... registers
------------------

function Settings.OnInitialize()
  LoadFile()
  CheckFileVersion(Settings.GetUserSettings("Version"))
  LoadModSettings(Settings.GetUserSettings("ModSettings"))
end

-- The mod forcefully tries to load user-settings.json if it didn't onInit
function Settings.OnOverlayOpen()
  if UserSettings == nil then
    local result = LoadFile()

    if result then 
      LoadModSettings(Settings.GetUserSettings("ModSettings"))
    else
      SaveRequest()
    end
  end
end

function Settings.OnOverlayClose()
  SaveFile()
end

-- leaving for later: another way to make th mod forcefully try to load user-settings.json if it didn't onInit
function Settings.OnUpdate()
  if not isLoadRequest and UserSettings == nil then
    local result = LoadFile()

    if result and UserSettings and UserSettings.ModSettings then
      if UserSettings and UserSettings.ModSettings and UserSettings.ModSettings.DebugMode then
        Globals.PrintTable(UserSettings)
      end

      LoadModSettings(Settings.GetUserSettings("ModSettings"))

      FrameGenGhostingFix.SetLoadUserSettingsFileAttmept(true)
      isLoadRequest = true

      Globals.PrintDebug(Settings.__NAME, LogText.settings_loaded)
    else
      FrameGenGhostingFix.SetLoadUserSettingsFileAttmept(true)
      isLoadRequest = true

      Globals.Print(Settings.__NAME, LogText.settings_file_not_found)
    end 
  end

  if UserSettings ~= nil then
    FrameGenGhostingFix.SetLoadUserSettingsFileAttmept(true)

    isLoadRequest = true

    Globals.PrintDebug(Settings.__NAME, "UserSettings found, stopping the check.")
  end
end

return Settings