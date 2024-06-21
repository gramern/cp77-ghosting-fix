--persepctive settings pattern: vehicleCameraPerspective + gamedataVehicleType = { transition event assigned to a vehicle's current speed  = { dumbo1setSize.X --> number, dumbo1setSize.Y --> number, dumbo2setSize.X --> number, dumbo2setSize.Y --> number, dumbo3setSize.X --> number, dumbo3setSize.Y --> number dumbo1setOpacity --> number, dumbo2setOpacity --> number, dumbo3setOpacity --> number, dumbo45setOpacity --> number, dynamic_dumbo1setOpacity --> number, dynamic_dumbo2setOpacity --> number, dynamic_dumbo3setOpacity --> number } }
-- to add support for translations make this your first line of code: local UITranslation = require("Modules/Translation")
local UITranslation = require("Modules/Translation")

local Preset = {
    TPPCar = {
        full = {7680.0, 1150.0, 0.0, 0.0, 0.0, 0.0, 0.045, 0.0, 0.0, 0.02, 0.02, 0.0, 0.0},
        faster = {7680.0, 1100.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.0, 0.0, 0.02, 0.02, 0.0, 0.0},
        slow = {7680.0, 1050.0, 0.0, 0.0, 0.0, 0.0, 0.02, 0.0, 0.0, 0.02, 0.01, 0.0, 0.0},
        crawl = {7680.0, 1050.0, 0.0, 0.0, 0.0, 0.0, 0.01, 0.0, 0.0, 0.01, 0.0, 0.0, 0.0}
    },
    TPPFarCar = {
        full = {0.0, 0.0, 2000.0, 700.0, 1800.0, 800.0, 0.0, 0.035, 0.02, 0.02, 0.03, 0.0, 0.0},
        slow = {0.0, 0.0, 1800.0, 700.0, 1800.0, 800.0, 0.0, 0.02, 0.015, 0.015, 0.02, 0.0, 0.0},
        crawl = {0.0, 0.0, 1600.0, 700.0, 1800.0, 800.0, 0.0, 0.015, 0.01, 0.01, 0.01, 0.0, 0.0}
    },
    TPPBike = {
        full = {7680.0, 1200.0, 2400.0, 700.0, 0.0, 0.0, 0.045, 0.025, 0.0, 0.02, 0.02, 0.0, 0.0},
        faster = {7680.0, 1100.0, 2400.0, 700.0, 0.0, 0.0, 0.025, 0.02, 0.0, 0.02, 0.02, 0.0, 0.0},
        slow = {7680.0, 1050.0, 2400.0, 700.0, 0.0, 0.0, 0.02, 0.02, 0.0, 0.02, 0.01, 0.0, 0.0},
        crawl = {7680.0, 1050.0, 2400.0, 700.0, 0.0, 0.0, 0.01, 0.01, 0.0, 0.01, 0.0, 0.0, 0.0}
    },
    TPPFarBike = {
        full = {0.0, 0.0, 2100.0, 700.0, 0.0, 0.0, 0.0, 0.045, 0.0, 0.02, 0.03, 0.0, 0.0},
        slow = {0.0, 0.0, 1800.0, 700.0, 0.0, 0.0, 0.0, 0.025, 0.0, 0.015, 0.02, 0.0, 0.0},
        crawl = {0.0, 0.0, 1600.0, 700.0, 0.0, 0.0, 0.0, 0.015, 0.0, 0.01, 0.01, 0.0, 0.0}
    },
    FPPBike = {
        enabled = true
    },
    MaskingInVehiclesGlobal = {
        enabled = true
    },
	PresetInfo = {
        -- name is the name of the preset that won't be visible on UI
        name = "Less masking (60+ FPS with FG ON)",
        -- display is the name of the preset that will be visible on UI only
        -- to support translations add "UITranslation.Presets.<Authorname>.<Preset's name without special characters except underscore>.name or " and then your own value
        -- without supporting transitions: display = "Less masking (60+ FPS with FG ON)",
        display = UITranslation.Presets.MyAuthorName.My_Special_Preset.name or "Less masking (60+ FPS with FG ON)",
        -- to support translations add "UITranslation.Presets.<Authorname>.<Preset's name without special characters except underscore>.description or " and then your own value
        -- without supporting transitions: description = "Preset tuned to improve smoothness when using modded\nFSR3 frame generation in lower framerates. Limits anti-\nghosting masks for a price of more visible ghosting/frame\ngeneration artefacts.",
		    description = UITranslation.Presets.MyAuthorName.My_Special_Preset.description or "Preset tuned to improve smoothness when using modded\nFSR3 frame generation in lower framerates. Limits anti-\nghosting masks for a price of more visible ghosting/frame\ngeneration artefacts.",
        author = nil
	}
}

return Preset