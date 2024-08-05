local VectorsEditor = {
  __NAME = "VectorsEditor",
  __VERSION = { 5, 0, 0 },
}

local PresetsList = {}

local SortedPresets = {}

local selectedPreset = nil

local selectedPresetName = nil

local LoadedPreset = {}

local isRandomSeed = false

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")
local Vectors = require("Modules/Vectors")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
local VehiclesText = Localization.GetVehiclesText()

local random, randomseed = math.random, math.randomseed

----------------------------------------------------------------------------------------------------------------------
-- Local UI Variables
----------------------------------------------------------------------------------------------------------------------

local screenWidth, screenHeight
local isInstance = false
local isLoadWindow = false
local isSaveWindow = false

local camera = Vectors.GetCameraData()
local cameraOptionsTextWidth
local perspectiveToggle = true

local isPreviewMode = false
local isPreviewModeToggle

local presetName = ""
local presetDescription = ""
local presetAuthor = ""
local presetFile = ""

local bikeAllMasksFPPToggle
local bikeAllMasksTPPToggle
local bikeSideMasksScale = {}
local bikeSideMasksScaleToggle = {}
local bikeWindshieldScale = {}
local bikeWindshieldScaleToggle = {}

local carAllMasksFPPToggle
local carFrontMaskToggle
local carRearMaskToggle
local carSideMasksToggle
local carSideMasksScale = {}
local carSideMasksScaleToggle = {}

local hedCornersToggle
local hedFillToggle
local hedFillLockToggle
local hedTrackerToggle
local hedScale = {}
local hedScaleToggle = {}
local hedLockToggle

local opacityHed
local opacityHedToggle
local maxOpacityHed = 6
local opacityMasks
local opacityMasksToggle
local maxOpacityMasks = 12
local opacityLockToggle

----------------------------------------------------------------------------------------------------------------------
-- Working Presets
----------------------------------------------------------------------------------------------------------------------

local function ResetLoadedPreset()
  LoadedPreset = {}
end

local function LoadPreset()
  local presetPath = "Presets/" .. PresetsList[selectedPreset].file

  local loadedPreset = Globals.LoadJSON(presetPath)

  if loadedPreset then
    ResetLoadedPreset()
    LoadedPreset = Globals.Deepcopy(loadedPreset)
    Globals.SetFallback('VectorsEditor', LoadedPreset)
    Vectors.LoadPreset(LoadedPreset)
  end
end

local function ResetPresetsList()
  PresetsList = {}
  SortedPresets = {}
  selectedPreset = nil
  selectedPresetName = nil
end

local function SetPresetsList(presetsList)
  ResetPresetsList()

  PresetsList = Globals.Deepcopy(presetsList)

  PresetsList.a005 = nil

  for k in pairs(PresetsList) do
    table.insert(SortedPresets, k)
  end

  table.sort(SortedPresets)

  if selectedPreset == nil then
    selectedPreset = "a001"
  end
end

----------------------------------------------------------------------------------------------------------------------
-- Editor Utils
----------------------------------------------------------------------------------------------------------------------

local function ResetUI()
  isLoadWindow, isSaveWindow = false, false

  isPreviewMode = false

  presetName = ""
  presetDescription = ""
  presetAuthor = ""
  presetFile = ""

  bikeSideMasksScale = {}
  bikeSideMasksScaleToggle = {}
  bikeWindshieldScale = {}
  bikeWindshieldScaleToggle = {}

  carSideMasksScale = {}
  carSideMasksScaleToggle = {}

  hedScale = {}
  hedScaleToggle = {}

  opacityHed = nil
  opacityMasks = nil
end

-- @param `opacity`: number; In range 0 - 200
--
-- @return None
local function SetMaxOpacity(opacity)
  maxOpacityHed = opacity /2
  maxOpacityMasks = opacity
end

local function CenterCamera()
  Game.GetPlayer():QueueEvent(vehicleCameraResetEvent.new())
end

local function ApplyPerspective(newPerspective)
  local togglePerspectiveEvt = vehicleRequestCameraPerspectiveEvent.new()
  togglePerspectiveEvt.cameraPerspective = Enum.new("vehicleCameraPerspective", newPerspective)
  Game.GetPlayer():QueueEvent(togglePerspectiveEvt)
end

local function TogglePerspective()
  if not Tracker.IsVehicleMounted() and not Tracker.IsGameReady() then return false, nil end
  local currentPerspective = Vectors.GetCameraData().activePerspective
  local newPerspective

  if not Tracker.IsVehicleWeapon() then -- couldn't trigger camera perspective toggle in a weaponized vehicle so mitigating
    if currentPerspective == vehicleCameraPerspective.FPP then
      newPerspective = 'TPPClose'
    elseif currentPerspective == vehicleCameraPerspective.TPPClose then
      newPerspective = 'TPPMedium'
    elseif currentPerspective == vehicleCameraPerspective.TPPMedium then
      newPerspective = 'TPPFar'
    elseif currentPerspective == vehicleCameraPerspective.TPPFar then
      newPerspective = 'FPP'
    end

    ApplyPerspective(newPerspective)

    return true, newPerspective
  else
    if currentPerspective ~= vehicleCameraPerspective.TPPFar then
      newPerspective = 'TPPFar'
    else
      newPerspective = 'FPP'
    end

    ApplyPerspective(newPerspective)

    return false, newPerspective
  end
end

local function GeneratePresetID()
  local lowercase = "bcdefghijklmnopqrstuvwxyz" -- Eliminating 'a'
  local uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local digits = "0123456789"
  local alphanumeric = lowercase .. uppercase .. digits
  
  -- Start with a random lowercase letter
  local randomIndex = random(1, #lowercase)
  Globals.PrintDebug(VectorsEditor.__NAME, "GeneratePresetID: random index for first char =", randomIndex)

  local id = lowercase:sub(randomIndex, randomIndex)
  Globals.PrintDebug(VectorsEditor.__NAME, "GeneratePresetID: first char: =", id)
  
  for i = 2, 8 do
      local index = random(1, #alphanumeric)
      id = id .. alphanumeric:sub(index, index)
  end
  
  Globals.PrintDebug(VectorsEditor.__NAME, "GeneratePresetID: generated id =", id)
  return id
end

local function SavePreset(presetName, presetAuthor, presetFile, presetDescription, presetId)
  presetFile = presetFile .. ".json"
  local presetFileLowerCase = presetFile:lower()

  for _, id in pairs(PresetsList) do
    if type(id) == "table" and id['file'] ~= nil then
      if presetFileLowerCase == id.file:lower() then
        return false
      end
    end
  end

  local preset = {
    __VERSION = FrameGenGhostingFix.GetVersion(true),
    MaskingGlobal = Globals.Deepcopy(LoadedPreset.MaskingGlobal),
    Vectors = {
      VehElements = Globals.Deepcopy(LoadedPreset.Vectors.VehElements),
      VehMasks = Globals.Deepcopy(LoadedPreset.Vectors.VehMasks),
      Modifiers = Globals.Deepcopy(LoadedPreset.Vectors.Modifiers),
    },
    PresetInfo = {
      name = presetName,
      description = presetDescription,
      author = presetAuthor,
      id = presetId
    }
  }

  local filePath = "Presets/" .. presetFile
  local result = Globals.SaveJSON(filePath, preset)

  return result
end

-- @param `presetsList`: table; Presets to be loaded into the editor
--
-- @return None
function VectorsEditor.SetInstance(presetsList)
  isInstance = true

  if not isRandomSeed then
    local delta = Tracker.GetGameDeltaTime()

    if delta then
      randomseed(delta * 1000000)
      Globals.PrintDebug(VectorsEditor.__NAME, "Func math.randomseed initiated.")
      isRandomSeed = true
    end
  end

  if Settings.IsDebugMode() then
    SetMaxOpacity(200)
    ImGuiExt.SetStatusBar("Presets Editor running in Debug Mode", 'PresetsEditor')
  else
    SetMaxOpacity(12)
    ImGuiExt.SetStatusBar(ImGuiExt.GetStatusBar(), 'PresetsEditor')
  end

  SetPresetsList(presetsList)
  LoadPreset()
end

-- @return None
function VectorsEditor.EndInstance()
  isInstance = false
  ResetUI()
end

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

function VectorsEditor.OnOverlayClose()
  if isInstance then
    Vectors.SetOpacityLock(false)
    Globals.CancelDelay('OpacityLock')
    Globals.CancelDelay('DecoupleOpacityLock1')
    Globals.CancelDelay('DecoupleOpacityLock2')
    Globals.CancelDelay('DecoupleOpacityLock3')
    Globals.CancelDelay('DecoupleOpacityLock4')

    if isPreviewMode then
      Globals.SetDelay(1.5, 'VectorsEditorPreviewHed', Vectors.SetOpacityLock, true, 1)
      Globals.SetDelay(1.5, 'VectorsEditorPreviewNotif', ImGuiExt.SetNotification, 2, "Preview Mode Enabled.")
    end

    if LoadedPreset ~= nil then -- Load current settings for preview
      Globals.SetDelay(1, 'VectorsEditorReloadSettingsNotif', Vectors.LoadPreset, LoadedPreset)
      ImGuiExt.SetNotification(1.2, "Reloading Settings...")
    end
  end
end

----------------------------------------------------------------------------------------------------------------------
-- Local UI
----------------------------------------------------------------------------------------------------------------------

local function FlagSettingChange()
  ImGuiExt.SetStatusBar("Close the overlay without closing the editor to preview current settings.", 'PresetsEditor')
end

local function LoadPresetWindow()
  ImGui.SetNextWindowPos(screenWidth / 2 - 210, screenHeight / 2 - 120)

  if ImGui.Begin("Load Preset", ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoCollapse + ImGuiWindowFlags.None) then

    selectedPresetName = PresetsList[selectedPreset].PresetInfo.name

    ImGui.SetNextItemWidth(410)
    if ImGui.BeginCombo("##Presets", selectedPresetName) then
      for _, presetId in ipairs(SortedPresets) do
        local name = PresetsList[presetId].PresetInfo.name
        local isSelected = (selectedPresetName == name)
        
        if ImGui.Selectable(name, isSelected) then
          selectedPresetName = name
          selectedPreset = PresetsList[presetId].PresetInfo.id
        end
        if isSelected then
          ImGui.SetItemDefaultFocus()
          ImGuiExt.ResetStatusBar()
        end
      end
      ImGui.EndCombo()
    end
    ImGuiExt.SetTooltip("Select a base preset to load its values to the editor.")

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Cancel", 100 * ImGuiExt.GetScaleFactor(), 0) then
      isLoadWindow = false
    end

    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 100 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Load", 100 * ImGuiExt.GetScaleFactor(), 0) then
      LoadPreset()

      local infoLoadedPreset = "Preset loaded: " .. selectedPresetName
      ImGuiExt.SetStatusBar(infoLoadedPreset, 'PresetsEditor')

      isLoadWindow = false
    end
  end

  ImGui.End()
end

local function SavePresetWindow()
  ImGui.SetNextWindowPos(screenWidth / 2 - 210, screenHeight / 2 - 120)

  if ImGui.Begin("Save Preset", ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoCollapse + ImGuiWindowFlags.None) then
    ImGuiExt.Text("Name:")
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetName = ImGui.InputText("##Name", presetName, 30)
    ImGuiExt.SetTooltip("Enter a name for the new preset.")

    ImGuiExt.Text("Author:")
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetAuthor = ImGui.InputText("##Author", presetAuthor, 30)
    ImGuiExt.SetTooltip("Enter an author name for the new preset.")

    ImGuiExt.Text("Description:")
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    presetDescription = ImGui.InputTextMultiline("##Description", presetDescription, 100, 300, 60)
    ImGuiExt.SetTooltip("Enter a description for the new preset.")
    
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text("Characters left:")
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 30 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text(tostring(100 - #presetDescription))

    ImGuiExt.Text("File Name:")
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetFile = ImGui.InputText("##FileName", presetFile, 30)
    ImGuiExt.SetTooltip("Enter a file name for the new preset (no spaces).")

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Cancel", 100 * ImGuiExt.GetScaleFactor(), 0) then
      isSaveWindow = false
      presetName, presetAuthor, presetDescription, presetFile = "", "", "", ""
    end

    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 100 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Save", 100 * ImGuiExt.GetScaleFactor(), 0) then
      if presetName == "" or presetAuthor == "" or presetFile == "" then
        ImGuiExt.SetStatusBar("Fill all fields to save.", 'SavePreset')
      elseif not Globals.AreLettersOnly(presetFile) then
        ImGuiExt.SetStatusBar("You can use letters only in the file name.", 'SavePreset')
      else
        local presetId = GeneratePresetID()
        local result = SavePreset(presetName, presetAuthor, presetFile, presetDescription, presetId)

        if result then
          local infoSavedPreset = "Preset saved: " .. presetFile .. ".json. Close the editor to reload presets list."
          ImGuiExt.SetStatusBar(infoSavedPreset, 'PresetsEditor')
          isSaveWindow = false
          presetName, presetAuthor, presetDescription, presetFile = "", "", "", ""
        else
          ImGuiExt.SetStatusBar("Can't save. Try different file and preset name.", 'SavePreset')
        end
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar('SavePreset'))
  end

  ImGui.End()

end

function VectorsEditor.DrawWindow()
  ImGui.SetNextWindowPos(500, 300, ImGuiCond.FirstUseEver)

  if ImGui.Begin("Presets Editor", ImGuiWindowFlags.AlwaysAutoResize) then
    if not Tracker.IsVehicleMounted() and not Tracker.IsPlayerDriver() then
      ImGuiExt.TextRed("Enter a vehicle first: a bike or a car.")

      ImGui.End()
      return
    end

    if ImGui.Button("Load Preset", 180 * ImGuiExt.GetScaleFactor(), 0) then
      isLoadWindow = not isLoadWindow
      isSaveWindow = false

      screenWidth, screenHeight = Globals.GetScreenResolution()
    end
    ImGuiExt.SetTooltip("Select a base preset to load its values to the editor.")
  
    if isLoadWindow then
      LoadPresetWindow()
    end

    ImGui.SameLine()

    if ImGui.Button("Save Preset", 180 * ImGuiExt.GetScaleFactor(), 0) then
      isSaveWindow = not isSaveWindow
      isLoadWindow = false
      screenWidth, screenHeight = Globals.GetScreenResolution()

      ImGuiExt.SetStatusBar("", 'SavePreset')
    end
    ImGuiExt.SetTooltip("Save your new values as a new preset file. The new preset will be saved in the 'Presets' folder and can be shared with other users of FrameGen Ghosting 'Fix' V.")

    if isSaveWindow then
      SavePresetWindow()
    end

    ImGui.SameLine()
    
    if ImGui.Button("Reset Values", 180 * ImGuiExt.GetScaleFactor(), 0) then
      LoadedPreset = Globals.Deepcopy(Globals.GetFallback('VectorsEditor'))
      Vectors.LoadPreset(LoadedPreset)
    end
    ImGuiExt.SetTooltip("Reset current values to ones found in the loaded preset.")

    ImGui.Separator()

    cameraOptionsTextWidth = ImGui.CalcTextSize("Camera Options:")
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - cameraOptionsTextWidth / 2 - 450 * ImGuiExt.GetScaleFactor() - 3 * ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text("Camera Options:")

    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 360 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Toggle Perspective", 180 * ImGuiExt.GetScaleFactor(), 0) then
      local newPerspective
      perspectiveToggle, newPerspective = TogglePerspective()
      Vectors.SetOpacityLock(false)

      local newStatus = "Current camera perspective: " .. tostring(newPerspective)
      ImGuiExt.SetStatusBar(newStatus, 'PresetsEditor')

      if not perspectiveToggle then
        ImGuiExt.SetStatusBar("Hide your vehicle's weapon to toggle through all perspectives.", 'PresetsEditor')
      end
    end
    ImGuiExt.SetTooltip("Toggle through all available camera perspectives for vehicles. The 'TPPFar' perspective is the best for editing TPP-related values.")
  
    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 180 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button("Center View", 180 * ImGuiExt.GetScaleFactor(), 0) then
      CenterCamera()

      ImGuiExt.SetStatusBar("Camera centered.", 'PresetsEditor')
    end
    ImGuiExt.SetTooltip("Center the current perspective/camera view.")

    ImGui.Separator()

    isPreviewMode, isPreviewModeToggle = ImGuiExt.Checkbox("Preview Mode: make enabled masks visible after overlay close", isPreviewMode)
    if isPreviewModeToggle and not isPreviewMode then
      Vectors.SetOpacityLock(false)
    end
    ImGuiExt.SetTooltip("")

    ImGui.Separator()

    if ImGui.BeginTabBar('EditorTabs') then
      if ImGui.BeginTabItem("Vehicle") then
        if Tracker.GetVehicleBaseObject() == 0 then

          if camera.activePerspective ~= vehicleCameraPerspective.FPP then
            ImGuiExt.Text("TPP Options:")
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible, bikeAllMasksTPPToggle = ImGuiExt.Checkbox("Enable masks around a vehicle", LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible)
            if bikeAllMasksTPPToggle then
              Vectors.SetVisibilityAllMasks('Bike', 'TPP', LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible)

              if LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              end

              FlagSettingChange()
            end

            if LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible then
              ImGui.Text("")
              ImGuiExt.Text("Scale masking for a vehicle's width:")
        
              bikeSideMasksScale.y, bikeSideMasksScaleToggle.y = ImGui.SliderFloat('##BikeSideMasksScale', Vectors.GetScaleMask('Bike', 'SideMasks').y, 1, 2.5, "%.2f")
              if bikeSideMasksScaleToggle.y then
                LoadedPreset.Vectors.Modifiers.Bike.SideMasks.Scale.y = bikeSideMasksScale.y
                Vectors.SetScaleMask('Bike', 'SideMasks', 'y', bikeSideMasksScale.y)
                Vectors.SetPopAndOutMask(4, 1, 'Mask2', 'Mask3')

                FlagSettingChange()
              end
            end
            ImGuiExt.SetTooltip("")

            ImGui.Text("")
            ImGuiExt.Text("FPP Options:")
            ImGui.Separator()
            ImGuiExt.Text("Switch to FPP to edit these options.")
          else
            ImGuiExt.Text("TPP Options:")
            ImGui.Separator()
            ImGuiExt.Text("Switch to a TPP camera to edit these options.")
            ImGui.Text("")

            ImGuiExt.Text("FPP Options:")
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible, bikeAllMasksFPPToggle = ImGuiExt.Checkbox("Enable masks around the steering bar", LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible)
            if bikeAllMasksFPPToggle then
              Vectors.SetVisibilityAllMasks('Bike', 'FPP', LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible)

              if LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              end

              FlagSettingChange()
            end

            if LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible then
              ImGui.Text("")
              ImGuiExt.Text(VehiclesText.Editor.Windshield.setting_1)
              ImGuiExt.SetTooltip(VehiclesText.Editor.Windshield.tooltip)
        
              bikeWindshieldScale.x, bikeWindshieldScaleToggle.x = ImGui.SliderFloat('##WindshieldScaleX', Vectors.GetScaleMask('Bike', 'Windshield').x, 0.7, 2, "%.2f")
              if bikeWindshieldScaleToggle.x then
                LoadedPreset.Vectors.Modifiers.Bike.Windshield.Scale.x = bikeWindshieldScale.x
                Vectors.SetScaleMask('Bike', 'Windshield', 'x', bikeWindshieldScale.x)
                Vectors.SetPopAndOutMask(4, 1, "Mask4")
              end
        
              ImGuiExt.Text(VehiclesText.Editor.Windshield.setting_2)
              ImGuiExt.SetTooltip(VehiclesText.Editor.Windshield.tooltip)
        
              bikeWindshieldScale.y, bikeWindshieldScaleToggle.y = ImGui.SliderFloat('##WindshieldScaleY', Vectors.GetScaleMask('Bike', 'Windshield').y, 0.7, 3, "%.2f")
              if bikeWindshieldScaleToggle.y then
                LoadedPreset.Vectors.Modifiers.Bike.Windshield.Scale.y = bikeWindshieldScale.y
                Vectors.SetScaleMask('Bike', 'Windshield', 'y', bikeWindshieldScale.y)
                Vectors.SetPopAndOutMask(4, 1, "Mask4")

                FlagSettingChange()
              end
            end
          end
        elseif Tracker.GetVehicleBaseObject() == 1 then

          if camera.activePerspective ~= vehicleCameraPerspective.FPP then
            ImGuiExt.Text("TPP Options:")
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible, carFrontMaskToggle = ImGuiExt.Checkbox("Enable mask in the front", LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible)
            if carFrontMaskToggle then
              Vectors.SetVisibilityCar('FrontMask', LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible)

              if LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask4')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip("")

            LoadedPreset.Vectors.Modifiers.Car.RearMask.visible, carRearMaskToggle = ImGuiExt.Checkbox("Enable mask in the rear", LoadedPreset.Vectors.Modifiers.Car.RearMask.visible)
            if carRearMaskToggle then
              Vectors.SetVisibilityCar('RearMask', LoadedPreset.Vectors.Modifiers.Car.RearMask.visible)

              if LoadedPreset.Vectors.Modifiers.Car.RearMask.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip("")

            LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible, carSideMasksToggle = ImGuiExt.Checkbox("Enable masks on the sides", LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible)
            if carSideMasksToggle then
              Vectors.SetVisibilityCar('SideMasks', LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible)

              if LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask2', 'Mask3')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask2', 'Mask3')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip("")
            
            if LoadedPreset.Vectors.Modifiers.Car.RearMask.visible or LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible then
              ImGui.Text("")
              ImGuiExt.Text("Scale masking for a vehicle's width:")
              ImGuiExt.SetTooltip("")

              carSideMasksScale.y, carSideMasksScaleToggle.y = ImGui.SliderFloat('##CarSideMasksScale', Vectors.GetScaleMask('Car', 'SideMasks').y, 1, 2.5, "%.2f")
              if carSideMasksScaleToggle.y then
                LoadedPreset.Vectors.Modifiers.Car.SideMasks.Scale.y = carSideMasksScale.y
                Vectors.SetScaleMask('Car', 'SideMasks', 'y', carSideMasksScale.y)

                if LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible and LoadedPreset.Vectors.Modifiers.Car.RearMask.visible then
                  Vectors.SetPopAndOutMask(4, 1, 'Mask1', 'Mask2', 'Mask3')
                elseif LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible then
                  Vectors.SetPopAndOutMask(4, 1, 'Mask2', 'Mask3')
                elseif LoadedPreset.Vectors.Modifiers.Car.RearMask.visible then
                  Vectors.SetPopAndOutMask(4, 1, 'Mask1')
                end

                FlagSettingChange()
              end
              ImGuiExt.SetTooltip("")
            end

            ImGui.Text("")
            ImGuiExt.Text("FPP Options:")
            ImGui.Separator()
            ImGuiExt.Text("Switch to FPP to edit these options.")
          else
            ImGuiExt.Text("TPP Options:")
            ImGui.Separator()
            ImGuiExt.Text("Switch to a TPP camera to edit these options.")
            ImGui.Text("")

            ImGuiExt.Text("FPP Options:")
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible, carAllMasksFPPToggle = ImGuiExt.Checkbox("Enable cockpit elements masks", LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible)
            if carAllMasksFPPToggle then
              Vectors.SetVisibilityAllMasks('Car', 'FPP', LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible)

              if LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip("")
          end
        end

        ImGui.EndTabItem()
      end

      if ImGui.BeginTabItem("Screen Bottom Edges") then
        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners, hedCornersToggle = ImGuiExt.Checkbox("Enable corners masks", LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners)
        if hedCornersToggle then
          Vectors.SetVisibilityHed('corners', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners then
            Vectors.SetPopAndOutHed(2, 1, 'corners')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'corners')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("")

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill, hedFillToggle = ImGuiExt.Checkbox("Enable middle mask", LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill)
        if hedFillToggle then
          Vectors.SetVisibilityHed('fill', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill then
            Vectors.SetPopAndOutHed(2, 1, 'fill')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'fill')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("")

        if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill then
          LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock, hedFillLockToggle = ImGuiExt.Checkbox("Lock middle mask", LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock)
          if hedFillLockToggle then
            Vectors.SetVisibilityHed('fillLock', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock)

            if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock then
              Vectors.SetPopAndOutHed(1, 1, 'fill')
              Globals.SetDelay(1.5, 'OpacityLock1', Vectors.SetPopAndOutHed, 1, 1, 'fill')
            else
              Vectors.SetPopAndOutHed(0.2, 0.5, 'fill')
              Globals.SetDelay(0.5, 'OpacityLock1', Vectors.SetPopAndOutHed, 0.2, 0.5, 'fill')
            end

            FlagSettingChange()
          end
          ImGuiExt.SetTooltip("")
        end

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker, hedTrackerToggle = ImGuiExt.Checkbox("Enable following mask", LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker)
        if hedTrackerToggle then
          Vectors.SetVisibilityHed('tracker', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker then
            Vectors.SetPopAndOutHed(2, 1, 'tracker')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'tracker')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("")

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock, hedLockToggle = ImGuiExt.Checkbox("Lock size of the screen bottom masking", LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock)
        if hedLockToggle then
          Vectors.SetSizeLockHed(LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock then
            Vectors.SetPopAndOutHed(2, 1, 'corners', 'fill')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'corners', 'fill')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("Stops the screen bottom masking from dynamically changing its size on camera movement.")

        ImGui.Text("")
        ImGuiExt.Text("Scale screen bottom edges masks:")
  
        hedScale.x, hedScaleToggle.x = ImGui.SliderFloat('##HedScaleX', Vectors.GetScaleHed().x, 0.92, 1, "%.2f")
        if hedScaleToggle.x then
          LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Scale.x = hedScale.x
          Vectors.SetScaleHed('x', hedScale.x)
          Vectors.SetPopAndOutHed(4, 1, 'corners', 'fill')

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("Scale the base width for the screen bottom masking. This size would be locked if the checkbox above is selected.")

        ImGui.EndTabItem()
      end

      if ImGui.BeginTabItem("Masking Strength") then
        LoadedPreset.MaskingGlobal.isOpacityLock, opacityLockToggle = ImGuiExt.Checkbox("Decouple masking strength from vehicle's speed", LoadedPreset.MaskingGlobal.isOpacityLock)
        if opacityLockToggle then
          if LoadedPreset.MaskingGlobal.isOpacityLock then
            Vectors.SetPopAndOutHed(0.25, 1, 'corners', 'fill')
            Globals.SetDelay(0.25, 'OpacityLock1', Vectors.SetPopAndOutMask, 0.25, 1, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
            Globals.SetDelay(1, 'OpacityLock2', Vectors.SetOpacityLock, false)
          else
            Vectors.SetPopAndOutMask(0.25, 1, 'Mask4')
            Globals.SetDelay(0.25, 'OpacityLock1', Vectors.SetPopAndOutMask, 0.25, 1, 'Mask2', 'Mask3')
            Globals.SetDelay(0.5, 'OpacityLock2', Vectors.SetPopAndOutMask, 0.25, 1, 'Mask1')
            Globals.SetDelay(0.75, 'OpacityLock3', Vectors.SetPopAndOutHed, 0.25, 1, 'corners', 'fill')
            Globals.SetDelay(1, 'OpacityLock4', Vectors.SetOpacityLock, false)
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("")

        ImGuiExt.Text("Set masking strength around a vehicle:")
  
        opacityMasks, opacityMasksToggle = ImGui.SliderFloat('##OpacityMasks', LoadedPreset.Vectors.VehMasks.Opacity.Def.max * 200, 0, maxOpacityMasks, "%.0f")
        if opacityMasksToggle then
          LoadedPreset.Vectors.VehMasks.Opacity.Def.max = opacityMasks / 200

          local previewOpacity = opacityMasks / maxOpacityMasks
          Vectors.SetPopAndOutMask(4, previewOpacity, 'Mask1', 'Mask2', 'Mask3', 'Mask4')

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("Set masking strength around a vehicle. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 10 is a good balance between effectiveness and them being almost unnoticeable.")
        ImGui.EndTabItem()

        ImGuiExt.Text("Set masking for the screen bottom edges:")
    
        opacityHed, opacityHedToggle = ImGui.SliderFloat('##OpacityHed', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def.max * 200, 0, maxOpacityHed, "%.0f")
        if opacityHedToggle then
          LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def.max = opacityHed / 200

          local previewOpacity = opacityHed / maxOpacityHed
          Vectors.SetPopAndOutHed(4, previewOpacity, 'corners', 'fill')

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip("Set masking strength for the screen bottom edges. Higher values cover frame generation artifacts more effectively, but masks might become noticeable. 6 is a good balance between effectiveness and them being almost unnoticeable.")

      ImGui.EndTabItem()
    end

      ImGui.EndTabBar()
    end

    ImGui.Text("")

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar('PresetsEditor'))
  end

  ImGui.End()
end


return VectorsEditor