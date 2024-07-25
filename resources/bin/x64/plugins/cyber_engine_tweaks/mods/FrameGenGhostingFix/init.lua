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
local GamePerf = Tracker.GetGamePerfTable()
local GameState = Tracker.GetGameStateTable()
local Vehicle = Tracker.GetVehicleTable()

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
local Debug = require("Dev/Debug")
local TrackerDebug = require("Dev/TrackerDebug")

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
local debugToggle
local debugUIToggle
local helpToggle
local keepWindowToggle
local fgToggle

--- Returns the version of FrameGen Ghosting 'Fix'.
--
-- @param asString: boolean; Whether to return the version as a string.
-- 
-- @return string | table; Version information, updates FrameGenGhostingFix.__VERSION_STRING internally.
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

function GetFps(deltaTime)
  local floor = math.floor

  currentFpsInt = floor(currentFps)
  currentFrametime = floor((deltaTime * 1000) + 0.5)
  gameDeltaTime = deltaTime

  Tracker.SetGamePerfCurrent(currentFps, gameDeltaTime)

  if openOverlay or GameState.isGamePaused then RestartBenchmark() return end
  if benchmarkRestart then RestartBenchmark() return end
  Benchmark()
end

function Benchmark()
  if not isBenchmark then return end
  if not GameState.isGameLoaded then return end

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
    Settings.SetSaved(false)
    Globals.SetNewInstall(false)

    if not Globals.ModState.isFirstRun then return end
    Globals.SetFirstRun(false)
  end
end

function SetBenchmark(boolean)
  isBenchmark = boolean

  if isBenchmark then
    isBenchmarkFinished = false

    Globals.Print(LogText.benchmark_starting)
    ImGuiExt.SetStatusBar(UIText.Options.Benchmark.benchmarkEnabled)
    return
  end

  if benchmarkTime >= benchmarkDuration then
    isBenchmarkFinished = true
  end

  benchmarkTime = 0
  benchmarkRemainingTime = benchmarkDuration

  ImGuiExt.SetStatusBar(UIText.Options.Benchmark.benchmarkFinished)
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

  if openOverlay or GameState.isGamePaused then benchmarkRestartTime = 0 return end

  benchmarkRestartTime = benchmarkRestartTime + gameDeltaTime
  benchmarkRestartRemaining = benchmarkRestartDuration - benchmarkRestartTime

  if benchmarkRestartTime >= benchmarkRestartDuration then
    benchmarkRestart = false
    benchmarkRestartTime = 0
    return
  end
end

function BenchmarkUI()
  ImGuiExt.Text(UIText.Options.Benchmark.currentFps)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFpsInt))
  ImGuiExt.Text(UIText.Options.Benchmark.currentFrametime)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(currentFrametime))
  ImGuiExt.Text(UIText.Options.Benchmark.benchmark)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(isBenchmark))
  ImGuiExt.Text(UIText.Options.Benchmark.benchmarkRemaining)
  ImGui.SameLine()
  ImGuiExt.Text(tostring(benchmarkRemainingTime))

  if isBenchmarkFinished then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Options.Benchmark.averageFps)
    ImGui.SameLine()
    ImGuiExt.Text(tostring(averageFps))
  end

  if GameState.isGamePaused then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Options.Benchmark.benchmarkPause)
  elseif openOverlay then
    ImGui.Text("")
    ImGuiExt.Text(UIText.Options.Benchmark.benchmarkPauseOverlay)
  else
    if benchmarkRestart then
      ImGui.Text("")
      ImGuiExt.Text(UIText.Options.Benchmark.benchmarkRestart)
      ImGui.SameLine()
      ImGuiExt.Text(tostring(benchmarkRestartRemaining))
    end
  end
end

--initialize all stuff etc
registerForEvent("onInit", function()
  if not Globals then Globals.Print(LogText.globals_missing) return end
  if not Localization then Globals.Print(LogText.localization_missing) return end
  if not Settings then Globals.Print(LogText.settings_missing) return end
  if not ImGuiExt then Globals.Print(LogText.imguiext_missing) return end
  if not Calculate then Globals.Print(LogText.calculate_missing) end
  if not Contextual then Globals.Print(LogText.contextual_missing) end
  if not Presets then Globals.Print(LogText.presets_missing) end
  if not Vectors then Globals.Print(LogText.vectors_missing_missing) end
  if not Translate then Globals.Print(LogText.translate_missing) end

  FrameGenGhostingFix.GetVersion()

  windowTitle = FrameGenGhostingFix.__NAME .. " " .. FrameGenGhostingFix.__EDITION or FrameGenGhostingFix.__NAME

  Globals.OnInitialize()

  if not FrameGenGhostingFix.__VERSION_SUFFIX then
    Diagnostics.OnInitialize()
  else
    Diagnostics = nil
  end

  if not Globals.IsModReady() then return end

  Tracker.OnInitialize()
  Settings.OnInitialize()
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
  --   Globals.SetDebug(true)
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
  Globals.OpenWindow(true)

  --translate UIText before other modules access it
  if Translate then
    Translate.SetTranslation("Modules/Localization", "UIText")
    Localization = require("Modules/Localization")
    UIText = Localization.UIText
  end

  Globals.OnOverlayOpen()
  ImGuiExt.OnOverlayOpen()

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

  if not Globals.ModState.keepWindow then
    Globals.OpenWindow(false)
  end

  Globals.OnOverlayClose()

  if not Globals.IsModReady() then return end

  Calculate.OnOverlayClose()

  Contextual.OnOverlayClose()

  if VectorsCustomize then
    VectorsCustomize.OnOverlayClose()
  end

  Settings.OnOverlayClose()

end)

registerForEvent("onUpdate", function(deltaTime)
  Tracker.OnUpdate()

  if GameState.isPreGame then return end
  if not GameState.isGameLoaded then return end

  if deltaTime == 0 then return end
  currentFps = 1 / deltaTime
  GetFps(deltaTime)

  if GameState.isGamePaused then return end

  Globals.UpdateDelays(gameDeltaTime)
  Vectors.OnUpdate()
end)

-- draw the mod's window
registerForEvent("onDraw", function()
  if Globals.ModState.openWindow then
    ImGui.SetNextWindowPos(400, 200, ImGuiCond.FirstUseEver)

    ImGuiExt.PushStyle()

    if ImGui.Begin(windowTitle, ImGuiWindowFlags.AlwaysAutoResize) then
      if ImGui.BeginTabBar('Tabs') then
        
        --diagnostics interface starts------------------------------------------------------------------------------------------------------------------
        if Diagnostics and Diagnostics.isUpdateRecommended then
            Diagnostics.DrawUI()
        end
        --diagnostics interface ends------------------------------------------------------------------------------------------------------------------
        
        --debug interface starts------------------------------------------------------------------------------------------------------------------
        if Debug and Globals.IsDebug() and Globals.IsDebugUI() then
            Debug.DrawUI()
            TrackerDebug.DrawUI()
        end
        --debug interface ends------------------------------------------------------------------------------------------------------------------
        -- danyalzia: remove forced benchmarking upon new install dur ing development
        -- if Globals.IsNewInstall() then
        --   if ImGui.BeginTabItem(UIText.Info.tabname) then

        --     if Globals.ModState.isFirstRun then
        --       ImGuiExt.Text(UIText.Info.benchmark)
        --     else
        --       ImGuiExt.Text(UIText.Info.benchmarkAsk)
        --     end

        --     ImGui.Text("")
        --     BenchmarkUI()
        --     ImGui.Text("")

        --     Globals.ModState.keepWindow, keepWindowToggle = ImGuiExt.Checkbox(UIText.Options.enabledWindow, Globals.ModState.keepWindow, keepWindowToggle)
        --     -- if keepWindowToggle then
        --     --   ImGuiExt.SetStatusBar(UIText.General.settings_saved)
        --     -- end
        --     ImGuiExt.SetTooltip(UIText.Options.tooltipWindow)

        --     if not Globals.ModState.isFirstRun and not isBenchmark then
        --       ImGui.Text("")

        --       if ImGui.Button(UIText.General.yes, 240, 40) then
        --         SetBenchmark(true)
        --       end

        --       ImGui.SameLine()

        --       if ImGui.Button(UIText.General.no, 240, 40) then
        --         Globals.SetNewInstall(false)
        --         Settings.SetSaved(false)
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
          if ImGui.BeginTabItem(UIText.Options.tabname) then

            if Debug then
              Globals.ModState.isDebug, debugToggle = ImGuiExt.Checkbox(UIText.Options.enabledDebug, Globals.ModState.isDebug, debugToggle)
            end
            if debugToggle then
              Settings.SetSaved(false)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end

            if Debug and Globals.IsDebug() then
              Globals.ModState.isDebugUI, debugUIToggle = ImGuiExt.Checkbox(UIText.Options.enabledDebugUI, Globals.ModState.isDebugUI, debugUIToggle)
            end
            if debugUIToggle then
              Settings.SetSaved(false)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end

            Globals.ModState.keepWindow, keepWindowToggle = ImGuiExt.Checkbox(UIText.Options.enabledWindow, Globals.ModState.keepWindow, keepWindowToggle)
            if keepWindowToggle then
              Settings.SetSaved(false)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end
            ImGuiExt.SetTooltip(UIText.Options.tooltipWindow)

            Globals.ModState.isHelp, helpToggle = ImGuiExt.Checkbox(UIText.Options.enabledHelp, Globals.ModState.isHelp, helpToggle)
            if helpToggle then
              Settings.SetSaved(false)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
            end
            ImGuiExt.SetTooltip(UIText.Options.tooltipHelp)

            ImGui.Separator()

            Globals.ModState.isFGEnabled, fgToggle = ImGuiExt.Checkbox(UIText.Options.toggleFG, Globals.ModState.isFGEnabled, fgToggle)
            if fgToggle then
              Settings.SetSaved(false)
              ImGuiExt.SetStatusBar(UIText.General.settings_saved)
              DLSSEnabler_SetFrameGenerationState(Globals.ModState.isFGEnabled)
            end
            ImGuiExt.SetTooltip(UIText.Options.tooltipToggleFG)
            
            ImGuiExt.Text(UIText.Options.fgEnableInGameMenu, true)
            ImGui.Separator()

            if currentFps then
              BenchmarkUI()
              ImGui.Text("")

              if not isBenchmark then
                if ImGui.Button(UIText.Options.Benchmark.benchmarkRun, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(true)
                  Globals.KeepWindow(true)
                end

                ImGuiExt.SetTooltip(UIText.Options.Benchmark.tooltipRunBench)
              else
                if ImGui.Button(UIText.Options.Benchmark.benchmarkStop, 480, 40) then
                  ResetBenchmarkResults()
                  SetBenchmark(false)
                end
              end

              if isBenchmarkFinished then
                if not benchmarkSetSuggested and ImGui.Button(UIText.Options.Benchmark.benchmarkSetSuggestedSettings, 480, 40) then
                  SetSuggestedSettings()
                end

                if benchmarkSetSuggested and ImGui.Button(UIText.Options.Benchmark.benchmarkRevertSettings, 480, 40) then
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