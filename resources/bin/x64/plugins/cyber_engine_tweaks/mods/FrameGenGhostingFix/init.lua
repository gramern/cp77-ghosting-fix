FrameGenGhostingFix = {
  __NAME = "FrameGen Ghosting 'Fix'",
  __EDITION = "V",
  __VERSION = { 5, 0, 0 },
  __VERSION_SUFFIX = nil,
  __VERSION_STATUS = "alpha",
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

--functional modules
local Calculate = require("Modules/Calculate")
local Contextual = require("Modules/Contextual")
local VectorsPresets = require("Modules/VectorsPresets")
local Vectors = require("Modules/Vectors")

--optional modules
local Diagnostics = require("Modules/Diagnostics")
local VectorsCustomize = require("Modules/VectorsCustomize")

--localization tables
local LogText = Localization.GetLogText()
local BenchmarkText = Localization.GetBenchmarkText()
local GeneralText = Localization.GetGeneralText()
local InfoText = Localization.GetInfoText()
local SettingsText = Localization.GetSettingsText()

--debug
local isDebug
local Debug = require("Dev/Debug")
local TrackerDebug = require("Dev/TrackerDebug")
local VectorsDebug = require("Dev/VectorsDebug")

--math
local huge, floor = math.huge, math.floor

--game performance
local gameDeltaTime = 0
local currentFps = 0
local currentFpsInt = 0
local currentFrametimeInt = 0
local currentCycle = 1 / 2
local currentCount = 0
local currentFpsSum = 0
local currentDeltaTimeSum = 0


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
-- Benchmark
------------------

local function SetBenchmark(boolean)
  isBenchmark = boolean

  if isBenchmark then
    isBenchmarkFinished = false

    Globals.Print(LogText.benchmark_starting)
    ImGuiExt.SetStatusBar(BenchmarkText.benchmarkEnabled)
    return
  end

  if benchmarkTime >= benchmarkDuration then
    isBenchmarkFinished = true
  end

  benchmarkTime = 0
  benchmarkRemainingTime = benchmarkDuration

  ImGuiExt.SetStatusBar(BenchmarkText.benchmarkFinished)
end

local function ResetBenchmarkResults()
  countFps = 0
  averageFps = 0
end

local function RestartBenchmark()
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

local function Benchmark()
  if not isBenchmark then return end
  if not Tracker.IsGameLoaded() then return end

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

    if not Tracker.IsModNewInstall() then return end
    Tracker.SetModNewInstall(false)

    if not Tracker.IsModFirstRun() then return end
    Tracker.SetModFirstRun(false)
  end
end

local function SetSuggestedSettings()
  if averageFps ~= 0 then
    Calculate.ApplySuggestedSettings(averageFps)
  end

  benchmarkSetSuggested = true
end

local function RestorePreviousSettings()
  Calculate.RestoreUserSettings()

  benchmarkSetSuggested = false
end

function BenchmarkUI()
  ImGuiExt.Text(BenchmarkText.currentFps)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFpsInt))
  ImGuiExt.Text(BenchmarkText.currentFrametime)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFrametimeInt))
  if openOverlay or isBenchmark then
    ImGuiExt.Text(BenchmarkText.benchmark)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(isBenchmark))
    ImGuiExt.Text(BenchmarkText.benchmarkRemaining)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(benchmarkRemainingTime))
  end

  if isBenchmarkFinished and openOverlay then
    ImGui.Text("")
    ImGuiExt.Text(BenchmarkText.averageFps)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(averageFps))
  end

  if Tracker.IsGamePaused() or Tracker.IsGamePreGame() then
    ImGui.Text("")
    ImGuiExt.Text(BenchmarkText.benchmarkPause, true)
  elseif openOverlay then
    ImGui.Text("")
    ImGuiExt.Text(BenchmarkText.benchmarkPauseOverlay, true)
  else
    if benchmarkRestart then
      ImGui.Text("")
      ImGuiExt.Text(BenchmarkText.benchmarkRestart)
      ImGui.SameLine()
      ImGuiExt.Text(tostring(benchmarkRestartRemaining))
    end
  end
end

------------------
-- Performance
------------------

local function MonitorFps(deltaTime)
  currentCycle = currentCycle - deltaTime
  currentCount = currentCount + 1
  currentFpsSum = currentFpsSum + currentFps
  currentDeltaTimeSum = currentDeltaTimeSum + (deltaTime * 1000)

  if currentCycle <= 0 then
    currentFpsInt = floor(currentFpsSum / currentCount + 0.5)
    currentFrametimeInt = floor(currentDeltaTimeSum / currentCount + 0.5)
    currentCycle = 0.5
    currentCount = 0
    currentFpsSum = 0
    currentDeltaTimeSum = 0
  end
end

local function MonitorDelta(deltaTime)
  gameDeltaTime = deltaTime
  currentFps = 1 / deltaTime

  if Tracker.IsModOpenWindow() then
    MonitorFps(deltaTime)
  end

  if openOverlay or Tracker.IsGamePaused() then RestartBenchmark() return end
  if benchmarkRestart then RestartBenchmark() return end
  Benchmark()
end

------------------
-- Registers
------------------

registerForEvent("onInit", function()
  if not ModArchiveExists("framegenghostingfix.archive") then Globals.PrintError(LogText.archive_missing) return end
  if not Game["FrameGenGhostingFixIsRedScriptModule"] then Globals.PrintError(LogText.redscript_missing) return end
  if not Globals then Globals.PrintError(LogText.globals_missing) return end
  if not Tracker then Globals.PrintError(LogText.tracker_missing) return end
  if not Settings then Globals.PrintError(LogText.settings_missing) return end
  if not ImGuiExt then Globals.PrintError(LogText.imguiext_missing) return end
  if not Localization then Globals.PrintError(LogText.localization_missing) return end
  if not Calculate then Globals.PrintError(LogText.calculate_missing) end
  if not Contextual then Globals.PrintError(LogText.contextual_missing) end
  if not VectorsPresets then Globals.PrintError(LogText.presets_missing) end
  if not Vectors then Globals.PrintError(LogText.vectors_missing_missing) end

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

  if not Tracker.IsModReady() then return end

  Calculate.OnInitialize()
  Contextual.OnInitialize()
  Vectors.OnInitialize()

  if VectorsCustomize then
    -- VectorsCustomize.OnInitialize()
  end

  VectorsPresets.OnInitialize()

  -- danyalzia: remove forced benchmarking upon new install during development
  -- if Tracker.IsModFirstRun() then
  --   SetBenchmark(true)
  -- end

  -- danyalzia: I am commenting it during development since I don't want to close these windows everytime I launch the game for testing :/
  -- if Debug then
  --   Globals.SetDebugMode(true)
    -- Settings.SetKeepWindow(true)
  -- end

  ImGuiExt.SetTheme(Settings.GetTheme())
end)

if Debug then
  registerInput('printPresets', 'Print the presets list', function(keypress)
    if not keypress then
      return
    end

    VectorsPresets.PrintPresets()
  end)

  registerInput('toggleMaskingVehicles', 'Toggle masking state for vehicles', function(keypress)
    if not keypress then
      return
    end

    Vectors.ToggleMaskingState()
  end)

  registerInput('getDLSSEnablerVersion', 'Get DLSSEnabler Version', function(keypress)
    if not keypress then
      return
    end

    local table = {}
    
    table = Globals.VersionStringToTable(DLSSEnabler_GetVersionAsString())

    if table ~= nil then
      Globals.PrintDebug(Globals.__NAME, "DLSS Enabler's version major:", table[1], "minor:", table[2], "patch:", table[3], "revision:", table[4])
    else
      Globals.PrintDebug(Globals.__NAME, "Couldn't retrieve DLSS Enabler's version.")
    end
  end)
end

registerForEvent("onOverlayOpen", function()
  openOverlay = true
  Tracker.SetModOpenWindow(true)

  isDebug = Settings.IsDebugMode()
  Globals.SetDebugMode(isDebug)

  --translate UIText before other modules access it
  Localization.OnOverlayOpen()

  Globals.OnOverlayOpen()
  ImGuiExt.OnOverlayOpen()
  Tracker.OnOverlayOpen()

  if not Tracker.IsModReady() then return end

  Vectors.OnOverlayOpen()

  if VectorsCustomize then
    -- VectorsCustomize.OnOverlayOpen() -- gramern: commented out for development
  end

  VectorsPresets.OnOverlayOpen()
end)

registerForEvent("onOverlayClose", function()
  openOverlay = false

  if not Settings.IsKeepWindow() then
    Tracker.SetModOpenWindow(false)
  end

  Globals.OnOverlayClose()

  if not Tracker.IsModReady() then return end

  Calculate.OnOverlayClose()

  if VectorsCustomize then
    -- VectorsCustomize.OnOverlayClose() -- gramern: commented out for development
  end

  Settings.OnOverlayClose()
  ImGuiExt.ResetStatusBar()
end)

registerForEvent("onUpdate", function(deltaTime)
  Tracker.OnUpdate()

  if Tracker.IsGamePreGame() then return end
  if not Tracker.IsGameLoaded() then return end

  if deltaTime == 0 then return end
  MonitorDelta(deltaTime)
  Tracker.SetGamePerfCurrent(currentFps, deltaTime)

  if Tracker.IsGamePaused() then return end
  Globals.UpdateDelays(deltaTime)

  if not Tracker.IsVehicleMounted() then return end
  Vectors.OnUpdate()
end)

------------------
-- Draw The Window
------------------

registerForEvent("onDraw", function()
  if Tracker.IsModOpenWindow() then
    ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)
    -- ImGui.SetNextWindowSizeConstraints(ImGui.ImVec2(400, 0), ImGui.ImVec2(huge, huge))

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
        -- danyalzia: remove forced benchmarking upon new install dur ing development
        -- if Tracker.IsModNewInstall() then
        --   if ImGui.BeginTabItem(InfoText.tabname) then

        --     if Tracker.IsModFirstRun() then
        --       ImGuiExt.Text(InfoText.benchmark, true)
        --     else
        --       ImGuiExt.Text(InfoText.benchmarkAsk, true)
        --     end

        --     ImGui.Text("")
        --     BenchmarkUI()
        --     ImGui.Text("")

        --     keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(SettingsText.enabledWindow, Settings.IsKeepWindow(), keepWindowToggle)
        --     if keepWindowToggle then
        --       Settings.SetKeepWindow(keepWindowBool)
        --     end
        --     ImGuiExt.SetTooltip(SettingsText.tooltipWindow)

        --     if not Tracker.IsModFirstRun() and not isBenchmark then
        --       ImGui.Text("")

        --       if ImGui.Button(GeneralText.yes, 240 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        --         SetBenchmark(true)
        --       end

        --       ImGui.SameLine()

        --       if ImGui.Button(GeneralText.no, 240 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        --         Tracker.SetModNewInstall(false)
        --         Settings.SetKeepWindow(false)
        --       end
        --     end
        --     ImGui.EndTabItem()
        --   end
        -- end

        if Globals.IsAspectRatioChange() then
          if ImGui.BeginTabItem(InfoText.tabname) then

            ImGuiExt.Text(InfoText.aspectRatioChange, true)

            ImGui.EndTabItem()
          end
        end

        if openOverlay and Tracker.IsModReady() then --done on purpose to mitigate possible distress during gameplay caused by some methods

          Contextual.DrawUI()
          VectorsPresets.DrawUI()
          Calculate.DrawUI()

        end
        
        --additional options interface starts------------------------------------------------------------------------------------------------------------------
        -- danyalzia: remove forced benchmarking upon new install during development
        -- if not Tracker.IsModNewInstall() and Tracker.IsModReady() then
        if Tracker.IsModReady() then
          if ImGui.BeginTabItem(SettingsText.tabname) then
            ImGuiExt.Text(SettingsText.groupMod)
            ImGui.Separator()
            
            if openOverlay then
              if Debug then
                debugBool, debugToggle = ImGuiExt.Checkbox(SettingsText.enabledDebug, Settings.IsDebugMode(), debugToggle)
              end
              if debugToggle then
                Settings.SetDebugMode(debugBool)
                ImGuiExt.SetStatusBar(GeneralText.settings_saved)
              end

              if Debug and Settings.IsDebugMode() then
                debugViewBool, debugViewToggle = ImGuiExt.Checkbox(SettingsText.enabledDebugView, Settings.IsDebugView(), debugViewToggle)
              end
              if debugViewToggle then
                Settings.SetDebugView(debugViewBool)
                ImGuiExt.SetStatusBar(GeneralText.settings_saved)
              end
            end


              keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(SettingsText.enabledWindow, Settings.IsKeepWindow(), keepWindowToggle)
              if keepWindowToggle then
                Settings.SetKeepWindow(keepWindowBool)
                ImGuiExt.SetStatusBar(GeneralText.settings_saved)
              end
              ImGuiExt.SetTooltip(SettingsText.tooltipWindow)
            
            if openOverlay then
              helpBool, helpToggle = ImGuiExt.Checkbox(SettingsText.enabledHelp, Settings.IsHelp(), helpToggle)
              if helpToggle then
                Settings.SetHelp(helpBool)
                ImGuiExt.SetStatusBar(GeneralText.settings_saved)
              end
              ImGuiExt.SetTooltip(SettingsText.tooltipHelp)

              ImGui.Text("")
              ImGuiExt.Text(SettingsText.selectTheme)
              if ImGui.BeginCombo("##Themes", ImGuiExt.GetTheme()) then
                local themesList = ImGuiExt.GetThemesList()
            
                for _, themeName in ipairs(themesList) do
                  local isSelected = (ImGuiExt.GetTheme() == themeName)
              
                  if ImGui.Selectable(themeName, isSelected) then
                    ImGuiExt.SetTheme(themeName)
                  end
            
                  if isSelected then
                    ImGui.SetItemDefaultFocus()
                  end
                end
            
                ImGui.EndCombo()
              end

              ImGuiExt.SetTooltip(SettingsText.tooltipTheme)
            
              ImGui.SameLine()
            
              if ImGui.Button("   " .. GeneralText.save .. "   ") then
                Settings.SetTheme(ImGuiExt.GetTheme())
            
                ImGuiExt.SetStatusBar(GeneralText.settings_saved)
              end
            end

              ImGui.Text("")
              ImGuiExt.Text(SettingsText.groupFG)
              ImGui.Separator()
            
            if openOverlay then
              if Tracker.IsGameReady() then
                fgBool, fgToggle = ImGuiExt.Checkbox(SettingsText.enableFG, Settings.IsFrameGeneration(), fgToggle)
                if fgToggle then
                  Settings.SetFrameGeneration(fgBool)
                  ImGuiExt.SetStatusBar(GeneralText.settings_saved)
                end
                ImGuiExt.SetTooltip(SettingsText.tooltipFG)
              
                ImGuiExt.Text(SettingsText.gameSettingsFG, true)
              else
                ImGuiExt.Text(SettingsText.gameNotReadyWarning, true)
              end
            else
              ImGuiExt.Text(GeneralText.info_frameGenStatus)
              ImGui.SameLine()
              if Tracker.IsModFrameGeneration() then
                ImGuiExt.Text(GeneralText.enabled)
              else
                ImGuiExt.Text(GeneralText.disabled)
              end
            end

            ImGui.Text("")
            ImGuiExt.Text(BenchmarkText.groupBenchmark)
            ImGui.Separator()

            if currentFps then
              BenchmarkUI()

              if openOverlay then
                ImGui.Text("")

                if not isBenchmark then
                  if ImGui.Button(BenchmarkText.benchmarkRun, 480 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    ResetBenchmarkResults()
                    SetBenchmark(true)
                    Settings.SetKeepWindow(true)
                  end

                  ImGuiExt.SetTooltip(BenchmarkText.tooltipRunBench)
                else
                  if ImGui.Button(BenchmarkText.benchmarkStop, 480 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    ResetBenchmarkResults()
                    SetBenchmark(false)
                  end
                end

                if isBenchmarkFinished then
                  if not benchmarkSetSuggested and ImGui.Button(BenchmarkText.benchmarkSetSuggestedSettings, 480 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    SetSuggestedSettings()
                  end

                  if benchmarkSetSuggested and ImGui.Button(BenchmarkText.benchmarkRevertSettings, 480 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    RestorePreviousSettings()

                    ImGuiExt.SetStatusBar(GeneralText.settings_restored)
                    Globals.Print(LogText.settings_restoredCache)
                  end
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