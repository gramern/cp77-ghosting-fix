local VectorsPresets = {
  __NAME = "VectorsPresets",
  __VERSION = { 5, 0, 0 },
}

local SortedPresetIds = {}

local PresetsList = {}

local selectedPreset = nil -- must be a unique identifier for the preset

local LoadedPreset = {}

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

----------------------------------------------------------------------------------------------------------------------
-- UserSettings
----------------------------------------------------------------------------------------------------------------------

local function GetUserSettings()
  local userSettings = {
    SelectedPreset = selectedPreset
  }

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
  if PresetsList[id] ~= nil then Globals.Print(VectorsPresets.__NAME, LogText.presets_skippedFileDuplicate) return end

  PresetsList[id] = {file = filename, PresetInfo = presetInfo}
end

function VectorsPresets.GetPresets()
  local presetsDir = dir('Presets')
  local addedPresets = {}

  AddCustomizePreset()
  
  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Globals.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo.id and presetContents.PresetInfo.name and PresetsList[presetContents.PresetInfo.id] == nil then
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

  -- Load Default when Customize preset is selected
  if selectedPreset == "a000" then
    presetPath = presetPath .. "Default.json"
    
  else
    presetPath = presetPath .. PresetsList[selectedPreset].file
  end

  local loadedPreset = Globals.LoadJSON(presetPath)

  if loadedPreset then
    LoadedPreset = Globals.Deepcopy(loadedPreset)
    Vectors.LoadPreset(LoadedPreset)
  end

  SaveUserSettings()
end

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

----------------------------------------------------------------------------------------------------------------------
-- On... registers
----------------------------------------------------------------------------------------------------------------------

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

function VectorsPresets.DrawUI()
  if ImGui.BeginTabItem(VehiclesText.tabname) then
    if not Tracker.IsGameFrameGeneration() then
      ImGuiExt.Text(GeneralText.info_frameGenOff, true)
      return
    end

    ImGuiExt.Text(GeneralText.title_general)
    ImGui.Separator()
    ImGuiExt.Text(VehiclesText.MaskingPresets.name)

    local selectedPresetName = PresetsList[selectedPreset].PresetInfo.name

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

    ImGui.SameLine()
    if ImGui.Button("   " .. GeneralText.apply .. "   ") then
      VectorsPresets.LoadPreset()

      ImGuiExt.SetStatusBar(GeneralText.settings_applied_veh)
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

    -- VectorsCustomize interface starts
    if selectedPreset == "a000" then
      if Tracker.IsVehicleMounted() then
        ImGui.Text("")
        -- VectorsCustomize.DrawUI()
        
        -- debugging
        if Settings.IsDebugMode() then
          if ImGui.Button("   VectorsCustomizeTesting   ") then
            Vectors.SetLiveViewContext(true)
            Vectors.SetLiveViewMask(true, "Mask1")
          end
        end
      else
        ImGuiExt.SetStatusBar(GeneralText.info_getIn)
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

    ImGui.EndTabItem()
  end
end

return VectorsPresets