Localization = {
  __NAME = "Localization",
  __VERSION = { 5, 0, 0 },
}

local UIText = {
  General = {
    group_general = "General Settings:",
    group_fps90 = "90+ FPS FG ON Settings:",
    group_fps120 = "120+ FPS FG ON Settings:",
    btn_yes = "Yes",
    btn_no = "No",
    btn_apply = "Apply",
    btn_cancel = "Cancel",
    btn_load = "Load",
    btn_save = "Save",
    info_disabled = "Disabled",
    info_enabled = "Enabled",
    info_mod_not_ready = "[ ! ] Mod isn't working. Check logs for details...",
    status_version = "Mod version:",
  },
  Info = {
    tab_name_info = "Info",
    info_aspect_ratio_change= "[ ! ] The aspect ratio of your screen has changed.\n\nPlease restart the game to ensure the mod will work as intended.",
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
    chk_preview_mode = "Preview Mode: Make enabled masks visible after overlay closes",
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
    status_preset_loaded = "Preset loaded:",
    status_preset_saved = "Preset saved:",
    status_camera_perspective = "Current camera perspective:",
    status_camera_centered = "Camera centered.",
    status_cant_save = "Can't save. Try different file and preset name.",
    status_close_overlay_reload_list = ".json. Close the editor to reload presets list.",
    status_close_overlay_preview = "Close the overlay without closing the editor to preview current settings.",
    status_fill_all_save = "Fill all fields to save.",
    status_file_name_letters_only = "You can use letters only in the file name.",
    status_hide_weapons_weponize_vehicle = "Hide your vehicle's weapon to toggle through all perspectives.",
    input_name = "Name:",
    input_author = "Author:",
    input_description = "Description:",
    input_file_name = "File Name:",
    info_enter_vehicle = "Enter a vehicle first: a bike or a car.",
    info_switch_to_fpp = "Switch to FPP to edit these options.",
    info_switch_to_tpp = "Switch to a TPP camera to edit these options.",
    info_chars_left = "Characters left:",
    info_is_moving_vehicle = "The vehicle is moving. Stop it to edit these options.",
    tooltip_bottom_edges = "Scale the base width for the whole screen bottom masking. This size will be locked if the 'Lock size of the screen bottom masking' checkbox is selected.",
    tooltip_center_view = "Center the current perspective/camera view.",
    tooltip_cockpit_masks = "Toggle on/off for masks coverings side mirrors and doors' lower parts while driving a car in FPP.",
    tooltip_corners_masks = "Toggle on/off for masks covering bottom corners of the screen while driving a vehicle.",
    tooltip_decouple_masking = "Enabling this option decouples masking strength from a vehicle's speed. If enabled, masks are fully active all the time while driving a vehicle: also when vehicle is static (its current speed is 0).",
    tooltip_following_mask = "Toggle on/off for the mask following the front or rear end of a vehicle, that is currently closer to the bottom edge of the screen.",
    tooltip_input_name = "Enter a name for the new preset.",
    tooltip_input_author = "Enter an author name for the new preset.",
    tooltip_input_description = "Enter a description for the new preset.",
    tooltip_input_file_name = "Enter a file name for the new preset (no spaces).",
    tooltip_load_preset = "Select a base preset to load its values to the editor.",
    tooltip_lock_middle_mask = "Lock the mask covering the middle part of the screen while driving a vehicle. This option makes the mask being active for all camera angle.",
    tooltip_lock_size_bottom_masking = "Stop the screen bottom masking from dynamically changing its size on camera movement.",
    tooltip_mask_front = "Toggle on/off for the mask in the front of a car.",
    tooltip_mask_rear = "Toggle on/off for the mask in the rear of a car.",
    tooltip_masks_sides = "Toggle on/off for masks on a car's sides.",
    tooltip_middle_mask = "Toggle on/off for the mask covering the middle part of the screen while driving a vehicle. The mask is dynamic by default and activates for specific camera angles.",
    tooltip_save_preset = "Save your new values as a new preset file. The new preset will be saved in the 'Presets' folder and can be shared with other users of FrameGen Ghosting 'Fix' V.",
    tooltip_strength_vehicle = "Set masking strength around a vehicle. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 10 is a good balance between effectiveness and them being almost unnoticeable.",
    tooltip_strength_bottom = "Set masking strength for the screen bottom edges. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 6 is a good balance between effectiveness and them being almost unnoticeable.",
    tooltip_preview_mode = "Enable Preview Mode, which allows you to see masks after the overlay closes while the editor remains open. This lets you view which parts of the screen are being masked and how your current settings work.",
    tooltip_reset_values = "Reset current values to ones found in the loaded preset.",
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
    info_dynamic_frame_gen = "Turn off 'Dynamic Frame Generation' in DLSS Enabler's settings and reopen CET's overlay to use these features.",
    info_requirement = "Please check 'Enable Frame Generation' in the 'Settings' tab to use these features.",
    info_select_context = "Select contexts to turn off frame generation during these events.",
    group_other = "Other:",
    group_on_foot = "On-Foot:",
    group_vehicles = "Vehicles:",
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
  },
  Settings = {
    tab_name_settings = "Settings",
    btn_default = "Set to default",
    btn_load_settings = "Load settings",
    btn_save_settings = "Save settings",
    chk_debug = "Enable debug mode",
    chk_debug_view = "Enable debug tabs in the window",
    chk_fg = "Enable Frame Generation",
    chk_help = "Enable tooltips",
    chk_window = "Keep this window open",
    combobox_theme = "Mod's Window Theme:",
    group_fg = "Frame Generation Settings:",
    group_mod = "Mod Settings:",
    info_frame_gen_status = "Current Frame Generation Status:",
    info_frame_gen_off = "[ ! ] Frame Generation is turned off in the game's settings. Masking is turned off.",
    info_game_not_ready_warning = "[ ! ] You need to start or unpause the game to change these settings.",
    info_game_settings_fg = "[ ! ] Please make sure frame generation is always enabled in game menu for this to work correctly.",
    status_settings_default = "Default settings restored.",
    status_settings_loaded = "User settings loaded.",
    status_settings_restored = "Restored your previous settings.",
    status_settings_saved = "[ ! ] Your settings will be saved.",
    tooltip_fg = "Turn on/off Frame Generation on the mod level (the game's settings remain unchanged).",
    tooltip_help = "Enable tooltips on mouse hover for certain settings.",
    tooltip_theme = "Pick your colors for the mod's window.",
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
}

local LogText = {
  archive_missing = "Missing mod's archive. The mod won't work...",
  benchmark_starting = "Starting benchmark...",
  benchmark_restarting = "Restarting benchmark...",
  benchmark_avg_fps_result = "Measured average FPS without frame generation =",
  bridge_bad_enabler_version = "DLSS Enabler is incompatible or missing. The mod's contextual frame generation feature won't work.",
  bridge_missing = "Can't find the 'dlss-enabler-bridge-2077.dll' file. The mod's contextual frame generation feature won't work.",
  calculate_apply_settings = "Applying settings accordingly...",
  calculate_missing = "Can't find the 'Calculate' module. The mod's anti-ghosting feature for on-foot gameplay won't work.",
  contextual_missing = "Can't find the 'Contextual' module. The mod's contextual frame generation feature won't work.",
  globals_controller_missing = "Masks controller not set.  The mod won't work...",
  globals_first_run = "Initial launch of the mod detected.",
  globals_missing = "Can't find the 'Globals' module. The mod won't work...",
  globals_wrong_version = "The mod's 'Globals' module seems to be not compatible with the mod's current version. The mod won't work...",
  imguiext_missing = "Can't find the 'ImGuiExt' module. The mod won't work...",
  localization_base_localization = "Set the mod to the default language:",
  localization_key_not_found = "Check translation files, couldn't find a key/table in a file:",
  localization_missing = "Can't find the 'Localization' module. The mod won't work...",
  localization_translation_found = "Found a translation for language code:",
  localization_translation_not_found = "Couldn't find any translation for language code:",
  localization_translation_author = "Author of the translation:",
  presets_loaded = "Vehicle presets loaded:",
  presets_missing = "Can't find the 'VectorsPresets' module. The mod's presets feature won't work...",
  presets_skipped_file_duplicate = "Another preset exists with the same name, skipped the file. Please use a different name.",
  presets_skipped_file_data = "Skipped the preset file. It does not contain the required data for anti-ghosting masks:",
  redscript_missing = "Can't find a compatible RedScript module. The mod won't work as intended...",
  settings_missing = "Can't find the 'Settings' module. The mod won't let you save your settings.",
  settings_file_not_found = "A 'user_settings.json' file hasn't been found.",
  settings_loaded = "User settings loaded.",
  settings_saved_to_file = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
  settings_not_saved_to_file = "Couldn't save user settings to a file.",
  settings_restored = "Your previous settings have been restored.",
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

function Localization.GetEditorText()
  return UIText.Editor
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
    Globals.Print(Localization.__NAME, LogText.localization_translation_found, GameOnScreenLang.current)

    if translation.__AUTHOR then
      Globals.Print(Localization.__NAME, LogText.localization_translation_author, translation.__AUTHOR)
    end

    SetFlag(key)
  else
    Working.Translated = Working.Default

    if GameOnScreenLang.last == GameOnScreenLang.current then return Working.Translated end
    Globals.Print(Localization.__NAME, LogText.localization_translation_not_found, GameOnScreenLang.current)

    SetFlag(key)
  end
end

local function GetDefaultLocalization(key)
  ClearFlag(key)

  Working.Translated = Globals.SafeMergeTables(Working.Default, Globals.GetFallback("Localization", key))

  if GameOnScreenLang.last == GameOnScreenLang.current then return Working.Translated end

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