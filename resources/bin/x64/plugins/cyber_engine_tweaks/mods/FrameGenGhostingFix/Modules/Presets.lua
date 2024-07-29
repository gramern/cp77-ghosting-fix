local Presets = {
  __NAME = "Presets",
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
local UIText = Localization.GetUIText()

------------------
-- UserSettings
------------------

local function GetUserSettings()
  UserSettings = {
    selectedPreset = Presets.selectedPreset
  }

  return UserSettings
end

local function SaveUserSettings()
  Settings.WriteUserSettings("Presets", GetUserSettings())
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

  Presets.AddPreset(customizePreset, customizePreset.id, customizePreset.name)
end

function Presets.AddPreset(presetInfo, id, filename)
  -- Skip if PresetsList is already populated with the same preset
  if Presets.PresetsList[id] ~= nil then Globals.Print(Presets.__NAME, LogText.presets_skippedFileDuplicate) return end

  Presets.PresetsList[id] = {file = filename, PresetInfo = presetInfo}
end

function Presets.GetPresets()
  local presetsDir = dir('Presets')
  local addedPresets = {}

  AddCustomizePreset()
  
  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Globals.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo.id and presetContents.PresetInfo.name and Presets.PresetsList[presetContents.PresetInfo.id] == nil then
        Presets.AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
        table.insert(addedPresets, presetFile.name)
      else
        Globals.Print(Presets.__NAME, LogText.presets_skippedFileData, presetFile.name)
      end
    end
  end

  Globals.Print(Presets.__NAME, LogText.presets_loaded, table.concat(addedPresets, ", "))

  -- Sort the preset names by their keys (preset ids) so they appear alphabetically in UI 
  for k in pairs(Presets.PresetsList) do
    table.insert(Presets.sortedPresetIds, k)
  end

  table.sort(Presets.sortedPresetIds)
end

function Presets.PrintPresets()
  for _, presetId in ipairs(Presets.PresetsList) do
    local name = Presets.PresetsList[presetId].PresetInfo.name
    local description = Presets.PresetsList[presetId].PresetInfo.description
    local author = Presets.PresetsList[presetId].PresetInfo.author

    print("| Name:", name, "| Description:", description, "| Author:", author, "| ID:", presetId)
  end

  if Presets.selectedPreset then
    Globals.Print(Presets.__NAME, "Selected preset:", Presets.PresetsList[Presets.selectedPreset].PresetInfo.name)
  end
end

function Presets.LoadPreset()
  -- Use Default if user has not selected any other preset yet
  if Presets.selectedPreset == nil then
    Presets.selectedPreset = "a001"
  end

  local presetPath = "Presets/"

  -- Load Default when Customize preset is selected
  if Presets.selectedPreset == "a000" then
    presetPath = presetPath .. "Default.json"
    
  else
    presetPath = presetPath .. Presets.PresetsList[Presets.selectedPreset].file
  end

  local loadedPreset = Globals.LoadJSON(presetPath)

  if loadedPreset then
    LoadedPreset = Globals.Deepcopy(loadedPreset)
    Vectors.ApplyPreset(LoadedPreset)
  end

  SaveUserSettings()
end

function Presets.OnInitialize()
  Globals.MergeTables(Presets, Settings.GetUserSettings("Presets"))
  Presets.GetPresets()
  Presets.LoadPreset()

  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not Presets.selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

------------------
-- On... registers
------------------

function Presets.OnOverlayOpen()
  -- Translate and refresh presets info and list
  Presets.PresetsList = Localization.GetTranslation(Presets.PresetsList, "PresetsList")
  
  if not Tracker.IsGameFrameGeneration() then
    Vectors.SetMaskingState(false)
  elseif Tracker.IsGameFrameGeneration() and not Vectors.GetMaskingState() and not Presets.selectedPreset == "a005" then
    Vectors.SetMaskingState(true)
  end
end

------------------
-- Local UI
------------------

function Presets.DrawUI()
  if ImGui.BeginTabItem(UIText.Vehicles.tabname) then
    if not Tracker.IsGameFrameGeneration() then
      ImGuiExt.Text(UIText.General.info_frameGenOff, true)
      return
    end

    ImGuiExt.Text(UIText.General.title_general)
    ImGui.Separator()
    ImGuiExt.Text(UIText.Vehicles.MaskingPresets.name)

    local selectedPresetName = Presets.PresetsList[Presets.selectedPreset].PresetInfo.name

    -- Displays list of presets' names and sets a preset
    if ImGui.BeginCombo("##Presets", selectedPresetName) then
      for _, presetId in ipairs(Presets.sortedPresetIds) do
        local name = Presets.PresetsList[presetId].PresetInfo.name
        local isSelected = (selectedPresetName == name)
        
        if ImGui.Selectable(name, isSelected) then
          selectedPresetName = name
          Presets.selectedPreset = Presets.PresetsList[presetId].PresetInfo.id
        end
        if isSelected then
          ImGui.SetItemDefaultFocus()
          ImGuiExt.ResetStatusBar()
        end
      end
      ImGui.EndCombo()
    end

    ImGuiExt.SetTooltip(UIText.Vehicles.MaskingPresets.tooltip)

    ImGui.SameLine()
    if ImGui.Button("   " .. UIText.General.apply .. "   ") then
      Presets.LoadPreset()

      ImGuiExt.SetStatusBar(UIText.General.settings_applied_veh)
    end

    if Presets.selectedPreset then
      if Presets.PresetsList[Presets.selectedPreset].PresetInfo.description then
        ImGuiExt.Text(UIText.Presets.infotabname)
        ImGuiExt.Text(Presets.PresetsList[Presets.selectedPreset].PresetInfo.description, true)
      end

      if Presets.PresetsList[Presets.selectedPreset].PresetInfo.author then
        ImGuiExt.Text(UIText.Presets.authtabname)
        ImGui.SameLine()
        ImGuiExt.Text(Presets.PresetsList[Presets.selectedPreset].PresetInfo.author)
      end
    end

    -- VectorsCustomize interface starts
    if Presets.selectedPreset == "a000" then
      if Tracker.IsVehicleMounted() then
        ImGui.Text("")
        -- VectorsCustomize.DrawUI()
      else
        ImGuiExt.SetStatusBar(UIText.General.info_getIn)
      end
    end

    ImGuiExt.StatusBar(ImGuiExt.GetStatusBar())

    ImGui.EndTabItem()
  end
end

return Presets