local Presets = {
  __NAME = "Presets",
  __VERSION_NUMBER = 500,
  selectedPreset = nil,
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

function LoadJSON(fileName)
  local content = {}

  local file = io.open(fileName, "r")
  if file ~= nil then
      local configStr = file:read("*a")
      content = json.decode(configStr)
      file:close()
  end

  return content
end

function SaveJSON(fileName, content)
  local file = io.open(fileName, "w")
  if file ~= nil then
      local jconfig = json.encode(content)
      file:write(jconfig)
      file:close()
  end
end

function Presets.AddPreset(presetInfo, id, filename)
  -- Skip if File is already populated with same preset
  if Presets.List[id] ~= nil then Config.Print(LogText.presets_skippedFileDuplicate, nil, nil, Presets.__NAME) return end

  Presets.List[id] = {PresetInfo = {}}
  Presets.List[id].PresetInfo = presetInfo
  Presets.List[id].PresetInfo.file = filename

  Config.Print(LogText.presets_added, presetInfo['name'], nil, Presets.__NAME)
end

function Presets.GetPresets()
  local presetsDir = dir('Presets')

  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.json$') then
      local presetPath = "Presets/" .. presetFile.name
      local presetContents = LoadJSON(presetPath)
      
      if presetContents and presetContents.PresetInfo.id and presetContents.PresetInfo.name and Presets.List[presetContents.PresetInfo.id] == nil then
        Presets.AddPreset(presetContents.PresetInfo, presetContents.PresetInfo.id, presetFile.name)
      else
        Config.Print(LogText.presets_skippedFileData, presetFile.name, nil, Presets.__NAME)
      end
    end
  end
end

function Presets.PrintPresets()
  for position, presetId in ipairs(Presets.List) do
    local name = Presets.List[presetId].PresetInfo.name
    local description = Presets.List[presetId].PresetInfo.description
    local author = Presets.List[presetId].PresetInfo.author

    print("| Position:", position, "| Name:", name, "| Description:", description, "| Author:", author, "| ID:", presetId)
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

  local presetPath = nil

  -- Load Default when Customize preset is selected
  if Presets.selectedPreset == "a000" then
    presetPath = "Presets/" .. "Default.json"
    
  else
    presetPath = "Presets/" .. Presets.List[Presets.selectedPreset].PresetInfo.file
  end

  local loadedPreset = LoadJSON(presetPath)

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
  -- refresh UIText
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  -- translate and refresh presets info and list
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

    -- displays list of presets' names and sets a preset
    if UI.Std.BeginCombo("##", selectedPresetName) then

      -- Need to sort the preset names alphabetically by their keys (preset ids)
      local presetIds = {}
      for k in pairs(Presets.List) do table.insert(presetIds, k) end
      table.sort(presetIds)

      for _, presetId in ipairs(presetIds) do
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

    -- VectorsCustomize interface starts ------------------------------------------------------------------------------------------------------------------
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