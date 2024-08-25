local VectorsPresets = {
  __NAME = "VectorsPresets",
  __VERSION = { 5, 1, 9 },
}

local SortedPresetIds = {}

local PresetsList = {}

local selectedPreset = nil -- must be a unique identifier for the preset

local selectedPresetName = nil

local LoadedPreset = {}

local lastLoadedPresets = ""

local isPresetsEditor

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local Vectors = require("Modules/Vectors")
local VectorsEditor = require("Modules/VectorsEditor")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
local SettingsText = Localization.GetSettingsText()
local VehiclesText = Localization.GetVehiclesText()

----------------------------------------------------------------------------------------------------------------------
-- UserSettings
----------------------------------------------------------------------------------------------------------------------

local function GetUserSettings()
  local userSettings = {
    SelectedPreset = selectedPreset
  }

  if userSettings.SelectedPreset == "a000" then
    userSettings.SelectedPreset = "a001"
  end

  return userSettings
end

local function LoadUserSettings(userSettings)
  if not userSettings or userSettings == nil then return end

  selectedPreset = userSettings and userSettings.SelectedPreset
end

local function SaveUserSettings()
  Settings.WriteUserSettings("VehiclesPreset", GetUserSettings())
end

----------------------------------------------------------------------------------------------------------------------
-- Presets management
----------------------------------------------------------------------------------------------------------------------

-- @return boolean; `true` if Presets Editor instance is running
function VectorsPresets.IsPresetsEditor()
  return isPresetsEditor
end

----------------------------------------------------------------------------------------------------------------------
-- Presets management
----------------------------------------------------------------------------------------------------------------------

local function AddPreset(presetInfo, id, filename)
  -- Skip if PresetsList is already populated with the same preset
  if PresetsList[id] ~= nil then Globals.Print(VectorsPresets.__NAME, LogText.presets_skipped_file_duplicate) return end

  PresetsList[id] = {file = filename, PresetInfo = presetInfo}
end

local function GetPresets()
  PresetsList = {}
  SortedPresetIds = {}

  local presetsDir = dir('Presets')
  local addedPresets = {}

  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Globals.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo and presetContents.PresetInfo.id and presetContents.PresetInfo.name and PresetsList[presetContents.PresetInfo.id] == nil then
        AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
        table.insert(addedPresets, presetFile.name)
      else
        Globals.Print(VectorsPresets.__NAME, LogText.presets_skipped_file_data, presetFile.name)
      end
    end
  end

  local loadedPresets = table.concat(addedPresets, ", ")

  if lastLoadedPresets == nil or lastLoadedPresets ~= loadedPresets then
    Globals.Print(VectorsPresets.__NAME, LogText.presets_loaded, loadedPresets)
    lastLoadedPresets = loadedPresets
  end

  -- Sort the preset names by their keys (preset ids) so they appear alphabetically in UI 
  for k in pairs(PresetsList) do
    table.insert(SortedPresetIds, k)
  end

  table.sort(SortedPresetIds)
end

function VectorsPresets.PrintPresets()
  for _, presetId in ipairs(PresetsList) do
    local name = PresetsList[presetId].PresetInfo.name
    local description = PresetsList[presetId].PresetInfo.description
    local author = PresetsList[presetId].PresetInfo.author

    print("| Name:", name, "| Description:", description, "| Author:", author, "| ID:", presetId)
  end

  if selectedPreset then
    Globals.Print(VectorsPresets.__NAME, "Selected preset:", PresetsList[selectedPreset].PresetInfo.name)
  end
end

function VectorsPresets.LoadPreset()
  -- Use Default if user has not selected any other preset yet
  if selectedPreset == nil then
    selectedPreset = "a001"
  end

  local presetPath = "Presets/"

  -- Load Default when Customize preset is selected or roll back to previosuly selected preset
  if selectedPreset == "a000" then
    if LoadedPreset == nil then
      presetPath = presetPath .. "Default.json"
    else
      selectedPreset = LoadedPreset.PresetInfo.id
    end
  else
    -- Check if selectedPreset exists in the list
    for _, presets in pairs(PresetsList) do
      if PresetsList[selectedPreset] == nil then
        selectedPreset = "a001"
      end
    end
  end

  presetPath = presetPath .. PresetsList[selectedPreset].file

  local loadedPreset = Globals.LoadJSON(presetPath)

  if loadedPreset then
    LoadedPreset = Globals.Deepcopy(loadedPreset)

    Vectors.LoadPreset(LoadedPreset)
  end
end

function VectorsPresets.UpdateMaskingState()
  if Tracker.IsGameFrameGeneration()  then
    if selectedPreset == "a005" then return end
    Vectors.SetMaskingState(true)
  else
    Vectors.SetMaskingState(false)
  end

  Globals.PrintDebug(VectorsPresets.__NAME, "Frame Generation in the game's settings is set to:", tostring(Tracker.IsGameFrameGeneration()), "Masking set to:", tostring(Vectors.GetMaskingState()))
end

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

function VectorsPresets.OnInitialize()
  LoadUserSettings(Settings.GetUserSettings("VehiclesPreset"))
  GetPresets()
  VectorsPresets.LoadPreset()
  VectorsPresets.UpdateMaskingState()
  Tracker.SetCallbackOnGameStateChange('gameUnpaused', 'VectorsPresetsUpdateMaskingState', VectorsPresets.UpdateMaskingState)
end

function VectorsPresets.OnOverlayOpen()
  -- Translate and refresh presets info and list
  PresetsList = Localization.GetLocalization(PresetsList, "PresetsList")
end

----------------------------------------------------------------------------------------------------------------------
-- Local UI
----------------------------------------------------------------------------------------------------------------------

local function GameFrameGenerationOffCaseUI()
  if ImGui.BeginTabItem(VehiclesText.tab_name_vehicle) then
    ImGui.Text("")
    ImGuiExt.Text(SettingsText.info_frame_gen_off, true)
    ImGui.Text("")

    ImGui.EndTabItem()
  end
end

function VectorsPresets.DrawUI()
  if not Tracker.IsGameFrameGeneration() then
    GameFrameGenerationOffCaseUI()
    
    return
  end

  if ImGui.BeginTabItem(VehiclesText.tab_name_vehicle) then

    ImGuiExt.Text(GeneralText.group_general)
    ImGui.Separator()

    selectedPresetName = PresetsList[selectedPreset].PresetInfo.name

    if not isPresetsEditor then
      ImGuiExt.Text(VehiclesText.info_presets)
      ImGui.SetNextItemWidth(370)

      -- Displays list of presets' names and sets a preset
      if ImGui.BeginCombo("##Presets", selectedPresetName) then
        for _, presetId in ipairs(SortedPresetIds) do
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
      ImGuiExt.SetTooltip(VehiclesText.tooltip_presets)

        ImGui.SameLine()
        
      if ImGui.Button(GeneralText.btn_apply, 100 * ImGuiExt.GetScaleFactor(), 0) then
        VectorsPresets.LoadPreset()
        SaveUserSettings()

        ImGuiExt.SetStatusBar(VehiclesText.status_applied_veh)
      end

      if selectedPreset then
        if PresetsList[selectedPreset].PresetInfo.description then
          ImGuiExt.Text(VehiclesText.info_description)
          ImGuiExt.Text(PresetsList[selectedPreset].PresetInfo.description, true)
        end

        if PresetsList[selectedPreset].PresetInfo.author then
          ImGuiExt.Text(VehiclesText.info_author)
          ImGui.SameLine()
          ImGuiExt.Text(PresetsList[selectedPreset].PresetInfo.author)
        end
      end
    else
      ImGuiExt.Text(VehiclesText.info_presets_locked, true)
    end

    -- VectorsEditor
    ImGui.Text("")
    ImGuiExt.Text(VehiclesText.group_editor)
    ImGui.Separator()

    if not isPresetsEditor then
      if ImGui.Button(VehiclesText.btn_open_editor, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        if Tracker.IsVehicleMounted() or Game.GetMountedVehicle(Game.GetPlayer()) then
          isPresetsEditor = true
          VectorsEditor.SetInstance(PresetsList)
        else
          ImGuiExt.SetStatusBar(VehiclesText.status_get_in)
        end
      end
      ImGuiExt.SetTooltip(VehiclesText.tooltip_open_editor)
    else
      if ImGui.Button(VehiclesText.btn_close_editor, 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        isPresetsEditor = false
        VectorsEditor.EndInstance()

        GetPresets()
        VectorsPresets.LoadPreset()
      end
      ImGuiExt.SetTooltip(VehiclesText.tooltip_close_editor)
    end
    
    ImGui.EndTabItem()
  end

  if isPresetsEditor then
    VectorsEditor.DrawWindow()
  end
end

return VectorsPresets