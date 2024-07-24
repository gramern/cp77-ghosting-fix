local Calculate = {
  __NAME = "Calculate",
  __VERSION = { 5, 0, 0 },
  MaskingGlobal = {
    masksController = nil,
    onFoot = true -- not used for now
  },
  Screen = {
    Edge = {
      down = 2160,
      left = 0,
      right = 3840,
    },
    type = 169,
  },
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
  },
}

local UserSettings = {}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")

local LogText = Localization.LogText
local UIText = Localization.UIText


function Calculate.SetVignetteScreenPosition(coordinate, value)
  Calculate.Vignette.ScreenPosition[coordinate] = value

  Calculate.GetVignetteScreenSpace(coordinate)
end

function Calculate.GetVignetteScreenSpace(coordinate)
  local floor = math.floor
  local newSpace = 0

  newSpace = Calculate.Vignette.Def.ScreenSpace[coordinate] * (Calculate.Vignette.ScreenPosition[coordinate] / 100)
  Calculate.Vignette.ScreenSpace[coordinate] = (floor(newSpace + 0.5))

  -- print("Vignette position and screen space",coordinate,Calculate.Vignette.ScreenPosition[coordinate],Calculate.Vignette.ScreenSpace[coordinate])

  return Calculate.Vignette.ScreenSpace
end

function Calculate.SetVignetteScale(coordinate, value)
  Calculate.Vignette.Scale[coordinate] = value

  Calculate.OnVignetteChange(coordinate)
  Calculate.GetVignetteSize(coordinate)
end

function Calculate.GetVignetteSize(coordinate)
  local floor = math.floor
  local newSize = 0

   newSize = Calculate.Vignette.Def.Size[coordinate] * (Calculate.Vignette.Scale[coordinate] / 100)
   Calculate.Vignette.Size[coordinate] = (floor(newSize + 0.5))

  -- print("Vignette scale and size",coordinate,Calculate.Vignette.Scale[coordinate],Calculate.Vignette.Size[coordinate])

  return Calculate.Vignette.Size
end

function Calculate.OnVignetteChange(coordinate)
  local scaleChange = Calculate.Vignette.Scale[coordinate] - Calculate.Vignette.Scale.Min[coordinate]

  Calculate.Vignette.ScreenPosition.Min[coordinate] = 100 - scaleChange
  Calculate.Vignette.ScreenPosition.Max[coordinate] = 100 + scaleChange

  if Calculate.Vignette.ScreenPosition[coordinate] < Calculate.Vignette.ScreenPosition.Min[coordinate] then
    Calculate.Vignette.ScreenPosition[coordinate] = Calculate.Vignette.ScreenPosition.Min[coordinate]
  end

  if Calculate.Vignette.ScreenPosition[coordinate] > Calculate.Vignette.ScreenPosition.Max[coordinate] then
    Calculate.Vignette.ScreenPosition[coordinate] = Calculate.Vignette.ScreenPosition.Max[coordinate]
  end

  Calculate.GetVignetteSize(coordinate)
  Calculate.GetVignetteScreenSpace(coordinate)
end

function Calculate.SetVignetteDefault(coordinate)
  Calculate.SetVignetteScreenPosition(coordinate, Calculate.Vignette.Def.ScreenPosition[coordinate])
  Calculate.SetVignetteScale(coordinate, Calculate.Vignette.Def.Scale[coordinate])
end

--other getters

function Calculate.GetCornersScreenSpace()
  return  Calculate.Corners.ScreenSpace
end

function Calculate.GetBlockerSize()
  return Calculate.Blocker.Size
end

function Calculate.GetVignetteScreenPosition()
  return Calculate.Vignette.ScreenPosition
end

function Calculate.GetVignetteScale()
  return Calculate.Vignette.Scale
end

--appliers

function Calculate.ApplyCornersScreenSpace()
  local screenType = Calculate.Screen.type
  local screenEdge = Calculate.Screen.Edge

  Calculate.Corners.ScreenSpace.Left.x = screenEdge.left
  Calculate.Corners.ScreenSpace.Right.x = screenEdge.right

  if screenType == 43 then
    Calculate.Corners.ScreenSpace.Bottom.y = 2440
  elseif screenType == 1610 then
    Calculate.Corners.ScreenSpace.Bottom.y = 2280
  else
    Calculate.Corners.ScreenSpace.Bottom.y = screenEdge.down
  end

  -- print("Corners screen space",Calculate.Corners.ScreenSpace.Left.x,Calculate.Corners.ScreenSpace.Right.x,Calculate.Corners.ScreenSpace.Bottom.y)
end

function Calculate.ApplyBlockerSize()
  local screenType = Calculate.Screen.type

  if screenType == 43 then
    Calculate.Blocker.Size = {x = 3840, y = 3074}
  elseif screenType == 169 then
    Calculate.Blocker.Size = {x = 3840, y = 2440}
  elseif screenType == 1610 then
    Calculate.Blocker.Size = {x = 3840, y = 2640}
  elseif screenType == 219 then
    Calculate.Blocker.Size = {x = 5140, y = 2440}
  elseif screenType == 329 then
    Calculate.Blocker.Size = {x = 7700, y = 2640}
  end
  -- print("Blocker size:",Calculate.Blocker.Size.x,Calculate.Blocker.Size.y)
end

function Calculate.ApplyVignetteSize()
  local screenType = Calculate.Screen.type

  if screenType == 43 then
    Calculate.Vignette.Def.Size = {x = 4840, y = 3072}
  elseif screenType == 169 then
    Calculate.Vignette.Def.Size = {x = 4840, y = 2560}
  elseif screenType == 1610 then
    Calculate.Vignette.Def.Size = {x = 4840, y = 2880}
  elseif screenType == 219 then
    Calculate.Vignette.Def.Size = {x = 6460, y = 2560}
  elseif screenType == 329 then
    Calculate.Vignette.Def.Size = {x = 9680, y = 2560}
  end
  -- print("Vignette default size:",Calculate.Vignette.Def.Size.x,Calculate.Vignette.Def.Size.y)
end

function Calculate.ApplyExceptions()
  if Calculate.Screen.type == 43 then
    Calculate.Vignette.Scale.Min.y = 95
  end
end

function Calculate.ApplyMasksController()
  Calculate.MaskingGlobal.masksController = Globals.GetMasksController()
end

function Calculate.ApplyScreen()
  local screen = Globals.GetScreen()

  Calculate.Screen.Edge = screen.Edge
  Calculate.Screen.type = screen.type
end

function Calculate.GetUserSettings()
  UserSettings = {
    Blocker = {onAim = Calculate.Blocker.onAim},
    Corners = {onWeapon = Calculate.Corners.onWeapon},
    Vignette = {
      permament = Calculate.Vignette.permament,
      onAim = Calculate.Vignette.onAim,
      onWeapon = Calculate.Vignette.onWeapon,
      ScreenPosition = {x = Calculate.Vignette.ScreenPosition.x, y = Calculate.Vignette.ScreenPosition.y},
      Scale = {x = Calculate.Vignette.Scale.x, y = Calculate.Vignette.Scale.y},
    }
  }

  return UserSettings
end

function Calculate.ApplySuggestedSettings(averageFps)
  Globals.SetFallback("Calculate",Calculate.GetUserSettings())

  if averageFps >= 38 then
    Calculate.Corners.onWeapon = true
  else
    Calculate.Corners.onWeapon = false
  end

  if averageFps >= 45 then
    Calculate.Blocker.onAim = true
    Calculate.Vignette.onAim = false
  else
    Calculate.Blocker.onAim = false
    Calculate.Vignette.onAim = false
  end

  if averageFps >= 59 then
    Calculate.Vignette.onWeapon = true
  else
    Calculate.Vignette.onWeapon = false
  end

  if averageFps >= 65 then
    Calculate.Vignette.permament = true
  else
    Calculate.Vignette.permament = false
  end

  Calculate.Toggle()

  Calculate.SaveUserSettings()

  Globals.Print(Calculate.__NAME,LogText.calculate_applySettings)
end

function Calculate.SaveUserSettings()
  Settings.WriteUserSettings("Calculate",Calculate.GetUserSettings())
end

function Calculate.RestoreUserSettings()
  Calculate = Globals.SafeMergeTables(Calculate,Globals.GetFallback("Calculate"))

  if Calculate == nil then Globals.Print(Calculate.__NAME,"Can't restore user settings.") end
  Calculate.SaveUserSettings()
end

function Calculate.OnInitialize()
  Globals.SafeMergeTables(Calculate,Settings.GetUserSettings("Calculate"))
  Calculate.ApplyMasksController()
  Calculate.ApplyScreen()
  Calculate.ApplyCornersScreenSpace()
  Calculate.ApplyBlockerSize()
  Calculate.ApplyVignetteSize()
  Calculate.ApplyExceptions()
  Calculate.GetVignetteScreenSpace('x')
  Calculate.GetVignetteScreenSpace('y')
  Calculate.GetVignetteSize('x')
  Calculate.GetVignetteSize('y')
  Calculate.Toggle()
end

function Calculate.OnOverlayOpen()
  Globals = require("Modules/Globals")

  --refresh UIText in case of translation
  Localization = require("Modules/Localization")
  UIText = Localization.UIText
end

function Calculate.OnOverlayClose()
  Calculate.ApplyScreen()
  Calculate.ApplyCornersScreenSpace()
  Calculate.ApplyBlockerSize()
  Calculate.ApplyVignetteSize()
  Calculate.ApplyExceptions()
  Calculate.GetVignetteScreenSpace('x')
  Calculate.GetVignetteScreenSpace('y')
  Calculate.GetVignetteSize('x')
  Calculate.GetVignetteSize('y')
  Calculate.Toggle()
  Calculate.TurnOffLiveView()
end

function Calculate.Toggle()
  Calculate.ToggleCornersOnWeapon()
  Calculate.ToggleBlockerOnAim()
  Calculate.ToggleVignetteOnAim()
  Calculate.ToggleVignetteOnWeapon()
  Calculate.ToggleVignettePermament()
end

function Calculate.ToggleCornersOnWeapon()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    local edge = Calculate.Screen.Edge

    Override(masksController, 'FrameGenGhostingFixOnFootToggleEvent', function(self, wrappedMethod)
      local originalOnFoot = wrappedMethod()

      if not Calculate.Corners.onWeapon then return originalOnFoot end
      self:FrameGenGhostingFixOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent', function(self)
      self:FrameGenGhostingFixMasksOnFootSetMargins(edge.left, edge.right, edge.down)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.ToggleBlockerOnAim()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    local size = Calculate.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixBlockerAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalBlockerAim = wrappedMethod()

      if not Calculate.Blocker.onAim then return originalBlockerAim end
      self:FrameGenGhostingFixBlockerAimOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.ToggleVignetteOnAim()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    local size = Calculate.Blocker.Size

    Override(masksController, 'FrameGenGhostingFixVignetteAimOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignetteAim = wrappedMethod()

      if not Calculate.Vignette.onAim then return originalVignetteAim end
      self:FrameGenGhostingFixVignetteAimOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent', function(self)
      self:FrameGenGhostingFixAimOnFootSetDimensionsToggle(size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.ToggleVignetteOnWeapon()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    local space = Calculate.Vignette.ScreenSpace
    local size = Calculate.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootToggleEvent', function(self, wrappedMethod)
      local originalVignette = wrappedMethod()

      if not  Calculate.Vignette.onWeapon then return originalVignette end
      self:FrameGenGhostingFixVignetteOnFootToggle(true)
    end)

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent', function(self, wrappedMethod)
      local originalVignetteDimensions = wrappedMethod()

      if not Calculate.Vignette.onWeapon then return originalVignetteDimensions end
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(space.x, space.y, size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.ToggleVignettePermament()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    Override(masksController, 'FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent', function(self, wrappedMethod)
      local originalFunction = wrappedMethod()

      if not Calculate.Vignette.permament then return originalFunction end
      self:FrameGenGhostingFixVignetteOnFootDeActivationToggle(true)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.TurnOnLiveView()
  local masksController = Calculate.MaskingGlobal.masksController

  if masksController then
    local space = Calculate.Vignette.ScreenSpace
    local size = Calculate.Vignette.Size

    Override(masksController, 'FrameGenGhostingFixVignetteOnFootEditorToggle', function(self)
      self:FrameGenGhostingFixVignetteOnFootEditorContext(true)
      self:FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(space.x, space.y, size.x, size.y)
    end)
  else
    Globals.Print(Calculate.__NAME,LogText.globals_controllerMissing)
  end
end

function Calculate.TurnOffLiveView()
  local masksController = Calculate.MaskingGlobal.masksController

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

--Local UI
local cornersOnWeaponToggle
local blockerOnAimToggle
local vignetteOnAimToggle
local vignetteOnWeaponToggle
local vignettePermamentToggle
local vignetteScaleToggle = {}
local vignettePositionToggle = {}

local vignetteScale = Calculate.Vignette.Scale
local vignettePosition = Calculate.Vignette.ScreenPosition

function Calculate.DrawUI()
  if ImGui.BeginTabItem(UIText.OnFoot.tabname) then
    ImGuiExt.Text(UIText.General.title_general)
    ImGui.Separator()

    Calculate.Corners.onWeapon, cornersOnWeaponToggle = ImGuiExt.Checkbox(UIText.OnFoot.BottomCornersMasks.name, Calculate.Corners.onWeapon)
    if cornersOnWeaponToggle then
      Calculate.SaveUserSettings()

      ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.BottomCornersMasks.tooltip)

    Calculate.Blocker.onAim, blockerOnAimToggle = ImGuiExt.Checkbox(UIText.OnFoot.BlockerAim.name, Calculate.Blocker.onAim)
    if blockerOnAimToggle then
      ImGuiExt.SetStatusBar(UIText.General.settings_saved)

      if Calculate.Vignette.onAim then
        
        Calculate.Vignette.onAim = false

        ImGuiExt.SetStatusBar(UIText.General.info_aimOnFoot)
      end

      Calculate.SaveUserSettings()
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.BlockerAim.tooltip)

    ImGui.Text("")
    ImGuiExt.Text(UIText.General.title_fps120)
    ImGui.Separator()

    Calculate.Vignette.onAim, vignetteOnAimToggle = ImGuiExt.Checkbox(UIText.OnFoot.VignetteAim.name, Calculate.Vignette.onAim)
    if vignetteOnAimToggle then
      ImGuiExt.SetStatusBar(UIText.General.settings_saved)

      if Calculate.Blocker.onAim then
        Calculate.Blocker.onAim = false

        ImGuiExt.SetStatusBar(UIText.General.info_aimOnFoot)
      end

      Calculate.SaveUserSettings()
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.VignetteAim.tooltip)

    Calculate.Vignette.onWeapon, vignetteOnWeaponToggle = ImGuiExt.Checkbox(UIText.OnFoot.Vignette.name, Calculate.Vignette.onWeapon)
    if vignetteOnWeaponToggle then
      Calculate.SaveUserSettings()

      ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
    end
    ImGuiExt.SetTooltip(UIText.OnFoot.Vignette.tooltip)

    if Calculate.Vignette.onWeapon then
      if not Globals.IsMounted() then
        Calculate.Vignette.permament, vignettePermamentToggle = ImGuiExt.Checkbox(UIText.OnFoot.VignettePermament.name, Calculate.Vignette.permament)
        if vignettePermamentToggle then
          Calculate.SaveUserSettings()

          ImGuiExt.SetStatusBar(UIText.General.settings_applied_onfoot)
        end
        ImGuiExt.SetTooltip(UIText.OnFoot.VignettePermament.tooltip)

        if Calculate.Vignette.onAim and Calculate.Vignette.onWeapon then
          ImGui.Text("")
          ImGuiExt.Text(UIText.OnFoot.VignetteAim.textfield_1)
        end
        --customize vignette interface starts------------------------------------------------------------------------------------------------------------------
        ImGui.Text("")
        ImGuiExt.Text(UIText.OnFoot.Vignette.textfield_1)
        ImGui.Text("")
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_1)
      
        vignetteScale.x, vignetteScaleToggle.x = ImGui.SliderFloat("##Scale X", vignetteScale.x, vignetteScale.Min.x, vignetteScale.Max.x, "%.0f")
        if vignetteScaleToggle.x then
          Calculate.OnVignetteChange('x')
          Calculate.TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_2)
      
        vignetteScale.y, vignetteScaleToggle.y = ImGui.SliderFloat("##Scale Y", vignetteScale.y, vignetteScale.Min.y, vignetteScale.Max.y, "%.0f")
        if vignetteScaleToggle.y then
          Calculate.OnVignetteChange('y')
          Calculate.TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_3)
      
        vignettePosition.x, vignettePositionToggle.x = ImGui.SliderFloat("##Pos. X", vignettePosition.x, vignettePosition.Min.x, vignettePosition.Max.y, "%.0f")
        if vignettePositionToggle.x then
          Calculate.OnVignetteChange('x')
          Calculate.TurnOnLiveView()
        end
      
        ImGuiExt.Text(UIText.OnFoot.Vignette.setting_4)
      
        vignettePosition.y, vignettePositionToggle.y = ImGui.SliderFloat("##Pos. Y", vignettePosition.y, vignettePosition.Min.y, vignettePosition.Max.y, "%.0f")
        if vignettePositionToggle.y then
          Calculate.OnVignetteChange('y')
          Calculate.TurnOnLiveView()
        end
      
        ImGui.Text("")
      
        if ImGui.Button(UIText.General.default, 240, 40) then
          Calculate.SetVignetteDefault('x')
          Calculate.SetVignetteDefault('y')
          Calculate.TurnOnLiveView()

          ImGuiExt.SetStatusBar(UIText.General.settings_default)
        end
      
        ImGui.SameLine()
      
        if ImGui.Button(UIText.General.settings_save, 240, 40) then
          Calculate.SaveUserSettings()

          ImGuiExt.SetStatusBar(UIText.General.settings_saved)
        end
      else
        ImGuiExt.SetStatusBar(UIText.General.info_getOut)
      end
    else
      if Calculate.Vignette.permament then
        Calculate.Vignette.permament = false
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

    ImGui.EndTabItem()
  end
end

return Calculate