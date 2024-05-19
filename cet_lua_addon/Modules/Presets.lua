--FrameGen Ghosting Fix 4.1.0

local Presets = {
    selectedPreset = nil,
    selectedPresetPosition = nil,
    presetsFile = {},
    presetsList = {},
    presetsDesc = {},
    presetsAuth = {},
}

local Config = require("Modules/Config")
local Vectors = require("Modules/Vectors")

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
            Presets.selectedPreset = "Default"
            Presets.GetPresetInfo()
        end
        local LoadDefault = Config.Default
        Config.TPPCar = LoadDefault.TPPCar
        Config.TPPFarCar = LoadDefault.TPPFarCar
        Config.FPPCar = LoadDefault.FPPCar
        Config.TPPBike = LoadDefault.TPPBike
        Config.TPPFarBike = LoadDefault.TPPFarBike
        Config.FPPBike = LoadDefault.FPPBike
        Config.MaskingInVehiclesGlobal.enabled = LoadDefault.MaskingInVehiclesGlobal.enabled
        Vectors.VehElements = LoadDefault.Vectors.VehElements
        Vectors.VehMasks.AnchorPoint = LoadDefault.Vectors.VehMasks.AnchorPoint
        Vectors.VehMasks.HorizontalEdgeDown.Size.Base = LoadDefault.Vectors.VehMasks.HorizontalEdgeDown.Size.Base
    else
        presetPath = string.gsub(presetPath, ".lua", "")
        local Preset = require(presetPath)
        if Preset.PresetInfo.name then
            if presetPath then
                Config.TPPCar = Preset.TPPCar
                Config.TPPFarCar = Preset.TPPFarCar
                Config.FPPCar = Preset.FPPCar
                Config.TPPBike = Preset.TPPBike
                Config.TPPFarBike = Preset.TPPFarBike
                Config.FPPBike = Preset.FPPBike
                Config.MaskingInVehiclesGlobal.enabled = Preset.MaskingInVehiclesGlobal.enabled
                Vectors.VehElements = Preset.Vectors.VehElements
                Vectors.VehMasks.AnchorPoint = Preset.Vectors.VehMasks.AnchorPoint
                Vectors.VehMasks.HorizontalEdgeDown.Size.Base = Preset.Vectors.VehMasks.HorizontalEdgeDown.Size.Base
            end
        end
    end
end

--this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, VehMasks.Mask2SetMargin, VehMasks.Mask2SetSize, VehMasks.Mask1Margin, VehMasks.Mask1SetSize, 0.04, 0.07, 0.07, true, true, false);

function Presets.ApplyPreset()
    --TPP Car
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPCarEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPCar.full[1], Config.TPPCar.full[2], Config.TPPCar.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPCarFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPCar.faster[1], Config.TPPCar.faster[2], Config.TPPCar.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPCarSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPCar.slow[1], Config.TPPCar.slow[2], Config.TPPCar.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPCarCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPCar.crawl[1], Config.TPPCar.crawl[2], Config.TPPCar.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)

   --TPPFar Car
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarCarEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarCar.full[1], Config.TPPFarCar.full[2], Config.TPPFarCar.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarCarFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarCar.faster[1], Config.TPPFarCar.faster[2], Config.TPPFarCar.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarCarSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarCar.slow[1], Config.TPPFarCar.slow[2], Config.TPPFarCar.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarCarCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarCar.crawl[1], Config.TPPFarCar.crawl[2], Config.TPPFarCar.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)

   --FPP Car
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPCarEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPCar.full[1], Config.FPPCar.full[2], Config.FPPCar.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPCarFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPCar.faster[1], Config.FPPCar.faster[2], Config.FPPCar.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPCarSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPCar.slow[1], Config.FPPCar.slow[2], Config.FPPCar.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPCarCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPCar.crawl[1], Config.FPPCar.crawl[2], Config.FPPCar.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)

   --TPP Bike
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPBikeEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPBike.full[1], Config.TPPBike.full[2], Config.TPPBike.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPBikeFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPBike.faster[1], Config.TPPBike.faster[2], Config.TPPBike.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPBikeSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPBike.slow[1], Config.TPPBike.slow[2], Config.TPPBike.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPBikeCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPBike.crawl[1], Config.TPPBike.crawl[2], Config.TPPBike.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)

   --TPPFar Bike
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarBikeEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarBike.full[1], Config.TPPFarBike.full[2], Config.TPPFarBike.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarBikeFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarBike.faster[1], Config.TPPFarBike.faster[2], Config.TPPFarBike.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarBikeSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarBike.slow[1], Config.TPPFarBike.slow[2], Config.TPPFarBike.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraTPPFarBikeCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.TPPFarBike.crawl[1], Config.TPPFarBike.crawl[2], Config.TPPFarBike.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)

   --FPP Bike
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPBikeEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPBike.full[1], Config.FPPBike.full[2], Config.FPPBike.full[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPBikeFasterEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPBike.faster[1], Config.FPPBike.faster[2], Config.FPPBike.faster[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPBikeSlowEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPBike.slow[1], Config.FPPBike.slow[2], Config.FPPBike.slow[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
   Override('IronsightGameController', 'OnFrameGenGhostingFixCameraFPPBikeCrawlEvent', function(self)
       self:OnFrameGenGhostingFixVehicleSetTransition(Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Margin.left, Y = Vectors.VehMasks.HorizontalEdgeDown.Margin.top}), Vector2.new({X = Vectors.VehMasks.HorizontalEdgeDown.Size.x, Y = Vectors.VehMasks.HorizontalEdgeDown.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask2.ScreenSpace.x, Y = Vectors.VehMasks.Mask2.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask2.Size.x, Y = Vectors.VehMasks.Mask2.Size.y}), Vector2.new({X = Vectors.VehMasks.Mask1.ScreenSpace.x, Y = Vectors.VehMasks.Mask1.ScreenSpace.y}), Vector2.new({X = Vectors.VehMasks.Mask1.Size.x, Y = Vectors.VehMasks.Mask1.Size.y}), Vector2.new({X = Vectors.VehMasks.AnchorPoint.x, Y = Vectors.VehMasks.AnchorPoint.y}), Config.FPPBike.crawl[1], Config.FPPBike.crawl[2], Config.FPPBike.crawl[3], Vectors.VehMasks.HorizontalEdgeDown.visible, Vectors.VehMasks.Mask2.visible, Vectors.VehMasks.Mask1.visible)
   end)
end

return Presets