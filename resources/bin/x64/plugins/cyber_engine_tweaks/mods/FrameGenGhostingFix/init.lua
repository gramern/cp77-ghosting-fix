local FrameGenGhostingFix = {
  __NAME= "FrameGen Ghosting 'Fix'",
  __VERSION = "4.8.0",
  __VERSION_NUMBER = 480,
  __VERSION_SUFFIX = "xl",
  __VERSION_STATUS = "alpha5",
  __DESCRIPTION = "Limits ghosting when using frame generation in Cyberpunk 2077",
  __LICENSE = [[
    MIT License

    Copyright (c) 2024 gramern (scz_g)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  ]],
}

--modules
local Calculate = require("Modules/Calculate")
local Config = require("Modules/Config")
local Debug = require("Dev/Debug")
local Diagnostics = require("Modules/Diagnostics")
local Presets = require("Modules/Presets")
local Settings = require("Modules/Settings")
local UIText = require("Modules/UIText")
local Vectors = require("Modules/Vectors")

--scopes
local floor = math.floor
local io = io
local json = json
local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiCond = ImGuiCond
local ImGuiStyleVar = ImGuiStyleVar
local ImGuiWindowFlags = ImGuiWindowFlags

--ui window title
local windowTitle = Config and FrameGenGhostingFix.__NAME .. " " .. Config.__EDITION or FrameGenGhostingFix.__NAME

--masks controller
local masksController = nil
local masksControllerReady = false

--run diagnostics?
local modsCompatibility = true

--is it a first run?
local firstRun = nil
local newInstall = nil

--speaks for itself
local isGamePaused = nil
local isPreGame = nil

--benchmark related
local gameDeltaTime = 0
local currentFps = 0
local currentFpsInt = 0
local currentFrametime = 0
local benchmark = false
local benchmarkDuration = 30
local benchmarkRemainingTime = benchmarkDuration
local benchmarkRestart = false
local benchmarkRestartDuration = 4
local benchmarkRestartTime = 0
local benchmarkRestartRemaining = benchmarkRestartDuration
local benchmarkTime = 0
local averageFps = 0
local countFps = 0

--user settings related
local userSettingsCache = {}
local saved = false
local appliedVeh = false
local appliedOnFoot = false

--default settings
local enabledDebug = false
local enabledWindow = false
local enabledWindshieldSettings = false
local enabledFPPOnFoot = false
local enabledFPPBlockerAimOnFoot = false
local enabledFPPVignetteAimOnFoot = false
local enabledFPPVignetteOnFoot = false
local enabledFPPVignettePermamentOnFoot = false

--ui settings names
local windshieldSettingsEnabled
local windshieldXChanged
local windshieldYChanged
local fppOnFootEnabled
local fppBlockerAimOnFootEnabled
local fppVignetteAimOnFootEnabled
local fppVignetteOnFootEnabled
local fppVignettePermamentOnFootEnabled
local vignetteFootSizeXChanged
local vignetteFootSizeYChanged
local vignetteFootMarginLeftChanged
local vignetteFootMarginTopChanged


function CheckVersion()
  if not Config then print(UIText.General.modname_log,UIText.General.info_config) return end

  if Config.MaskingGlobal.masksController ~= "IronsightGameController" then
    FrameGenGhostingFix.__VERSION_SUFFIX = "xl"
  end

  FrameGenGhostingFix.__VERSION = FrameGenGhostingFix.__VERSION .. FrameGenGhostingFix.__VERSION_SUFFIX .. "-" .. FrameGenGhostingFix.__VERSION_STATUS
end

--set for available modules
function LoadModules()
  if Debug then
    enabledDebug = true
    enabledWindow = true
  return end

  if Diagnostics then
    Diagnostics.CheckModsCompatibility()

    modsCompatibility = Diagnostics.modsCompatibility

    if not modsCompatibility then
      print(UIText.General.modname_log,UIText.General.info_diagnostics)
    end
  end
end

function LoadMasksController()
  if not Config then print(UIText.General.modname_log,UIText.General.info_config) return end

  masksController = Config.MaskingGlobal.masksController

  if Debug then
    Debug.masksController = masksController
  end

  if Presets then
    Presets.masksController = masksController
  end

  if Settings then
    Settings.masksController = masksController
  end

end

function ObserveMasksController()
  if masksController then
    Observe(masksController, 'OnPlayerAttach', function()
      masksControllerReady = true
    end)

    Observe(masksController, 'OnPlayerDetach', function()
      masksControllerReady = false
    end)

    if Debug then
      Debug.masksControllerReady = masksControllerReady
    end

    if Vectors then
      Vectors.VehMasks.masksControllerReady = masksControllerReady
    end
  end
end

function FirstRun()
  firstRun = true
  NewInstall()
  StartBenchmark()
end

function AfterFirstRun()
  firstRun = false
end

function NewInstall()
  newInstall = true
end

function AfterNewInstall()
  newInstall = false
end

function GetGameState()
  isGamePaused = Game.GetSystemRequestsHandler():IsGamePaused()
  isPreGame = Game.GetSystemRequestsHandler():IsPreGame()

  if Debug then
    Debug.isGamePaused = isGamePaused
    Debug.isPreGame = isPreGame
  end

  if Presets then
    Presets.isGamePaused = isGamePaused
    Presets.isPreGame = isPreGame
  end

  if Vectors then
    Vectors.Game.isGamePaused = isGamePaused
    Vectors.Game.isPreGame = isPreGame
  end
end

function GetFps(deltaTime)
  currentFpsInt = floor(currentFps)
  currentFrametime = floor((deltaTime * 1000) + 0.5)
  gameDeltaTime = deltaTime

  Vectors.Game.currentFps = currentFps
  Vectors.Game.gameDeltaTime = deltaTime

  if Debug then
    Debug.currentFps = currentFps
  end

  if not masksControllerReady then return end
  if isGamePaused then RestartBenchmark() return end
  if benchmarkRestart then RestartBenchmark() return end
  Benchmark()
end

function Benchmark()
  if not benchmark then return end
  if not modsCompatibility then return end
  if not masksControllerReady then return end

  benchmarkTime = benchmarkTime + gameDeltaTime
  countFps = countFps + 1
  averageFps = floor(1 / (benchmarkTime / countFps) + 0.5)
  benchmarkRemainingTime = benchmarkDuration - benchmarkTime

  if benchmarkTime >= benchmarkDuration then
    StopBenchmark()
    SetSuggestedSettings()

    if not newInstall then return end
    AfterNewInstall()

    if not firstRun then return end
    SaveUserSettings()
    AfterFirstRun()
  end
end

function StartBenchmark()
  benchmark = true
end

function RestartBenchmark()
  if not benchmark then return end
  benchmarkRestart = true

  if isGamePaused then benchmarkRestartTime = 0 return end

  benchmarkRestartTime = benchmarkRestartTime + gameDeltaTime
  benchmarkRestartRemaining = benchmarkRestartDuration - benchmarkRestartTime

  if benchmarkRestartTime >= benchmarkRestartDuration then
    benchmarkRestart = false
    benchmarkRestartTime = 0
    return
  end
end

function StopBenchmark()
  benchmark = false
  benchmarkRemainingTime = 0
end

function ResetBenchmark()
  benchmarkTime = 0
  countFps = 0
  averageFps = 0
end

function SetSuggestedSettings()
  print(UIText.General.modname_log,UIText.General.settings_benchmarked_1,averageFps)
  print(UIText.General.modname_log,UIText.General.settings_benchmarked_2)

  if averageFps >= 38 then
    enabledFPPOnFoot = true
  end

  if averageFps >= 38 then
    enabledFPPBlockerAimOnFoot = true
  end

  if averageFps >= 52 then
    enabledFPPVignetteOnFoot = true
  end

  if averageFps >= 62 then
    enabledFPPVignettePermamentOnFoot = true
  end

  if Settings then
    Settings.ApplySettings()
  end
end

--set default preset
function SetDefaultPreset()
  table.insert(Presets.presetsList, 1, Config.Default.PresetInfo.name)
  table.insert(Presets.presetsDesc, 1, Config.Default.PresetInfo.description)
  table.insert(Presets.presetsAuth, 1, Config.Default.PresetInfo.author)
end

function SetDefaultPresetFile()
  table.insert(Presets.presetsFile, 1, Config.Default.PresetInfo.file)
end

function SetAnotherDefaultPreset()
  if Calculate.ScreenDetection.screenType == 5 then
    Presets.selectedPreset = "Stronger"
  end
end

--load user settigns
function LoadUserSettings()
  local file = io.open("user_settings.json", "r")
  if file then
    local userSettingsContents = file:read("*a")
    file:close()
    local userSettings = json.decode(userSettingsContents)
    local version = nil
    userSettingsCache = userSettings or {}

    enabledWindshieldSettings = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.enabledWindshield or false
    Vectors.VehMasks.Mask4.Scale.x = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.width or Vectors.VehMasks.Mask4.Scale.x
    Vectors.VehMasks.Mask4.Scale.y = userSettings.FPPBikeWindshield and userSettings.FPPBikeWindshield.height or Vectors.VehMasks.Mask4.Scale.y
  

    enabledFPPOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledOnFoot or false
    enabledFPPBlockerAimOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledBlockerAimOnFoot or false
    enabledFPPVignetteAimOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignetteOnFoot or false
    enabledFPPVignetteOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignetteOnFoot or false
    enabledFPPVignettePermamentOnFoot = userSettings.FPPOnFoot and userSettings.FPPOnFoot.enabledVignettePermamentOnFoot or false
    Calculate.FPPOnFoot.vignetteFootMarginLeft = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootMarginLeft or Calculate.FPPOnFoot.vignetteFootMarginLeft
    Calculate.FPPOnFoot.vignetteFootMarginTop = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootMarginTop or Calculate.FPPOnFoot.vignetteFootMarginTop
    Calculate.FPPOnFoot.vignetteFootSizeX = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootSizeX or Calculate.FPPOnFoot.vignetteFootSizeX
    Calculate.FPPOnFoot.vignetteFootSizeY = userSettings.FPPOnFoot and userSettings.FPPOnFoot.vignetteFootSizeY or Calculate.FPPOnFoot.vignetteFootSizeY

    Presets.selectedPreset = userSettings.Vehicles and userSettings.Vehicles.selectedPreset or Presets.selectedPreset

    version =  userSettings.General and userSettings.General.version or false

    if version ~= FrameGenGhostingFix.__VERSION_NUMBER or not version then
      NewInstall()
    end

    if userSettings then
        print(UIText.General.modname_log, UIText.General.settings_loaded)
    end
  else
    FirstRun()
    SetAnotherDefaultPreset()
    Vectors.SetWindshieldDefault()
    Calculate.SetVignetteDefault()
    print(UIText.General.modname_log,UIText.General.settings_notfound)
    print(UIText.General.modname_log,UIText.General.settings_benchmark_start)
  end
end

function LoadUserSettingsCache()
  enabledWindshieldSettings = userSettingsCache.FPPBikeWindshield and userSettingsCache.FPPBikeWindshield.enabledWindshield or false
  Vectors.VehMasks.Mask4.Scale.x = userSettingsCache.FPPBikeWindshield and userSettingsCache.FPPBikeWindshield.width or Vectors.VehMasks.Mask4.Scale.x
  Vectors.VehMasks.Mask4.Scale.y = userSettingsCache.FPPBikeWindshield and userSettingsCache.FPPBikeWindshield.height or Vectors.VehMasks.Mask4.Scale.y
  
  
  enabledFPPOnFoot = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.enabledOnFoot or false
  enabledFPPBlockerAimOnFoot = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.enabledBlockerAimOnFoot or false
  enabledFPPVignetteAimOnFoot = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.enabledVignetteOnFoot or false
  enabledFPPVignetteOnFoot = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.enabledVignetteOnFoot or false
  enabledFPPVignettePermamentOnFoot = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.enabledVignettePermamentOnFoot or false
  Calculate.FPPOnFoot.vignetteFootMarginLeft = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.vignetteFootMarginLeft or Calculate.FPPOnFoot.vignetteFootMarginLeft
  Calculate.FPPOnFoot.vignetteFootMarginTop = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.vignetteFootMarginTop or Calculate.FPPOnFoot.vignetteFootMarginTop
  Calculate.FPPOnFoot.vignetteFootSizeX = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.vignetteFootSizeX or Calculate.FPPOnFoot.vignetteFootSizeX
  Calculate.FPPOnFoot.vignetteFootSizeY = userSettingsCache.FPPOnFoot and userSettingsCache.FPPOnFoot.vignetteFootSizeY or Calculate.FPPOnFoot.vignetteFootSizeY

  Presets.selectedPreset = userSettingsCache.Vehicles and userSettingsCache.Vehicles.selectedPreset or Presets.selectedPreset

  if userSettingsCache then
    print(UIText.General.modname_log, UIText.General.settings_loaded)
  else
    print(UIText.General.modname_log,UIText.General.settings_notfound)
  end
end

--save user settigns
function SaveUserSettings()
  local userSettings = {
    Vehicles = {
      selectedPreset = Presets.selectedPreset,
    },
    FPPBikeWindshield = {
      enabledWindshield = enabledWindshieldSettings,
      width = Vectors.VehMasks.Mask4.Cache.Scale.x,
      height = Vectors.VehMasks.Mask4.Cache.Scale.y,
    },
    FPPOnFoot = {
      enabledOnFoot = enabledFPPOnFoot,
      enabledBlockerAimOnFoot = enabledFPPBlockerAimOnFoot,
      enabledVignetteAimOnFoot = enabledFPPVignetteAimOnFoot,
      enabledVignetteOnFoot = enabledFPPVignetteOnFoot,
      enabledVignettePermamentOnFoot = enabledFPPVignettePermamentOnFoot,
      vignetteFootMarginLeft = Calculate.FPPOnFoot.vignetteFootMarginLeft,
      vignetteFootMarginTop = Calculate.FPPOnFoot.vignetteFootMarginTop,
      vignetteFootSizeX = Calculate.FPPOnFoot.vignetteFootSizeX,
      vignetteFootSizeY = Calculate.FPPOnFoot.vignetteFootSizeY
    },
    General = {
      version = FrameGenGhostingFix.__VERSION_NUMBER,
    }
  }
  userSettingsCache = userSettings or {}

  local userSettingsContents = json.encode(userSettings)
  local file = io.open("user_settings.json", "w+")

  if file and userSettingsContents ~= nil then
    -- print(userSettingsContents)
    file:write(userSettingsContents)
    file:close()
    print(UIText.General.modname_log,UIText.General.settings_save_path)
  end
end

function UpdateSettings()
  if Settings then
    Settings.enabledFPPOnFoot = enabledFPPOnFoot
    Settings.enabledFPPBlockerAimOnFoot = enabledFPPBlockerAimOnFoot
    Settings.enabledFPPVignetteAimOnFoot = enabledFPPVignetteAimOnFoot
    Settings.enabledFPPVignetteOnFoot = enabledFPPVignetteOnFoot
    Settings.enabledFPPVignettePermamentOnFoot = enabledFPPVignettePermamentOnFoot

    Settings.CheckCrossSetting()

    appliedVeh = Settings.appliedVeh
    appliedOnFoot = Settings.appliedOnFoot
    enabledFPPBlockerAimOnFoot = Settings.enabledFPPBlockerAimOnFoot
    enabledFPPVignetteAimOnFoot = Settings.enabledFPPVignetteAimOnFoot
  end
end

--initialize all stuff etc
registerForEvent("onInit", function()
  CheckVersion()
  LoadModules()
  LoadMasksController()
  ObserveMasksController()
  Calculate.CalcAspectRatio()
  Calculate.GetAspectRatio()
  SetDefaultPreset()
  Presets.ListPresets()
  SetDefaultPresetFile()
  LoadUserSettings()
  Presets.GetPresetInfo()
  Presets.LoadPreset()
  Presets.ApplyPreset()
  Calculate.SetCornersMargins()
  Calculate.SetVignetteOrgMinMax()
  Calculate.SetVignetteOrgSize()
  Calculate.SetMaskingAimSize()
  Calculate.VignettePosX()
  Calculate.VignettePosY()
  Calculate.VignetteX()
  Calculate.VignetteY()
  Calculate.SetHEDSize()
  UpdateSettings()
  Settings.ApplySettings()
end)

registerForEvent("onOverlayOpen", function()
  OverlayEnabled = true
end)

registerForEvent("onOverlayClose", function()
  if not enabledWindow then
    OverlayEnabled = false
  end

  Calculate.CalcAspectRatio()
  Calculate.GetAspectRatio()
  Calculate.SetCornersMargins()
  Calculate.SetVignetteOrgMinMax()
  Calculate.SetVignetteOrgSize()
  Calculate.SetMaskingAimSize()
  Calculate.VignettePosX()
  Calculate.VignettePosY()
  Calculate.VignetteX()
  Calculate.VignetteY()
  Calculate.SetHEDSize()
  Settings.LogResetOnFoot()
  Settings.ApplySettings()
end)

registerForEvent("onUpdate", function(deltaTime)
  if not masksController then return end
  ObserveMasksController()
  GetGameState()
  if isPreGame then return end
  if not masksControllerReady then return end
  if deltaTime == 0 then return end
  currentFps = 1 / deltaTime
  GetFps(deltaTime)
  if isGamePaused then return end
  Vectors.GetCameraData()
  Vectors.GetPlayerData()
  Vectors.ProjectVehicleMasks()
end)

-- draw a ImGui window
registerForEvent("onDraw", function()
  UpdateSettings()

  if OverlayEnabled then
    ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, 300, 100)

    ImGui.PushStyleColor(ImGuiCol.Button, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.CheckMark, 0, 0, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.FrameBgActive, 0.74, 0.58, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.Header, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.HeaderHovered, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.HeaderActive, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.PopupBg, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.ResizeGrip, 0.78, 0.612, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.SliderGrab, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.Tab, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TabHovered, 1, 0.85, 0.31, 1)
    ImGui.PushStyleColor(ImGuiCol.TabActive, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TabUnfocused, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TabUnfocusedActive, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.Text, 0, 0, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TitleBg, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TitleBgActive, 1, 0.78, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, 0.73, 0.56, 0, 1)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0, 0, 0, 0.75)

    if ImGui.Begin(windowTitle, ImGuiWindowFlags.AlwaysAutoResize) then
      if ImGui.BeginTabBar('Tabs') then
        --diagnostics interface starts------------------------------------------------------------------------------------------------------------------
        if Diagnostics and Diagnostics.updateinfo then
            Diagnostics.DiagnosticsUI()
        end
        --diagnostics interface ends------------------------------------------------------------------------------------------------------------------
        --debug interface starts------------------------------------------------------------------------------------------------------------------
        if Debug and enabledDebug then
            Debug.DebugUI()
        end
        --debug interface ends------------------------------------------------------------------------------------------------------------------
        if newInstall then
          if ImGui.BeginTabItem(UIText.Info.tabname) then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
            if firstRun then
              ImGui.Text(UIText.Info.benchmark)
            else
              ImGui.Text(UIText.Info.benchmarkAsk)
            end
            if isGamePaused then
              ImGui.Text("")
              ImGui.Text(UIText.Options.Benchmark.benchmarkPause)
            else
              if benchmarkRestart then
                ImGui.Text("")
                ImGui.Text(UIText.Options.Benchmark.benchmarkRestart)
                ImGui.SameLine()
                ImGui.Text(tostring(benchmarkRestartRemaining))
              else
                if not isPreGame then
                  ImGui.Text("")
                  ImGui.Text(UIText.Options.Benchmark.currentFps)
                  ImGui.SameLine()
                  ImGui.Text(tostring(currentFpsInt))
                  ImGui.Text(UIText.Options.Benchmark.currentFrametime)
                  ImGui.SameLine()
                  ImGui.Text(tostring(currentFrametime))
                end
              end
            end
            ImGui.Text("")
            ImGui.Text(UIText.Info.benchmarkRemaining)
            ImGui.SameLine()
            ImGui.Text(tostring(benchmarkRemainingTime))
            ImGui.PopStyleColor()
            if not firstRun and not benchmark then
              ImGui.Text("")
              if ImGui.Button(UIText.General.yes, 240, 40) then
                StartBenchmark()
              end
              ImGui.SameLine()
              if ImGui.Button(UIText.General.no, 240, 40) then
                AfterNewInstall()
                SaveUserSettings()
              end
            end
            ImGui.EndTabItem()
          end
        end
        if ImGui.BeginTabItem(UIText.Vehicles.tabname) then
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.1
          ImGui.Text(UIText.General.title_general)
          ImGui.Separator()
          ImGui.Text(UIText.Vehicles.MaskingPresets.name)
          ImGui.PopStyleColor() --PSC.1
          if Presets.selectedPresetPosition == nil then
            Presets.GetPresetInfo()
          end
          if ImGui.BeginCombo("##", Presets.selectedPreset) then
            for _, preset in ipairs(Presets.presetsList) do
              local preset_selected = (Presets.selectedPreset == preset)
              if ImGui.Selectable(preset, preset_selected) then
                Presets.selectedPreset = preset
                Presets.GetPresetInfo()
              end
              if preset_selected then
                ImGui.SetItemDefaultFocus()
                Settings.LogResetVehicles()
              end
            end
            ImGui.EndCombo()
          end
          if ImGui.IsItemHovered() then
            ImGui.SetTooltip(UIText.Vehicles.MaskingPresets.tooltip)
          else
            ImGui.SetTooltip(nil)
          end
          ImGui.SameLine()
          if ImGui.Button(UIText.General.settings_apply) then
            SaveUserSettings()
            Presets.LoadPreset()
            Presets.ApplyPreset()
            Settings.LogApplyVehicles()
          end
          ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.2
          if Presets.selectedPresetPosition then
            if Presets.presetsDesc[Presets.selectedPresetPosition] then
              ImGui.Text("Preset's info:")
              ImGui.Text(Presets.presetsDesc[Presets.selectedPresetPosition])
            end
            if Presets.presetsAuth[Presets.selectedPresetPosition] then
              ImGui.Text("Preset's author:")
              ImGui.SameLine()
              ImGui.Text(Presets.presetsAuth[Presets.selectedPresetPosition])
            end
          end
          ImGui.PopStyleColor() --PSC.2
          if appliedVeh then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.3
            ImGui.Text("")
            ImGui.Text(UIText.General.settings_applied_veh)
            ImGui.PopStyleColor() --PSC.3
          end
          if Config.MaskingGlobal.enabled then
            --additional settings interface starts------------------------------------------------------------------------------------------------------------------
            if Settings then
              ImGui.Text("")
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.4
              ImGui.Text(UIText.General.title_fps90)
              ImGui.Separator()
              enabledWindshieldSettings, windshieldSettingsEnabled = ImGui.Checkbox(UIText.Vehicles.Windshield.name, enabledWindshieldSettings)
              if windshieldSettingsEnabled then
                Vectors.ReadCache()
                SaveUserSettings()
              end
              ImGui.PopStyleColor() --PSC.4
              if ImGui.IsItemHovered() then
                ImGui.SetTooltip(UIText.Vehicles.Windshield.tooltip)
              else
                ImGui.SetTooltip(nil)
              end
              if enabledWindshieldSettings then
                if Vectors.Vehicle.currentSpeed ~= nil and Vectors.Vehicle.currentSpeed < 1 and Vectors.Vehicle.vehicleBaseObject == 0 and Vectors.Vehicle.activePerspective == vehicleCameraPerspective.FPP then
                  ImGui.Text("")
                  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.5
                  ImGui.Text(UIText.Vehicles.Windshield.textfield_1)
                  ImGui.Text("")
                  ImGui.Text(UIText.Vehicles.Windshield.setting_1)
                  ImGui.PopStyleColor() --PSC.5
                  Vectors.VehMasks.Mask4.Scale.x, windshieldXChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_1,Vectors.VehMasks.Mask4.Scale.x, 70, 150, "%.0f")
                    if windshieldXChanged then
                      saved = false
                      Settings.TurnOnLiveViewWindshieldEditor()
                    end
                  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.6
                  ImGui.Text(UIText.Vehicles.Windshield.setting_2)
                  ImGui.PopStyleColor() --PSC.6
                  Vectors.VehMasks.Mask4.Scale.y, windshieldYChanged = ImGui.SliderFloat(UIText.Vehicles.Windshield.comment_2,Vectors.VehMasks.Mask4.Scale.y, 70, 300, "%.0f")
                    if windshieldYChanged then
                      saved = false
                      Settings.TurnOnLiveViewWindshieldEditor()
                    end
                  ImGui.Text("")
                  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.7
                  if saved == true then
                    ImGui.Text(UIText.General.settings_saved)
                  end
                  ImGui.PopStyleColor() --PSC.7
                  if ImGui.Button(UIText.General.settings_default, 240, 40) then
                    saved = false
                    Vectors.SetWindshieldDefault()
                    Settings.DefaultLiveViewWindshieldEditor()
                  end
                  ImGui.SameLine()
                  if ImGui.Button(UIText.General.settings_save, 240, 40) then
                    saved = true
                    Vectors.SaveCache()
                    SaveUserSettings()
                  end
                else
                  ImGui.Text("")
                  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.8
                  ImGui.Text(UIText.Vehicles.Windshield.warning)
                  ImGui.Text("")
                  ImGui.PopStyleColor() --PSC.8
                end
              else
                Vectors.SetWindshieldDefault()
              end
            end
          end
          ImGui.EndTabItem()
        end
        if Settings then
          if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.9
            ImGui.Text(UIText.General.title_general)
            ImGui.Separator()
            enabledFPPOnFoot, fppOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BottomCornersMasks.name, enabledFPPOnFoot)
            if fppOnFootEnabled then
              SaveUserSettings()
              Settings.LogApplyOnFoot()
            end
            ImGui.PopStyleColor()--PSC.9
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
            if not enabledFPPVignetteAimOnFoot then
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.10
              enabledFPPBlockerAimOnFoot, fppBlockerAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.BlockerAim.name, enabledFPPBlockerAimOnFoot)
              if fppBlockerAimOnFootEnabled then
                enabledFPPVignetteAimOnFoot = false
                SaveUserSettings()
                Settings.LogApplyOnFoot()
              end
              ImGui.PopStyleColor() --PSC.10
              if ImGui.IsItemHovered() then
                ImGui.SetTooltip(UIText.OnFoot.BlockerAim.tooltip)
              else
                ImGui.SetTooltip(nil)
              end
            else
              ImGui.Separator()
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.11
              ImGui.Text(UIText.General.info_aim_onfoot)
              ImGui.PopStyleColor() --PSC.11
              ImGui.Separator()
            end
            ImGui.Text("")
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.12
            ImGui.Text(UIText.General.title_fps120)
            ImGui.Separator()
            ImGui.PopStyleColor() --PSC.12
            if not enabledFPPBlockerAimOnFoot then
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.13
              enabledFPPVignetteAimOnFoot, fppVignetteAimOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignetteAim.name, enabledFPPVignetteAimOnFoot)
              if fppVignetteAimOnFootEnabled then
                enabledFPPBlockerAimOnFoot = false
                SaveUserSettings()
                Settings.LogApplyOnFoot()
              end
              ImGui.PopStyleColor() --PSC.13
              if ImGui.IsItemHovered() then
                ImGui.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)
              else
                ImGui.SetTooltip(nil)
              end
            else
              ImGui.Separator()
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.14
              ImGui.Text(UIText.General.info_aim_onfoot)
              ImGui.PopStyleColor() --PSC.14
              ImGui.Separator()
            end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.15
            enabledFPPVignetteOnFoot, fppVignetteOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.Vignette.name, enabledFPPVignetteOnFoot)
            if fppVignetteOnFootEnabled then
              SaveUserSettings()
              Settings.LogApplyOnFoot()
            end
            ImGui.PopStyleColor() --PSC.15
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.OnFoot.Vignette.tooltip)
            else
              ImGui.SetTooltip(nil)
            end
            if enabledFPPVignetteOnFoot then
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.16
              enabledFPPVignettePermamentOnFoot, fppVignettePermamentOnFootEnabled = ImGui.Checkbox(UIText.OnFoot.VignettePermament.name, enabledFPPVignettePermamentOnFoot)
              if fppVignettePermamentOnFootEnabled then
                SaveUserSettings()
                Settings.LogApplyOnFoot()
              end
              ImGui.PopStyleColor() --PSC.16
              if ImGui.IsItemHovered() then
                ImGui.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)
              else
                ImGui.SetTooltip(nil)
              end
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.17
              if enabledFPPVignetteAimOnFoot and enabledFPPVignetteOnFoot then
                ImGui.Text("")
                ImGui.Text(UIText.OnFoot.VignetteAim.textfield_1)
              end
              ImGui.Text("")
              ImGui.Text(UIText.OnFoot.Vignette.textfield_1)
              ImGui.Text("")
              ImGui.Text(UIText.OnFoot.Vignette.setting_1)
              ImGui.PopStyleColor() --PSC.17
              Calculate.FPPOnFoot.vignetteFootSizeX, vignetteFootSizeXChanged = ImGui.SliderFloat("X size",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeX, "%.0f")
                if vignetteFootSizeXChanged then
                  Calculate.VignetteCalcMarginX()
                  Calculate.VignetteX()
                  saved = false
                  Settings.TurnOnLiveViewVignetteOnFootEditor()
                end
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.18
              ImGui.Text(UIText.OnFoot.Vignette.setting_2)
              ImGui.PopStyleColor() --PSC.18
              Calculate.FPPOnFoot.vignetteFootSizeY, vignetteFootSizeYChanged = ImGui.SliderFloat("Y size",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxSizeY, "%.0f")
                if vignetteFootSizeYChanged then
                  Calculate.VignetteCalcMarginY()
                  Calculate.VignetteY()
                  saved = false
                  Settings.TurnOnLiveViewVignetteOnFootEditor()
                end
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.19
              ImGui.Text(UIText.OnFoot.Vignette.setting_3)
              ImGui.PopStyleColor() --PSC.19
              Calculate.FPPOnFoot.vignetteFootMarginLeft, vignetteFootMarginLeftChanged = ImGui.SliderFloat("X pos.",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX, "%.0f")
                if vignetteFootMarginLeftChanged then
                  Calculate.VignetteCalcMarginX()
                  Calculate.VignettePosX()
                  saved = false
                  Settings.TurnOnLiveViewVignetteOnFootEditor()
                end
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.20
              ImGui.Text(UIText.OnFoot.Vignette.setting_4)
              ImGui.PopStyleColor() --PSC.20
              Calculate.FPPOnFoot.vignetteFootMarginTop, vignetteFootMarginTopChanged = ImGui.SliderFloat("Y pos.",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY, Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY, "%.0f")
                if vignetteFootMarginTopChanged then
                  Calculate.VignetteCalcMarginY()
                  Calculate.VignettePosY()
                  saved = false
                  Settings.TurnOnLiveViewVignetteOnFootEditor()
                end
              ImGui.Text("")
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.21
              if saved == true then
                ImGui.Text(UIText.General.settings_saved)
              end
              ImGui.PopStyleColor() --PSC.21
              if ImGui.Button(UIText.General.settings_default, 240, 40) then
                saved = false
                Calculate.SetVignetteDefault()
                Settings.TurnOnLiveViewVignetteOnFootEditor()
              end
              ImGui.SameLine()
              if ImGui.Button(UIText.General.settings_save, 240, 40) then
                saved = true
                SaveUserSettings()
                Settings.LogApplyOnFoot()
              end
            else
              enabledFPPVignettePermamentOnFoot = false
            end
            if appliedOnFoot then
              ImGui.Separator()
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1) --PSC.22
              ImGui.Text(UIText.General.settings_saved_onfoot)
              ImGui.PopStyleColor() --PSC.22
            end
            ImGui.EndTabItem()
          end
        end
        --additional settings interface ends------------------------------------------------------------------------------------------------------------------
        --advanced options interface starts------------------------------------------------------------------------------------------------------------------
        if not newInstall then
          if ImGui.BeginTabItem(UIText.Options.tabname) then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
            if Debug then
              enabledDebug = ImGui.Checkbox(UIText.Options.enabledDebug, enabledDebug)
            end
            enabledWindow = ImGui.Checkbox(UIText.Options.enabledWindow, enabledWindow)
            ImGui.PopStyleColor()
            if ImGui.IsItemHovered() then
              ImGui.SetTooltip(UIText.Options.tooltipWindow)
            else
              ImGui.SetTooltip(nil)
            end
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
            if currentFps then
              ImGui.Separator()
              ImGui.Text(UIText.Options.Benchmark.currentFps)
              ImGui.SameLine()
              ImGui.Text(tostring(currentFpsInt))
              ImGui.Text(UIText.Options.Benchmark.currentFrametime)
              ImGui.SameLine()
              ImGui.Text(tostring(currentFrametime))
              ImGui.Text(UIText.Options.Benchmark.benchmark)
              ImGui.SameLine()
              ImGui.Text(tostring(benchmark))
              ImGui.Text(UIText.Options.Benchmark.benchmarkTime)
              ImGui.SameLine()
              ImGui.Text(tostring(benchmarkRemainingTime))
              if benchmarkTime >= benchmarkDuration then
                ImGui.Text(UIText.Options.Benchmark.averageFps)
                ImGui.SameLine()
                ImGui.Text(tostring(averageFps))
              end
              ImGui.Text("")
              if isGamePaused then
                ImGui.Text(UIText.Options.Benchmark.benchmarkPause)
                ImGui.Text("")
              else
                if benchmarkRestart then
                  ImGui.Text(UIText.Options.Benchmark.benchmarkRestart)
                  ImGui.SameLine()
                  ImGui.Text(tostring(benchmarkRestartRemaining))
                  ImGui.Text("")
                end
              end
              ImGui.PopStyleColor()
              if not benchmark then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkRun, 490, 40) then
                  ResetBenchmark()
                  StartBenchmark()
                end
                if ImGui.IsItemHovered() then
                  ImGui.SetTooltip(UIText.Options.Benchmark.tooltipRunBench)
                else
                  ImGui.SetTooltip(nil)
                end
              end
              if benchmark then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkStop, 490, 40) then
                  benchmark = false
                end
              end
              if benchmarkTime >= benchmarkDuration then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkRevertSettings, 240, 40) then
                  LoadUserSettingsCache()
                  Settings.ApplySettings()
                end
                ImGui.SameLine()
                if not saved then
                  if ImGui.Button(UIText.Options.Benchmark.benchmarkSaveSettings, 240, 40) then
                    saved = true
                    SaveUserSettings()
                  end
                end
              end
              ImGui.Separator()
              ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
              if FrameGenGhostingFix.__VERSION then
                ImGui.Text(UIText.General.info_version)
                ImGui.SameLine()
                ImGui.Text(FrameGenGhostingFix.__VERSION)
              end
              ImGui.PopStyleColor()
            end
            ImGui.EndTabItem()
          end
        end
        --advanced options interface ends------------------------------------------------------------------------------------------------------------------
        ImGui.EndTabBar()
      end
    end
    ImGui.End()
    ImGui.PopStyleColor(26)
    ImGui.PopStyleVar(1)
  end
end)

return FrameGenGhostingFix