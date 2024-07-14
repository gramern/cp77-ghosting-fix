local Presets = {
  __NAME = "Presets",
  __VERSION_NUMBER = 500,
  selectedPreset = nil, -- must be a unique identifier for the preset
  sortedPresetIds = {},
  List = {
    a000 = {
      PresetInfo = {
        name = "Customize",
        description = "Customize your preset.",
        author = nil,
        id = "a000"
      }
    }
  }
}

local UserSettings = {}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local UI = require("Modules/UI")

local UIText = Localization.UIText
local LogText = Localization.LogText

local Translate = require("Modules/Translate")
local Vectors = require("Modules/Vectors")
local VectorsCustomize = require("Modules/VectorsCustomize")

function Presets.LoadJSON(filename)
  local content = {}

  local file = io.open(filename, "r")
  if file ~= nil then
      content = json.decode(file:read("*a"))
      file:close()
  end

  return content
end

function Presets.AddPreset(presetInfo, id, filename)
  -- Skip if List is already populated with the same preset
  if Presets.List[id] ~= nil then Config.Print(LogText.presets_skippedFileDuplicate, nil, nil, Presets.__NAME) return end

  Presets.List[id] = {file = filename, PresetInfo = presetInfo}
end

function Presets.GetPresets()
  local presetsDir = dir('Presets')
  local addedPresets = {}
  
  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = Presets.LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo.id and presetContents.PresetInfo.name and Presets.List[presetContents.PresetInfo.id] == nil then
        Presets.AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
        table.insert(addedPresets, presetFile.name)
      else
        Config.Print(LogText.presets_skippedFileData, presetFile.name, nil, Presets.__NAME)
      end
    end
  end

  Config.Print(LogText.presets_loaded, table.concat(addedPresets, ","), nil, Presets.__NAME)

  -- Sort the preset names by their keys (preset ids) so they appear alphabetically in UI 
  for k in pairs(Presets.List) do
    table.insert(Presets.sortedPresetIds, k)
  end

  table.sort(Presets.sortedPresetIds)
end

function Presets.PrintPresets()
  for _, presetId in ipairs(Presets.List) do
    local name = Presets.List[presetId].PresetInfo.name
    local description = Presets.List[presetId].PresetInfo.description
    local author = Presets.List[presetId].PresetInfo.author

    print("| Name:", name, "| Description:", description, "| Author:", author, "| ID:", presetId)
  end

  if Presets.selectedPreset then
    Config.Print("Selected preset:", Presets.List[Presets.selectedPreset].PresetInfo.name)
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
    presetPath = presetPath .. Presets.List[Presets.selectedPreset].file
  end

  local loadedPreset = Presets.LoadJSON(presetPath)

  if loadedPreset then
    Config.WriteWhiteBoard("Presets", loadedPreset)
  end

  Presets.SaveUserSettings()

end

function Presets.GetUserSettings()
  UserSettings = {
    selectedPreset = Presets.selectedPreset
  }

  return UserSettings
end

function Presets.SaveUserSettings()
  Settings.WriteUserSettings("Presets", Presets.GetUserSettings())
end

function Presets.OnInitialize()
  Config.MergeTables(Presets, Settings.GetUserSettings("Presets"))
  Presets.GetPresets()
  Presets.LoadPreset()
end

function Presets.OnOverlayOpen()
  -- Refresh UIText
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  -- Translate and refresh presets info and list
  if Translate then
    Translate.SetTranslation("Modules/Presets", "List")
  end
end

-- Local UI
function Presets.DrawUI()
  if UI.Std.BeginTabItem(UIText.Vehicles.tabname) then

    UI.Ext.TextWhite(UIText.General.title_general)
    UI.Std.Separator()
    UI.Ext.TextWhite(UIText.Vehicles.MaskingPresets.name)

    local selectedPresetName = Presets.List[Presets.selectedPreset].PresetInfo.name

    -- Displays list of presets' names and sets a preset
    if UI.Std.BeginCombo("##", selectedPresetName) then
      for _, presetId in ipairs(Presets.sortedPresetIds) do
        local name = Presets.List[presetId].PresetInfo.name
        local isSelected = (selectedPresetName == name)
        
        if UI.Std.Selectable(name, isSelected) then
          selectedPresetName = name
          Presets.selectedPreset = Presets.List[presetId].PresetInfo.id
        end
        if isSelected then
          UI.Std.SetItemDefaultFocus()
          Config.ResetStatusBar()
        end
      end
      UI.Std.EndCombo()
    end

    UI.Ext.OnItemHovered.SetTooltip(UIText.Vehicles.MaskingPresets.tooltip)

    UI.Std.SameLine()
    if UI.Std.Button("   " .. UIText.General.apply .. "   ") then
      Presets.LoadPreset()
      Vectors.ApplyPreset()

      Config.SetStatusBar(UIText.General.settings_applied_veh)
    end

    if Presets.selectedPreset then
      if Presets.List[Presets.selectedPreset].PresetInfo.description then
        UI.Ext.TextWhite(UIText.Presets.infotabname)
        UI.Ext.TextWhite(Presets.List[Presets.selectedPreset].PresetInfo.description)
      end

      if Presets.List[Presets.selectedPreset].PresetInfo.author then
        UI.Ext.TextWhite(UIText.Presets.authtabname)
        UI.Std.SameLine()
        UI.Ext.TextWhite(Presets.List[Presets.selectedPreset].PresetInfo.author)
      end
    end

    -- VectorsCustomize interface starts
    if Presets.selectedPreset == "a000" then
      if Config.IsMounted() then
        UI.Std.Text("")
        VectorsCustomize.DrawUI()
      else
        Config.SetStatusBar(UIText.General.info_getIn)
      end
    end

    UI.Ext.StatusBar(Config.GetStatusBar())

    UI.Std.EndTabItem()
  end
end

return Presets