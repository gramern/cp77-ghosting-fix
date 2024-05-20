--FrameGen Ghosting Fix 4.1.2xl

local UIText = {
  General = {
    modname = "FrameGen Ghosting 'Fix'",
    modname_log = "[FrameGen Ghosting 'Fix']",
    title_general = "General Settings:",
    title_fps90 = "90+ FPS FG ON Settings:",
    title_fps100 = "100+ FPS FG ON Settings:",
    title_fps120 = "120+ FPS FG ON Settings:",
    settings_loaded = "User settings loaded.",
    settings_loaded_preset = "Preset loaded",
    settings_apply = "  Apply  ",
    settings_applied_veh = "[ ! ] Selected preset applied.",
    settings_save = "Save settings",
    settings_saved = "[ ! ] Your settings are saved.",
    settings_saved_onfoot = "[ ! ] Redraw your weapon to accept changes.",
    settings_save_path = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
    settings_notfound = "A 'user_settings.json' file hasn't been found. Setting default values...",
    settings_default = "Set to default",
    info_aim_onfoot = "[ ! ] You can enable one aiming/blocking feature at once."
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
  }
}

return UIText