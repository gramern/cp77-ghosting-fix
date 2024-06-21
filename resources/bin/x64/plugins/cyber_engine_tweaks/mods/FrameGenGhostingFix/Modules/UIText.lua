local UITranslation = require("Modules/Translation")

local UIText = {
  __VERSION_NUMBER = 484,
  General = {
    modname_log = "[FrameGen Ghosting 'Fix']",
    title_general = UITranslation.General.title_general or "General Settings:",
    title_fps90 = UITranslation.General.title_fps90 or "90+ FPS FG ON Settings:",
    title_fps100 = UITranslation.General.title_fps100 or "100+ FPS FG ON Settings:",
    title_fps120 = UITranslation.General.title_fps120 or "120+ FPS FG ON Settings:",
    yes = UITranslation.General.yes or "Yes",
    no = UITranslation.General.no or "No",
    settings_loaded = UITranslation.General.settings_loaded or "User settings loaded.",
    settings_loaded_preset = UITranslation.General.settings_loaded_preset or "Preset loaded",
    settings_apply = UITranslation.General.settings_apply or "  Apply  ",
    settings_applied_veh = UITranslation.General.settings_applied_veh or "[ ! ] Selected preset applied.",
    settings_save = UITranslation.General.settings_save or "Save settings",
    settings_saved = UITranslation.General.settings_saved or "[ ! ] Your settings are saved.",
    settings_saved_onfoot = UITranslation.General.settings_saved_onfoot or "[ ! ] Redraw your weapon to accept changes.",
    settings_save_path = UITranslation.General.settings_save_path or "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
    settings_notfound = UITranslation.General.settings_notfound or "A 'user_settings.json' file hasn't been found.",
    settings_benchmark_start = UITranslation.General.settings_benchmark_start or "Starting benchmark...",
    settings_benchmarked_1 = UITranslation.General.settings_benchmarked_1 or "Measured average FPS without frame generation =",
    settings_benchmarked_2 = UITranslation.General.settings_benchmarked_2 or "Applying settings accordingly...",
    settings_default = UITranslation.General.settings_default or "Set to default",
    info_aim_onfoot = UITranslation.General.info_aim_onfoot or "[ ! ] You can enable one aiming/blocking feature at once.",
    info_version = UITranslation.General.info_version or "Mod version:",
    info_diagnostics = UITranslation.General.info_diagnostics or "Potential conflicts with other mods detected.",
    info_calculateMissing = UITranslation.General.info_calculateMissing or "Can't find the 'Calculate' module. The mod won't work...",
    info_configMissing = UITranslation.General.info_configMissing or "Can't find the 'Config' module. The mod won't work...",
    info_presetsMissing = UITranslation.General.info_presetsMissing or "Can't find the 'Presets' module. The mod won't work...",
    info_vectorsMissing = UITranslation.General.info_vectorsMissing or "Can't find the 'Vectors' module. The mod won't work...",
    info_aspectRatioChange = UITranslation.General.info_aspectRatioChange or "The aspect ratio of your screen has changed. Please restart the game to ensure the mod will work as intended."
  },
  Info = {
    tabname = UITranslation.Info.tabname or "Info",
    aspectRatioChange = UITranslation.Info.aspectRatioChange or "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod will\nwork as intended.",
    benchmark = UITranslation.Info.benchmark or "[ ! ] FrameGen Ghosting 'Fix' is benchmarking your game's\nperformance. Please continue playing freely: once the\nbenchmark is finished, the mod will apply optimal settings\nfor your game's performance. You can change those\nsettings later.\n\nThe benchmark is conducted during the first run of the mod.",
    benchmarkAsk = UITranslation.Info.benchmarkAsk or "[ ! ] Do you want to run a benchmark to let the mod measure\nyour game's performance and set optimal anti-ghosting\nsettings?\n\nIt will happen in the background, please continue playing\nfreely.",
    benchmarkRemaining = UITranslation.Info.benchmarkRemaining or "Remaining benchmark time (s):"
  },
  Vehicles = {
    tabname = UITranslation.Vehicles.tabname or "Vehicles",
    Customize = {

    },
    MaskingPresets = {
      name = UITranslation.Vehicles.MaskingPresets.name or "Use this preset for vehicles:",
      tooltip = UITranslation.Vehicles.MaskingPresets.tooltip or "Choose a preset of anti-ghosting for vehicles.",
    },
    Windshield = {
      name = UITranslation.Vehicles.Windshield.name or "Customize motorcycle windshield mask",
      tooltip = UITranslation.Vehicles.Windshield.tooltip or "Enables customization of the anti-ghosting mask to stop frame generation\nfrom occuring locally around a windshield when riding a motorcycle.",
      textfield_1 = UITranslation.Vehicles.Windshield.textfield_1 or "The sliders below let you customize the size of the motorcycle\nwindshield mask. Usually not necessary, may turn out handy for\nsome motorcycles like Apollo.",
      setting_1 = UITranslation.Vehicles.Windshield.setting_1 or "Windshield anti-ghosting mask width:",
      setting_2 = UITranslation.Vehicles.Windshield.setting_2 or "Windshield anti-ghosting mask height:",
      comment_1 = UITranslation.Vehicles.Windshield.comment_1 or "Scale width",
      comment_2 = UITranslation.Vehicles.Windshield.comment_2 or "Scale height",
      warning = UITranslation.Vehicles.Windshield.warning or "V needs to be sitting on a stationary motorcycle while in\nFirst Person Perspective to edit this option."
    }
  },
  OnFoot = {
    tabname = UITranslation.OnFoot.tabname or "On Foot",
    BottomCornersMasks = {
      name = UITranslation.OnFoot.BottomCornersMasks.name or "Enable bottom corners anti-ghosting masks",
      tooltip = UITranslation.OnFoot.BottomCornersMasks.tooltip or "Enables position-fixed anti-ghosting masks to stop frame generation\nfrom occuring locally around bottom corners of your screen and reduce\nghosting when V is holding a weapon.",
    },
    VignetteAim = {
      name = UITranslation.OnFoot.VignetteAim.name or "Enable anti-ghosting vignette for aiming/blocking",
      tooltip = UITranslation.OnFoot.VignetteAim.tooltip or "Enables dynamic anti-ghosting vignette to stop frame generation\nfrom occuring locally around edges of your screen and reduce\nghosting when V is aiming/blocking with a weapon. For framerates\nlower than recommended, this setting comes at a cost of perceived\nsmoothness in outermost areas of your field of view.",
      textfield_1 = UITranslation.OnFoot.VignetteAim.textfield_1 or "[ ! ] Enabling both vignette's options at the same time may cause\nmore noticeable dimming around edges of your screen."
    },
    Vignette = {
      name = UITranslation.OnFoot.Vignette.name or "Enable customizable anti-ghosting vignette",
      tooltip = UITranslation.OnFoot.Vignette.tooltip or "Enables customizable anti-ghosting vignette to stop frame generation\nfrom occuring locally around edges of your screen and reduce ghosting\nwhen V is holding a weapon.",
      textfield_1 = UITranslation.OnFoot.Vignette.textfield_1 or "The sliders below let you customize the vignette's dimensions\nto cover ghosting on your screen edges. For framerates lower\nthan recommended, these settings come at a noticeable cost\nof perceived smoothness in outermost areas of your field\nof view.",
      setting_1 = UITranslation.OnFoot.Vignette.setting_1 or "Vignette's width:",
      setting_2 = UITranslation.OnFoot.Vignette.setting_2 or "Vignette's height:",
      setting_3 = UITranslation.OnFoot.Vignette.setting_3 or "Vignette's horizontal position:",
      setting_4 = UITranslation.OnFoot.Vignette.setting_4 or "Vignette's vertical position:"
    },
    VignettePermament = {
      name = UITranslation.OnFoot.VignettePermament.name or "Keep the vignette turned on when V holsters a weapon",
      tooltip = UITranslation.OnFoot.VignettePermament.tooltip or "By default, the vignette hides when V holsters a weapon.\nThis setting lets you keep the vignette turned on all the\ntime when V is on foot."
    },
    BlockerAim = {
      name = UITranslation.OnFoot.BlockerAim.name or "Enable frame gen blocker for aiming/blocking",
      tooltip = UITranslation.OnFoot.BlockerAim.tooltip or "Enables contextual blocking of frame generation\nfor a whole screen when V is aiming/blocking with a weapon. This\nmay turn out to be helpful in higher framerates as crosshairs/\nsights tend to ghost heavily with frame generation turned on."
    }
  },
  Options = {
    tabname = UITranslation.Options.tabname or "Additional Options",
    enabledDebug = UITranslation.Options.enabledDebug or "Enable debug view",
    enabledWindow = UITranslation.Options.enabledWindow or "Keep this window open",
    tooltipWindow = UITranslation.Options.tooltipWindow or "Keeps this window opened after closing CET's overlay.",
    Benchmark = {
      currentFps = UITranslation.Options.Benchmark.currentFps or "Current FPS without Frame Gen:",
      currentFrametime = UITranslation.Options.Benchmark.currentFrametime or "Current Frame-Time without Frame Gen (ms):",
      averageFps = UITranslation.Options.Benchmark.averageFps or "Average FPS without Frame Gen:",
      benchmark = UITranslation.Options.Benchmark.benchmark or "Benchmark enabled:",
      benchmarkTime = UITranslation.Options.Benchmark.benchmarkTime or "Benchmark remaining time (s):",
      benchmarkPause = UITranslation.Options.Benchmark.benchmarkPause or "[ ! ] Benchmark is paused. Unpause the game to continue.",
      benchmarkRestart = UITranslation.Options.Benchmark.benchmarkRestart or "[ ! ] Benchmark restarting in:",
      benchmarkRun = UITranslation.Options.Benchmark.benchmarkRun or "Run benchmark",
      benchmarkSaveSettings = UITranslation.Options.Benchmark.benchmarkSaveSettings or "Save suggested settings",
      benchmarkRevertSettings = UITranslation.Options.Benchmark.benchmarkRevertSettings or "Revert to my settings",
      benchmarkStop = UITranslation.Options.Benchmark.benchmarkStop or "Stop benchmark",
      tooltipRunBench = UITranslation.Options.Benchmark.tooltipRunBench or "Runs the benchmark to measure your game's performance and applies\nsuggested settings once completed. The new settings won't be saved\n- you can revert them."
    },
  },
  Diagnostics = {
    tabname = UITranslation.Diagnostics.tabname or "Diagnostics",
    title_warning = UITranslation.Diagnostics.title_warning or "CONFLICTS WITH OTHER MODS DETECTED",
    title_info = UITranslation.Diagnostics.title_info or "UPDATE AVAILABLE",
    textfield_1 = UITranslation.Diagnostics.textfield_1 or "Seems like you have a conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation\nwill work without problems, please, visit FrameGen\nGhosting 'Fix's Nexus page to download and install\nthe 'Preem Compatibility Edition - ArchiveXL'\nversion of the mod instead.",
    textfield_2 = UITranslation.Diagnostics.textfield_2 or "Conflicting mods:",
    textfield_3 = UITranslation.Diagnostics.textfield_3 or "Seems like you have a potentially conflicting mod\ninstalled.\n\nTo ensure that anti-ghosting for frame generation\nwill work without problems in the future, please visit\nFrameGenGhosting 'Fix's Nexus page to download and\ninstall the 'Preem Compatibility Edition - ArchiveXL'\nversion of the mod instead.\n\nWith the new version you no longer need any\ncompatibility tweaks.",
    textfield_4 = UITranslation.Diagnostics.textfield_4 or "Potentially conflicting mods:"
  },
  Presets = {
    infoname = UITranslation.Presets.infoname or "Preset's info:",
    authorname = UITranslation.Presets.authorname or "Preset's author:",
  }
}

return UIText