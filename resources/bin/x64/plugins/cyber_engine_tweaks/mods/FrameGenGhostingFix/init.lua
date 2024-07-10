local FrameGenGhostingFix = {
  __NAME = "FrameGen Ghosting 'Fix'",
  __VERSION_NUMBER = 490,
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
  GameState = {
    averageFps = 0,
    currentFps = 0,
    isGameLoaded = false,
    isGamePaused = false,
    isPreGame = false,
  }
}

--necessary modules
local Config = require("Modules/Config")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local UI = require("Modules/UI")

local LogText = Localization.LogText
local UIText = Localization.UIText

--optional modules
local Calculate = require("Modules/Calculate")
local Debug = require("Dev/Debug")
local Diagnostics = require("Modules/Diagnostics")
local Translate = require("Modules/Translate")
local Presets = require("Modules/Presets")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

--game performance
local gameDeltaTime = 0
local currentFps = 0
local currentFpsInt = 0
local currentFrametime = 0

--benchmark related
local isBenchmark = false
local isBenchmarkFinished = false
local benchmarkDuration = 30
local benchmarkRemainingTime = benchmarkDuration
local benchmarkRestart = false
local benchmarkRestartDuration = 4
local benchmarkRestartTime = 0
local benchmarkRestartRemaining = benchmarkRestartDuration
local benchmarkSetSuggested = false
local benchmarkTime = 0
local averageFps = 0
local countFps = 0

--ui
local windowTitle
local openOverlay
local keepWindowToggle

function GetGameState()
  local GameState = FrameGenGhostingFix.GameState

  GameState.isGamePaused = Game.GetSystemRequestsHandler():IsGamePaused()
  GameState.isPreGame = Game.GetSystemRequestsHandler():IsPreGame()

  Config.GameState = GameState
end

function IsGameLoaded(isLoaded)
  FrameGenGhostingFix.GameState.isGameLoaded = isLoaded
end

function GetFps(deltaTime)
  local floor = math.floor
  local GameState = FrameGenGhostingFix.GameState

  currentFpsInt = floor(currentFps)
  currentFrametime = floor((deltaTime * 1000) + 0.5)
  gameDeltaTime = deltaTime

  GameState.currentFps = currentFps

  if openOverlay or GameState.isGamePaused then RestartBenchmark() return end
  if benchmarkRestart then RestartBenchmark() return end
  Benchmark()
end

function Benchmark()
  if not isBenchmark then return end
  if not FrameGenGhostingFix.GameState.isGameLoaded then return end

  local floor = math.floor

  benchmarkTime = benchmarkTime + gameDeltaTime
  countFps = countFps + 1
  averageFps = floor(1 / (benchmarkTime / countFps) + 0.5)
  benchmarkRemainingTime = benchmarkDuration - benchmarkTime

  if benchmarkTime >= benchmarkDuration then
    SetBenchmark(false)

    FrameGenGhostingFix.GameState.averageFps = averageFps

    Config.Print(LogText.benchmark_avgFpsResult,averageFps)

    if Calculate then
      Calculate.ApplySuggestedSettings(averageFps)
    end

    benchmarkSetSuggested = true

    if not Config.ModState.isNewInstall then return end
    Settings.SaveFile()
    Config.SetNewInstall(false)

    if not Config.ModState.isFirstRun then return end
    Config.SetFirstRun(false)
  end
end

function SetBenchmark(boolean)
  isBenchmark = boolean

  if isBenchmark then
    isBenchmarkFinished = false

    Config.Print(LogText.benchmark_starting)
    Config.SetStatusBar(UIText.Options.Benchmark.benchmarkEnabled)
    return
  end

  if benchmarkTime >= benchmarkDuration then
    isBenchmarkFinished = true
  end

  benchmarkTime = 0
  benchmarkRemainingTime = benchmarkDuration

  Config.SetStatusBar(UIText.Options.Benchmark.benchmarkFinished)
end

function ResetBenchmarkResults()
  countFps = 0
  averageFps = 0
end

function SetSuggestedSettings()
  if averageFps ~= 0 then
    Calculate.ApplySuggestedSettings(averageFps)
  end

  benchmarkSetSuggested = true
end

function RestorePreviousSettings()
  Calculate.RestoreUserSettings()

  benchmarkSetSuggested = false
end

function RestartBenchmark()
  if not isBenchmark then return end
  benchmarkRestart = true

  if openOverlay or FrameGenGhostingFix.GameState.isGamePaused then benchmarkRestartTime = 0 return end

  benchmarkRestartTime = benchmarkRestartTime + gameDeltaTime
  benchmarkRestartRemaining = benchmarkRestartDuration - benchmarkRestartTime

  if benchmarkRestartTime >= benchmarkRestartDuration then
    benchmarkRestart = false
    benchmarkRestartTime = 0
    return
  end
end

function BenchmarkUI()
  UI.Ext.TextWhite(UIText.Options.Benchmark.currentFps)
  UI.Std.SameLine()
  UI.Ext.TextWhite(tostring(currentFpsInt))
  UI.Ext.TextWhite(UIText.Options.Benchmark.currentFrametime)
  UI.Std.SameLine()
  UI.Ext.TextWhite(tostring(currentFrametime))
  UI.Ext.TextWhite(UIText.Options.Benchmark.benchmark)
  UI.Std.SameLine()
  UI.Ext.TextWhite(tostring(isBenchmark))
  UI.Ext.TextWhite(UIText.Options.Benchmark.benchmarkRemaining)
  UI.Std.SameLine()
  UI.Ext.TextWhite(tostring(benchmarkRemainingTime))

  if isBenchmarkFinished then
    UI.Std.Text("")
    UI.Ext.TextWhite(UIText.Options.Benchmark.averageFps)
    UI.Std.SameLine()
    UI.Ext.TextWhite(tostring(averageFps))
  end

  if FrameGenGhostingFix.GameState.isGamePaused then
    UI.Std.Text("")
    UI.Ext.TextWhite(UIText.Options.Benchmark.benchmarkPause)
  elseif openOverlay then
    UI.Std.Text("")
    UI.Ext.TextWhite(UIText.Options.Benchmark.benchmarkPauseOverlay)
  else
    if benchmarkRestart then
      UI.Std.Text("")
      UI.Ext.TextWhite(UIText.Options.Benchmark.benchmarkRestart)
      UI.Std.SameLine()
      UI.Ext.TextWhite(tostring(benchmarkRestartRemaining))
    end
  end
end

--initialize all stuff etc
registerForEvent("onInit", function()
  if not Config then
    Config.Print(LogText.config_missing)
  return end

  windowTitle = Config and FrameGenGhostingFix.__NAME .. " " .. Config.__EDITION or FrameGenGhostingFix.__NAME

  Config.OnInitialize()

  if not Config.__VERSION_SUFFIX then
    Diagnostics.OnInitialize()
  else
    Diagnostics = nil
  end

  if not Config.ModState.isReady then return end
  if Config.ModState.isFirstRun then SetBenchmark(true) end

  Observe('QuestTrackerGameController', 'OnInitialize', function()
    IsGameLoaded(true)
  end)

  Observe('QuestTrackerGameController', 'OnUninitialize', function()
    IsGameLoaded(false)
  end)

  if Settings then
    Settings.OnInitialize()
  end

  if Presets then
    Presets.OnInitialize()
  end

  if Calculate then
    Calculate.OnInitialize()
  end

  if Vectors then
    Vectors.OnInitialize()

    if VectorsCustomize then
      VectorsCustomize.OnInitialize()
    end
  end

  if Config.ModState.isFirstRun then
    SetBenchmark(true)
  end

  if Debug then
    Config.ModState.enabledDebug = true
    Config.KeepWindow(true)
  end
end)

if Debug then
  registerInput('printPresets', 'Print the presets list', function(keypress)
    if not keypress then
        return
    end

    if Presets then
      Presets.PrintPresets()
    else
      Config.Print("No 'Presets' module available.")
    end
  end)
end

registerForEvent("onOverlayOpen", function()
  openOverlay = true
  Config.OpenWindow(true)

  --translate UIText before other modules access it
  if Translate then
    Translate.SetTranslation("Modules/Localization", "UIText")
    Localization = require("Modules/Localization")
    UIText = Localization.UIText
  end

  Config.OnOverlayOpen()

  if Diagnostics then
    Diagnostics.OnOverlayOpen()
  end

  if Presets then
    Presets.OnOverlayOpen()
  end

  if Calculate then
    Calculate.OnOverlayOpen()
  end

  if Vectors then
    Vectors.OnOverlayOpen()

    if VectorsCustomize then
      VectorsCustomize.OnOverlayOpen()
    end
  end
end)

registerForEvent("onOverlayClose", function()
  openOverlay = false

  if not Config.ModState.keepWindow then
    Config.OpenWindow(false)
  end

  Config.OnOverlayClose()

  if Calculate then
    Calculate.OnOverlayClose()
  end

  if Vectors and VectorsCustomize then
    VectorsCustomize.OnOverlayClose()
  end

  if Settings then
    Settings.OnOverlayClose()
  end
end)

registerForEvent("onUpdate", function(deltaTime)
  GetGameState()

  if FrameGenGhostingFix.GameState.isPreGame then return end
  if not FrameGenGhostingFix.GameState.isGameLoaded then return end

  if deltaTime == 0 then return end
  currentFps = 1 / deltaTime
  GetFps(deltaTime)

  if FrameGenGhostingFix.GameState.isGamePaused then return end

  Vectors.Game.currentFps = currentFps
  Vectors.Game.gameDeltaTime = deltaTime
  Vectors.OnUpdate()
end)

-- draw the mod's window
registerForEvent("onDraw", function()
  if Config.ModState.openWindow then
    UI.Std.SetNextWindowPos(400, 200, UI.Cond.FirstUseEver)

    UI.PushStyle()

    if UI.Std.Begin(windowTitle, UI.WindowFlags.AlwaysAutoResize) then
      if UI.Std.BeginTabBar('Tabs') then
        
        --diagnostics interface starts------------------------------------------------------------------------------------------------------------------
        if Diagnostics and Diagnostics.isUpdateRecommended then
            Diagnostics.DrawUI()
        end
        --diagnostics interface ends------------------------------------------------------------------------------------------------------------------
        
        --debug interface starts------------------------------------------------------------------------------------------------------------------
        if Debug and Config.ModState.enabledDebug then
            Debug.DrawUI()
        end
        --debug interface ends------------------------------------------------------------------------------------------------------------------
        
        if Config.ModState.isNewInstall then
          if UI.Std.BeginTabItem(UIText.Info.tabname) then

            if Config.ModState.isFirstRun then
              UI.Ext.TextWhite(UIText.Info.benchmark)
            else
              UI.Ext.TextWhite(UIText.Info.benchmarkAsk)
            end

            UI.Std.Text("")
            BenchmarkUI()
            UI.Std.Text("")

            Config.ModState.keepWindow, keepWindowToggle = UI.Ext.Checkbox.TextWhite(UIText.Options.enabledWindow, Config.ModState.keepWindow, keepWindowToggle)
            if keepWindowToggle then
              Config.SetStatusBar(UIText.General.settings_saved)
            end
            UI.Ext.OnItemHovered.SetTooltip(UIText.Options.tooltipWindow)

            if not Config.ModState.isFirstRun and not isBenchmark then
              UI.Std.Text("")

              if UI.Std.Button(UIText.General.yes, 240, 40) then
                SetBenchmark(true)
              end

              UI.Std.SameLine()

              if UI.Std.Button(UIText.General.no, 240, 40) then
                Config.SetNewInstall(false)
                Settings.SaveFile()
              end
            end
            UI.Std.EndTabItem()
          end
        end

        if Config.Screen.isAspectRatioChange then
          if UI.Std.BeginTabItem(UIText.Info.tabname) then

            UI.Ext.TextWhite(UIText.Info.aspectRatioChange)

            UI.Std.EndTabItem()
          end
        end

        if openOverlay then --done on purpose to mitigate possible distress during gameplay caused by some methods
          if Presets then
            Presets.DrawUI()
          end

          if Calculate then
            Calculate.DrawUI()
          end
        end
        
        --additional options interface starts------------------------------------------------------------------------------------------------------------------
        if not Config.ModState.isNewInstall then
          if UI.Std.BeginTabItem(UIText.Options.tabname) then

            if Debug then
              Config.ModState.enabledDebug = UI.Ext.Checkbox.TextWhite(UIText.Options.enabledDebug, Config.ModState.enabledDebug)
            end

            Config.ModState.keepWindow, keepWindowToggle = UI.Ext.Checkbox.TextWhite(UIText.Options.enabledWindow, Config.ModState.keepWindow, keepWindowToggle)
            if keepWindowToggle then
              Config.SetStatusBar(UIText.General.settings_saved)
            end
            UI.Ext.OnItemHovered.SetTooltip(UIText.Options.tooltipWindow)

            UI.Std.Separator()

            if currentFps then
              BenchmarkUI()
              UI.Std.Text("")

              if not isBenchmark then
                if UI.Std.Button(UIText.Options.Benchmark.benchmarkRun, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(true)
                  Config.KeepWindow(true)
                end
                UI.Ext.OnItemHovered.SetTooltip(UIText.Options.Benchmark.tooltipRunBench)
              else
                if UI.Std.Button(UIText.Options.Benchmark.benchmarkStop, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(false)
                end
              end

              if isBenchmarkFinished then
                if not benchmarkSetSuggested and UI.Std.Button(UIText.Options.Benchmark.benchmarkSetSuggestedSettings, 480, 40) then
                  SetSuggestedSettings()
                end

                if benchmarkSetSuggested and UI.Std.Button(UIText.Options.Benchmark.benchmarkRevertSettings, 480, 40) then
                  RestorePreviousSettings()

                  Config.SetStatusBar(UIText.General.settings_restored)
                  Config.Print(LogText.settings_restoredCache)
                end
              end

              UI.Ext.StatusBar(Config.GetStatusBar())

            end
            UI.Std.EndTabItem()
          end
        end
        --additonal options interface ends------------------------------------------------------------------------------------------------------------------
        UI.Std.EndTabBar()
      end
    end
    UI.Std.End()

    UI.PopStyle()
  end
end)

return FrameGenGhostingFix