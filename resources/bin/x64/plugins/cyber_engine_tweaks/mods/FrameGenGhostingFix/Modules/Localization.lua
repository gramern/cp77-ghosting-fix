local Localization = {
  __NAME = "Localization",
  __VERSION_NUMBER = 500,
  UIText = {
    General = {
      title_general = "General Settings:",
      title_fps90 = "90+ FPS FG ON Settings:",
      title_fps100 = "100+ FPS FG ON Settings:",
      title_fps120 = "120+ FPS FG ON Settings:",
      yes = "Yes",
      no = "No",
      apply = "Apply",
      default = "Set to default",
      presets_comboBox = "Use this preset:",
      presets_comboBox_tooltip = "Choose a preset of anti-ghosting.",
      settings_loaded = "User settings loaded.",
      settings_loaded_preset = "Preset loaded",
      settings_applied_veh = "[ ! ] Selected preset applied.",
      settings_restored = "Restored your previous settings.",
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
    },
    Info = {
      tabname = "Info",
      aspectRatioChange = "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod will\nwork as intended.",
      benchmark = "[ ! ] FrameGen Ghosting 'Fix' is benchmarking your game's\nperformance. Please continue playing freely: once the\nbenchmark is finished, the mod will apply optimal settings\nfor your game's performance. You can change those\nsettings later.\n\nThe benchmark is conducted during the first run of the mod.",
      benchmarkAsk = "[ ! ] Do you want to run a benchmark to let the mod measure\nyour game's performance and set optimal anti-ghosting\nsettings?\n\nIt will happen in the background, please continue playing\nfreely.",
      modNotReady = "The mod encountered a problem:",
    },
    Vehicles = {
      tabname = "Vehicles",
      MaskingPresets = {
        name = "Use this preset for vehicles:",
        tooltip = "Choose a preset of anti-ghosting for vehicles.",
      },
      Windshield = {
        name = "Customize motorcycle windshield mask",
        tooltip = "Enables customization of the anti-ghosting mask to stop frame generation\nfrom occuring locally around a windshield when riding a motorcycle.",
        textfield_1 = "The sliders below let you customize the size of the motorcycle\nwindshield mask. Usually not necessary, may turn out handy for\nsome motorcycles like Apollo.",
        setting_1 = "Windshield anti-ghosting mask width:",
        setting_2 = "Windshield anti-ghosting mask height:",
        comment_1 = "Scale width",
        comment_2 = "Scale height",
        warning = "V needs to be sitting on a stationary motorcycle while in\nFirst Person Perspective to edit this option."
      }
    },
    OnFoot = {
      tabname = "On Foot",
      BottomCornersMasks = {
        name = "Enable bottom corners anti-ghosting masks",
        tooltip = "Enables position-fixed anti-ghosting masks to stop frame generation\nfrom occuring locally around bottom corners of your screen and reduce\nghosting when V is holding a weapon.",
      },
      VignetteAim = {
        name = "Enable anti-ghosting vignette for aiming/blocking",
        tooltip = "Enables dynamic anti-ghosting vignette to stop frame generation\nfrom occuring locally around edges of your screen and reduce\nghosting when V is aiming/blocking with a weapon. For framerates\nlower than recommended, this setting comes at a cost of perceived\nsmoothness in outermost areas of your field of view.",
        textfield_1 = "[ ! ] Enabling both vignette's options at the same time may cause\nmore noticeable dimming around edges of your screen."
      },
      Vignette = {
        name = "Enable customizable anti-ghosting vignette",
        tooltip = "Enables customizable anti-ghosting vignette to stop frame generation\nfrom occuring locally around edges of your screen and reduce ghosting\nwhen V is holding a weapon.",
        textfield_1 = "The sliders below let you customize the vignette's dimensions\nto cover ghosting on your screen edges. For framerates lower\nthan recommended, these settings come at a noticeable cost\nof perceived smoothness in outermost areas of your field\nof view.",
        setting_1 = "Vignette's width:",
        setting_2 = "Vignette's height:",
        setting_3 = "Vignette's horizontal position:",
        setting_4 = "Vignette's vertical position:"
      },
      VignettePermament = {
        name = "Keep the vignette turned on when V holsters a weapon",
        tooltip = "By default, the vignette hides when V holsters a weapon.\nThis setting lets you keep the vignette turned on all the\ntime when V is on foot."
      },
      BlockerAim = {
        name = "Enable frame gen blocker for aiming/blocking",
        tooltip = "Enables contextual blocking of frame generation\nfor a whole screen when V is aiming/blocking with a weapon. This\nmay turn out to be helpful in higher framerates as crosshairs/\nsights tend to ghost heavily with frame generation turned on."
      }
    },
    Options = {
      tabname = "Additional Options",
      enabledDebug = "Enable debug view",
      enabledWindow = "Keep this window open",
      tooltipWindow = "Keeps this window opened after closing CET's overlay.",
      Benchmark = {
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
        tooltipRunBench = "Runs the benchmark to measure your game's performance and applies\nsuggested settings once completed. When finished you can review\nthe new settings and revert to your current ones if needed."
      },
    },
    Diagnostics = {
      tabname = "Diagnostics",
      title_warning = "CONFLICTS WITH OTHER MODS DETECTED",
      title_info = "UPDATE AVAILABLE",
      textfield_1 = "Seems like you have a conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation\nwill work without problems, please, visit FrameGen\nGhosting 'Fix's Nexus page to download and install\nthe 'Preem Compatibility Edition - ArchiveXL'\nversion of the mod instead.",
      textfield_2 = "Conflicting mods:",
      textfield_3 = "Seems like you have a potentially conflicting mod\ninstalled.\n\nTo ensure that anti-ghosting for frame generation\nwill work without problems in the future, please visit\nFrameGenGhosting 'Fix's Nexus page to download and\ninstall the 'Preem Compatibility Edition - ArchiveXL'\nversion of the mod instead.\n\nWith the new version you no longer need any\ncompatibility tweaks.",
      textfield_4 = "Potentially conflicting mods:"
    },
    Presets = {
      infotabname = "Preset's info:",
      authtabname = "Preset's author:",
    }
  },
  LogText = {
    benchmark_starting = "Starting benchmark...",
    benchmark_restarting = "Restarting benchmark...",
    benchmark_avgFpsResult = "Measured average FPS without frame generation =",
    calculate_applySettings = "Applying settings accordingly...",
    calculate_missing = "Can't find the 'Calculate' module. The mod's anti-ghosting feature for on-foot gameplay won't work.",
    config_aspectRatioChange = "The aspect ratio of the screen has changed. Please restart the game to ensure the mod will work as intended.",
    config_controllerMissing = "Masks controller not set.  The mod won't work...",
    config_firstRun = "Initial launch of the mod detected.",
    config_missing = "Can't find the 'Config' module. The mod won't work...",
    config_newVersion = "New version of the mod detected.",
    config_wrongVersion = "The mod's 'Config' module seems to be not compatible with the mod's current version. The mod won't work...",
    translate_baseLocalization = "Set the mod to the default language:",
    translate_keyNotFound = "Error: check translation files, couldn't find a key/table in a file:",
    translate_translationFound = "Found a translation for language code: ",
    translate_translationNotFound = "Couldn't find any translation for language code: ",
    presets_missing = "Can't find the 'Presets' module. The mod won't let you load anti-ghosting presets.",
    presets_skippedFile = "Skipped a preset file. There is a conflict with an already indexed preset, please check presets names and IDs and try again:",
    presets_skippedFilePos = "Another preset exists on the received position, skipped the file. Try a lower position",
    settings_missing = "Can't find the 'Settings' module. The mod won't let you save your settings.",
    settings_fileNotFound = "A 'user_settings.json' file hasn't been found.",
    settings_loaded = "User settings loaded.",
    settings_savedToFile = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
    settings_notSavedToFile = "Error: Couldn't save user settings to a file.",
    settings_savedToCache = "Your current settings have been saved to memory.",
    settings_restoredCache = "Your previous settings have been restored.",
    vectors_missing = "Can't find the 'Vectors' module. The mod's anti-ghosting feature for vehicles won't work.",
  },
}

return Localization