FrameGenGhostingFix = {
  __NAME = "FrameGen Ghosting 'Fix'",
  __EDITION = "V",
  __VERSION = { 5, 0, 0 },
  __VERSION_SUFFIX = nil,
  __VERSION_STATUS = nil,
  __VERSION_STRING = nil,
  __DESCRIPTION = "Limits ghosting when using frame generation in Cyberpunk 2077",
  __LICENSE = [[
    MIT License

    Copyright (c) 2024 gramern (scz_g), danyalzia (omniscient)

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

--necessary modules
local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local LogText = Localization.LogText
local UIText = Localization.UIText

--functional modules
local Calculate = require("Modules/Calculate")
local Contextual = require("Modules/Contextual")
local Presets = require("Modules/Presets")
local Vectors = require("Modules/Vectors")

--optional modules
local Diagnostics = require("Modules/Diagnostics")
local Translate = require("Modules/Translate")
local VectorsCustomize = require("Modules/VectorsCustomize")

--debug
local isDebug
local Debug = require("Dev/Debug")
local TrackerDebug = require("Dev/TrackerDebug")
local VectorsDebug = require("Dev/VectorsDebug")

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
local debugBool, debugToggle
local debugViewBool, debugViewToggle
local helpBool, helpToggle
local keepWindowBool, keepWindowToggle
local fgBool, fgToggle

------------------
-- Global Methods
------------------

--- Returns the version of FrameGen Ghosting 'Fix'.
--
-- @param `asString`: boolean; Whether to return the version as a string.
-- 
-- @return string | table; Version information, updates `FrameGenGhostingFix.__VERSION_STRING` internally.
function FrameGenGhostingFix.GetVersion(asString)
  FrameGenGhostingFix.__VERSION_STRING = table.concat(FrameGenGhostingFix.__VERSION, ".")

  if FrameGenGhostingFix.__VERSION_SUFFIX ~= nil then
    FrameGenGhostingFix.__VERSION_STRING = FrameGenGhostingFix.__VERSION_STRING .. FrameGenGhostingFix.__VERSION_SUFFIX
  end

  if FrameGenGhostingFix.__VERSION_STATUS then
    FrameGenGhostingFix.__VERSION_STRING = FrameGenGhostingFix.__VERSION_STRING .. "-" .. FrameGenGhostingFix.__VERSION_STATUS
  end

  if asString then
    return FrameGenGhostingFix.__VERSION_STRING
  else
    return FrameGenGhostingFix.__VERSION
  end
end

------------------
-- Performance
------------------

function GetFps(deltaTime)
  local floor = math.floor

  currentFpsInt = floor(currentFps)
  currentFrametime = floor((deltaTime * 1000) + 0.5)
  gameDeltaTime = deltaTime

  Tracker.SetGamePerfCurrent(currentFps, gameDeltaTime)

  if openOverlay or Tracker.IsGamePaused() then RestartBenchmark() return end
  if benchmarkRestart then RestartBenchmark() return end
  Benchmark()
end

function Benchmark()
  if not isBenchmark then return end
  if not Tracker.IsGameLoaded() then return end

  local floor = math.floor

  benchmarkTime = benchmarkTime + gameDeltaTime
  countFps = countFps + 1
  averageFps = floor(1 / (benchmarkTime / countFps) + 0.5)
  benchmarkRemainingTime = benchmarkDuration - benchmarkTime

  if benchmarkTime >= benchmarkDuration then
    SetBenchmark(false)

    Tracker.SetGamePerfAverage(averageFps)

    Globals.Print(LogText.benchmark_avgFpsResult, averageFps)

    Calculate.ApplySuggestedSettings(averageFps)

    benchmarkSetSuggested = true

    if not Globals.IsNewInstall() then return end
    Globals.SetNewInstall(false)

    if not Globals.IsFirstRun() then return end
    Globals.SetFirstRun(false)
  end
end

function SetBenchmark(boolean)
  isBenchmark = boolean

  if isBenchmark then
    isBenchmarkFinished = false

    Globals.Print(LogText.benchmark_starting)
    ImGuiExt.SetStatusBar(UIText.Settings.Benchmark.benchmarkEnabled)
    return
  end

  if benchmarkTime >= benchmarkDuration then
    isBenchmarkFinished = true
  end

  benchmarkTime = 0
  benchmarkRemainingTime = benchmarkDuration

  ImGuiExt.SetStatusBar(UIText.Settings.Benchmark.benchmarkFinished)
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

  if openOverlay or Tracker.IsGamePaused() then benchmarkRestartTime = 0 return end

  benchmarkRestartTime = benchmarkRestartTime + gameDeltaTime
  benchmarkRestartRemaining = benchmarkRestartDuration - benchmarkRestartTime

  if benchmarkRestartTime >= benchmarkRestartDuration then
    benchmarkRestart = false
    benchmarkRestartTime = 0
    return
  end
end

function BenchmarkUI()
  ImGuiExt.Text(UIText.Settings.Benchmark.currentFps)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFpsInt))
  ImGuiExt.Text(UIText.Settings.Benchmark.currentFrametime)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFrametime))
  ImGuiExt.Text(UIText.Settings.Benchmark.benchmark)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(isBenchmark))
  ImGuiExt.Text(UIText.Settings.Benchmark.benchmarkRemaining)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(benchmarkRemainingTime))

  if isBenchmarkFinished then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Settings.Benchmark.averageFps)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(averageFps))
  end

  if Tracker.IsGamePaused() then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Settings.Benchmark.benchmarkPause)
  elseif openOverlay then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Settings.Benchmark.benchmarkPauseOverlay)
  else
    if benchmarkRestart then
      ImGui.Text("")
      ImGuiExt.Text(UIText.Settings.Benchmark.benchmarkRestart)
      ImGui.SameLine()
      ImGuiExt.Text(tostring(benchmarkRestartRemaining))
    end
  end
end

------------------
-- Registers
------------------

registerForEvent("onInit", function()
  if not Globals then Globals.Print(LogText.globals_missing) return end
  if not Tracker then Globals.Print(LogText.tracker_missing) return end
  if not Settings then Globals.Print(LogText.settings_missing) return end
  if not ImGuiExt then Globals.Print(LogText.imguiext_missing) return end
  if not Localization then Globals.Print(LogText.localization_missing) return end
  if not Calculate then Globals.Print(LogText.calculate_missing) end
  if not Contextual then Globals.Print(LogText.contextual_missing) end
  if not Presets then Globals.Print(LogText.presets_missing) end
  if not Vectors then Globals.Print(LogText.vectors_missing_missing) end
  if not Translate then Globals.Print(LogText.translate_missing) end

  FrameGenGhostingFix.GetVersion()

  windowTitle = FrameGenGhostingFix.__NAME .. " " .. FrameGenGhostingFix.__EDITION or FrameGenGhostingFix.__NAME

  Globals.OnInitialize()
  Tracker.OnInitialize()
  Settings.OnInitialize()

  if not FrameGenGhostingFix.__VERSION_SUFFIX then
    Diagnostics.OnInitialize()
  else
    Diagnostics = nil
  end

  isDebug = Settings.IsDebugMode()
  Globals.SetDebugMode(isDebug)

  if not Globals.IsModReady() then return end

  Presets.OnInitialize()
  Calculate.OnInitialize()
  Contextual.OnInitialize()
  Vectors.OnInitialize()

  if VectorsCustomize then
    VectorsCustomize.OnInitialize()
  end

  -- danyalzia: remove forced benchmarking upon new install during development
  -- if Globals.IsFirstRun() then
  --   SetBenchmark(true)
  -- end

  -- danyalzia: I am commenting it during development since I don't want to close these windows everytime I launch the game for testing :/
  -- if Debug then
  --   Globals.SetDebugMode(true)
  --   Globals.KeepWindow(true)
  -- end
end)

if Debug then
  registerInput('printPresets', 'Print the presets list', function(keypress)
    if not keypress then
      return
    end

    Presets.PrintPresets()
  end)

  registerInput('toggleMaskingVehicles', 'Toggle masking state for vehicles', function(keypress)
    if not keypress then
      return
    end

    Vectors.ToggleMaskingState()
  end)

  registerInput('printFrameGenMode', 'Print frame generation mode', function(keypress)
    if not keypress then
      return
    end

    local mode = DLSSEnabler_GetFrameGenerationMode()
    
    if mode then
      Globals.Print("Retrieved current Frame Generation Mode:", mode)
    else
      Globals.Print("Failed to retrieve current Frame Generation Mode:", mode)
    end
  end)
end

registerForEvent("onOverlayOpen", function()
  openOverlay = true
  Globals.SetOpenWindow(true)

  isDebug = Settings.IsDebugMode()
  Globals.SetDebugMode(isDebug)

  --translate UIText before other modules access it
  if Translate then
    Translate.SetTranslation("Modules/Localization", "UIText")
    Localization = require("Modules/Localization")
    UIText = Localization.UIText
  end

  Globals.OnOverlayOpen()
  ImGuiExt.OnOverlayOpen()
  Tracker.OnOverlayOpen()

  if Diagnostics then
    Diagnostics.OnOverlayOpen()
  end

  if not Globals.IsModReady() then return end

  Presets.OnOverlayOpen()
  Calculate.OnOverlayOpen()
  Contextual.OnOverlayOpen()
  Vectors.OnOverlayOpen()

  if VectorsCustomize then
    VectorsCustomize.OnOverlayOpen()
  end
end)

registerForEvent("onOverlayClose", function()
  openOverlay = false

  if not Settings.IsKeepWindow() then
    Globals.SetOpenWindow(false)
  end

  Globals.OnOverlayClose()

  if not Globals.IsModReady() then return end

  Calculate.OnOverlayClose()

  if VectorsCustomize then
    VectorsCustomize.OnOverlayClose()
  end

  Settings.OnOverlayClose()
end)

registerForEvent("onUpdate", function(deltaTime)
  Tracker.OnUpdate()

  if Tracker.IsGamePreGame() then return end
  if not Tracker.IsGameLoaded() then return end

  if deltaTime == 0 then return end
  currentFps = 1 / deltaTime
  GetFps(deltaTime)

  if Tracker.IsGamePaused() then return end

  -- Globals.UpdateDelays(gameDeltaTime)

  if not Tracker.IsVehicleMounted() then return end
  Vectors.OnUpdate()
end)

------------------
-- Draw The Window
------------------

registerForEvent("onDraw", function()
  if Globals.IsOpenWindow() then
    ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)

    ImGuiExt.PushStyle()

    if ImGui.Begin(windowTitle, ImGuiWindowFlags.AlwaysAutoResize) then
      if ImGui.BeginTabBar('Tabs') then
        
        --diagnostics interface starts------------------------------------------------------------------------------------------------------------------
        if Diagnostics and Diagnostics.IsUpdateRecommended() then
            Diagnostics.DrawUI()
        end
        --diagnostics interface ends------------------------------------------------------------------------------------------------------------------
        
        --debug interface starts------------------------------------------------------------------------------------------------------------------
        if Debug and Settings.IsDebugMode() and Settings.IsDebugView() then
            Debug.DrawUI()
            TrackerDebug.DrawUI()
            VectorsDebug.DrawUI()
        end
        --debug interface ends------------------------------------------------------------------------------------------------------------------

        if not Tracker.IsGameFrameGeneration() then
          if ImGui.BeginTabItem(UIText.Info.tabname) then

            ImGuiExt.Text("Yo, your FG is turned off, turn it on in the game's settings")

            ImGui.EndTabItem()
          end
        end

        -- danyalzia: remove forced benchmarking upon new install dur ing development
        -- if Globals.IsNewInstall() then
        --   if ImGui.BeginTabItem(UIText.Info.tabname) then

        --     if Globals.IsFirstRun() then
        --       ImGuiExt.Text(UIText.Info.benchmark)
        --     else
        --       ImGuiExt.Text(UIText.Info.benchmarkAsk)
        --     end

        --     ImGui.Text("")
        --     BenchmarkUI()
        --     ImGui.Text("")

        --     keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(UIText.Settings.enabledWindow, Settings.IsKeepWindow(), keepWindowToggle)
        --     if keepWindowToggle then
        --       Settings.SetKeepWindow(keepWindowBool)
        --     end
        --     ImGuiExt.SetTooltip(UIText.Settings.tooltipWindow)

        --     if not Globals.IsFirstRun() and not isBenchmark then
        --       ImGui.Text("")

        --       if ImGui.Button(UIText.General.yes, 240, 40) then
        --         SetBenchmark(true)
        --       end

        --       ImGui.SameLine()

        --       if ImGui.Button(UIText.General.no, 240, 40) then
        --         Globals.SetNewInstall(false)
        --         Settings.SetKeepWindow(false)
        --       end
        --     end
        --     ImGui.EndTabItem()
        --   end
        -- end

        if Globals.IsAspectRatioChange() then
          if ImGui.BeginTabItem(UIText.Info.tabname) then

            ImGuiExt.Text(UIText.Info.aspectRatioChange)

            ImGui.EndTabItem()
          end
        end

        if openOverlay and Globals.IsModReady() then --done on purpose to mitigate possible distress during gameplay caused by some methods

          Presets.DrawUI()
          Calculate.DrawUI()
          Contextual.DrawUI()

        end
        
        --additional options interface starts------------------------------------------------------------------------------------------------------------------
        -- danyalzia: remove forced benchmarking upon new install during development
        -- if not Globals.IsNewInstall() and Globals.IsModReady() then
        if Globals.IsModReady() then
          if ImGui.BeginTabItem(UIText.Settings.tabname) then

            if Debug then
              debugBool, debugToggle = ImGuiExt.Checkbox(UIText.Settings.enabledDebug, Settings.IsDebugMode(), debugToggle)
            end
            if debugToggle then
              Settings.SetDebugMode(debugBool)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end

            if Debug and Settings.IsDebugMode() then
              debugViewBool, debugViewToggle = ImGuiExt.Checkbox(UIText.Settings.enabledDebugView, Settings.IsDebugView(), debugViewToggle)
            end
            if debugViewToggle then
              Settings.SetDebugView(debugViewBool)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end

            keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(UIText.Settings.enabledWindow, Settings.IsKeepWindow(), keepWindowToggle)
            if keepWindowToggle then
              Settings.SetKeepWindow(keepWindowBool)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end
            ImGuiExt.SetTooltip(UIText.Settings.tooltipWindow)

            helpBool, helpToggle = ImGuiExt.Checkbox(UIText.Settings.enabledHelp, Settings.IsHelp(), helpToggle)
            if helpToggle then
              Settings.SetHelp(helpBool)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end
            ImGuiExt.SetTooltip(UIText.Settings.tooltipHelp)

            ImGui.Separator()

            if Tracker.IsGameReady() then
              fgBool, fgToggle = ImGuiExt.Checkbox(UIText.Settings.enableFG, Settings.IsFrameGeneration(), fgToggle)
              if fgToggle then
                Settings.SetFrameGeneration(fgBool)
                ImGuiExt.SetStatusBar(UIText.General.settings_saved)
              end
              ImGuiExt.SetTooltip(UIText.Settings.tooltipFG)
            
              ImGuiExt.Text(UIText.Settings.gameSettingsFG, true)
            else
              ImGuiExt.Text(UIText.Settings.gameNotReadyWarning, true)
            end

            ImGui.Separator()

            if currentFps then
              BenchmarkUI()
              ImGui.Text("")

              if not isBenchmark then
                if ImGui.Button(UIText.Settings.Benchmark.benchmarkRun, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(true)
                  Settings.SetKeepWindow(true)
                end

                ImGuiExt.SetTooltip(UIText.Settings.Benchmark.tooltipRunBench)
              else
                if ImGui.Button(UIText.Settings.Benchmark.benchmarkStop, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(false)
                end
              end

              if isBenchmarkFinished then
                if not benchmarkSetSuggested and ImGui.Button(UIText.Settings.Benchmark.benchmarkSetSuggestedSettings, 480, 40) then
                  SetSuggestedSettings()
                end

                if benchmarkSetSuggested and ImGui.Button(UIText.Settings.Benchmark.benchmarkRevertSettings, 480, 40) then
                  RestorePreviousSettings()

                  ImGuiExt.SetStatusBar(UIText.General.settings_restored)
                  Globals.Print(LogText.settings_restoredCache)
                end
              end

              ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

            end
            ImGui.EndTabItem()
          end
        end
        --additonal options interface ends------------------------------------------------------------------------------------------------------------------
        ImGui.EndTabBar()
      end
    end
    ImGui.End()

    ImGuiExt.PopStyle()
  end
end)

return FrameGenGhostingFix