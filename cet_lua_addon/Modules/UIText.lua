--FrameGen Ghosting Fix 3.1.0

local UIText = {
    General = {
        modname = "FrameGen Ghosting 'Fix'",
        modname_log = "[FrameGen Ghosting 'Fix']",
        title_general = "General Settings:",
        title_fps90 = "90+ FPS FG ON Recommended Settings:",
        title_fps100 = "100+ FPS FG ON Recommended Settings:",
        title_fps120 = "120+ FPS FG ON Recommended Settings:",
        settings_loaded = "User settings loaded.",
        settings_loaded_preset = "Preset loaded",
        settings_apply = "  Apply  ",
        settings_save = "Save settings",
        settings_saved = "[ ! ] Your settings are saved.",
        settings_saved_onfoot = "[ ! ] Redraw your weapon to accept changes.",
        settings_save_path = "Your settings have been saved in your '.../cyber_engine_tweaks/mods/FrameGenGhostingFix/user_settings.json' file.",
        settings_notfound = "A 'user_settings.json' file hasn't been found. Setting default values...",
        settings_default = "Set to default",
        info_aim_onfoot = "[ ! ] You can enable one aiming/blocking feature at once."
    },
	Diagnostics = {
        tabname = "Diagnostics",
        title = "CONFLICTS WITH OTHER MODS DETECTED",
        textfield_1 = "To resolve conflicts with these mods:",
        textfield_2 = "and ensure FG anti-ghosting will work, please visit\nGhosting 'Fix's Nexus page for compatibility tweaks\nand instructions."
    },
    Vehicles = {
        tabname = "Vehicles",
        MaskingPresets = {
            name = "Use anti-ghosting masking preset:",
            tooltip = "Choose a preset of anti-ghosting for vehicles."
        },
        SideMirror = {
            name = "Enable left-side mirror anti-ghosting for FPP in cars",
            tooltip = "Enables position-fixed anti-ghosting mask to stop frame generation\nfrom occuring locally around a left-side mirror and reduce ghosting\nwhen driving a car in FPP."
        },
        ELG = {
            name = "Enable 'Even Less Ghosting' anti-ghosting for FPP on bikes",
            tooltip = "Enables customizable, dynamic anti-ghosting masks to stop frame generation\nfrom occuring locally around a windshield and further reduce ghosting\nwhen riding a motorcycle.",
            textfield_1 = "For a live view, change the values below when in FPP on a\nmotorcycle during gameplay (not in the game's menu).",
            textfield_2 = "Sliders below let you customize ELG settings. The default ELG\nsettings are optimized for 45+ base fps (90+ fps with FG ON).\nYou need much more base fps for a good experience when\nsetting high values below. Potential Side Effects: sunscreen\nand banding.",
            setting_1 = "Handlebars AG mask height (ELG default 170%):",
            setting_2 = "Windshield AG mask width (ELG default 120%):",
            setting_3 = "Windshield AG mask height (ELG default 300%):",
            comment_1 = "Extreme",
            comment_2 = "Oooffff",
            comment_3 = "Bonkers"
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
            textfield_1 = "Sliders below let you customize the vignette's dimensions\nto cover ghosting on your screen edges. For framerates lower\nthan recommended, these settings come at a noticeable cost\nof perceived smoothness in outermost areas of your field\nof view.",
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
            tooltip = "[EXPERIMENTAL] Enables contextual blocking of frame generation\nfor a whole screen when V is aiming/blocking with a weapon. This\nmay turn out to be helpful in higher framerates as crosshairs/\nsights tend to ghost heavily with frame generation turned on."
        }
    }
}

return UIText