--[=====[ 

  Rename this file fitting to your translation. Following Codes are supported by the game:
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
  __VERSION_NUMBER = 490,
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
      settings_saved = "[ ! ] Your settings are saved.",
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
        benchmarkRestart = "[ ! ] Benchmark restarting in:",
        benchmarkRun = "Run benchmark",
        benchmarkSaveSettings = "Save suggested settings",
        benchmarkRevertSettings = "Revert to my settings",
        benchmarkStop = "Stop benchmark",
        benchmarkEnabled = "Benchmark enabled.",
        benchmarkFinished = "Finished benchmarking.",
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
    },
    Presets = {
      infotabname = "Preset's info:",
      authtabname = "Preset's author:",
    }
  },
  PresetsInfo = {
    --[=====[
    Presets are saved using IDs, to translate a preset you need the ID of it. The structure looks like following
    [PresetID] = {
      name = "Preset's name",
      description = "Preset's description"
    }

    IDs have to be covered by brackets [], else your translation will fail!
    To find the ID of a preset just ask the author or take a look at the website were it'S been published.
    --]=====]
    a000 = {
      name = "Default",
      description = "Default preset.",
      author = nil,
    },
    a001 = {
      name = "Customize",
      description = "Customize your preset.",
      author = nil,
    },
    a003 = {
      name = "Stronger",
      description = "Masks' anti-ghosting strength is slightly greater and\ntheir state change delay on a sudden speed decrease\nis twice as long (3 seconds instead of 1.5).",
      author = nil,
    },
    a004 = {
      name = "Turn off anti-ghosting masking",
      description = "Turns off TPP and FPP anti-ghosting masks for all vehicles",
      author = nil,
    }
  },
  --[=====[
  I've retained Debug's table for now, but I don't see this as necessary. The Debug module is a development tool that could change rapidly during the mod's development. 
  
  There's no need for translation, and introducing such would make expected changes to it tedious.
  Debug = {
    back = "Back",
    front = "Front",
    right = "Right",
    left = "Left",
    rotation = "Rotation",
    length = "Length",
    General = {
      tabname = "General Data",
      topic_diagnostic = "Diagnostics:",
      compatibility = "Mods Compatibility",
      missing_diagnostic = "Diagnostics module not present",
      screen_resolution = "Screen Resolution:",
      screen_aspect_ratio = "Screen Aspect Ratio:",
      camera_fov = "Active Camera FOV:",
      screen_aspect_factor = "Screen Aspect Factor:",
      screen_space = "Screen Space:",
      pre_game = "Is Pre-Game:",
      loaded_game = "Is Game Loaded:",
      paused_game = "Is Game Paused:",
      current_fps = "Current FPS:",
      masked_controller = "Masks Controller:",
      module_presets = "For Presets Module:",
      module_settings = "For Settings Module:",
      module_vectors = "For Vectors Module",
      init_file = "For init.lua",
      masked_controller_ready = "Is Masks Controller Ready:",
      enabled_masking = "Masking enabled:",
      vehicle_mask = "Vehicles HED Mask Size:",
      hed_toggle_value = "HED Fill/Tracker Toggle Value:",
      foot_mask = "On Foot Corner Masks Margins:",
      mask_path = "Masks Paths:",
    },
    Vector = {
      tabname = "Vectors Data",
      camera = "Camera Forward:",
      DotProduct = {
        vehicle = "DotProduct Vehicle Forward:",
        vehicle_absolute = "DotProduct Vehicle Forward Absolute:",
        vehicle_right = "DotProduct Vehicle Right:",
        vehicle_right_absolute = "DotProduct Vehicle Right Absolute:",
        vehicle_up = "DotProduct Vehicle Up:",
        vehicle_up_absolute = "DotProduct Vehicle Up Absolute:",
      },
      camera_angle = "Camera Forward Angle:",
      vehicle_forward_horizontal = "Vehicle Forward Horizontal Plane:",
      vehicle_forward_median = "Vehicle Forward Median Plane:",
      camera_forward_z = "Camera Forward Z:",
      camera_forward_xyz = "Camera Forward (x, y, z, w = 0):",
      camera_right_xyz = "Camera Right (x, y, z, w = 0):",
      camera_up_xyz = "Camera Up (x, y, z, w = 0):",
      vehicle_forward_xyz = "Vehicle Forward (x, y, z, w = 0):",
      vehicle_right_xyz = "Vehicle Right (x, y, z, w = 0):",
      vehicle_up_xyz = "Vehicle Up (x, y, z, w = 0):",
    },
    Vehicle = {
      tabname = "Vehicle Data",
      inside = "Is in a Vehicle:",
      inside_negative_answer = "false",
      Mounted = {
        bike = "bike",
        car = "car",
        tank = "tank",
        unknown = "vehicle"
      },
      id = "Current Vehicle's ID",
      speed = "Vehicle Current Speed:",
      perspective = "Active Camera Perspective in Vehicle:",
      position = "Vehicle's Position:",
      wheels_position = "Wheels Positions:",
      wheel_bl = "Back Left",
      wheel_br = "Back Right",
      wheel_fl = "Front Left",
      wheel_fr = "Front Right",
      wheel_base = "Vehicle's Wheelbase:",
      wheel_axes_postion = "Vehicle Axes Midpoints' Positions:",
      wheel_axis_back = "Back Wheels' Axis",
      wheel_axes_front = "Front Wheels' Axis",
      wheel_axis_left = "Left Wheels' Axis",
      wheel_axis_right = "Right Wheels' Axis",
      bumper_position = "Vehicle Bumpers Positions:",
      bumper_back = "Back",
      bumper_front = "Front",
      bumper_distance = "Distance Between Bumpers:",
      bumper_offset = "Bumpers Offset From Wheels:",
    },
    ScreenSpace = {
      tabname = "Screen Space Data",
      wheels_position = "Wheels Screen Space Positions:",
      bumper_position = "Bumpers Screen Space Distance:",
      axis_rotation = "Distance (Longtitude Axis) Rotation:",
      axes_screen = "Wheels' Axes Screen Data:",
    },
    Masks = {
      tabname ="Masks Data",
      hed_opacity = "Current HED Opacity:",
      hed_tracker_opacity = "Current HED Tracker Opacity:",
      hed_tracker_size = "HED Tracker Size (x, y):",
      opacity = "Current Masks Opacities:",
      opacity_gain = "Opacity Gain:",
      opacity_delay = "Opacity Transformation Delay Time:",
      opacity_normal = "Is Opacity Normalized:",
      position = "Masks Positions:",
      sizes = "Masks Sizes:",
      cached_size = "Cached Masks Sizes:",
      [1] = "Mask 1",
      [2] = "Mask 2",
      [3] = "Mask 3",
      [4] = "Mask 4",
      hed_fill = "HED Fill Lock:",
      hed_tracker = "HED Tracker Position:",
    },
    Player = {
      tabname = "Player Data",
      is_moving = "Is Moving:",
      has_weapon = "Has a Weapon in Hand:",
      is_mounted = "Is Mounted:",
    }
  },
  --]=====]
}

return translation