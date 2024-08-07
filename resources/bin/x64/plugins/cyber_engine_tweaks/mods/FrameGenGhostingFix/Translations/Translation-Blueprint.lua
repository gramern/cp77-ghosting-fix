--[=====[ 

  Rename this file fitting to your translation and keep it in the 'Translations' folder. Following Codes are supported by the game:
    ar-ar = Arabic
    zh-cn = Chinese (Simplified)
    zh-tw = Chinese (Traditional)
    cz-cz = Czech
    fr-fr = French
    de-de = German
    hu-hu = Hungarian
    it-it = Italian
    jp-jp = Japanese
    kr-kr = Korean
    pl-pl = Polish
    pt-br = Portuguese (Brazillian)
    ru-ru = Russian
    es-mx = Spanish (Latin American)
    es-es = Spanish
    th-th = Thai
    tr-tr = Turkish
    ua-ua = Ukrainian
  
  A translation for German would be called de-de.lua for example.
  Authros can upload their own presets. Presets are saved using IDs translating those will be a litte more complex:
  Further down you'll find Presets.Info follow the instrunctions for translating a preset


  If you don't know how to translate something you can either keep it on english or delete the key
  for example:
  {
    infolog = "Here is the requested info",
    warnlog = "This is a warning do not follow it"
  }
    would then be
  {
      infolog = "Hier sind die angeforderten Infos",
      --warnlog = "This is a warning do not follow it"
  }

  -- creates a comment, that way you can translate it later without having to search for the key again before being able to translate it

--]=====]

local translation = {
  __VERSION = { 5, 0, 0 },
  __AUTHOR = "", -- Mark your work. 
  UIText = {
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
      onFootStanding = "Standing/Crouching",
      onFootSlowWalk = "Slow Walking/Crouch Walking",
      onFootWalk = "Walking",
      onFootSprint = "Sprinting/Crouch Sprinting",
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
      enabledDebugView = "Enable debug view in the window",
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
  },
  PresetsInfo = {
    --[=====[
    Presets are saved using IDs, to translate a preset you need the ID of it. The structure looks like following
    [PresetID] = {
      PresetInfo = {
        name = "Preset's name",
        description = "Preset's description"
      }
    }

    IDs have to be covered by brackets [], else your translation will fail!
    To find the ID of a preset just ask the author or take a look at the website were it'S been published.
    --]=====]
    a000 = {
      PresetInfo = {
        name = "Customize",
        description = "Customize your preset.",
      }
    },
    a001 = {
      PresetInfo = {
        name = "Default",
        description = "Default preset.",
      }
    },
    a002 = {
      PresetInfo = {
        name = "Stronger",
        description = "Masks' anti-ghosting strength is slightly greater and their state change delay on a sudden speed decrease is twice as long (3 seconds instead of 1.5).",
      }
    },
    a003 = {
      PresetInfo = {
          name = "Testing",
          description = "Testing preset, all masks visible.",
        }
    },
    a004 = {
      PresetInfo = {
        name = "Testing Stronger",
        description = "Testing 'Stronger' preset, all masks visible. Opacity normalization doesn't work in this one (Masks are visible all the time).",
      }
    },
    a005 = {
      PresetInfo = {
        name = "Turn off anti-ghosting masking",
        description = "Turns off TPP and FPP anti-ghosting masks for all vehicles.",
      }
    }
  }
}

return translation