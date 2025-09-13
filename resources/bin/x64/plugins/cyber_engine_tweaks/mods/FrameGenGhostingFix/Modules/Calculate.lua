local Calculate = {
  __NAME = "Calculate",
  __VERSION = { 5, 2, 7 },
}

local MaskingGlobal = {
  masksController = nil,
  onFoot = true -- not used for now
}

local Screen = {
  Edge = {
    down = 2160,
    left = 0,
    right = 3840,
  },
  type = 169,
}

local MasksData = {
  Blocker = {
    Def = {
      ScreenSpace = {x = 1920, y = 1080},
    },
    onAim = false,
    Size = {x = 3840, y = 2440}
  },
  Corners = {
    onWeapon = false,
    ScreenSpace = {
      Left = {x = 0},
      Right = {x = 3840},
      Bottom = {y = 2160}
    },
  },
  Vignette = {
    Def = {
      Scale = {
        Max = {x = 130, y = 130},
        Min = {x = 80, y = 85},
        x = 120,
        y = 120,
      },
      ScreenPosition = {
        Max = {x = 150, y = 145},
        Min = {x = 50, y = 55},
        x = 100,
        y = 75,
      },
      ScreenSpace = {x = 1920, y = 1080},
      Size = {x = 4840, y = 2560},
    },
    onAim = false,
    onWeapon = false,
    permament = false,
    Scale = {
      Max = {x = 130, y = 130},
      Min = {x = 80, y = 85},
      x = 120,
      y = 120,
    },
    ScreenPosition = {
      Max = {x = 150, y = 145},
      Min = {x = 50, y = 55},
      x = 100,
      y = 75,
    },
    ScreenSpace = {x = 1920, y = 1080},
    Size = {x = 4840, y = 2560},
  },
  Opacity = {
    max = 0.02,
    changeStep = 0.005
  }
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
local OnFootText = Localization.GetOnFootText()
local SettingsText = Localization.GetSettingsText()

------------------
-- UserSettings
------------------

local function GetUserSettings()
  local userSettings = {
    Blocker = {onAim = MasksData.Blocker.onAim},
    Corners = {onWeapon = MasksData.Corners.onWeapon},
    Vignette = {
      permament = MasksData.Vignette.permament,
      onAim = MasksData.Vignette.onAim,
      onWeapon = MasksData.Vignette.onWeapon,
      ScreenPosition = {x = MasksData.Vignette.ScreenPosition.x, y = MasksData.Vignette.ScreenPosition.y},
      Scale = {x = MasksData.Vignette.Scale.x, y = MasksData.Vignette.Scale.y},
    },
    Opacity = {max = MasksData.Opacity.max, changeStep = MasksData.Opacity.changeStep}
  }

  return userSettings
end

local function LoadUserSettings(userSettings)
  if not userSettings or userSettings == nil then return end

  Globals.SafeMergeTables(MasksData, userSettings)
end

local function SaveUserSettings()
  Settings.WriteUserSettings('OnFoot', GetUserSettings())
end

local function BackupUserSettings()
  Globals.SetFallback('OnFoot', GetUserSettings())
end

function Calculate.RestoreUserSettings()
  Globals.SafeMergeTables(MasksData, Globals.GetFallback('OnFoot'))

  SaveUserSettings()
end

------------------
-- Get Tables
------------------

-- @return table;
function Calculate.GetMaskingGlobalData()
  return MaskingGlobal
end

-- @return table;
function Calculate.GetMasksData()
  return MasksData
end

------------------
-- Masks'
------------------

-- @param `context`: string; Contexts: `onAim`
--
-- @return boolean;
local function GetBlockerState(context)
  if not context then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, no context given.") return end

  if MasksData.Blocker[context] == nil then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, bad context given.") return end
  return MasksData.Blocker[context]
end

-- @param `context`: string; Contexts: `onAim`
-- @param `isEnabled`: boolean
--
-- @return None
local function SetBlockerState(context, isEnabled)
  MasksData.Blocker[context] = isEnabled
end

-- @param `context`: string; Contexts: `onWeapon`
--
-- @return boolean;
local function GetCornersState(context)
  if not context then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, no context given.") return end

  if MasksData.Corners[context] == nil then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, bad context given.") return end
  return MasksData.Corners[context]
end

-- @param `context`: string; Contexts: `onWeapon`
-- @param `isEnabled`: boolean
--
-- @return None
local function SetCornersState(context, isEnabled)
  MasksData.Corners[context] = isEnabled
end

-- @param `context`: string; Contexts: `onAim`, `onWeapon`, `permament`
--
-- @return boolean;
local function GetVignetteState(context)
  if not context then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, no context given.") return end

  if MasksData.Vignette[context] == nil then Globals.PrintDebug(Calculate.__NAME, "Cannot retireve a state, bad context given.") return end
  return MasksData.Vignette[context]
end

-- @param `context`: string; Contexts: `onAim`, `onWeapon`, `permament`
-- @param `isEnabled`: boolean
--
-- @return None
local function SetVignetteState(context, isEnabled)
  MasksData.Vignette[context] = isEnabled
end

-- @param `coordinate`: string; `x` or `y`
--
-- @return number;
local function GetVignetteScreenSpace(coordinate)
  local floor = math.floor
  local newSpace = 0

  newSpace = MasksData.Vignette.Def.ScreenSpace[coordinate] * (MasksData.Vignette.ScreenPosition[coordinate] / 100)
  MasksData.Vignette.ScreenSpace[coordinate] = (floor(newSpace + 0.5))

  -- Globals.PrintDebug(Calculate.__NAME, "Vignette position and screen space",coordinate,MasksData.Vignette.ScreenPosition[coordinate],MasksData.Vignette.ScreenSpace[coordinate])
  return MasksData.Vignette.ScreenSpace[coordinate]
end

-- @param `coordinate`: string; `x` or `y`
-- @param `minMax`: string; Optional `Min` or `Max`
--
-- @return number;
local function GetVignetteScreenPosition(coordinate, minMax)
  if not minMax then
    return MasksData.Vignette.ScreenPosition[coordinate]
  else
    local minMaxKey = MasksData.Vignette.ScreenPosition[minMax]

    return minMaxKey[coordinate]
  end
end

-- @param `coordinate`: string `x` or `y`
-- @param `value`: number
--
-- @return None
local function SetVignetteScreenPosition(coordinate, value)
  MasksData.Vignette.ScreenPosition[coordinate] = value

  Calculate.OnVignetteChange(coordinate)
end

-- @param `coordinate`: string; `x` or `y`
--
-- @return number;
local function GetVignetteSize(coordinate)
  local floor = math.floor
  local newSize = 0

  newSize = MasksData.Vignette.Def.Size[coordinate] * (MasksData.Vignette.Scale[coordinate] / 100)
  MasksData.Vignette.Size[coordinate] = (floor(newSize + 0.5))

  -- Globals.PrintDebug(Calculate.__NAME, "Vignette scale and size",coordinate,MasksData.Vignette.Scale[coordinate],MasksData.Vignette.Size[coordinate])
  return MasksData.Vignette.Size[coordinate]
end

-- @param `coordinate`: string; `x` or `y`
-- @param `minMax`: string; Optional `Min` or `Max`
--
-- @return number;
local function GetVignetteScale(coordinate, minMax)
  if not minMax then
    return MasksData.Vignette.Scale[coordinate]
  else
    local minMaxKey = MasksData.Vignette.Scale[minMax]

    return minMaxKey[coordinate]
  end
end

-- @param `coordinate`: string; `x` or `y`
-- @param `value`: number
--
-- @return None
local function SetVignetteScale(coordinate, value)
  MasksData.Vignette.Scale[coordinate] = value

  Calculate.OnVignetteChange(coordinate)
end

-- @param `coordinate`: string; `x` or `y`
--
-- @return None
function Calculate.SetVignetteDefault(coordinate)
  SetVignetteScreenPosition(coordinate, MasksData.Vignette.Def.ScreenPosition[coordinate])
  SetVignetteScale(coordinate, MasksData.Vignette.Def.Scale[coordinate])
end

function Calculate.OnVignetteChange(coordinate)
  local scaleChange = MasksData.Vignette.Scale[coordinate] - MasksData.Vignette.Scale.Min[coordinate]

  MasksData.Vignette.ScreenPosition.Min[coordinate] = 100 - scaleChange
  MasksData.Vignette.ScreenPosition.Max[coordinate] = 100 + scaleChange

  if MasksData.Vignette.ScreenPosition[coordinate] < MasksData.Vignette.ScreenPosition.Min[coordinate] then
    MasksData.Vignette.ScreenPosition[coordinate] = MasksData.Vignette.ScreenPosition.Min[coordinate]
  end

  if MasksData.Vignette.ScreenPosition[coordinate] > MasksData.Vignette.ScreenPosition.Max[coordinate] then
    MasksData.Vignette.ScreenPosition[coordinate] = MasksData.Vignette.ScreenPosition.Max[coordinate]
  end

  GetVignetteSize(coordinate)
  GetVignetteScreenSpace(coordinate)
end

------------------
-- Prepare masks for the screen
------------------

local function ApplyCornersScreenSpace()
  local screenType = Screen.type
  local screenEdge = Screen.Edge

  MasksData.Corners.ScreenSpace.Left.x = screenEdge.left
  MasksData.Corners.ScreenSpace.Right.x = screenEdge.right

  if screenType == 43 then
    MasksData.Corners.ScreenSpace.Bottom.y = 2440
  elseif screenType == 1610 then
    MasksData.Corners.ScreenSpace.Bottom.y = 2280
  else
    MasksData.Corners.ScreenSpace.Bottom.y = screenEdge.down
  end

  -- Globals.PrintDebug("Corners screen space",MasksData.Corners.ScreenSpace.Left.x,MasksData.Corners.ScreenSpace.Right.x,MasksData.Corners.ScreenSpace.Bottom.y)
end

local function ApplyBlockerSize()
  local screenType = Screen.type

  if screenType == 43 then
    MasksData.Blocker.Size = {x = 3840, y = 3074}
  elseif screenType == 169 then
    MasksData.Blocker.Size = {x = 3840, y = 2440}
  elseif screenType == 1610 then
    MasksData.Blocker.Size = {x = 3840, y = 2640}
  elseif screenType == 219 then
    MasksData.Blocker.Size = {x = 5140, y = 2440}
  elseif screenType == 329 then
    MasksData.Blocker.Size = {x = 7700, y = 2640}
  end
  -- Globals.PrintDebug("Blocker size:",MasksData.Blocker.Size.x,MasksData.Blocker.Size.y)
end

local function ApplyVignetteSize()
  local screenType = Screen.type

  if screenType == 43 then
    MasksData.Vignette.Def.Size = {x = 4840, y = 3072}
  elseif screenType == 169 then
    MasksData.Vignette.Def.Size = {x = 4840, y = 2560}
  elseif screenType == 1610 then
    MasksData.Vignette.Def.Size = {x = 4840, y = 2880}
  elseif screenType == 219 then
    MasksData.Vignette.Def.Size = {x = 6460, y = 2560}
  elseif screenType == 329 then
    MasksData.Vignette.Def.Size = {x = 9680, y = 2560}
  end
  -- Globals.PrintDebug("Vignette default size:",MasksData.Vignette.Def.Size.x,MasksData.Vignette.Def.Size.y)
end

local function ApplyExceptions()
  if Screen.type == 43 then
    MasksData.Vignette.Scale.Min.y = 95
  end
end

local function ApplyMasksController()
  MaskingGlobal.masksController = Globals.GetMasksController()
end

local function ApplyScreenEdges()
  local screen = Globals.GetScreenTable()

  Screen.Edge = screen.Edge
  Screen.type = screen.type
end

function Calculate.ApplySuggestedSettings(averageFps)
  BackupUserSettings()

  if averageFps >= 35 then
    MasksData.Corners.onWeapon = true
  else
    MasksData.Corners.onWeapon = false
  end

  if averageFps >= 45 then
    MasksData.Blocker.onAim = true
    MasksData.Vignette.onAim = false
  else
    MasksData.Blocker.onAim = false
    MasksData.Vignette.onAim = false
  end

  if averageFps >= 50 then
    MasksData.Vignette.onWeapon = true
  else
    MasksData.Vignette.onWeapon = false
  end

  if averageFps >= 60 then
    MasksData.Vignette.permament = true
  else
    MasksData.Vignette.permament = false
  end

  Calculate.SetVignetteDefault('x')
  Calculate.SetVignetteDefault('y')
  Calculate.Toggle()


  SaveUserSettings()

  Globals.Print(Calculate.__NAME, LogText.calculate_apply_settings)
end

------------------
-- On... registers
------------------

function Calculate.OnInitialize()
  LoadUserSettings(Settings.GetUserSettings('OnFoot'))
  ApplyMasksController()
  ApplyScreenEdges()
  ApplyCornersScreenSpace()
  ApplyBlockerSize()
  ApplyVignetteSize()
  ApplyExceptions()
  GetVignetteScreenSpace('x')
  GetVignetteScreenSpace('y')
  GetVignetteSize('x')
  GetVignetteSize('y')
  Calculate.Toggle()
end

function Calculate.OnOverlayClose()
  ApplyScreenEdges()
  ApplyCornersScreenSpace()
  ApplyBlockerSize()
  ApplyVignetteSize()
  ApplyExceptions()
  GetVignetteScreenSpace('x')
  GetVignetteScreenSpace('y')
  GetVignetteSize('x')
  GetVignetteSize('y')
  Calculate.Toggle()
  TurnOffLiveView()
end

------------------
-- Toggle RedScript Methods
------------------

function Calculate.Toggle()
  ToggleOnFootOpacity()
  ToggleCornersOnWeapon()
  ToggleBlockerOnAim()
  ToggleVignetteOnAim()
  ToggleVignetteOnWeapon()
  ToggleVignettePermament()
end

function ToggleCornersOnWeapon()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local edge = Screen.Edge

    Override(masksController, 'FrameGenGhostingFixCornersOnFootToggle', function(self, cornersOnFoot, wrappedMethod)
      local originalOnFoot = wrappedMethod(cornersOnFoot)

      if not MasksData.Corners.onWeapon then return originalOnFoot end
      self.cornersOnFootEnabled = true
    end)

    Override(masksController, 'FrameGenGhostingFixMasksOnFootSetMarginsToggle', function(self, cornerDownLeftMargin, cornerDownRightMargin, cornerDownMarginTop, wrappedMethod)
      self.cornerDownLeftMargin = edge.left
      self.cornerDownRightMargin = edge.right
      self.cornerDownMarginTop = edge.down
      self:FrameGenGhostingFixMasksOnFootSetMargins()
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function ToggleBlockerOnAim()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local size = MasksData.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixBlockerAimOnFootToggle', function(self, blockerAimOnFoot, wrappedMethod)
      local originalBlockerAim = wrappedMethod(blockerAimOnFoot)

      if not MasksData.Blocker.onAim then return originalBlockerAim end
      self.blockerAimOnFootEnabled = true
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggle', function(self, aimOnFootSizeX, aimOnFootSizeY, wrappedMethod)
      self.aimOnFootSizeX = size.x
      self.aimOnFootSizeY = size.y
      self:FrameGenGhostingFixAimOnFootSetDimensions()
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function ToggleVignetteOnAim()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local size = MasksData.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixVignetteAimOnFootToggle', function(self, vignetteAimOnFoot, wrappedMethod)
      local originalVignetteAim = wrappedMethod(vignetteAimOnFoot)

      if not MasksData.Vignette.onAim then return originalVignetteAim end
      self.vignetteAimOnFootEnabled = true
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggle', function(self, aimOnFootSizeX, aimOnFootSizeY, wrappedMethod)
      self.aimOnFootSizeX = size.x
      self.aimOnFootSizeY = size.y
      self:FrameGenGhostingFixAimOnFootSetDimensions()
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function ToggleVignetteOnWeapon()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local space = MasksData.Vignette.ScreenSpace
    local size = MasksData.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootToggle', function(self, vignetteOnFoot, wrappedMethod)
      local originalVignette = wrappedMethod(vignetteOnFoot)

      if not  MasksData.Vignette.onWeapon then return originalVignette end
      self.vignetteOnFootEnabled = true
    end)

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggle', function(self, vignetteOnFootMarginLeft, vignetteOnFootMarginTop, vignetteOnFootSizeX, vignetteOnFootSizeY, wrappedMethod)
      self.vignetteOnFootMarginLeft = space.x
      self.vignetteOnFootMarginTop = space.y
      self.vignetteOnFootSizeX = size.x
      self.vignetteOnFootSizeY = size.y
      self:FrameGenGhostingFixVignetteOnFootSetDimensions();
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function ToggleVignettePermament()
  local masksController = MaskingGlobal.masksController

  if masksController then
    Override(masksController, 'FrameGenGhostingFixVignetteOnFootPermamentToggle', function(self, vignetteOnFootPermament, wrappedMethod)
      local originalFunction = wrappedMethod(vignetteOnFootPermament)

      if not MasksData.Vignette.permament then return originalFunction end
      self.vignetteOnFootPermamentEnabled = true
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function ToggleOnFootOpacity()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local opacity = MasksData.Opacity

    Override(masksController, 'FrameGenGhostingFixOpacityOnFootToggle', function(self, maxOpacity, changeStep, wrappedMethod)
      self.onFootMaxOpacity = opacity.max
      self.onFootChangeOpacityBy = opacity.changeStep
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function TurnOnLiveView()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local opacity = MasksData.Opacity
    local space = MasksData.Vignette.ScreenSpace
    local size = MasksData.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootEditorContext', function(self, vignetteOnFootEditor, wrappedMethod)
      self.vignetteOnFootEditor = true
      self.onFootMaxOpacity = opacity.max
      self.onFootChangeOpacityBy = opacity.changeStep
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(space.x, space.y, size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

function TurnOffLiveView()
  local masksController = MaskingGlobal.masksController

  if masksController then
    Override(masksController, 'FrameGenGhostingFixVignetteOnFootEditorContext', function(self, vignetteOnFootEditor, wrappedMethod)
      self.vignetteOnFootEditor = false
      self:FrameGenGhostingFixVignetteOnFootEditorTurnOff()
      self:FrameGenGhostingFixVignetteOnFootSetDimensions()
    end)
  else
    Globals.Print(Calculate.__NAME, LogText.globals_controller_missing)
  end
end

------------------
-- Local UI
------------------

local function GameFrameGenerationOffCaseUI()
  if ImGui.BeginTabItem(OnFootText.tab_name_on_foot) then
    ImGui.Text("")
    ImGuiExt.Text(SettingsText.info_game_frame_gen_required, true)
    ImGui.Text("")

    ImGui.EndTabItem()
  end
end

function Calculate.DrawUI()
  if not Tracker.IsGameFrameGeneration() then
    GameFrameGenerationOffCaseUI()
  
    return
  end

  local cornersOnWeaponBool, cornersOnWeaponToggle
  local blockerOnAimBool, blockerOnAimToggle
  local vignetteOnAimBool, vignetteOnAimToggle
  local vignetteOnWeaponBool, vignetteOnWeaponToggle
  local vignettePermamentBool, vignettePermamentToggle
  local vignetteScaleToggle = {}
  local vignettePositionToggle = {}
  local vignetteScale = {}
  local vignettePosition = {}
  local opacityMaxFloat, opacityMaxToggle

  if ImGui.BeginTabItem(OnFootText.tab_name_on_foot) then

    ImGuiExt.Text(GeneralText.group_general)
    ImGui.Separator()

    cornersOnWeaponBool, cornersOnWeaponToggle = ImGuiExt.Checkbox(OnFootText.chk_bottom_corners_masks, GetCornersState('onWeapon'))
    if cornersOnWeaponToggle then
      SetCornersState('onWeapon', cornersOnWeaponBool)
      SaveUserSettings()

      ImGuiExt.SetStatusBar(OnFootText.status_reload_accept_changes)
    end
    ImGuiExt.SetTooltip(OnFootText.tooltip_bottom_corners_masks)

    blockerOnAimBool, blockerOnAimToggle = ImGuiExt.Checkbox(OnFootText.chk_blocker_aim, GetBlockerState('onAim'))
    if blockerOnAimToggle then
      SetBlockerState('onAim', blockerOnAimBool)
      ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)

      if GetVignetteState('onAim') then
        
        SetVignetteState('onAim', false)

        ImGuiExt.SetStatusBar(OnFootText.status_aim)
      end

      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(OnFootText.tooltip_blocker_aim)

    ImGui.Text("")
    ImGuiExt.Text(GeneralText.group_fps120)
    ImGui.Separator()

    vignetteOnAimBool, vignetteOnAimToggle = ImGuiExt.Checkbox(OnFootText.chk_vignette_aim, GetVignetteState('onAim'))
    if vignetteOnAimToggle then
      SetVignetteState('onAim', vignetteOnAimBool)
      ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)

      if GetBlockerState('onAim') then
        SetBlockerState('onAim', false)

        ImGuiExt.SetStatusBar(OnFootText.status_aim)
      end

      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(OnFootText.tooltip_vignette_aim)

    vignetteOnWeaponBool, vignetteOnWeaponToggle = ImGuiExt.Checkbox(OnFootText.chk_vignette, GetVignetteState('onWeapon'))
    if vignetteOnWeaponToggle then
      SetVignetteState('onWeapon', vignetteOnWeaponBool)
      SaveUserSettings()
      
      ImGuiExt.SetStatusBar(OnFootText.status_reload_accept_changes)
    end
    ImGuiExt.SetTooltip(OnFootText.tooltip_vignette)

    if GetVignetteState('onWeapon') then
      if not Tracker.IsVehicleMounted() then
        vignettePermamentBool, vignettePermamentToggle = ImGuiExt.Checkbox(OnFootText.chk_vignette_permament, GetVignetteState('permament'))
        if vignettePermamentToggle then
          SetVignetteState('permament', vignettePermamentBool)
          SaveUserSettings()

          ImGuiExt.SetStatusBar(OnFootText.status_reload_accept_changes)
        end
        ImGuiExt.SetTooltip(OnFootText.tooltip_vignette_permament)

        if GetVignetteState('onAim') and GetVignetteState('onWeapon') then
          ImGui.Text("")
          ImGuiExt.Text(OnFootText.info_dimming, true)
        end

        --customize vignette interface starts------------------------------------------------------------------------------------------------------------------
        ImGui.Text("")
        ImGuiExt.Text(OnFootText.info_vignette, true)
        ImGui.Text("")
        ImGuiExt.Text(OnFootText.slider_vignette_width)
      
        vignetteScale.x, vignetteScaleToggle.x = ImGui.SliderFloat("##Scale X", GetVignetteScale('x'), GetVignetteScale('x', 'Min'), GetVignetteScale('x', 'Max'), "%.0f")
        if vignetteScaleToggle.x then
          SetVignetteScale('x', vignetteScale.x)
          Calculate.OnVignetteChange('x')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_save_reminder)
        end
      
        ImGuiExt.Text(OnFootText.slider_vignette_height)
      
        vignetteScale.y, vignetteScaleToggle.y = ImGui.SliderFloat("##Scale Y", GetVignetteScale('y'), GetVignetteScale('y', 'Min'), GetVignetteScale('y', 'Max'), "%.0f")
        if vignetteScaleToggle.y then
          SetVignetteScale('y', vignetteScale.y)
          Calculate.OnVignetteChange('y')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_save_reminder)
        end
      
        ImGuiExt.Text(OnFootText.slider_vignette_pos_x)
      
        vignettePosition.x, vignettePositionToggle.x = ImGui.SliderFloat("##Pos. X", GetVignetteScreenPosition('x'), GetVignetteScreenPosition('x', 'Min'), GetVignetteScreenPosition('x', 'Max'), "%.0f")
        if vignettePositionToggle.x then
          SetVignetteScreenPosition('x', vignettePosition.x)
          Calculate.OnVignetteChange('x')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_save_reminder)
        end
      
        ImGuiExt.Text(OnFootText.slider_vignette_pos_y)
      
        vignettePosition.y, vignettePositionToggle.y = ImGui.SliderFloat("##Pos. Y", GetVignetteScreenPosition('y'), GetVignetteScreenPosition('y', 'Min'), GetVignetteScreenPosition('y', 'Max'), "%.0f")
        if vignettePositionToggle.y then
          SetVignetteScreenPosition('y', vignettePosition.y)
          Calculate.OnVignetteChange('y')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_save_reminder)
        end

        ImGuiExt.Text(OnFootText.slider_masking_strength)
      
        opacityMaxFloat, opacityMaxToggle = ImGui.SliderFloat("##Opacity", MasksData.Opacity.max * 50, 1, 2.5, "%.1f")
        if opacityMaxToggle then
          MasksData.Opacity.max = opacityMaxFloat * 0.02
          MasksData.Opacity.changeStep = opacityMaxFloat * 0.005
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_save_reminder)
        end
      
        ImGui.Text("")
      
        if ImGui.Button(SettingsText.btn_default, 234 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
          Calculate.SetVignetteDefault('x')
          Calculate.SetVignetteDefault('y')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_default)
        end
      
        ImGui.SameLine()
      
        if ImGui.Button(SettingsText.btn_save_settings, 234 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
          SaveUserSettings()

          ImGuiExt.SetStatusBar(SettingsText.status_settings_saved)
        end
      else
        ImGuiExt.SetStatusBar(OnFootText.status_get_out)
      end
    else
      SetVignetteState('permament', false)
    end

    ImGui.EndTabItem()
  end
end

return Calculate