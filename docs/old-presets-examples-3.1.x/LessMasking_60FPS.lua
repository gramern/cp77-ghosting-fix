--persepctive settings pattern: vehicleCameraPerspective + gamedataVehicleType = { transition event assigned to a vehicle's current speed  = { dumbo1setSize.X --> number, dumbo1setSize.Y --> number, dumbo2setSize.X --> number, dumbo2setSize.Y --> number, dumbo3setSize.X --> number, dumbo3setSize.Y --> number dumbo1setOpacity --> number, dumbo2setOpacity --> number, dumbo3setOpacity --> number, dumbo45setOpacity --> number, dynamic_dumbo1setOpacity --> number, dynamic_dumbo2setOpacity --> number, dynamic_dumbo3setOpacity --> number } }

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
        id = 102, -- ID has to be between 100 and 999999, duplicated IDs will fail the loading process
        name = "Less masking (60+ FPS with FG ON)",
		    description = "Preset tuned to improve smoothness when using modded\nFSR3 frame generation in lower framerates. Limits anti-\nghosting masks for a price of more visible ghosting/frame\ngeneration artefacts.",
        author = nil
	}
}

return Preset