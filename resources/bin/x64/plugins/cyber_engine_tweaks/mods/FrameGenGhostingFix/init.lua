FrameGenGhostingFix = {
  __NAME = "FrameGen Ghosting 'Fix'",
  __EDITION = "V",
  __VERSION = { 5, 0, 0 },
  __VERSION_SUFFIX = nil,
  __VERSION_STATUS = nil,
  __VERSION_STRING = nil,
  __DLSS_ENABLER_VERSION_MIN = { 3, 0, 0, 1},
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
local VectorsEditor = require("Modules/VectorsEditor")

--localization tables
local LogText = Localization.GetLogText()
local BenchmarkText = Localization.GetBenchmarkText()
local ContextualText = Localization.GetContextualText()
local GeneralText = Localization.GetGeneralText()
local InfoText = Localization.GetInfoText()
local SettingsText = Localization.GetSettingsText()

--debug
local Debug = require("Dev/Debug")
local TrackerDebug = require("Dev/TrackerDebug")
local VectorsDebug = require("Dev/VectorsDebug")

--math
local floor = math.floor

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

-- user_settings not loading on SteamOS - problem mitigation attempt
-- local userSettingsLoaded = false

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


--- Returns the version of DLSS Enabler.
--
-- @param asTable: boolean; Whether to return the version as a table.
-- 
-- @return string | table | nil; Version information. If `dlss-enabler-bridge-2077.dll` is not present, returns `nil`
function FrameGenGhostingFix.GetDLSSEnablerVersion(asTable)
  local version = DLSSEnabler_GetVersionAsString() or nil

  if not version then return nil end

  if version ~= "Unknown" and asTable then
    version = Globals.VersionStringToTable(DLSSEnabler_GetVersionAsString())
  end

  return version
end

--- Returns if a compatible of DLSS Enabler version is installed.
--
-- @param None
-- 
-- @return boolean; `true` if compatible, `false` if otherwise or DLSS Enabler is missing
function FrameGenGhostingFix.IsDLSSEnablerCompatible()
  local version = FrameGenGhostingFix.GetDLSSEnablerVersion(true)

  if not version then Globals.PrintError(LogText.bridge_missing) return false end

  local enablerVersion = FrameGenGhostingFix.__DLSS_ENABLER_VERSION_MIN
  local minVersion = {major = enablerVersion[1], minor = enablerVersion[2], patch = enablerVersion[3], revision = enablerVersion[4]}

  local isCompatible =
    version[1] > minVersion.major or
    (version[1] == minVersion.major and version[2] > minVersion.minor) or
    (version[1] == minVersion.major and version[2] == minVersion.minor and version[3] > minVersion.patch) or
    (version[1] == minVersion.major and version[2] == minVersion.minor and version[3] == minVersion.patch and version[4] >= minVersion.revision)

  return isCompatible
end

--- Sets internal info, that user settings file has been loaded. A mitigation for specific problems with normal file loading on Linux/SteamOs
--
-- @param `isLoaded`: boolean;
-- 
-- @return None
-- function FrameGenGhostingFix.SetLoadUserSettingsFileAttmept(isExecuted)
--   userSettingsLoaded = isExecuted
-- end

------------------
-- Benchmark
------------------

local function SetBenchmark(boolean)
  isBenchmark = boolean

  if isBenchmark then
    isBenchmarkFinished = false

    Globals.Print(LogText.benchmark_starting)
    ImGuiExt.SetStatusBar(BenchmarkText.status_benchmark_enabled)
    return
  end

  if benchmarkTime >= benchmarkDuration then
    isBenchmarkFinished = true
  end

  benchmarkTime = 0
  benchmarkRemainingTime = benchmarkDuration

  ImGuiExt.SetStatusBar(BenchmarkText.status_benchmark_finished)
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

    Globals.Print("Benchmark", LogText.benchmark_avg_fps_result, averageFps)

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
  if not Tracker.IsGamePreGame() then
    ImGuiExt.Text(BenchmarkText.info_current_fps)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(currentFpsInt))
    ImGuiExt.Text(BenchmarkText.info_current_frametime)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(currentFrametimeInt))
  else
    ImGui.Text("")
    ImGuiExt.Text(BenchmarkText.info_benchmark_pre_game, true)
  end

  if openOverlay or isBenchmark then
    ImGuiExt.Text(BenchmarkText.info_benchmark)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(isBenchmark))
    ImGuiExt.Text(BenchmarkText.info_benchmark_remaining)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(benchmarkRemainingTime))
  end

  if isBenchmarkFinished and openOverlay then
    ImGui.Text("")
    ImGuiExt.Text(BenchmarkText.info_average_fps)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(averageFps))
  end

  if isBenchmark then
    if not Tracker.IsGameReady() then
      ImGui.Text("")
      ImGuiExt.Text(BenchmarkText.info_benchmark_pause, true)
    elseif openOverlay then
      ImGui.Text("")
      ImGuiExt.Text(BenchmarkText.info_benchmark_pause_overlay, true)
    else
      if benchmarkRestart then
        ImGui.Text("")
        ImGuiExt.Text(BenchmarkText.info_benchmark_restart)
        ImGui.SameLine()
        ImGuiExt.Text(tostring(benchmarkRestartRemaining))
      end
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
  if not VectorsPresets then Globals.PrintError(LogText.presets_missing) end
  if not Vectors then Globals.PrintError(LogText.vectors_missing) end

  -- check for the right DLSS Enabler's version for the contextual edition of the mod
  if FrameGenGhostingFix.__VERSION_SUFFIX ~= "nc" then
    if Contextual then 
      if not FrameGenGhostingFix.IsDLSSEnablerCompatible() then
        Globals.PrintError(Contextual.__NAME, LogText.bridge_bad_enabler_version)
        Globals.PrintError(Contextual.__NAME, LogText.bridge_found_enabler_version, FrameGenGhostingFix.GetDLSSEnablerVersion())
      end
    else
      Globals.PrintError(LogText.contextual_missing)
      return
    end
  end

  -- the first early return on very first problems with the mod
  if not Tracker.IsModReady() then return end

  FrameGenGhostingFix.GetVersion()

  windowTitle = FrameGenGhostingFix.__NAME .. " " .. FrameGenGhostingFix.__EDITION or FrameGenGhostingFix.__NAME

  Globals.OnInitialize()
  Tracker.OnInitialize()
  Settings.OnInitialize()

  Globals.SetDebugMode(Settings.IsDebugMode())

  -- the second early return on problems with the game/user settings
  if not Tracker.IsModReady() then return end

  Calculate.OnInitialize()

  -- check for the non-contextual edition of the mod
  if FrameGenGhostingFix.__VERSION_SUFFIX ~= "nc" then
    Contextual.OnInitialize()
  end

  Vectors.OnInitialize()
  VectorsPresets.OnInitialize()
  
  -- danyalzia: remove forced benchmarking upon new install during development
  if Tracker.IsModFirstRun() then
    SetBenchmark(true)
  end

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

    local table = FrameGenGhostingFix.GetDLSSEnablerVersion(true)

    if table ~= nil then
      Globals.PrintDebug(Globals.__NAME, "DLSS Enabler's version major:", table[1], "minor:", table[2], "patch:", table[3], "revision:", table[4])
    else
      Globals.PrintDebug(Globals.__NAME, "Couldn't retrieve DLSS Enabler's version.")
    end
  end)
end

registerForEvent("onOverlayOpen", function()
  if not Tracker.IsModReady() then return end
  openOverlay = true
  Tracker.SetModOpenWindow(true)

  Globals.SetDebugMode(Settings.IsDebugMode())

  --translate UIText before other modules access it
  Localization.OnOverlayOpen()

  Globals.OnOverlayOpen()
  ImGuiExt.OnOverlayOpen()
  Tracker.OnOverlayOpen()
  Settings.OnOverlayOpen()

  Vectors.OnOverlayOpen()
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

  -- check for the non-contextual edition of the mod
  if FrameGenGhostingFix.__VERSION_SUFFIX ~= "nc" then
    Contextual.OnOverlayClose()
  end

  Settings.OnOverlayClose()
  ImGuiExt.OnOverlayClose()

  VectorsEditor.OnOverlayClose()
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
  if not Tracker.IsModReady() then return end
  ImGuiExt.DrawNotification()

  if Tracker.IsModOpenWindow() then
    ImGuiExt.PushStyle()
    ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)

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
        
        if Globals.IsAspectRatioChange() then
          if ImGui.BeginTabItem(InfoText.tab_name_info) then

            ImGuiExt.Text(InfoText.info_aspect_ratio_change, true)

            ImGui.EndTabItem()
            return
          end
        end

        -- danyalzia: remove forced benchmarking upon new install dur ing development
        if Tracker.IsModNewInstall() then
          if ImGui.BeginTabItem(InfoText.tab_name_info) then

            if Tracker.IsModFirstRun() then
              ImGuiExt.Text(InfoText.info_benchmark, true)
            else
              ImGuiExt.Text(InfoText.info_benchmark_ask, true)
            end

            ImGui.Text("")
            BenchmarkUI()
            ImGui.Text("")

            keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(SettingsText.chk_window, Settings.IsKeepWindow(), keepWindowToggle)
            if keepWindowToggle then
              Settings.SetKeepWindow(keepWindowBool)
            end
            ImGuiExt.SetTooltip(SettingsText.tooltip_window)

            if not Tracker.IsModFirstRun() and not isBenchmark then
              ImGui.Text("")

              if ImGui.Button(GeneralText.yes, 234 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                SetBenchmark(true)
              end

              ImGui.SameLine()

              if ImGui.Button(GeneralText.no, 234 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                Tracker.SetModNewInstall(false)
                Settings.SetKeepWindow(false)
              end
            end
            ImGui.EndTabItem()
          end
        end

        if FrameGenGhostingFix.__VERSION_SUFFIX and not Settings.IsMessage() then
          if ImGui.BeginTabItem(ContextualText.tab_name_contextual) then

            ImGuiExt.Text(ContextualText.info_contextual, true)
            ImGui.Text("")
            ImGuiExt.Text(ContextualText.info_contextual_dependencies, true)
            ImGui.Text("")
            ImGuiExt.Text(GeneralText.info_version, true)
            ImGuiExt.Text(FrameGenGhostingFix.__VERSION_STRING, true)
            ImGui.Text("")
            ImGuiExt.TextColor(GeneralText.info_important, 1, 0.85, 0.31, 1, true)
            ImGuiExt.Text(ContextualText.info_contextual_requirements, true)
            ImGui.Text("")

            if ImGui.Button(GeneralText.btn_apply, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
              Settings.SetMessage(true)
            end

            ImGui.EndTabItem()
          end
        end

        if openOverlay and FrameGenGhostingFix.__VERSION_SUFFIX ~= "nc" or Contextual and Settings.IsDebugMode() then
          Contextual.DrawUI()
        end

        if openOverlay and Tracker.IsModReady() then --done on purpose to mitigate possible distress during gameplay caused by some methods

          VectorsPresets.DrawUI()
          Calculate.DrawUI()

        end
        
        --additional options interface starts------------------------------------------------------------------------------------------------------------------
        if Tracker.IsModReady() then
          if ImGui.BeginTabItem(SettingsText.tab_name_settings) then

            if Debug and openOverlay then
              ImGuiExt.Text("Debug:")
              ImGui.Separator()

              debugBool, debugToggle = ImGuiExt.Checkbox(SettingsText.chk_debug, Settings.IsDebugMode(), debugToggle)
              if debugToggle then
                Settings.SetDebugMode(debugBool)
                ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
              end

              if Settings.IsDebugMode() then
                debugViewBool, debugViewToggle = ImGuiExt.Checkbox(SettingsText.chk_debug_view, Settings.IsDebugView(), debugViewToggle)
              end

              if debugViewToggle then
                Settings.SetDebugView(debugViewBool)
                ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
              end

              if Settings.IsDebugMode() then
                ImGui.Text("")

                if ImGui.Button(SettingsText.btn_print_user_settings, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                  Globals.PrintTable(Globals.LoadJSON('user-settings'))
                end

                ImGui.Text("")
              end
            end

            ImGuiExt.Text(SettingsText.group_mod)
            ImGui.Separator()

            keepWindowBool, keepWindowToggle = ImGuiExt.Checkbox(SettingsText.chk_window, Settings.IsKeepWindow(), keepWindowToggle)
            if keepWindowToggle then
              Settings.SetKeepWindow(keepWindowBool)
              ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
            end
            ImGuiExt.SetTooltip(SettingsText.tooltip_window)
            
            if openOverlay then
              helpBool, helpToggle = ImGuiExt.Checkbox(SettingsText.chk_help, Settings.IsHelp(), helpToggle)
              if helpToggle then
                Settings.SetHelp(helpBool)
                ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
              end
              ImGuiExt.SetTooltip(SettingsText.tooltip_help)

              ImGui.Text("")
              ImGuiExt.Text(SettingsText.combobox_theme)
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
              ImGuiExt.SetTooltip(SettingsText.tooltip_theme)
            
              ImGui.SameLine()
            
              if ImGui.Button(GeneralText.btn_save,  100 * ImGuiExt.GetScaleFactor(), 0) then
                Settings.SetTheme(ImGuiExt.GetTheme())
            
                ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
              end
            end

            if not Tracker.IsGamePreGame() and not Tracker.IsGameLoaded() then
              ImGui.Text("")

              if ImGui.Button(SettingsText.btn_reload_mod, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                local result = Tracker.SetGameLoaded(true)

                if result then
                  ImGuiExt.SetStatusBar(SettingsText.status_mod_reloaded)
                else
                  ImGuiExt.SetStatusBar(SettingsText.status_game_loaded_fail)
                end
              end
              ImGuiExt.SetTooltip(SettingsText.tooltip_reload_mod)
            end

            ImGui.Text("")
            ImGuiExt.Text(SettingsText.group_fg)
            ImGui.Separator()
          
            -- this toggle is a debug exclusive since it's a double of the game's settings switch and 
            if Settings.IsDebugMode() and openOverlay then
              fgBool, fgToggle = ImGuiExt.Checkbox(SettingsText.chk_fg, Settings.IsModFrameGeneration(), fgToggle)
              if fgToggle then
                Settings.SetModFrameGeneration(fgBool)
                ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
              end
              ImGuiExt.SetTooltip(SettingsText.tooltip_fg)

              if Tracker.IsGameReady() then
                ImGuiExt.Text(SettingsText.info_game_settings_fg, true)
              else
                ImGuiExt.Text(SettingsText.info_game_not_ready_warning, true)
              end

              ImGui.Text("")
            end
            
            ImGuiExt.Text(SettingsText.info_frame_gen_status)
            ImGui.SameLine()
            
            if FrameGenGhostingFix.__VERSION_SUFFIX ~= "nc" then
              if Tracker. IsGameFrameGeneration() and Tracker.IsModFrameGeneration() then
                ImGuiExt.Text(GeneralText.info_enabled)
              else
                ImGuiExt.Text(GeneralText.info_disabled)
              end
            else
              if Tracker. IsGameFrameGeneration() then
                ImGuiExt.Text(GeneralText.info_enabled)
              else
                ImGuiExt.Text(GeneralText.info_disabled)
              end
            end

            ImGui.Text("")
            ImGuiExt.Text(BenchmarkText.group_benchmark)
            ImGui.Separator()

            if currentFps then
              BenchmarkUI()

              if openOverlay then
                ImGui.Text("")

                if not isBenchmark then
                  if ImGui.Button(BenchmarkText.btn_benchmark_run, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    ResetBenchmarkResults()
                    SetBenchmark(true)
                    Settings.SetKeepWindow(true)
                  end
                  ImGuiExt.SetTooltip(BenchmarkText.tooltip_run_bench)

                else
                  if ImGui.Button(BenchmarkText.btn_benchmark_stop, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    ResetBenchmarkResults()
                    SetBenchmark(false)
                  end
                end

                if isBenchmarkFinished then
                  if not benchmarkSetSuggested and ImGui.Button(BenchmarkText.btn_benchmark_set_suggested_settings, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    SetSuggestedSettings()
                  end

                  if benchmarkSetSuggested and ImGui.Button(BenchmarkText.btn_benchmark_revert_settings, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
                    RestorePreviousSettings()

                    ImGuiExt.SetStatusBar(SettingsText.status_settings_restored)
                    Globals.Print(LogText.settings_restored)
                  end
                end
              end
            end
            ImGui.EndTabItem()
          end
        end
        --additonal options interface ends------------------------------------------------------------------------------------------------------------------
        ImGui.EndTabBar()
      end

      ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())
    end

    ImGui.End()
    ImGuiExt.PopStyle()
  end
end)

return FrameGenGhostingFix