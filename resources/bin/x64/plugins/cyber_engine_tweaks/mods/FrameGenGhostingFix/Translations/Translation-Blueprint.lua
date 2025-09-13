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
  __VERSION = { 5, 2, 7 },
  __AUTHOR = "", -- Mark your work. 
  UIText = {
    General = {
      group_general = "General Settings:",
      group_fps90 = "90+ FPS FG ON Settings:",
      group_fps120 = "120+ FPS FG ON Settings:",
      group_overview = "Overview:",
      btn_yes = "Yes",
      btn_no = "No",
      btn_apply = "Apply",
      btn_cancel = "Cancel",
      btn_load = "Load",
      btn_save = "Save",
      info_disabled = "Disabled",
      info_enabled = "Enabled",
      info_mod_not_ready = "[ ! ] Mod isn't working. Check logs for details...",
      info_important = "IMPORTANT:",
      info_reopen_overlay = "Reopen CET's overlay after change.",
      info_required = "Required:",
      info_version = "Your FrameGen Ghosting 'Fix' version:",
      status_version = "Mod version:",
    },
    Info = {
      tab_name_info = "Info",
      info_aspect_ratio_change= "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod works as intended.",
      info_benchmark = "[ ! ] FrameGen Ghosting 'Fix' is benchmarking your game's performance. Please continue playing freely: once the benchmark is finished, the mod will apply optimal settings for your game's performance. You can change those settings later.\n\nThe benchmark is conducted during the first run of the mod.",
      info_benchmark_ask = "[ ! ] Do you want to run a benchmark to let the mod measure your game's performance and set optimal anti-ghosting settings?\n\nIt will happen in the background, please continue playing freely.",
      info_mod_not_ready = "The mod encountered a problem:",
    },
    Vehicles = {
      tab_name_vehicle = "Vehicles",
      btn_close_editor = "Close Presets Editor",
      btn_open_editor = "Open Presets Editor",
      group_editor = "Presets Editor:",
      info_author = "Preset's author:",
      info_description = "Preset's info:",
      info_no_masking_vehicles = "[ ! ] Ghosting masking for vehicles is turned off globally.",
      info_presets = "Use this preset for vehicles:",
      info_presets_locked = "Presets are locked when Presets Editor is opened. Please close it when you finish your work.",
      status_applied_veh = "[ ! ] Selected preset applied.",
      status_get_in = "[ ! ] V must be in a vehicle to use this option.",
      tooltip_presets = "Choose a preset of anti-ghosting for vehicles.",
      tooltip_open_editor = "Open Preset Editor: a tool that allows you to modify ghosting masking settings, test them, find ones that suit you best, and save them as a new preset to a file that can be shared with others.",
      tooltip_close_editor = "Close Preset Editor and reaload the preset list.",
    },
    Editor = {
      window_presets_editor = "Presets Editor",
      window_load_preset = "Load Preset",
      window_save_preset = "Save Preset",
      tab_name_vehicle = "Vehicle",
      tab_name_bottom_edges = "Screen Bottom Edges",
      tab_name_masking_strength = "Masking Strength",
      btn_load_preset = "Load Preset",
      btn_save_preset = "Save Preset",
      btn_reset_values = "Reset Values",
      btn_toggle_perspective = "Toggle Perspective",
      btn_center_view = "Center View",
      chk_preview_mode = "Preview Mode: Make enabled masks visible after overlay close",
      chk_masks_around_vehicle = "Enable masks around a vehicle",
      chk_masks_steering_bar = "Enable masks around the steering bar",
      chk_mask_front = "Enable mask in the front",
      chk_mask_rear = "Enable mask in the rear",
      chk_masks_sides = "Enable masks on the sides",
      chk_cockpit_masks = "Enable cockpit elements masks",
      chk_corners_masks = "Enable corner masks",
      chk_middle_mask = "Enable middle mask",
      chk_lock_middle_mask = "Lock middle mask",
      chk_following_mask = "Enable following mask",
      chk_lock_size_bottom_masking = "Lock size of the screen bottom masking",
      chk_decouple_masking = "Decouple masking strength from vehicle's speed",
      group_camera_options = "Camera Options:",
      group_tpp_options = "TPP Options:",
      group_fpp_options = "FPP Options:",
      notif_reloading_settings = "Reloading Settings...",
      notif_preview_mode = "Preview Mode Enabled.",
      slider_vehicle_width = "Scale masking for a vehicle's width:",
      slider_windshield_width = "Scale windshield mask width:",
      slider_windshield_height = "Scale windshield mask height:",
      slider_bottom_edges = "Scale screen bottom edges masks:",
      slider_strength_vehicle = "Set masking strength around a vehicle:",
      slider_strength_bottom = "Set masking strength for the screen bottom edges:",
      slider_strength_bike_dashboard = "Set masking strength for the dashboard mask:",
      slider_strength_bike_end = "Set masking strength for the end mask:",
      slider_strength_car_front = "Set masking strength for the front mask:",
      slider_strength_car_rear = "Set masking strength for the rear mask:",
      slider_strength_sides = "Set masking strength for side masks:",
      slider_strength_gain = "Set masking strength gain around a vehicle:",
      slider_strength_threshold_car = "Set masking strength threshold for rear and front car masks:",
      slider_strength_state_change_delay = "Set masking state change delay around a vehicle:",
      status_preset_loaded = "Preset loaded:",
      status_preset_saved = "Preset saved:",
      status_camera_perspective = "Current camera perspective:",
      status_camera_centered = "Camera centered.",
      status_cant_save = "Can't save. Try different file and preset name.",
      status_close_overlay_reload_list = ".json. Close the editor to reload presets list.",
      status_close_overlay_preview = "Close the overlay without closing the editor to preview current settings.",
      status_fill_all_save = "Fill all fields to save.",
      status_file_name_letters_only = "Only letters, digits, '-', and '_' are allowed for a filename. The first character must be a letter.",
      status_hide_weapons_weponize_vehicle = "Hide your vehicle's weapon to toggle through all perspectives.",
      input_name = "Name:",
      input_author = "Author:",
      input_description = "Description:",
      input_file_name = "File Name:",
      info_enter_vehicle = "Enter a vehicle first: a bike or a car.",
      info_game_loading_wait = "Wait for the game to load.",
      info_switch_to_fpp = "Switch to FPP to edit these options.",
      info_switch_to_tpp = "Switch to a TPP camera to edit these options.",
      info_chars_left = "Characters left:",
      info_is_moving_vehicle = "The vehicle is moving. Stop it to edit these options.",
      tooltip_bottom_edges = "Scale the base width for the whole screen bottom masking. This size will be locked if the 'Lock size of the screen bottom masking' checkbox is selected.",
      tooltip_center_view = "Center the current perspective/camera view.",
      tooltip_cockpit_masks = "Toggle ON/OFF for masks coverings side mirrors and doors' lower parts while driving a car in FPP.",
      tooltip_corners_masks = "Toggle ON/OFF for masks covering bottom corners of the screen while driving a vehicle.",
      tooltip_decouple_masking = "Enabling this option decouples masking strength from a vehicle's speed. If enabled, masks are fully active all the time while driving a vehicle: also when vehicle is static (its current speed is 0).",
      tooltip_following_mask = "Toggle ON/OFF for the mask following the front or rear end of a vehicle, that is currently closer to the bottom edge of the screen.",
      tooltip_input_name = "Enter a name for the new preset.",
      tooltip_input_author = "Enter an author name for the new preset.",
      tooltip_input_description = "Enter a description for the new preset.",
      tooltip_input_file_name = "Enter a file name for the new preset (no spaces).",
      tooltip_load_preset = "Select a base preset to load its values to the editor.",
      tooltip_lock_middle_mask = "Lock the mask covering the middle part of the screen while driving a vehicle. This option makes the mask being active for all camera angle.",
      tooltip_lock_size_bottom_masking = "Stop the screen bottom masking from dynamically changing its size on camera movement.",
      tooltip_mask_front = "Toggle ON/OFF for the mask in the front of a car.",
      tooltip_mask_rear = "Toggle ON/OFF for the mask in the rear of a car.",
      tooltip_masks_sides = "Toggle ON/OFF for masks on a car's sides.",
      tooltip_middle_mask = "Toggle ON/OFF for the mask covering the middle part of the screen while driving a vehicle. The mask is dynamic by default and activates for specific camera angles.",
      tooltip_save_preset = "Save your new values as a new preset file. The new preset will be saved in the 'Presets' folder and can be shared with other users of FrameGen Ghosting 'Fix' V.",
      tooltip_strength_vehicle = "Set masking strength around a vehicle. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 10 is a good balance between effectiveness and them being almost unnoticeable.",
      tooltip_strength_bottom = "Set masking strength for the screen bottom edges. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 6 is a good balance between effectiveness and them being almost unnoticeable.",
      tooltip_strength_bike_dashboard = "Set masking strength for the dashboard mask for a bike in relation to the general masking strength around the vehicle.",
      tooltip_strength_bike_end = "Set masking strength for the end mask of a bike in relation to the general masking strength around the vehicle.",
      tooltip_strength_car_front = "Set masking strength for the front mask of a car in relation to the general masking strength around the vehicle.",
      tooltip_strength_car_rear = "Set masking strength for the rear mask of a car in relation to the general masking strength around the vehicle.",
      tooltip_strength_sides = "Set masking strength for side masks in relation to the general masking strength around the vehicle.",
      tooltip_strength_gain = "Set masking strength gain around a vehicle. Define how quickly masking strength will change for camera angle-dependent transformation.",
      tooltip_strength_threshold_car = "Set masking strength threshold around a vehicle. Define a threshold value at which masking strength transformation for rear and front car masks will temporarily 'freeze' for camera angles close to side view.",
      tooltip_strength_state_change_delay = "Set state change delay in seconds for masking around a vehicle on a sudden speed decrease.",
      tooltip_preview_mode = "Enable Preview Mode, which allows you to see masks after the overlay closes while the editor remains open. This lets you view which parts of the screen are being masked and how your current settings work.",
      tooltip_reset_values = "Reset current values to those found in the loaded preset.",
      tooltip_toggle_perspective = "Toggle through all available camera perspectives for vehicles. The 'TPPFar' perspective is the best for editing TPP-related values.",
      tooltip_windshield = "The sliders let you customize the size of the motorcycle windshield mask. Usually not necessary, but may be handy for some motorcycles with a bigger windshield, like Apollo.",
      tooltip_vehicle_width = "Set an area that will be covered by anti-ghosting masks on sides and in the rear of a car.",
    },
    OnFoot = {
      tab_name_on_foot = "On-Foot",
      chk_blocker_aim = "Enable frame gen blocker for aiming/blocking",
      chk_bottom_corners_masks = "Enable bottom corners anti-ghosting masks",
      chk_vignette = "Enable customizable anti-ghosting vignette",
      chk_vignette_aim = "Enable anti-ghosting vignette for aiming/blocking",
      chk_vignette_permament = "Keep the vignette turned on when V holsters a weapon",
      info_dimming = "[ ! ] Enabling both vignette's options at the same time may cause more noticeable dimming around edges of your screen.",
      info_no_masking_on_foot = "[ ! ] Ghosting masking On-Foot is turned off globally.",
      info_vignette = "The sliders let you customize the vignette's dimensions to cover ghosting on your screen edges. For framerates lower than recommended, these settings come at a noticeable cost of perceived smoothness in outermost areas of your field of view.",
      slider_vignette_height = "Vignette's height:",
      slider_vignette_pos_x = "Vignette's horizontal position:",
      slider_vignette_pos_y = "Vignette's vertical position:",
      slider_vignette_width = "Vignette's width:",
      slider_masking_strength = "Masking strength:",
      status_aim = "[ ! ] You can enable one aiming/blocking feature at once.",
      status_get_out = "[ ! ] V must exit a vehicle to use this option.",
      status_reload_accept_changes = "[ ! ] Redraw your weapon to accept changes.",
      tooltip_blocker_aim = "Enables contextual blocking of frame generation for a whole screen when V is aiming/blocking with a weapon. This may turn out to be helpful in higher framerates as crosshairs/ sights tend to ghost heavily with frame generation turned on.",
      tooltip_bottom_corners_masks = "Enables position-fixed anti-ghosting masks to stop frame generation from occuring locally around bottom corners of your screen and reduce ghosting when V is holding a weapon.",
      tooltip_vignette = "Enables customizable anti-ghosting vignette to stop frame generation from occuring locally around edges of your screen and reduce ghosting when V is holding a weapon.",
      tooltip_vignette_aim = "Enables dynamic anti-ghosting vignette to stop frame generation from occuring locally around edges of your screen and reduce ghosting when V is aiming/blocking with a weapon. For framerates lower than recommended, this setting comes at a cost of perceived smoothness in outermost areas of your field of view.",
      tooltip_vignette_permament = "By default, the vignette hides when V holsters a weapon. This setting lets you keep the vignette turned on all the time when V is on foot.",
    },
    Contextual = {
      tab_name_contextual = "Contextual",
      info_dynamic_frame_gen_forbidden = "Turn off 'Dynamic Frame Generation' in DLSS Enabler's settings to ensure these features work properly. Reopen CET's overlay after change.",
      info_overview = "The contextual feature allows you to prioritize image quality for specific game events by seamlessly turning off frame generation for them.",
      info_select_context = "Select contexts for which you want to automatically turn off frame generation.",
      info_bad_enabler_version = "[ ! ] DLSS Enabler is incompatible or missing. The mod's Contextual Frame Generation feature won't work.",
      info_found_enabler_version = "DLSS Enabler version:",
      info_contextual = "Contextual Frame Generation is a new feature that smoothly toggles frame generation ON/OFF based on the game's events. The feature allows you to prioritize image quality and get rid of frame generation artifacts for selected contexts, like city sightseeing, slow-paced scenes or cinematics.",
      info_contextual_dependencies = "To use the new feature, you need 'FSR3 Frame Gen for Cyberpunk 2077 (DLSS Enabler 2077 Edition)' 3.00.000.0+ and FrameGen Ghosting 'Fix' 5.0.0+.",
      info_contextual_requirements = "This feature needs 55+ base FPS (without frame generation) to work in the intended way.",
      info_context_base_fps = "Set a base FPS value, below which frame generation will be turned off globally.\n\nValue set to '0' disables this feature.",
      info_context_base_fps_state = "Base FPS Context is:",
      group_contexts = "Contexts:",
      group_other = "Other:",
      group_on_foot = "On-Foot:",
      group_vehicles = "Vehicles:",
      group_base_fps = "Base FPS Context:",
      chk_context_sightseeing = "Sightseeing",
      chk_context_slow_paced = "Slow-Paced and Cinematics",
      chk_context_fast_paced = "Fast-Paced",
      chk_context_my_own = "My Own",
      chk_on_foot_standing = "Standing/Crouching",
      chk_on_foot_slow_walking = "Slow Walking",
      chk_on_foot_walking = "Walking/Crouch Walking",
      chk_on_foot_sprinting = "Sprinting/Crouch Sprinting",
      chk_on_foot_swimming = "Swimming",
      chk_vehicles_static = "Static",
      chk_vehicles_driving = "Driving",
      chk_vehicles_static_weapon = "Static (Weapon Drawn)",
      chk_vehicles_driving_weapon = "Driving (Weapon Drawn)",
      chk_braindance = "Braindance",
      chk_cinematics = "Cinematics",
      chk_combat = "Combat (Enemies Alerted)",
      chk_photo_mode = "Photo Mode",
      slider_context_base_fps_threshold = "Set Base FPS Context Threshold:",
      slider_base_fps_calc_interval = "Set Base FPS Calculation Interval:",
      tooltip_context_sightseeing = "Automatically turns off frame generation for:\n- V being stationary (standing and crouching),\n- slow walk (usually activated after pressing the 'G' key),\n- photo mode.\n\nWhen V is in combat, FG remains enabled while moving on-foot or swimming. To disable FG for those states in combat, activate the 'My Own' context and select the 'Combat (Enemies Alerted)' checkbox.",
      tooltip_context_slow_paced = "Automatically turns off frame generation for slow-paced contexts apart from those triggered by 'Sightseeing':\n- normal walking and crouch walking,\n- swimming,\n- being in a stationary vehicle,\n- during braindance sequences,\n- during cinematics.\n\nWhen V is in combat, FG remains enabled while moving on-foot or swimming. To disable FG for those states in combat, activate the 'My Own' context and select the 'Combat (Enemies Alerted)' checkbox.",
      tooltip_context_fast_paced = "Automatically turns off frame generation for:\n- sprinting and crouch sprinting,\n- driving a vehicle,\n- being in a stationary vehicle with a weapon drawn,\n- driving a vehicle with a weapon drawn,\n- during combat sequences.",
      tooltip_context_my_own = "This feature allows you to select exact events to automatically turn off frame generation.",
      tooltip_context_base_fps = "This feature allows you to set a base FPS threshold (FPS without FG), below which frame generation will be turned off globally. When the base FPS reported by the mod falls below your set value, other contexts selected above are overwritten and can't toggle the frame generation state: it remains disabled.\n\nOnce your FPS rises above this threshold, frame generation will be re-enabled, and other contexts will be able to toggle its state again.\n\n(Community Requested Feature).",
      tooltip_base_fps_calc_interval = "Set how often (interval seconds) the mod checks if frame generation should be enabled/disabled for Base FPS Context. This interval also determines the FPS update frequency in the 'Game Performance Benchmark' section of the 'Settings' tab.\n\nThis value doesn't influence average FPS result reported when the mod's Benchmark is finished.",
    },
    Settings = {
      tab_name_settings = "Settings",
      btn_default = "Set to default",
      btn_load_settings = "Load settings",
      btn_reload_mod = "Reload Mod",
      btn_print_user_settings = "Print User Settings From File",
      btn_save_settings = "Save settings",
      chk_debug = "Enable debug mode",
      chk_debug_view = "Enable debug view",
      chk_fg = "Enable Frame Generation",
      chk_help = "Enable tooltips",
      chk_window = "Keep this window open",
      combobox_theme = "Mod's Window Theme:",
      group_fg = "Frame Generation Settings:",
      group_mod = "Mod Settings:",
      info_context_base_fps = "Base FPS Context is enabled. Frame Generation turns off when 'Current FPS without Frame Gen' is lower than:",
      info_frame_gen_status = "Current Frame Generation Status:",
      info_frame_gen_off = "[ ! ] Frame Generation is turned off in the game's settings. Masking is turned off.",
      info_game_not_ready_warning = "[ ! ] You need to start or unpause the game to change these settings.",
      info_game_settings_fg = "[ ! ] Please make sure frame generation is always enabled in game menu for this to work correctly.",
      info_game_frame_gen_required = "[ ! ] Please enable FSR 3 Frame Generation in the game's settings to use these features.",
      info_game_modded_frame_gen_required = "[ ! ] Please enable the MODDED FSR 3 Frame Generation in the game's settings to use these features.",
      info_mod_frame_gen_required = "[ ! ] Please check 'Enable Frame Generation' in the 'Settings' tab to use these features.",
      status_mod_reloaded = "The mod has been reloaded.",
      status_game_loaded_fail = "The game is in the main menu, can't be set to loaded.",
      status_settings_default = "Default settings restored.",
      status_settings_loaded = "User settings loaded.",
      status_settings_restored = "Restored your previous settings.",
      status_settings_saved = "[ ! ] Your settings will be saved.",
      status_settings_save_reminder = "[ ! ] Remember to save your new settings when you finish editing.",
      tooltip_fg = "Turn ON/OFF Frame Generation on the mod level (the game's settings remain unchanged).",
      tooltip_help = "Enable tooltips on mouse hover for certain settings.",
      tooltip_theme = "Pick your colors for the mod's window.",
      tooltip_print_user_settings = "Tries to load 'user-settings.json'. If the file is present, prints its contents. Reopen CET's overlay for this function to work properly.",
      tooltip_reload_mod = "Reload the mod after using 'Reload all mods' option in Cyber Engine Tweaks.",
      tooltip_window = "Keep this window opened after closing CET's overlay.",
    },
    Benchmark = {
      btn_benchmark_revert_settings = "Revert to my settings",
      btn_benchmark_run = "Run benchmark",
      btn_benchmark_set_suggested_settings = "Set suggested settings",
      btn_benchmark_stop = "Stop benchmark",
      info_average_fps = "Average FPS without Frame Gen:",
      info_benchmark = "Benchmark enabled:",
      info_benchmark_pause = "[ ! ] Benchmark is paused. Unpause the game to continue.",
      info_benchmark_pause_overlay = "[ ! ] Benchmark is paused. Exit CET's overlay to continue.",
      info_benchmark_pre_game = "[ ! ] Game metrics are paused. Load the game to continue.",
      info_benchmark_remaining = "Remaining benchmark time (s):",
      info_benchmark_restart = "[ ! ] Benchmark restarting in:",
      info_current_fps = "Current FPS without Frame Gen:",
      info_current_frametime = "Current Frame-Time without Frame Gen (ms):",
      group_benchmark = "Game Performance Benchmark:",
      status_benchmark_enabled = "Benchmark enabled.",
      status_benchmark_finished = "Finished benchmarking.",
      tooltip_run_bench = "Runs the benchmark to measure your game's performance and applies suggested settings once completed. When finished you can review the new settings and revert to your current ones if needed."
    },
    Diagnostics = {
      tab_name_diagnostics = "Diagnostics",
      info_warning = "CONFLICTS WITH OTHER MODS DETECTED",
      info_update = "UPDATE AVAILABLE",
      info_conflict = "Seems like you have a conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation will work without problems, please, visit FrameGen Ghosting 'Fix's Nexus page to download and install the latest version of the mod.",
      info_conflicting_mods = "Conflicting mods:",
      info_potentially = "Seems like you have a potentially conflicting mod installed.\n\nTo ensure that anti-ghosting for frame generation will work without problems in the future, please visit FrameGenGhosting 'Fix's Nexus page to download and install the latest version of the mod.\n\nWith the new version you no longer need any compatibility tweaks.",
      info_potentially_mods = "Potentially conflicting mods:"
    },
  },
  PresetsList = {
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
    },
    a006 = {
      PresetInfo = {
        name = "Maximum Strength",
        description = "Masks' anti-ghosting strength is much greater. Their state change delay on a sudden speed decrease is set to 3 seconds.",
      }
    },
    a007 = {
      PresetInfo = {
        name = "Extreme - DBK Edition",
        description = "For enthusiasts of extremely fast cars and bold, wide spoilers.",
      }
    }
  }
}

return translation