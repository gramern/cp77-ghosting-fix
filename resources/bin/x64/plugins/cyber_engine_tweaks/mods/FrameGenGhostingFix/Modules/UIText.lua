local UIText = {
  __VERSION_NUMBER = 480,
  General = {
    modname_log = "[FrameGen Ghosting 'Fix']",
    title_general = "General Settings:",
    title_fps90 = "90+ FPS FG ON Settings:",
    title_fps100 = "100+ FPS FG ON Settings:",
    title_fps120 = "120+ FPS FG ON Settings:",
    yes = "Yes",
    no = "No",
    settings_loaded = "User settings loaded.",
    settings_loaded_preset = "Preset loaded",
    settings_apply = "  Apply  ",
    settings_applied_veh = "[ ! ] Selected preset applied.",
    settings_save = "Save settings",
    settings_saved = "[ ! ] Your settings are saved.",
    settings_saved_onfoot = "[ ! ] Redraw your weapon to accept changes.",
    settings_save_path = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
    settings_notfound = "A 'user_settings.json' file hasn't been found.",
    settings_benchmark_start = "Starting benchmark...",
    settings_benchmarked_1 = "Measured average FPS without frame generation =",
    settings_benchmarked_2 = "Applying settings accordingly...",
    settings_default = "Set to default",
    info_aim_onfoot = "[ ! ] You can enable one aiming/blocking feature at once.",
    info_version = "Mod version:",
    info_diagnostics = "Potential conflicts with other mods detected.",
    info_config = "Can't find the 'Config' module. The mod won't work...",
    info_aspectRatioChange = "The aspect ratio of your screen has changed. Please restart the game to ensure the mod will work as intended."
  },
  Info = {
    tabname = "Info",
    aspectRatioChange = "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod will\nwork as intended.",
    benchmark = "[ ! ] FrameGen Ghosting 'Fix' is benchmarking your game's\nperformance. Please continue playing freely: once the\nbenchmark is finished, the mod will apply optimal settings\nfor your game's performance. You can change those\nsettings later.\n\nThe benchmark is conducted during the first run of the mod.",
    benchmarkAsk = "[ ! ] Do you want to run a benchmark to let the mod measure\nyour game's performance and set optimal anti-ghosting\nsettings?\n\nIt will happen in the background, please continue playing\nfreely.",
    benchmarkRemaining = "Remaining benchmark time (s):"
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
      benchmarkTime = "Benchmark remaining time (s):",
      benchmarkPause = "[ ! ] Benchmark is paused. Unpause the game to continue.",
      benchmarkRestart = "[ ! ] Benchmark restarting in:",
      benchmarkRun = "Run benchmark",
      benchmarkSaveSettings = "Save suggested settings",
      benchmarkRevertSettings = "Revert to my settings",
      benchmarkStop = "Stop benchmark",
      tooltipRunBench = "Runs the benchmark to measure your game's performance and applies\nsuggested settings once completed. The new settings won't be saved\n- you can revert them."
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
  }
}

return UIText