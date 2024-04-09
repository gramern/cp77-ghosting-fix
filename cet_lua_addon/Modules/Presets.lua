--FrameGen Ghosting Fix 3.1.2

local Presets = {
    selectedPreset = nil,
    selectedPresetPosition = nil,
    presetsFile = {},
    presetsList = {},
    presetsDesc = {},
    presetsAuth = {},
    TPPCar = {
        full = {7680.0, 950.0, 3600.0, 850.0, 2000.0, 900.0, 0.03, 0.05, 0.03, 0.03, 0.03, 0.0, 0.0},
        faster = {7680.0, 950.0, 3600.0, 850.0, 2000.0, 900.0, 0.025, 0.03, 0.025, 0.025, 0.02, 0.0, 0.0},
        slow = {7680.0, 950.0, 3400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0},
        crawl = {7680.0, 950.0, 3400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
    },
    TPPFarCar = {
        full = {7680.0, 800.0, 2000.0, 1150.0, 1800.0, 800.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
        slow = {7680.0, 800.0, 2600.0, 800.0, 1800.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
        crawl = {7680.0, 800.0, 2600.0, 800.01, 800.0, 800.0, 0.0, 0.01, 0.02, 0.01, 0.01, 0.0, 0.0}
    },
    TPPBike = {
        full = {7680.0, 950.0, 3200.0, 1050.0, 1400.0, 1400.0, 0.03, 0.04, 0.03, 0.03, 0.03, 0.0, 0.0},
        faster = {7680.0, 950.0, 3200.0, 1050.0, 1400.0, 1400.0, 0.025, 0.025, 0.025, 0.025, 0.02, 0.0, 0.0},
        slow = {7680.0, 950.0, 2400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0},
        crawl = {7680.0, 950.0, 2400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
    },
    TPPFarBike = {
        full = {7680.0, 800.0, 2000.0, 1050.0, 1800.0, 800.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
        slow = {7680.0, 800.0, 2000.0, 900.0, 1800.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
        crawl = {7680.0, 800.0, 2000.0, 700.0, 1800.0, 800.0, 0.0, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
    },
    FPPBike = {
        enabled = true
    },
    MaskingInVehiclesGlobal = {
        enabled = true
    },
    Default = {
        TPPCar = {
            full = {7680.0, 950.0, 3600.0, 850.0, 2000.0, 900.0, 0.03, 0.05, 0.03, 0.03, 0.03, 0.0, 0.0},
            faster = {7680.0, 950.0, 3600.0, 850.0, 2000.0, 900.0, 0.025, 0.03, 0.025, 0.025, 0.02, 0.0, 0.0},
            slow = {7680.0, 950.0, 3400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0},
            crawl = {7680.0, 950.0, 3400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        TPPFarCar = {
            full = {7680.0, 800.0, 2000.0, 1150.0, 1800.0, 800.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
            slow = {7680.0, 800.0, 2600.0, 800.0, 1800.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
            crawl = {7680.0, 800.0, 2600.0, 800.0, 800.0, 800.0, 0.0, 0.01, 0.02, 0.01, 0.01, 0.0, 0.0}
        },
        TPPBike = {
            full = {7680.0, 950.0, 3200.0, 1050.0, 1400.0, 1400.0, 0.03, 0.04, 0.03, 0.03, 0.03, 0.0, 0.0},
            faster = {7680.0, 950.0, 3200.0, 1050.0, 1400.0, 1400.0, 0.025, 0.025, 0.025, 0.025, 0.02, 0.0, 0.0},
            slow = {7680.0, 950.0, 2400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0},
            crawl = {7680.0, 950.0, 2400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        TPPFarBike = {
            full = {7680.0, 800.0, 2000.0, 1050.0, 1800.0, 800.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
            slow = {7680.0, 800.0, 2000.0, 900.0, 1800.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
            crawl = {7680.0, 800.0, 2000.0, 700.0, 1800.0, 800.0, 0.0, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        FPPBike = {
            enabled = true
        },
        MaskingInVehiclesGlobal = {
            enabled = true
        },
        PresetInfo = {
            file = "Default.lua",
            name = "Default (90+ FPS with FG ON)",
            description = "Default preset, optimized for 90+ fps with FG ON.",
            author = nil
        },
    },
    Default43 = {
        TPPCar = {
            full = {7680.0, 1400.0, 3800.0, 1200.0, 2000.0, 1000.0, 0.04, 0.05, 0.03, 0.03, 0.04, 0.0, 0.0},
            faster = {7680.0, 1250.0, 3600.0, 850.0, 2000.0, 900.0, 0.03, 0.035, 0.025, 0.025, 0.025, 0.0, 0.0},
            slow = {7680.0, 1150.0, 3400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.015, 0.0, 0.0},
            crawl = {7680.0, 1050.0, 3400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        TPPFarCar = {
            full = {7680.0, 950.0, 2800.0, 1150.0, 2200.0, 1200.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
            slow = {7680.0, 950.0, 2600.0, 1000.0, 2000.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
            crawl = {7680.0, 950.0, 2600.0, 800.01, 800.0, 800.0, 0.0, 0.01, 0.02, 0.01, 0.01, 0.0, 0.0}
        },
        TPPBike = {
            full = {7680.0, 1400.0, 3600.0, 1200.0, 1400.0, 1400.0, 0.04, 0.05, 0.03, 0.03, 0.04, 0.0, 0.0},
            faster = {7680.0, 1250.0, 3200.0, 1050.0, 1400.0, 1400.0, 0.03, 0.035, 0.025, 0.025, 0.025, 0.0, 0.0},
            slow = {7680.0, 1150.0, 2400.0, 700.0, 1800.0, 800.0, 0.02, 0.02, 0.02, 0.02, 0.015, 0.0, 0.0},
            crawl = {7680.0, 1050.0, 2400.0, 700.0, 1800.0, 800.0, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        TPPFarBike = {
            full = {7680.0, 950.0, 2800.0, 1150.0, 2200.0, 1200.0, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0},
            slow = {7680.0, 950.0, 2600.0, 1000.0, 2000.0, 800.0, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0},
            crawl = {7680.0, 950.0, 2000.0, 700.0, 1800.0, 800.0, 0.0, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0}
        },
        FPPBike = {
            enabled = true
        },
        MaskingInVehiclesGlobal = {
            enabled = true
        },
        PresetInfo = {
            file = "Default43.lua",
            name = "Default for 4:3 (90+ FPS with FG ON)",
            description = "Default preset, optimized for 90+ fps with FG ON.",
            author = nil
        },
    }
}

function Presets.GetPresets()
    local presetsDir = dir('Presets')
    local i = 1
    for _, preset in ipairs(presetsDir) do
        if string.find(preset.name, '%.lua$') then
            table.insert(Presets.presetsFile, i, preset.name)
            i = i + 1
        end
    end
end

function Presets.ListPresets()
    Presets.selectedPreset = Presets.presetsList[1]
    Presets.GetPresets()
    local i = 1
    for _,preset in pairs(Presets.presetsFile) do
        preset = string.gsub(preset, ".lua", "")
        local presetPath = "Presets/" .. preset
        local Preset = require(presetPath)
        if Preset.PresetInfo.name then
            i = i + 1
            table.insert(Presets.presetsList, i, Preset.PresetInfo.name)
            table.insert(Presets.presetsDesc, i, Preset.PresetInfo.description)
            table.insert(Presets.presetsAuth, i, Preset.PresetInfo.author)
        end
    end
end

function Presets.GetPresetInfo()
    for i, preset in ipairs(Presets.presetsList) do
        if preset == Presets.selectedPreset then
            Presets.selectedPresetPosition = i
            return i
        end
    end
end

function Presets.LoadPreset()
    local presetPath = nil
    if Presets.presetsFile[Presets.selectedPresetPosition] then
        presetPath = "Presets/" .. Presets.presetsFile[Presets.selectedPresetPosition]
    end
    if Presets.selectedPresetPosition == 1 or not presetPath then
        if not presetPath then
            Presets.selectedPreset = "Default (90+ FPS with FG ON)"
            Presets.GetPresetInfo()
        end
        local LoadDefault = Presets.Default
        if Presets.presetsFile[Presets.selectedPresetPosition] == "Default43.lua" then
            LoadDefault = Presets.Default43
        end
        Presets.TPPCar.full = LoadDefault.TPPCar.full
        Presets.TPPCar.faster = LoadDefault.TPPCar.faster
        Presets.TPPCar.slow = LoadDefault.TPPCar.slow
        Presets.TPPCar.crawl = LoadDefault.TPPCar.crawl
        Presets.TPPFarCar.full = LoadDefault.TPPFarCar.full
        Presets.TPPFarCar.faster = LoadDefault.TPPFarCar.faster
        Presets.TPPFarCar.crawl = LoadDefault.TPPFarCar.crawl
        Presets.TPPBike.full = LoadDefault.TPPBike.full
        Presets.TPPBike.faster = LoadDefault.TPPBike.faster
        Presets.TPPBike.slow = LoadDefault.TPPBike.slow
        Presets.TPPBike.crawl = LoadDefault.TPPBike.crawl
        Presets.TPPFarBike.full = LoadDefault.TPPFarBike.full
        Presets.TPPFarBike.faster = LoadDefault.TPPFarBike.faster
        Presets.TPPFarBike.crawl = LoadDefault.TPPFarBike.crawl
        Presets.FPPBike.enabled = LoadDefault.FPPBike.enabled
        Presets.MaskingInVehiclesGlobal.enabled = LoadDefault.MaskingInVehiclesGlobal.enabled
    else
        presetPath = string.gsub(presetPath, ".lua", "")
        local Preset = require(presetPath)
        if Preset.PresetInfo.name then
            if presetPath then
                Presets.TPPCar.full = Preset.TPPCar.full
                Presets.TPPCar.faster = Preset.TPPCar.faster
                Presets.TPPCar.slow = Preset.TPPCar.slow
                Presets.TPPCar.crawl = Preset.TPPCar.crawl
                Presets.TPPFarCar.full = Preset.TPPFarCar.full
                Presets.TPPFarCar.faster = Preset.TPPFarCar.faster
                Presets.TPPFarCar.crawl = Preset.TPPFarCar.crawl
                Presets.TPPBike.full = Preset.TPPBike.full
                Presets.TPPBike.faster = Preset.TPPBike.faster
                Presets.TPPBike.slow = Preset.TPPBike.slow
                Presets.TPPBike.crawl = Preset.TPPBike.crawl
                Presets.TPPFarBike.full = Preset.TPPFarBike.full
                Presets.TPPFarBike.faster = Preset.TPPFarBike.faster
                Presets.TPPFarBike.crawl = Preset.TPPFarBike.crawl
                Presets.FPPBike.enabled = Preset.FPPBike.enabled
                Presets.MaskingInVehiclesGlobal.enabled = Preset.MaskingInVehiclesGlobal.enabled
            end
        end
    end
end

function Presets.ApplyPreset()
    --TPP Car
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPCarEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPCar.full[1], Y = Presets.TPPCar.full[2]}), Vector2.new({X = Presets.TPPCar.full[3], Y = Presets.TPPCar.full[4]}), Vector2.new({X = Presets.TPPCar.full[5], Y = Presets.TPPCar.full[6]}), Presets.TPPCar.full[7], Presets.TPPCar.full[8], Presets.TPPCar.full[9], Presets.TPPCar.full[10], Presets.TPPCar.full[11], Presets.TPPCar.full[12], Presets.TPPCar.full[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPCarFasterEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPCar.faster[1], Y = Presets.TPPCar.faster[2]}), Vector2.new({X = Presets.TPPCar.faster[3], Y = Presets.TPPCar.faster[4]}), Vector2.new({X = Presets.TPPCar.faster[5], Y = Presets.TPPCar.faster[6]}), Presets.TPPCar.faster[7], Presets.TPPCar.faster[8], Presets.TPPCar.faster[9], Presets.TPPCar.faster[10], Presets.TPPCar.faster[11], Presets.TPPCar.faster[12], Presets.TPPCar.faster[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPCarSlowEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPCar.slow[1], Y = Presets.TPPCar.slow[2]}), Vector2.new({X = Presets.TPPCar.slow[3], Y = Presets.TPPCar.slow[4]}), Vector2.new({X = Presets.TPPCar.slow[5], Y = Presets.TPPCar.slow[6]}), Presets.TPPCar.slow[7], Presets.TPPCar.slow[8], Presets.TPPCar.slow[9], Presets.TPPCar.slow[10], Presets.TPPCar.slow[11], Presets.TPPCar.slow[12], Presets.TPPCar.slow[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPCarCrawlEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPCar.crawl[1], Y = Presets.TPPCar.crawl[2]}), Vector2.new({X = Presets.TPPCar.crawl[3], Y = Presets.TPPCar.crawl[4]}), Vector2.new({X = Presets.TPPCar.crawl[5], Y = Presets.TPPCar.crawl[6]}), Presets.TPPCar.crawl[7], Presets.TPPCar.crawl[8], Presets.TPPCar.crawl[9], Presets.TPPCar.crawl[10], Presets.TPPCar.crawl[11], Presets.TPPCar.crawl[12], Presets.TPPCar.crawl[13])
    end)

    --TPPFar Car
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarCarEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarCar.full[1], Y = Presets.TPPFarCar.full[2]}), Vector2.new({X = Presets.TPPFarCar.full[3], Y = Presets.TPPFarCar.full[4]}), Vector2.new({X = Presets.TPPFarCar.full[5], Y = Presets.TPPFarCar.full[6]}), Presets.TPPFarCar.full[7], Presets.TPPFarCar.full[8], Presets.TPPFarCar.full[9], Presets.TPPFarCar.full[10], Presets.TPPFarCar.full[11], Presets.TPPFarCar.full[12], Presets.TPPFarCar.full[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarCarSlowEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarCar.slow[1], Y = Presets.TPPFarCar.slow[2]}), Vector2.new({X = Presets.TPPFarCar.slow[3], Y = Presets.TPPFarCar.slow[4]}), Vector2.new({X = Presets.TPPFarCar.slow[5], Y = Presets.TPPFarCar.slow[6]}), Presets.TPPFarCar.slow[7], Presets.TPPFarCar.slow[8], Presets.TPPFarCar.slow[9], Presets.TPPFarCar.slow[10], Presets.TPPFarCar.slow[11], Presets.TPPFarCar.slow[12], Presets.TPPFarCar.slow[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarCar.crawl[1], Y = Presets.TPPFarCar.crawl[2]}), Vector2.new({X = Presets.TPPFarCar.crawl[3], Y = Presets.TPPFarCar.crawl[4]}), Vector2.new({X = Presets.TPPFarCar.crawl[5], Y = Presets.TPPFarCar.crawl[6]}), Presets.TPPFarCar.crawl[7], Presets.TPPFarCar.crawl[8], Presets.TPPFarCar.crawl[9], Presets.TPPFarCar.crawl[10], Presets.TPPFarCar.crawl[11], Presets.TPPFarCar.crawl[12], Presets.TPPFarCar.crawl[13])
    end)

    --TPP Bike
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPBikeEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPBike.full[1], Y = Presets.TPPBike.full[2]}), Vector2.new({X = Presets.TPPBike.full[3], Y = Presets.TPPBike.full[4]}), Vector2.new({X = Presets.TPPBike.full[5], Y = Presets.TPPBike.full[6]}), Presets.TPPBike.full[7], Presets.TPPBike.full[8], Presets.TPPBike.full[9], Presets.TPPBike.full[10], Presets.TPPBike.full[11], Presets.TPPBike.full[12], Presets.TPPBike.full[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPBikeFasterEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPBike.faster[1], Y = Presets.TPPBike.faster[2]}), Vector2.new({X = Presets.TPPBike.faster[3], Y = Presets.TPPBike.faster[4]}), Vector2.new({X = Presets.TPPBike.faster[5], Y = Presets.TPPBike.faster[6]}), Presets.TPPBike.faster[7], Presets.TPPBike.faster[8], Presets.TPPBike.faster[9], Presets.TPPBike.faster[10], Presets.TPPBike.faster[11], Presets.TPPBike.faster[12], Presets.TPPBike.faster[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPBikeSlowEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPBike.slow[1], Y = Presets.TPPBike.slow[2]}), Vector2.new({X = Presets.TPPBike.slow[3], Y = Presets.TPPBike.slow[4]}), Vector2.new({X = Presets.TPPBike.slow[5], Y = Presets.TPPBike.slow[6]}), Presets.TPPBike.slow[7], Presets.TPPBike.slow[8], Presets.TPPBike.slow[9], Presets.TPPBike.slow[10], Presets.TPPBike.slow[11], Presets.TPPBike.slow[12], Presets.TPPBike.slow[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPBikeCrawlEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPBike.crawl[1], Y = Presets.TPPBike.crawl[2]}), Vector2.new({X = Presets.TPPBike.crawl[3], Y = Presets.TPPBike.crawl[4]}), Vector2.new({X = Presets.TPPBike.crawl[5], Y = Presets.TPPBike.crawl[6]}), Presets.TPPBike.crawl[7], Presets.TPPBike.crawl[8], Presets.TPPBike.crawl[9], Presets.TPPBike.crawl[10], Presets.TPPBike.crawl[11], Presets.TPPBike.crawl[12], Presets.TPPBike.crawl[13])
    end)

    --TPPFar Bike
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarBikeEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarBike.full[1], Y = Presets.TPPFarBike.full[2]}), Vector2.new({X = Presets.TPPFarBike.full[3], Y = Presets.TPPFarBike.full[4]}), Vector2.new({X = Presets.TPPFarBike.full[5], Y = Presets.TPPFarBike.full[6]}), Presets.TPPFarBike.full[7], Presets.TPPFarBike.full[8], Presets.TPPFarBike.full[9], Presets.TPPFarBike.full[10], Presets.TPPFarBike.full[11], Presets.TPPFarBike.full[12], Presets.TPPFarBike.full[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarBike.slow[1], Y = Presets.TPPFarBike.slow[2]}), Vector2.new({X = Presets.TPPFarBike.slow[3], Y = Presets.TPPFarBike.slow[4]}), Vector2.new({X = Presets.TPPFarBike.slow[5], Y = Presets.TPPFarBike.slow[6]}), Presets.TPPFarBike.slow[7], Presets.TPPFarBike.slow[8], Presets.TPPFarBike.slow[9], Presets.TPPFarBike.slow[10], Presets.TPPFarBike.slow[11], Presets.TPPFarBike.slow[12], Presets.TPPFarBike.slow[13])
    end)
    Override('IronsightGameController', 'OnFrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent', function(self)
        self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Presets.TPPFarBike.crawl[1], Y = Presets.TPPFarBike.crawl[2]}), Vector2.new({X = Presets.TPPFarBike.crawl[3], Y = Presets.TPPFarBike.crawl[4]}), Vector2.new({X = Presets.TPPFarBike.crawl[5], Y = Presets.TPPFarBike.crawl[6]}), Presets.TPPFarBike.crawl[7], Presets.TPPFarBike.crawl[8], Presets.TPPFarBike.crawl[9], Presets.TPPFarBike.crawl[10], Presets.TPPFarBike.crawl[11], Presets.TPPFarBike.crawl[12], Presets.TPPFarBike.crawl[13])
    end)
end

return Presets