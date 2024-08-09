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

local GeneralText = Localization.GetGeneralText()
local EditorText = Localization.GetEditorText()

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

-- found in keanuWheeze's Metro System mod (https://github.com/justarandomguyintheinternet/CP77_TrainSystem/blob/318a91ddcd64abe601af56f1c4119533ac68efa4/modules/utils/utils.lua#L156)
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
    ImGuiExt.SetStatusBar("Presets Editor running in Debug Mode", 'PresetsEditorWindow')
  else
    SetMaxOpacity(12)
    ImGuiExt.SetStatusBar(ImGuiExt.GetStatusBar(), 'PresetsEditorWindow')
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
    Globals.CancelDelay('OpacityLock1')
    Globals.CancelDelay('OpacityLock2')
    Globals.CancelDelay('OpacityLock3')
    Globals.CancelDelay('OpacityLock4')

    if isPreviewMode then
      Globals.SetDelay(1.5, 'VectorsEditorPreview', Vectors.SetOpacityLock, true, 1)
      Globals.SetDelay(1.5, 'VectorsEditorPreviewNotif', ImGuiExt.SetNotification, 2, EditorText.notif_preview_mode)
    end

    if LoadedPreset ~= nil then -- Load current settings for preview
      Globals.SetDelay(1, 'VectorsEditorReloadSettingsNotif', Vectors.LoadPreset, LoadedPreset)
      ImGuiExt.SetNotification(1.2, EditorText.notif_reloading_settings)
    end
  end
end

----------------------------------------------------------------------------------------------------------------------
-- Local UI
----------------------------------------------------------------------------------------------------------------------

local function FlagSettingChange()
  ImGuiExt.SetStatusBar(EditorText.status_close_overlay_preview, 'PresetsEditorWindow')
end

local function LoadPresetWindow()
  ImGuiExt.PushStyle()
  ImGui.SetNextWindowPos(screenWidth / 2 - 210, screenHeight / 2 - 120)

  if ImGui.Begin(EditorText.window_load_preset, ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoCollapse + ImGuiWindowFlags.None) then

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
    ImGuiExt.SetTooltip(EditorText.tooltip_load_preset)

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(GeneralText.btn_cancel, 100 * ImGuiExt.GetScaleFactor(), 0) then
      isLoadWindow = false
    end

    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 100 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(GeneralText.btn_load, 100 * ImGuiExt.GetScaleFactor(), 0) then
      LoadPreset()

      local infoLoadedPreset = EditorText.status_preset_loaded .. " " .. selectedPresetName
      ImGuiExt.SetStatusBar(infoLoadedPreset, 'PresetsEditorWindow')

      isLoadWindow = false
    end
  end

  ImGui.End()
  ImGuiExt.PopStyle()
end

local function SavePresetWindow()
  ImGuiExt.PushStyle()
  ImGui.SetNextWindowPos(screenWidth / 2 - 210, screenHeight / 2 - 120)

  if ImGui.Begin(EditorText.window_save_preset, ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoCollapse + ImGuiWindowFlags.None) then

    ImGuiExt.Text(EditorText.input_name)
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetName = ImGui.InputText("##Name", presetName, 30)
    ImGuiExt.SetTooltip(EditorText.tooltip_input_name)

    ImGuiExt.Text(EditorText.input_author)
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetAuthor = ImGui.InputText("##Author", presetAuthor, 30)
    ImGuiExt.SetTooltip(EditorText.tooltip_input_author)

    ImGuiExt.Text(EditorText.input_description)
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    presetDescription = ImGui.InputTextMultiline("##Description", presetDescription, 100, 300, 60)
    ImGuiExt.SetTooltip(EditorText.tooltip_input_description)
    
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text(EditorText.info_chars_left)
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 30 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text(tostring(100 - #presetDescription))

    ImGuiExt.Text(EditorText.input_file_name)
    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 300 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)
    ImGui.SetNextItemWidth(300)

    presetFile = ImGui.InputText("##FileName", presetFile, 30)
    ImGuiExt.SetTooltip(EditorText.tooltip_input_file_name)

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 200 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(GeneralText.btn_cancel, 100 * ImGuiExt.GetScaleFactor(), 0) then
      isSaveWindow = false
      presetName, presetAuthor, presetDescription, presetFile = "", "", "", ""
    end

    ImGui.SameLine()
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 100 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(GeneralText.btn_save, 100 * ImGuiExt.GetScaleFactor(), 0) then
      if presetName == "" or presetAuthor == "" or presetFile == "" then
        ImGuiExt.SetStatusBar(EditorText.status_fill_all_save, 'SavePresetWindow')
      elseif not Globals.AreLettersOnly(presetFile) then
        ImGuiExt.SetStatusBar(EditorText.status_file_name_letters_only, 'SavePresetWindow')
      else
        local presetId = GeneratePresetID()
        local result = SavePreset(presetName, presetAuthor, presetFile, presetDescription, presetId)

        if result then
          local infoSavedPreset = EditorText.status_preset_saved .. " " .. presetFile .. EditorText.status_close_overlay_reload_list
          ImGuiExt.SetStatusBar(infoSavedPreset, 'PresetsEditorWindow')
          isSaveWindow = false
          presetName, presetAuthor, presetDescription, presetFile = "", "", "", ""
        else
          ImGuiExt.SetStatusBar(EditorText.status_cant_save, 'SavePresetWindow')
        end
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar('SavePresetWindow'))
  end

  ImGui.End()
  ImGuiExt.PopStyle()
end

function VectorsEditor.DrawWindow()
  ImGuiExt.PushStyle()
  ImGui.SetNextWindowPos(500, 300, ImGuiCond.FirstUseEver)

  if ImGui.Begin(EditorText.window_presets_editor, ImGuiWindowFlags.AlwaysAutoResize) then

    if not Tracker.IsGameLoaded() then
      ImGui.Text("")
      ImGuiExt.TextRed(EditorText.info_game_loading_wait)
      ImGui.Text("")

      ImGui.End()
      return
    end

    if not Tracker.IsVehicleMounted() and not Tracker.IsPlayerDriver() then
      ImGui.Text("")
      ImGuiExt.TextRed(EditorText.info_enter_vehicle)
      ImGui.Text("")

      ImGui.End()
      return
    end

    if ImGui.Button(EditorText.btn_load_preset, 180 * ImGuiExt.GetScaleFactor(), 0) then
      isLoadWindow = not isLoadWindow
      isSaveWindow = false

      screenWidth, screenHeight = Globals.GetScreenResolution()
    end
    ImGuiExt.SetTooltip(EditorText.tooltip_load_preset)

    ImGui.SameLine()

    if ImGui.Button(EditorText.btn_save_preset, 180 * ImGuiExt.GetScaleFactor(), 0) then
      isSaveWindow = not isSaveWindow
      isLoadWindow = false
      screenWidth, screenHeight = Globals.GetScreenResolution()

      ImGuiExt.SetStatusBar("", 'SavePresetWindow')
    end
    ImGuiExt.SetTooltip(EditorText.tooltip_save_preset)

    ImGui.SameLine()
    
    if ImGui.Button(EditorText.btn_reset_values, 180 * ImGuiExt.GetScaleFactor(), 0) then
      LoadedPreset = Globals.Deepcopy(Globals.GetFallback('VectorsEditor'))
      Vectors.LoadPreset(LoadedPreset)
    end
    ImGuiExt.SetTooltip(EditorText.tooltip_reset_values)

    ImGui.Separator()

    cameraOptionsTextWidth = ImGui.CalcTextSize(EditorText.group_camera_options)
    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - cameraOptionsTextWidth / 2 - 450 * ImGuiExt.GetScaleFactor() - 3 * ImGui.GetStyle().ItemSpacing.x)
    ImGuiExt.Text(EditorText.group_camera_options)

    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 360 * ImGuiExt.GetScaleFactor() - 2 * ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(EditorText.btn_toggle_perspective, 180 * ImGuiExt.GetScaleFactor(), 0) then
      local newPerspective
      perspectiveToggle, newPerspective = TogglePerspective()
      Vectors.SetOpacityLock(false)

      local newStatus = EditorText.status_camera_perspective .. " " .. tostring(newPerspective)
      ImGuiExt.SetStatusBar(newStatus, 'PresetsEditorWindow')

      if not perspectiveToggle then
        ImGuiExt.SetStatusBar(EditorText.status_hide_weapons_weponize_vehicle, 'PresetsEditorWindow')
      end
    end
    ImGuiExt.SetTooltip(EditorText.status_hide_weapons_weponize_vehicle)
  
    ImGui.SameLine()

    ImGui.SetCursorPosX(ImGui.GetWindowWidth() - 180 * ImGuiExt.GetScaleFactor() - ImGui.GetStyle().ItemSpacing.x)

    if ImGui.Button(EditorText.btn_center_view, 180 * ImGuiExt.GetScaleFactor(), 0) then
      CenterCamera()

      ImGuiExt.SetStatusBar(EditorText.status_camera_centered, 'PresetsEditorWindow')
    end
    ImGuiExt.SetTooltip(EditorText.tooltip_center_view)

    ImGui.Separator()

    isPreviewMode, isPreviewModeToggle = ImGuiExt.Checkbox(EditorText.chk_preview_mode, isPreviewMode)
    if isPreviewModeToggle and not isPreviewMode then
      Vectors.SetOpacityLock(false)
    end
    ImGuiExt.SetTooltip(EditorText.tooltip_preview_mode)

    ImGui.Separator()

    if ImGui.BeginTabBar('EditorTabs') then
      if ImGui.BeginTabItem(EditorText.tab_name_vehicle) then
        if Tracker.GetVehicleBaseObject() == 0 then

          if camera.activePerspective ~= vehicleCameraPerspective.FPP then
            ImGuiExt.Text(EditorText.group_tpp_options)
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible, bikeAllMasksTPPToggle = ImGuiExt.Checkbox(EditorText.chk_masks_around_vehicle, LoadedPreset.Vectors.Modifiers.Bike.AllMasks.TPP.visible)
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
              ImGuiExt.Text(EditorText.slider_vehicle_width)
        
              bikeSideMasksScale.y, bikeSideMasksScaleToggle.y = ImGui.SliderFloat('##BikeSideMasksScale', Vectors.GetScaleMask('Bike', 'SideMasks').y, 1, 2.5, "%.2f")
              if bikeSideMasksScaleToggle.y then
                LoadedPreset.Vectors.Modifiers.Bike.SideMasks.Scale.y = bikeSideMasksScale.y
                Vectors.SetScaleMask('Bike', 'SideMasks', 'y', bikeSideMasksScale.y)
                Vectors.SetPopAndOutMask(4, 1, 'Mask2', 'Mask3')

                FlagSettingChange()
              end
            end
            ImGuiExt.SetTooltip(EditorText.tooltip_vehicle_width)

            ImGui.Text("")
            ImGuiExt.Text(EditorText.group_fpp_options)
            ImGui.Separator()
            ImGuiExt.Text(EditorText.info_switch_to_fpp)
          else
            ImGuiExt.Text(EditorText.group_tpp_options)
            ImGui.Separator()
            ImGuiExt.Text(EditorText.info_switch_to_tpp)
            ImGui.Text("")

            ImGuiExt.Text(EditorText.group_fpp_options)
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible, bikeAllMasksFPPToggle = ImGuiExt.Checkbox(EditorText.chk_masks_steering_bar, LoadedPreset.Vectors.Modifiers.Bike.AllMasks.FPP.visible)
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
              ImGuiExt.Text(EditorText.slider_windshield_width)
              
        
              bikeWindshieldScale.x, bikeWindshieldScaleToggle.x = ImGui.SliderFloat('##WindshieldScaleX', Vectors.GetScaleMask('Bike', 'Windshield').x, 0.7, 2, "%.2f")
              if bikeWindshieldScaleToggle.x then
                LoadedPreset.Vectors.Modifiers.Bike.Windshield.Scale.x = bikeWindshieldScale.x
                Vectors.SetScaleMask('Bike', 'Windshield', 'x', bikeWindshieldScale.x)
                Vectors.SetPopAndOutMask(4, 1, "Mask4")
              end
              ImGuiExt.SetTooltip(EditorText.tooltip_windshield)
        
              ImGuiExt.Text(EditorText.slider_windshield_height)
        
              bikeWindshieldScale.y, bikeWindshieldScaleToggle.y = ImGui.SliderFloat('##WindshieldScaleY', Vectors.GetScaleMask('Bike', 'Windshield').y, 0.7, 3, "%.2f")
              if bikeWindshieldScaleToggle.y then
                LoadedPreset.Vectors.Modifiers.Bike.Windshield.Scale.y = bikeWindshieldScale.y
                Vectors.SetScaleMask('Bike', 'Windshield', 'y', bikeWindshieldScale.y)
                Vectors.SetPopAndOutMask(4, 1, "Mask4")

                FlagSettingChange()
              end
              ImGuiExt.SetTooltip(EditorText.tooltip_windshield)
            end
          end
        elseif Tracker.GetVehicleBaseObject() == 1 then

          if camera.activePerspective ~= vehicleCameraPerspective.FPP then
            ImGuiExt.Text(EditorText.group_tpp_options)
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible, carFrontMaskToggle = ImGuiExt.Checkbox(EditorText.chk_mask_front, LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible)
            if carFrontMaskToggle then
              Vectors.SetVisibilityCar('FrontMask', LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible)

              if LoadedPreset.Vectors.Modifiers.Car.FrontMask.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask4')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip(EditorText.tooltip_mask_front)

            LoadedPreset.Vectors.Modifiers.Car.RearMask.visible, carRearMaskToggle = ImGuiExt.Checkbox(EditorText.chk_mask_rear, LoadedPreset.Vectors.Modifiers.Car.RearMask.visible)
            if carRearMaskToggle then
              Vectors.SetVisibilityCar('RearMask', LoadedPreset.Vectors.Modifiers.Car.RearMask.visible)

              if LoadedPreset.Vectors.Modifiers.Car.RearMask.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip(EditorText.tooltip_mask_rear)

            LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible, carSideMasksToggle = ImGuiExt.Checkbox(EditorText.chk_masks_sides, LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible)
            if carSideMasksToggle then
              Vectors.SetVisibilityCar('SideMasks', LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible)

              if LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask2', 'Mask3')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask2', 'Mask3')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip(EditorText.tooltip_masks_sides)
            
            if LoadedPreset.Vectors.Modifiers.Car.RearMask.visible or LoadedPreset.Vectors.Modifiers.Car.SideMasks.visible then
              ImGui.Text("")
              ImGuiExt.Text(EditorText.slider_vehicle_width)

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
              ImGuiExt.SetTooltip(EditorText.tooltip_vehicle_width)
            end

            ImGui.Text("")
            ImGuiExt.Text(EditorText.group_fpp_options)
            ImGui.Separator()
            ImGuiExt.Text(EditorText.info_switch_to_fpp)
          else
            ImGuiExt.Text(EditorText.group_tpp_options)
            ImGui.Separator()
            ImGuiExt.Text(EditorText.info_switch_to_tpp)
            ImGui.Text("")

            ImGuiExt.Text(EditorText.group_fpp_options)
            ImGui.Separator()

            LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible, carAllMasksFPPToggle = ImGuiExt.Checkbox(EditorText.chk_cockpit_masks, LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible)
            if carAllMasksFPPToggle then
              Vectors.SetVisibilityAllMasks('Car', 'FPP', LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible)

              if LoadedPreset.Vectors.Modifiers.Car.AllMasks.FPP.visible then
                Vectors.SetPopAndOutMask(2, 1, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              else
                Vectors.SetPopAndOutMask(0.2, 0.5, 'Mask1', 'Mask2', 'Mask3', 'Mask4')
              end

              FlagSettingChange()
            end
            ImGuiExt.SetTooltip(EditorText.tooltip_cockpit_masks)
          end
        end

        ImGui.EndTabItem()
      end

      if ImGui.BeginTabItem(EditorText.tab_name_bottom_edges) then
        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners, hedCornersToggle = ImGuiExt.Checkbox(EditorText.chk_corners_masks, LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners)
        if hedCornersToggle then
          Vectors.SetVisibilityHed('corners', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners then
            Vectors.SetPopAndOutHed(2, 1, 'corners')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'corners')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_corners_masks)

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill, hedFillToggle = ImGuiExt.Checkbox(EditorText.chk_middle_mask, LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill)
        if hedFillToggle then
          Vectors.SetVisibilityHed('fill', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill then
            Vectors.SetPopAndOutHed(2, 1, 'fill')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'fill')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_middle_mask)

        if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill then
          LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock, hedFillLockToggle = ImGuiExt.Checkbox(EditorText.chk_lock_middle_mask, LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fillLock)
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
          ImGuiExt.SetTooltip(EditorText.tooltip_lock_middle_mask)
        end

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker, hedTrackerToggle = ImGuiExt.Checkbox(EditorText.chk_following_mask, LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker)
        if hedTrackerToggle then
          Vectors.SetVisibilityHed('tracker', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.tracker then
            Vectors.SetPopAndOutHed(2, 1, 'tracker')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'tracker')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_following_mask)

        LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock, hedLockToggle = ImGuiExt.Checkbox(EditorText.chk_lock_size_bottom_masking, LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock)
        if hedLockToggle then
          Vectors.SetSizeLockHed(LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock)

          if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Size.Def.lock then
            Vectors.SetPopAndOutHed(2, 1, 'corners', 'fill')
          else
            Vectors.SetPopAndOutHed(0.2, 0.5, 'corners', 'fill')
          end

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_lock_size_bottom_masking)

        if LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.corners or LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Visible.Def.fill then
          ImGui.Text("")
          ImGuiExt.Text(EditorText.slider_bottom_edges)
    
          hedScale.x, hedScaleToggle.x = ImGui.SliderFloat('##HedScaleX', Vectors.GetScaleHed().x, 0.92, 1, "%.2f")
          if hedScaleToggle.x then
            LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Scale.x = hedScale.x
            Vectors.SetScaleHed('x', hedScale.x)
            Vectors.SetPopAndOutHed(4, 1, 'corners', 'fill')

            FlagSettingChange()
          end
          ImGuiExt.SetTooltip(EditorText.tooltip_bottom_edges)
        end

        ImGui.EndTabItem()
      end

      if ImGui.BeginTabItem(EditorText.tab_name_masking_strength) then
        LoadedPreset.MaskingGlobal.isOpacityLock, opacityLockToggle = ImGuiExt.Checkbox(EditorText.chk_decouple_masking, LoadedPreset.MaskingGlobal.isOpacityLock)
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
        ImGuiExt.SetTooltip(EditorText.tooltip_decouple_masking)

        ImGuiExt.Text(EditorText.slider_strength_vehicle)
  
        opacityMasks, opacityMasksToggle = ImGui.SliderFloat('##OpacityMasks', LoadedPreset.Vectors.VehMasks.Opacity.Def.max * 200, 0, maxOpacityMasks, "%.0f")
        if opacityMasksToggle then
          LoadedPreset.Vectors.VehMasks.Opacity.Def.max = opacityMasks / 200

          local previewOpacity = opacityMasks / maxOpacityMasks
          Vectors.SetPopAndOutMask(4, previewOpacity, 'Mask1', 'Mask2', 'Mask3', 'Mask4')

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_strength_vehicle)

        ImGuiExt.Text(EditorText.slider_strength_bottom)
    
        opacityHed, opacityHedToggle = ImGui.SliderFloat('##OpacityHed', LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def.max * 200, 0, maxOpacityHed, "%.0f")
        if opacityHedToggle then
          LoadedPreset.Vectors.VehMasks.HorizontalEdgeDown.Opacity.Def.max = opacityHed / 200

          local previewOpacity = opacityHed / maxOpacityHed
          Vectors.SetPopAndOutHed(4, previewOpacity, 'corners', 'fill')

          FlagSettingChange()
        end
        ImGuiExt.SetTooltip(EditorText.tooltip_strength_bottom)

        ImGui.EndTabItem()
      end

      ImGui.EndTabBar()
    end

    ImGui.Text("")

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar('PresetsEditorWindow'))
  end

  ImGui.End()
  ImGuiExt.PopStyle()

  if isLoadWindow then
    LoadPresetWindow()
  end

  if isSaveWindow then
    SavePresetWindow()
  end
end


return VectorsEditor