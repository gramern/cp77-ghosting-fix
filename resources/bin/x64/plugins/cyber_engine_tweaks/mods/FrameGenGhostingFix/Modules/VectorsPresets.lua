local VectorsPresets = {
  __NAME = "VectorsPresets",
  __VERSION = { 5, 0, 0 },
  selectedPreset = nil, -- must be a unique identifier for the preset
  sortedPresetIds = {},
  PresetsList = {}
}

local LoadedPreset = {}

local UserSettings = {}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

local LogText = Localization.GetLogText()
local GeneralText = Localization.GetGeneralText()
local VehiclesText = Localization.GetVehiclesText()

------------------
-- UserSettings
------------------

local function GetUserSettings()
  UserSettings = {
    selectedPreset = VectorsPresets.selectedPreset
  }

  return UserSettings
end

local function SaveUserSettings()
  Settings.WriteUserSettings("VectorsPresets", GetUserSettings())
end

------------------
-- Presets management
------------------

local function AddCustomizePreset()
  local customizePreset = {
      name = "Customize",
      description = "Customize your preset.",
      author = nil,
      id = "a000"
  }

  VectorsPresets.AddPreset(customizePreset, customizePreset.id, customizePreset.name)
end

function VectorsPresets.AddPreset(presetInfo, id, filename)
  -- Skip if PresetsList is already populated with the same preset
  if VectorsPresets.PresetsList[id] ~= nil then Globals.Print(VectorsPresets.__NAME, LogText.presets_skippedFileDuplicate) return end

  VectorsPresets.PresetsList[id] = {file = filename, PresetInfo = presetInfo}
end

function VectorsPresets.GetPresets()
  local presetsDir = dir('Presets')
  local addedPresets = {}

  AddCustomizePreset()
  
  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Globals.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo.id and presetContents.PresetInfo.name and VectorsPresets.PresetsList[presetContents.PresetInfo.id] == nil then
        VectorsPresets.AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
        table.insert(addedPresets, presetFile.name)
      else
        Globals.Print(VectorsPresets.__NAME, LogText.presets_skippedFileData, presetFile.name)
      end
    end
  end

  Globals.Print(VectorsPresets.__NAME, LogText.presets_loaded, table.concat(addedPresets, ", "))

  -- Sort the preset names by their keys (preset ids) so they appear alphabetically in UI 
  for k in pairs(VectorsPresets.PresetsList) do
    table.insert(VectorsPresets.sortedPresetIds, k)
  end

  table.sort(VectorsPresets.sortedPresetIds)
end

function VectorsPresets.PrintPresets()
  for _, presetId in ipairs(VectorsPresets.PresetsList) do
    local name = VectorsPresets.PresetsList[presetId].PresetInfo.name
    local description = VectorsPresets.PresetsList[presetId].PresetInfo.description
    local author = VectorsPresets.PresetsList[presetId].PresetInfo.author

    print("| Name:", name, "| Description:", description, "| Author:", author, "| ID:", presetId)
  end

  if VectorsPresets.selectedPreset then
    Globals.Print(VectorsPresets.__NAME, "Selected preset:", VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.name)
  end
end

function VectorsPresets.LoadPreset()
  -- Use Default if user has not selected any other preset yet
  if VectorsPresets.selectedPreset == nil then
    VectorsPresets.selectedPreset = "a001"
  end

  local presetPath = "Presets/"

  -- Load Default when Customize preset is selected
  if VectorsPresets.selectedPreset == "a000" then
    presetPath = presetPath .. "Default.json"
    
  else
    presetPath = presetPath .. VectorsPresets.PresetsList[VectorsPresets.selectedPreset].file
  end

  local loadedPreset = Globals.LoadJSON(presetPath)

  if loadedPreset then
    LoadedPreset = Globals.Deepcopy(loadedPreset)
    Vectors.ApplyPreset(LoadedPreset)
  end

  SaveUserSettings()
end

function VectorsPresets.OnInitialize()
  Globals.MergeTables(VectorsPresets, Settings.GetUserSettings("Presets"))
  VectorsPresets.GetPresets()
  VectorsPresets.LoadPreset()

  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not VectorsPresets.selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

------------------
-- On... registers
------------------

function VectorsPresets.OnOverlayOpen()
  -- Translate and refresh presets info and list
  VectorsPresets.PresetsList = Localization.GetTranslation(VectorsPresets.PresetsList, "PresetsList")
  
  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not VectorsPresets.selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

------------------
-- Local UI
------------------

function VectorsPresets.DrawUI()
  if ImGui.BeginTabItem(VehiclesText.tabname) then
    if not Tracker.IsGameFrameGeneration() then
      ImGuiExt.Text(GeneralText.info_frameGenOff, true)
      return
    end

    ImGuiExt.Text(GeneralText.title_general)
    ImGui.Separator()
    ImGuiExt.Text(VehiclesText.MaskingPresets.name)

    local selectedPresetName = VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.name

    -- Displays list of presets' names and sets a preset
    if ImGui.BeginCombo("##Presets", selectedPresetName) then
      for _, presetId in ipairs(VectorsPresets.sortedPresetIds) do
        local name = VectorsPresets.PresetsList[presetId].PresetInfo.name
        local isSelected = (selectedPresetName == name)
        
        if ImGui.Selectable(name, isSelected) then
          selectedPresetName = name
          VectorsPresets.selectedPreset = VectorsPresets.PresetsList[presetId].PresetInfo.id
        end
        if isSelected then
          ImGui.SetItemDefaultFocus()
          ImGuiExt.ResetStatusBar()
        end
      end
      ImGui.EndCombo()
    end

    ImGuiExt.SetTooltip(VehiclesText.MaskingPresets.tooltip)

    ImGui.SameLine()
    if ImGui.Button("   " .. GeneralText.apply .. "   ") then
      VectorsPresets.LoadPreset()

      ImGuiExt.SetStatusBar(GeneralText.settings_applied_veh)
    end

    if VectorsPresets.selectedPreset then
      if VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.description then
        ImGuiExt.Text(VehiclesText.MaskingPresets.description)
        ImGuiExt.Text(VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.description, true)
      end

      if VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.author then
        ImGuiExt.Text(VehiclesText.MaskingPresets.author)
        ImGui.SameLine()
        ImGuiExt.Text(VectorsPresets.PresetsList[VectorsPresets.selectedPreset].PresetInfo.author)
      end
    end

    -- VectorsCustomize interface starts
    if VectorsPresets.selectedPreset == "a000" then
      if Tracker.IsVehicleMounted() then
        ImGui.Text("")
        -- VectorsCustomize.DrawUI()
      else
        ImGuiExt.SetStatusBar(GeneralText.info_getIn)
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

    ImGui.EndTabItem()
  end
end

return VectorsPresets