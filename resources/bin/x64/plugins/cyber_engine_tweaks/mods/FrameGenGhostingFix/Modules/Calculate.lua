local Calculate = {
  __NAME = "Calculate",
  __VERSION = { 5, 0, 0 },
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
        y = 80,
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
      y = 80,
    },
    ScreenSpace = {x = 1920, y = 1080},
    Size = {x = 4840, y = 2560},
  }
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local LogText = Localization.LogText
local UIText = Localization.UIText

------------------
-- UserSettings
------------------

local function GetUserSettings()
  UserSettings = {
    Blocker = {onAim = MasksData.Blocker.onAim},
    Corners = {onWeapon = MasksData.Corners.onWeapon},
    Vignette = {
      permament = MasksData.Vignette.permament,
      onAim = MasksData.Vignette.onAim,
      onWeapon = MasksData.Vignette.onWeapon,
      ScreenPosition = {x = MasksData.Vignette.ScreenPosition.x, y = MasksData.Vignette.ScreenPosition.y},
      Scale = {x = MasksData.Vignette.Scale.x, y = MasksData.Vignette.Scale.y},
    }
  }

  return UserSettings
end

local function LoadUserSettings()
  Globals.SafeMergeTables(MasksData, Settings.GetUserSettings("Calculate"))
end

local function SaveUserSettings()
  Settings.WriteUserSettings("Calculate", GetUserSettings())
end

local function BackupUserSettings()
  Globals.SetFallback("Calculate", GetUserSettings())
end

function Calculate.RestoreUserSettings()
  Calculate = Globals.SafeMergeTables(MasksData, Globals.GetFallback("Calculate"))

  if Calculate == nil then Globals.Print(Calculate.__NAME, "Can't restore user settings.") end
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
local function SetVignetteDefault(coordinate)
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

  if averageFps >= 38 then
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

  if averageFps >= 59 then
    MasksData.Vignette.onWeapon = true
  else
    MasksData.Vignette.onWeapon = false
  end

  if averageFps >= 65 then
    MasksData.Vignette.permament = true
  else
    MasksData.Vignette.permament = false
  end

  Toggle()

  SaveUserSettings()

  Globals.Print(Calculate.__NAME, LogText.calculate_applySettings)
end

------------------
-- On... registers
------------------

function Calculate.OnInitialize()
  LoadUserSettings()
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
  Toggle()
end

function Calculate.OnOverlayOpen()
  Globals = require("Modules/Globals")

  --refresh UIText in case of translation
  Localization = require("Modules/Localization")
  UIText = Localization.UIText
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
  Toggle()
  TurnOffLiveView()
end

------------------
-- Toggle RedScript Methods
------------------

function Toggle()
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

    Override(masksController, 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
      local originalOnFoot = wrappedMethod()

      if not MasksData.Corners.onWeapon then return originalOnFoot end
      self:FrameGenGhostingFixOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
      self:FrameGenGhostingFixMasksOnFootSetMargins(edge.left, edge.right, edge.down)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function ToggleBlockerOnAim()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local size = MasksData.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalBlockerAim = wrappedMethod()

      if not MasksData.Blocker.onAim then return originalBlockerAim end
      self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function ToggleVignetteOnAim()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local size = MasksData.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignetteAim = wrappedMethod()

      if not MasksData.Vignette.onAim then return originalVignetteAim end
      self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function ToggleVignetteOnWeapon()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local space = MasksData.Vignette.ScreenSpace
    local size = MasksData.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignette = wrappedMethod()

      if not  MasksData.Vignette.onWeapon then return originalVignette end
      self:FrameGenGhostingFixVignetteOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
      local originalVignetteDimensions = wrappedMethod()

      if not MasksData.Vignette.onWeapon then return originalVignetteDimensions end
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(space.x, space.y, size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function ToggleVignettePermament()
  local masksController = MaskingGlobal.masksController

  if masksController then
    Override(masksController, 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
      local originalFunction = wrappedMethod()

      if not MasksData.Vignette.permament then return originalFunction end
      self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function TurnOnLiveView()
  local masksController = MaskingGlobal.masksController

  if masksController then
    local space = MasksData.Vignette.ScreenSpace
    local size = MasksData.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
      self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(space.x, space.y, size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function TurnOffLiveView()
  local masksController = MaskingGlobal.masksController

  if masksController then
    Override(masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
      self:FrameGenGhostingFixVignetteOnFootEditorContext(false)
      self:FrameGenGhostingFixVignetteOnFootEditorTurnOff()
      self:FrameGenGhostingFixVignetteOnFootSetDimensions()
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

------------------
-- Local UI
------------------

local cornersOnWeaponBool, cornersOnWeaponToggle
local blockerOnAimBool, blockerOnAimToggle
local vignetteOnAimBool, vignetteOnAimToggle
local vignetteOnWeaponBool, vignetteOnWeaponToggle
local vignettePermamentBool, vignettePermamentToggle
local vignetteScaleToggle = {}
local vignettePositionToggle = {}
local vignetteScale = {}
local vignettePosition = {}

function Calculate.DrawUI()
  if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
    ImGuiExt.Text(UIText.General.title_general)
    ImGui.Separator()

    cornersOnWeaponBool, cornersOnWeaponToggle = ImGuiExt.Checkbox(UIText.OnFoot.BottomCornersMasks.name, GetCornersState("onWeapon"))
    if cornersOnWeaponToggle then
      SetCornersState("onWeapon", cornersOnWeaponBool)
      SaveUserSettings()

      ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)

    blockerOnAimBool, blockerOnAimToggle = ImGuiExt.Checkbox(UIText.OnFoot.BlockerAim.name, GetBlockerState("onAim"))
    if blockerOnAimToggle then
      SetBlockerState("onAim", blockerOnAimBool)
      ImGuiExt.SetStatusBar(UIText.General.settings_saved)

      if GetVignetteState("onAim") then
        
        SetVignetteState("onAim", false)

        ImGuiExt.SetStatusBar(UIText.General.info_aimOnFoot)
      end

      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.BlockerAim.tooltip)

    ImGui.Text("")
    ImGuiExt.Text(UIText.General.title_fps120)
    ImGui.Separator()

    vignetteOnAimBool, vignetteOnAimToggle = ImGuiExt.Checkbox(UIText.OnFoot.VignetteAim.name, GetVignetteState("onAim"))
    if vignetteOnAimToggle then
      SetVignetteState("onAim", vignetteOnAimBool)
      ImGuiExt.SetStatusBar(UIText.General.settings_saved)

      if GetBlockerState("onAim") then
        SetBlockerState("onAim", false)

        ImGuiExt.SetStatusBar(UIText.General.info_aimOnFoot)
      end

      SaveUserSettings()
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)

    vignetteOnWeaponBool, vignetteOnWeaponToggle = ImGuiExt.Checkbox(UIText.OnFoot.Vignette.name, GetVignetteState("onWeapon"))
    if vignetteOnWeaponToggle then
      SetVignetteState("onWeapon", vignetteOnWeaponBool)
      SaveUserSettings()
      
      ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.Vignette.tooltip)

    if GetVignetteState("onWeapon") then
      if not Tracker.IsVehicleMounted() then
        vignettePermamentBool, vignettePermamentToggle = ImGuiExt.Checkbox(UIText.OnFoot.VignettePermament.name, GetVignetteState("permament"))
        if vignettePermamentToggle then
          SetVignetteState("permament", vignettePermamentBool)
          SaveUserSettings()

          ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
        end
        ImGuiExt.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)

        if GetVignetteState("onAim") and GetVignetteState("onWeapon") then
          ImGui.Text("")
          ImGuiExt.Text(UIText.OnFoot.VignetteAim.textfield_1)
        end

        --customize vignette interface starts------------------------------------------------------------------------------------------------------------------
        ImGui.Text("")
        ImGuiExt.Text(UIText.OnFoot.Vignette.textfield_1)
        ImGui.Text("")
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_1)
      
        vignetteScale.x, vignetteScaleToggle.x = ImGui.SliderFloat("##Scale X", GetVignetteScale("x"), GetVignetteScale("x", "Min"), GetVignetteScale("x", "Max"), "%.0f")
        if vignetteScaleToggle.x then
          SetVignetteScale("x", vignetteScale.x)
          Calculate.OnVignetteChange('x')
          TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_2)
      
        vignetteScale.y, vignetteScaleToggle.y = ImGui.SliderFloat("##Scale Y", GetVignetteScale("y"), GetVignetteScale("y", "Min"), GetVignetteScale("y", "Max"), "%.0f")
        if vignetteScaleToggle.y then
          SetVignetteScale("y", vignetteScale.y)
          Calculate.OnVignetteChange('y')
          TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_3)
      
        vignettePosition.x, vignettePositionToggle.x = ImGui.SliderFloat("##Pos. X", GetVignetteScreenPosition("x"), GetVignetteScreenPosition("x", "Min"), GetVignetteScreenPosition("x", "Max"), "%.0f")
        if vignettePositionToggle.x then
          SetVignetteScreenPosition("x", vignettePosition.x)
          Calculate.OnVignetteChange('x')
          TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_4)
      
        vignettePosition.y, vignettePositionToggle.y = ImGui.SliderFloat("##Pos. Y", GetVignetteScreenPosition("y"), GetVignetteScreenPosition("y", "Min"), GetVignetteScreenPosition("y", "Max"), "%.0f")
        if vignettePositionToggle.y then
          SetVignetteScreenPosition("y", vignettePosition.y)
          Calculate.OnVignetteChange('y')
          TurnOnLiveView()
        end
      
        ImGui.Text("")
      
        if ImGui.Button(UIText.General.default, 240 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
          SetVignetteDefault('x')
          SetVignetteDefault('y')
          TurnOnLiveView()

          ImGuiExt.SetStatusBar(UIText.General.settings_default)
        end
      
        ImGui.SameLine()
      
        if ImGui.Button(UIText.General.settings_save, 240 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
          SaveUserSettings()

          ImGuiExt.SetStatusBar(UIText.General.settings_saved)
        end
      else
        ImGuiExt.SetStatusBar(UIText.General.info_getOut)
      end
    else
      if GetVignetteState("permament") then
        SetVignetteState("permament", false)
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

    ImGui.EndTabItem()
  end
end

return Calculate