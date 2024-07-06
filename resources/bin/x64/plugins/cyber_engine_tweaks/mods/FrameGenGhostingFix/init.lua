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

local LogText = Localization.LogText
local UIText = Localization.UIText

--optional modules
local Calculate = require("Modules/Calculate")
local Debug = require("Dev/Debug")
local Diagnostics = require("Modules/Diagnostics")
local Translate = require("Modules/Translate")
local Presets = require("Modules/Presets")
local Settings = require("Modules/Settings")
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
local benchmarkDuration = 5
local benchmarkRemainingTime = benchmarkDuration
local benchmarkRestart = false
local benchmarkRestartDuration = 4
local benchmarkRestartTime = 0
local benchmarkRestartRemaining = benchmarkRestartDuration
local benchmarkTime = 0
local averageFps = 0
local countFps = 0

--ui
local windowTitle
local openOverlay
local openWindow
local keepWindowToggle

--ImGui scopes
local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiCond = ImGuiCond
local ImGuiStyleVar = ImGuiStyleVar
local ImGuiWindowFlags = ImGuiWindowFlags
local ImGuiExt = {

  Checkbox = {
    TextWhite = function(string, setting, toggle)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      setting, toggle = ImGui.Checkbox(string, setting)
      ImGui.PopStyleColor()

      return setting, toggle
    end,
  },

  OnItemHovered = {
    SetTooltip = function(string)
      if ImGui.IsItemHovered() then
        ImGui.SetTooltip(string)
      else
        ImGui.SetTooltip(nil)
      end
    end,
  },

  TextRed = function(string)
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
    ImGui.Text(string)
    ImGui.PopStyleColor()
  end,

  TextWhite = function(string)
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
    ImGui.Text(string)
    ImGui.PopStyleColor()
  end,
}

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

  if GameState.isGamePaused then RestartBenchmark() return end
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

    if not Config.ModState.isNewInstall then return end
    FrameGenGhostingFix.SetNewInstall(false)

    if not Config.ModState.isFirstRun then return end
    FrameGenGhostingFix.SetFirstRun(false)
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

function RestartBenchmark()
  if not isBenchmark then return end
  benchmarkRestart = true

  if FrameGenGhostingFix.GameState.isGamePaused then benchmarkRestartTime = 0 return end

  benchmarkRestartTime = benchmarkRestartTime + gameDeltaTime
  benchmarkRestartRemaining = benchmarkRestartDuration - benchmarkRestartTime

  if benchmarkRestartTime >= benchmarkRestartDuration then
    benchmarkRestart = false
    benchmarkRestartTime = 0
    return
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

  Observe('QuestTrackerGameController', 'OnInitialize', function()
    IsGameLoaded(true)
  end)

  Observe('QuestTrackerGameController', 'OnUninitialize', function()
    IsGameLoaded(false)
  end)

  -- if Settings then
  --   Settings.OnInitialize()
  -- end

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
    Config.ModState.keepWindow = true
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
  openWindow = true
  Config.ModState.openWindow = true

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
    openWindow = false
    Config.ModState.openWindow = false
  end

  Config.OnOverlayClose()

  if Calculate then
    Calculate.OnOverlayClose()
  end

  if Vectors and VectorsCustomize then
    VectorsCustomize.OnOverlayClose()
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

-- draw a ImGui window
registerForEvent("onDraw", function()
  if openWindow then
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
          if ImGui.BeginTabItem(UIText.Info.tabname) then

            if Config.ModState.isFirstRun then
              ImGuiExt.TextWhite(UIText.Info.benchmark)
            else
              ImGuiExt.TextWhite(UIText.Info.benchmarkAsk)
            end
            if FrameGenGhostingFix.GameState.isGamePaused then
              ImGui.Text("")
              ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkPause)
            else
              if benchmarkRestart then
                ImGui.Text("")
                ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkRestart)
                ImGui.SameLine()
                ImGuiExt.TextWhite(tostring(benchmarkRestartRemaining))
              else
                if not FrameGenGhostingFix.GameState.isPreGame then
                  ImGui.Text("")
                  ImGuiExt.TextWhite(UIText.Options.Benchmark.currentFps)
                  ImGui.SameLine()
                  ImGuiExt.TextWhite(tostring(currentFpsInt))
                  ImGuiExt.TextWhite(UIText.Options.Benchmark.currentFrametime)
                  ImGui.SameLine()
                  ImGuiExt.TextWhite(tostring(currentFrametime))
                end
              end
            end
            ImGui.Text("")
            ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkRemaining)
            ImGui.SameLine()
            ImGuiExt.TextWhite(tostring(benchmarkRemainingTime))

            if not Config.ModState.isFirstRun and not isBenchmark then
              ImGui.Text("")
              if ImGui.Button(UIText.General.yes, 240, 40) then
                SetBenchmark(true)
              end
              ImGui.SameLine()
              if ImGui.Button(UIText.General.no, 240, 40) then
                Config.SetNewInstall(false)
                Config.SaveUserSettings()
              end
            end
            ImGui.EndTabItem()
          end
        end
        if Config.Screen.isAspectRatioChange then
          if ImGui.BeginTabItem(UIText.Info.tabname) then

            ImGuiExt.TextWhite(UIText.Info.aspectRatioChange)

            ImGui.EndTabItem()
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
          if ImGui.BeginTabItem(UIText.Options.tabname) then

            if Debug then
              Config.ModState.enabledDebug = ImGuiExt.Checkbox.TextWhite(UIText.Options.enabledDebug, Config.ModState.enabledDebug)
            end

            Config.ModState.keepWindow, keepWindowToggle = ImGuiExt.Checkbox.TextWhite(UIText.Options.enabledWindow, Config.ModState.keepWindow, keepWindowToggle)
            if keepWindowToggle then
              Config.SaveUserSettings()

              Config.SetStatusBar(UIText.General.settings_saved)
            end
            ImGuiExt.OnItemHovered.SetTooltip(UIText.Options.tooltipWindow)

            if currentFps then
              ImGui.Separator()
              ImGuiExt.TextWhite(UIText.Options.Benchmark.currentFps)
              ImGui.SameLine()
              ImGuiExt.TextWhite(tostring(currentFpsInt))
              ImGuiExt.TextWhite(UIText.Options.Benchmark.currentFrametime)
              ImGui.SameLine()
              ImGuiExt.TextWhite(tostring(currentFrametime))
              ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmark)
              ImGui.SameLine()
              ImGuiExt.TextWhite(tostring(isBenchmark))
              ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkRemaining)
              ImGui.SameLine()
              ImGuiExt.TextWhite(tostring(benchmarkRemainingTime))

              if isBenchmarkFinished then
                ImGuiExt.TextWhite(UIText.Options.Benchmark.averageFps)
                ImGui.SameLine()
                ImGuiExt.TextWhite(tostring(averageFps))
              end

              ImGui.Text("")

              if FrameGenGhostingFix.GameState.isGamePaused then
                ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkPause)
                ImGui.Text("")
              else
                if benchmarkRestart then
                  ImGuiExt.TextWhite(UIText.Options.Benchmark.benchmarkRestart)
                  ImGui.SameLine()
                  ImGuiExt.TextWhite(tostring(benchmarkRestartRemaining))
                  ImGui.Text("")
                end
              end
              if not isBenchmark then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkRun, 490, 40) then
                  -- saved = false
                  ResetBenchmarkResults()
                  SetBenchmark(true)
                end
                if ImGui.IsItemHovered() then
                  ImGui.SetTooltip(UIText.Options.Benchmark.tooltipRunBench)
                else
                  ImGui.SetTooltip(nil)
                end
              end

              if isBenchmark then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkStop, 490, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(false)
                end
              end

              if isBenchmarkFinished then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkRevertSettings, 240, 40) then
                  Calculate.RestoreUserSettings()

                  Config.SetStatusBar(UIText.General.settings_restored)
                  Config.Print(LogText.settings_restoredCache)
                end
                ImGui.SameLine()
                -- if not saved then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkSaveSettings, 240, 40) then
                  -- saved = true
                  Config.SaveUserSettings()

                  Config.SetStatusBar(UIText.General.settings_saved)
                end
                -- end
              end

              ImGui.Separator()

              ImGuiExt.TextWhite(Config.GetStatusBar())

            end
            ImGui.EndTabItem()
          end
        end
        --additonal options interface ends------------------------------------------------------------------------------------------------------------------
        ImGui.EndTabBar()
      end
    end
    ImGui.End()
    ImGui.PopStyleColor(26)
    ImGui.PopStyleVar(1)
  end
end)

return FrameGenGhostingFix