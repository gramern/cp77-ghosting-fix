local VectorsPresets = {
  __NAME = "VectorsPresets",
  __VERSION = { 5, 0, 0 },
}

local SortedPresetIds = {}

local PresetsList = {}

local selectedPreset = nil -- must be a unique identifier for the preset

local selectedPresetName = nil

local LoadedPreset = {}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local Vectors = require("Modules/Vectors")
local VectorsEditor = require("Modules/VectorsEditor")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
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

function VectorsPresets.AddPreset(presetInfo, id, filename)
  -- Skip if PresetsList is already populated with the same preset
  if PresetsList[id] ~= nil then Globals.Print(VectorsPresets.__NAME, LogText.presets_skippedFileDuplicate) return end

  PresetsList[id] = {file = filename, PresetInfo = presetInfo}
end

function VectorsPresets.GetPresets() 
  PresetsList = {}
  SortedPresetIds = {}

  local presetsDir = dir('Presets')
  local addedPresets = {}

  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Globals.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo and presetContents.PresetInfo.id and presetContents.PresetInfo.name and PresetsList[presetContents.PresetInfo.id] == nil then
        VectorsPresets.AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
        table.insert(addedPresets, presetFile.name)
      else
        Globals.Print(VectorsPresets.__NAME, LogText.presets_skippedFileData, presetFile.name)
      end
    end
  end

  Globals.Print(VectorsPresets.__NAME, LogText.presets_loaded, table.concat(addedPresets, ", "))

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

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

function VectorsPresets.OnInitialize()
  LoadUserSettings(Settings.GetUserSettings("VehiclesPreset"))
  VectorsPresets.GetPresets()
  VectorsPresets.LoadPreset()

  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

function VectorsPresets.OnOverlayOpen()
  -- Translate and refresh presets info and list
  PresetsList = Localization.GetTranslation(PresetsList, "PresetsList")
  
  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

----------------------------------------------------------------------------------------------------------------------
-- Local UI
----------------------------------------------------------------------------------------------------------------------

local isPresetsEditor

function VectorsPresets.DrawUI()
  if ImGui.BeginTabItem(VehiclesText.tabname) then
    if not Tracker.IsGameFrameGeneration() then
      ImGuiExt.Text(GeneralText.info_frameGenOff, true)
      return
    end

    ImGuiExt.Text(GeneralText.title_general)
    ImGui.Separator()
    ImGuiExt.Text(VehiclesText.MaskingPresets.name)

    selectedPresetName = PresetsList[selectedPreset].PresetInfo.name

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
    ImGuiExt.SetTooltip(VehiclesText.MaskingPresets.tooltip)

    if selectedPreset ~= "a000" then
      ImGui.SameLine()
      
      if ImGui.Button(GeneralText.apply, 100 * ImGuiExt.GetScaleFactor(), 0) then
        VectorsPresets.LoadPreset()
        SaveUserSettings()

        ImGuiExt.SetStatusBar(GeneralText.settings_applied_veh)
      end
    elseif selectedPreset == "a000" and not isPresetsEditor then
      ImGuiExt.SetStatusBar("Open presets editor by pressing the 'Open Editor' preset")
    end

    if selectedPreset then
      if PresetsList[selectedPreset].PresetInfo.description then
        ImGuiExt.Text(VehiclesText.MaskingPresets.description)
        ImGuiExt.Text(PresetsList[selectedPreset].PresetInfo.description, true)
      end

      if PresetsList[selectedPreset].PresetInfo.author then
        ImGuiExt.Text(VehiclesText.MaskingPresets.author)
        ImGui.SameLine()
        ImGuiExt.Text(PresetsList[selectedPreset].PresetInfo.author)
      end
    end

    -- VectorsEditor
    ImGui.Text("")
    ImGuiExt.Text("Presets Editor:")
    ImGui.Separator()

    if not isPresetsEditor then
      if ImGui.Button("Open Presets Editor", 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        if Tracker.IsVehicleMounted() then
          isPresetsEditor = true
          VectorsEditor.SetInstance(PresetsList)
        else
          ImGuiExt.SetStatusBar(GeneralText.info_getIn)
        end
      end
      ImGuiExt.SetTooltip("")
    else
      if ImGui.Button("Close Presets Editor", 478 * ImGuiExt.GetScaleFactor(), 40 * ImGuiExt.GetScaleFactor()) then
        isPresetsEditor = false
        VectorsEditor.EndInstance()

        VectorsPresets.GetPresets()
        VectorsPresets.LoadPreset()
      end
    end
    
    ImGui.EndTabItem()
  end

  if isPresetsEditor then
    VectorsEditor.DrawWindow()
  end
end

return VectorsPresets