Localization = {
  __NAME = "Localization",
  __VERSION = { 5, 0, 0 },
}

local UIText = {
  General = {
    title_general = "General Settings:",
    title_fps90 = "90+ FPS FG ON Settings:",
    title_fps100 = "100+ FPS FG ON Settings:",
    title_fps120 = "120+ FPS FG ON Settings:",
    yes = "Yes",
    no = "No",
    apply = "Apply",
    cancel = "Cancel",
    default = "Set to default",
    disabled = "Disabled",
    enabled = "Enabled",
    presets_comboBox = "Use this preset:",
    presets_comboBox_tooltip = "Choose a preset of anti-ghosting.",
    save = "Save",
    settings_loaded = "User settings loaded.",
    settings_loaded_preset = "Preset loaded",
    settings_applied_veh = "[ ! ] Selected preset applied.",
    settings_restored = "Restored your previous settings.",
    settings_load = "Load settings",
    settings_save = "Save settings",
    settings_saved = "[ ! ] Your settings will be saved.",
    settings_applied_onfoot = "[ ! ] Redraw your weapon to accept changes.",
    settings_default = "Default settings restored.",
    info_getOut = "[ ! ] V must exit a vehicle to customize this option.",
    info_getIn = "[ ! ] V must be in a vehicle to customize this option.",
    info_aimOnFoot = "[ ! ] You can enable one aiming/blocking feature at once.",
    info_diagnostics = "Potential conflicts with other mods detected.",
    info_modNotReady = "[ ! ] Mod isn't working. Check logs for details...",
    info_version = "Mod version:",
    info_vectorsMissing = "No compatible 'Vectors' module found.",
    info_frameGenStatus = "Current Frame Generation Status:",
    info_frameGenOff = "[ ! ] Frame Generation is turned off in the game's settings. Masking is turned off.",
    info_noMaskingOnFoot = "[ ! ] Ghosting masking On-Foot is turned off globally.",
    info_noMaskingVehicles = "[ ! ] Ghosting masking for vehicles is turned off globally.",
  },
  Info = {
    tabname = "Info",
    aspectRatioChange = "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod will work as intended.",
    benchmark = "[ ! ] FrameGen Ghosting 'Fix' is benchmarking your game's performance. Please continue playing freely: once the benchmark is finished, the mod will apply optimal settings for your game's performance. You can change those settings later.\n\nThe benchmark is conducted during the first run of the mod.",
    benchmarkAsk = "[ ! ] Do you want to run a benchmark to let the mod measure your game's performance and set optimal anti-ghosting settings?\n\nIt will happen in the background, please continue playing freely.",
    modNotReady = "The mod encountered a problem:",
  },
  Vehicles = {
    tabname = "Vehicles",
    MaskingPresets = {
      name = "Use this preset for vehicles:",
      tooltip = "Choose a preset of anti-ghosting for vehicles.",
      description = "Preset's info:",
      author = "Preset's author:",
    },
    Windshield = {
      name = "Customize motorcycle windshield mask",
      tooltip = "Enables customization of the anti-ghosting mask to stop frame generation from occuring locally around a windshield when riding a motorcycle.",
      textfield_1 = "The sliders below let you customize the size of the motorcycle windshield mask. Usually not necessary, may turn out handy for some motorcycles like Apollo.",
      setting_1 = "Windshield anti-ghosting mask width:",
      setting_2 = "Windshield anti-ghosting mask height:",
      comment_1 = "Scale width",
      comment_2 = "Scale height",
      warning = "V needs to be sitting on a stationary motorcycle while in First Person Perspective to edit this option."
    }
  },
  OnFoot = {
    tabname = "On-Foot",
    BottomCornersMasks = {
      name = "Enable bottom corners anti-ghosting masks",
      tooltip = "Enables position-fixed anti-ghosting masks to stop frame generation from occuring locally around bottom corners of your screen and reduce ghosting when V is holding a weapon.",
    },
    VignetteAim = {
      name = "Enable anti-ghosting vignette for aiming/blocking",
      tooltip = "Enables dynamic anti-ghosting vignette to stop frame generation from occuring locally around edges of your screen and reduce ghosting when V is aiming/blocking with a weapon. For framerates lower than recommended, this setting comes at a cost of perceived smoothness in outermost areas of your field of view.",
      textfield_1 = "[ ! ] Enabling both vignette's options at the same time may cause more noticeable dimming around edges of your screen."
    },
    Vignette = {
      name = "Enable customizable anti-ghosting vignette",
      tooltip = "Enables customizable anti-ghosting vignette to stop frame generation from occuring locally around edges of your screen and reduce ghosting when V is holding a weapon.",
      textfield_1 = "The sliders below let you customize the vignette's dimensions to cover ghosting on your screen edges. For framerates lower than recommended, these settings come at a noticeable cost of perceived smoothness in outermost areas of your field of view.",
      setting_1 = "Vignette's width:",
      setting_2 = "Vignette's height:",
      setting_3 = "Vignette's horizontal position:",
      setting_4 = "Vignette's vertical position:"
    },
    VignettePermament = {
      name = "Keep the vignette turned on when V holsters a weapon",
      tooltip = "By default, the vignette hides when V holsters a weapon. This setting lets you keep the vignette turned on all the time when V is on foot."
    },
    BlockerAim = {
      name = "Enable frame gen blocker for aiming/blocking",
      tooltip = "Enables contextual blocking of frame generation for a whole screen when V is aiming/blocking with a weapon. This may turn out to be helpful in higher framerates as crosshairs/ sights tend to ghost heavily with frame generation turned on."
    }
  },
  Contextual = {
    tabname = "Contextual",
    requirement = 'Please check "Enable Frame Generation" in the "Settings" tab to use these features.',
    info = "Select contexts to turn off frame generation during these events.",
    groupOther = "Other:",
    groupOnFoot = "On-Foot:",
    groupVehicles = "Vehicles:",
    onFootStanding = "Standing",
    onFootSlowWalk = "Slow Walking",
    onFootWalk = "Walking",
    onFootSprint = "Sprinting",
    onFootSwimming = "Swimming",
    vehiclesStatic = "Static",
    vehiclesDriving = "Driving",
    vehiclesStaticWeapon = "Static (Weapon Drawn)",
    vehiclesDrivingWeapon = "Driving (Weapon Drawn)",
    braindance = "Braindance",
    cinematics = "Cinematics",
    combat = "Combat (Enemies Alerted)",
    photoMode = "Photo Mode",
  },
  Settings = {
    tabname = "Settings",
    groupMod = "Mod Settings:",
    enabledDebug = "Enable debug mode",
    enabledDebugView = "Enable debug tabs in the window",
    enabledHelp = "Enable tooltips",
    tooltipHelp = "Enable tooltips on mouse hover for certain settings.",
    enabledWindow = "Keep this window open",
    tooltipWindow = "Keep this window opened after closing CET's overlay.",
    selectTheme = "Mod's Window Theme:",
    tooltipTheme = "Pick your colors for the mod's window.",
    groupFG = "Frame Generation Settings:",
    enableFG = "Enable Frame Generation",
    tooltipFG = "Turn on/off Frame Generation on the mod level (the game's settings remain unchanged).",
    gameSettingsFG = "[ ! ] Please make sure frame generation is always enabled in game menu for this to work correctly.",
    gameNotReadyWarning = "[ ! ] You need to start or unpause the game to change these settings.",
  },
  Benchmark = {
    groupBenchmark = "Game Performance Benchmark:",
    currentFps = "Current FPS without Frame Gen:",
    currentFrametime = "Current Frame-Time without Frame Gen (ms):",
    averageFps = "Average FPS without Frame Gen:",
    benchmark = "Benchmark enabled:",
    benchmarkRemaining = "Remaining benchmark time (s):",
    benchmarkPause = "[ ! ] Benchmark is paused. Unpause the game to continue.",
    benchmarkPauseOverlay = "[ ! ] Benchmark is paused. Exit CET's overlay to continue.",
    benchmarkRestart = "[ ! ] Benchmark restarting in:",
    benchmarkRun = "Run benchmark",
    benchmarkSetSuggestedSettings = "Set suggested settings",
    benchmarkRevertSettings = "Revert to my settings",
    benchmarkStop = "Stop benchmark",
    benchmarkEnabled = "Benchmark enabled.",
    benchmarkFinished = "Finished benchmarking.",
    tooltipRunBench = "Runs the benchmark to measure your game's performance and applies suggested settings once completed. When finished you can review the new settings and revert to your current ones if needed."
  },
  Diagnostics = {
    tabname = "Diagnostics",
    title_warning = "CONFLICTS WITH OTHER MODS DETECTED",
    title_info = "UPDATE AVAILABLE",
    textfield_1 = "Seems like you have a conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation will work without problems, please, visit FrameGen Ghosting 'Fix's Nexus page to download and install the latest version of the mod.",
    textfield_2 = "Conflicting mods:",
    textfield_3 = "Seems like you have a potentially conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation will work without problems in the future, please visit FrameGenGhosting 'Fix's Nexus page to download and install the latest version of the mod.\n\nWith the new version you no longer need any compatibility tweaks.",
    textfield_4 = "Potentially conflicting mods:"
  },
}

local LogText = {
  archive_missing = "Missing mod's archive. The mod won't work...",
  benchmark_starting = "Starting benchmark...",
  benchmark_restarting = "Restarting benchmark...",
  benchmark_avgFpsResult = "Measured average FPS without frame generation =",
  calculate_applySettings = "Applying settings accordingly...",
  calculate_missing = "Can't find the 'Calculate' module. The mod's anti-ghosting feature for on-foot gameplay won't work.",
  contextual_missing = "Can't find the 'Contextual' module. The mod's contextual frame generation feature won't work.",
  globals_controllerMissing = "Masks controller not set.  The mod won't work...",
  globals_firstRun = "Initial launch of the mod detected.",
  globals_missing = "Can't find the 'Globals' module. The mod won't work...",
  globals_wrongVersion = "The mod's 'Globals' module seems to be not compatible with the mod's current version. The mod won't work...",
  imguiext_missing = "Can't find the 'ImGuiExt' module. The mod won't work...",
  localization_baseLocalization = "Set the mod to the default language:",
  localization_keyNotFound = "Check translation files, couldn't find a key/table in a file:",
  localization_missing = "Can't find the 'Localization' module. The mod won't work...",
  localization_translationFound = "Found a translation for language code:",
  localization_translationNotFound = "Couldn't find any translation for language code:",
  localization_translationAuthor = "Author of the translation:",
  presets_loaded = "Vehicle presets loaded:",
  presets_missing = "Can't find the 'VectorsPresets' module. The mod's presets feature won't work...",
  presets_skippedFileDuplicate = "Another preset exists with the same name, skipped the file. Please use a different name.",
  presets_skippedFileData = "Skipped the preset file. It does not contain the required data for anti-ghosting masks:",
  redscript_missing = "Can't find a compatible RedScript module. The mod won't work as intended...",
  settings_missing = "Can't find the 'Settings' module. The mod won't let you save your settings.",
  settings_fileNotFound = "A 'user_settings.json' file hasn't been found.",
  settings_loaded = "User settings loaded.",
  settings_savedToFile = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
  settings_notSavedToFile = "Couldn't save user settings to a file.",
  settings_savedToCache = "Your current settings have been saved to memory.",
  settings_restoredCache = "Your previous settings have been restored.",
  tracker_missing = "Can't find the 'Tracker' module. The mod won't work...",
  vectors_missing = "Can't find the 'Vectors' module. The mod's anti-ghosting feature for vehicles won't work.",
}


-- the mod's default language code
local modDefaultLang = "en-us"

local GameOnScreenLang = {
  -- the game's current onScreen language code
  current = nil,
  -- stores previous GameOnScreenLang.current to prevent unnecessary notfications
  last = nil,
  -- stores previous GameOnScreenLang.current for each translated table to prevent unnecessary translations
  Flags = {}
}

local Working = {
  -- temporary table to store received localization
  Default = {},
  -- temporary table to store new localization
  Translated = {},
}

local Globals = require("Modules/Globals")

------------------
-- Getters
------------------

-- @return table;
function Localization.GetGeneralText()
  return UIText.General
end

-- @return table;
function Localization.GetInfoText()
  return UIText.Info
end

-- @return table;
function Localization.GetSettingsText()
  return UIText.Settings
end

-- @return table;
function Localization.GetBenchmarkText()
  return UIText.Benchmark
end

-- @return table;
function Localization.GetDiagnosticsText()
  return UIText.Diagnostics
end

-- @return table;
function Localization.GetContextualText()
  return UIText.Contextual
end

-- @return table;
function Localization.GetOnFootText()
  return UIText.OnFoot
end

-- @return table;
function Localization.GetVehiclesText()
  return UIText.Vehicles
end

-- @return table;
function Localization.GetLogText()
  return LogText
end

-- @return table; The game's current onScreen language code.
function Localization.GetOnScreenLanguage()
  GameOnScreenLang.current = Game.NameToString(Game.GetSettingsSystem():GetVar("/language", "OnScreen"):GetValue())
  return GameOnScreenLang.current
end

------------------
-- Get Localization
------------------

local function ClearFlag(key)
  -- clear translation flag
  GameOnScreenLang.Flags[key] = nil
end

local function SetFlag(key)
  -- set a translation flag for the table content
  GameOnScreenLang.Flags[key] = modDefaultLang

  -- set a general translation flag
  GameOnScreenLang.last = GameOnScreenLang.current
end

local function GetNewLocalization(key)
  ClearFlag(key)

  -- adds fallback to the default localization for the source table if such doesn't exist yet
  if Globals.GetFallback("Localization", key) == nil then
    Globals.SetFallback("Localization", Working.Default, key)
  else -- make sure it defaults to the mod's default language first
    Working.Default = Globals.SafeMergeTables(Working.Default, Globals.GetFallback("Localization", key))
  end
  
  -- loads a translation file for the current lang
  local translationFile = "Translations/" .. GameOnScreenLang.current .. ".lua"
  local chunk = loadfile(translationFile)

  -- if the translation file exist, merges it with the default localization
  if chunk then
    local translation = chunk()

    -- replace the default language strings with found translated strings
    Working.Translated = Globals.SafeMergeTables(Working.Default, translation[key])
    
    if GameOnScreenLang.last == GameOnScreenLang.current then return Working.Translated end
    Globals.Print(Localization.__NAME, LogText.localization_translationFound, GameOnScreenLang.current)

    if translation.__AUTHOR then
      Globals.Print(Localization.__NAME, LogText.localization_translationAuthor, translation.__AUTHOR)
    end

    SetFlag(key)
  else
    Working.Translated = Working.Default

    if GameOnScreenLang.last == GameOnScreenLang.current then return Working.Translated end
    Globals.Print(Localization.__NAME, LogText.localization_translationNotFound, GameOnScreenLang.current)

    SetFlag(key)
  end
end

local function GetDefaultLocalization(key)
  ClearFlag(key)

  Working.Translated = Globals.SafeMergeTables(Working.Default, Globals.GetFallback("Localization", key))

  if GameOnScreenLang.last == GameOnScreenLang.current then return Working.Translated end
  Globals.Print(Localization.__NAME, LogText.localization_baseLocalization, modDefaultLang)

  SetFlag(key)
end

--- Returns a localized version of a table, if a translation is found.
--
-- @param `sourceTable`: table; A table with strings.
-- @param `key`: string; A name for the method to recognize the sourceTable in a translation file.
--
-- return table; A translated table if a translation is found and needed, `sourceTable` otherwise.
function Localization.GetTranslation(sourceTable, key)
  --get current language
  Localization.GetOnScreenLanguage()

  -- check if there's a need for translation at all
  if GameOnScreenLang.current == modDefaultLang and GameOnScreenLang.last == nil then return sourceTable end

  -- check if the table/content was already translated (a translation flag exist)
  if GameOnScreenLang.Flags[key] and GameOnScreenLang.Flags[key] == GameOnScreenLang.current then return sourceTable end

  -- set sourceTable as working default
  Working.Default = sourceTable

  -- check if there is a need for translation
  if GameOnScreenLang.current ~= modDefaultLang then
    GetNewLocalization(key)
  else -- or to revert to the mod's default manguage
    GetDefaultLocalization(key)
  end

  return Working.Translated
end

------------------
-- On... registers
------------------

function Localization.OnOverlayOpen()
  UIText = Localization.GetTranslation(UIText, "UIText")
end

return Localization