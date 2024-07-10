local Presets = {
  __NAME = "Presets",
  __VERSION_NUMBER = 490,
  masksController = nil,
  selectedPreset = nil,
  selectedPresetPosition = nil,
  List = {
    OnScreenName = {},
    File = {},
    ID = {},
  },
  PresetsInfo = {}
}

local DefaultPresets = {
  Customize = {
    PresetInfo = {
      file = "Customize.lua",
      name = "Customize",
      description = "Customize your preset.",
      author = nil,
      id = "a001"
    },
  },
  Default = {
    MaskingGlobal = {
      vehicles = true,
      onFoot = true --not used now
    },
    Vectors = {
      VehElements = {
        BikeSpeedometer = {
          Offset = {x=0.0, y=0.45, z=0.8},
          rotation = 180,
          Size = {x = 6120, y = 1600},
          visible = true,
        },
        BikeHandlebars = {
          Left = {
            Offset = {x=-0.6, y=0.48, z=0.7},
            rotation = 0,
            Size = {x = 3000, y = 1800},
            visible = true,
          },
          Right = {
            Offset = {x=0.6, y=0.48, z=0.7},
            rotation = 0,
            Size = {x = 3000, y = 1800},
            visible = true,
          }
        },
        BikeWindshield = {
          Offset = {x=0.0, y=0.54, z=1},
          rotation = 0,
          Size = {x = 3600, y = 1200},
          visible = true,
        },
        CarDoors = {
          Left = {
            Offset = {x=-1.2, y=0, z=0.55},
            rotation = 140,
            Size = {x = 3000, y = 2000},
            visible = true,
          },
          Right = {
            Offset = {x=1.2, y=0, z=0.55},
            rotation = -160,
            Size = {x = 2250, y = 1500},
            visible = true,
          },
        },
        CarSideMirrors = {
          Left = {
            Offset = {x=-1, y=0.65, z=0.45},
            rotation = 40,
            Size = {x = 1400, y = 1200},
            visible = true,
          },
          Right = {
            Offset = {x=1.05, y=0.65, z=0.45},
            rotation = 145,
            Size = {x = 800, y = 800},
            visible = true,
          },
        },
      },
      VehMasks = {
        AnchorPoint = {x = 0.5, y = 0.5},
        HorizontalEdgeDown = {
          Opacity = {
            Def = {
              max = 0.03,
            }
          },
          Size = {
            Def = {
              lock = false,
              x = 4240,
              y = 1480
            },
          },
          Visible = {
            Def = {
              corners = true,
              fill = true,
              fillLock = false,
              tracker = true,
            }
          }
        },
        Opacity = {
          Def = {
            delayDuration = 1.5,
            delayThreshold = 0.95,
            gain = 1,
            max = 0.05,
            speedFactor = 0.01,
            stepFactor = 0.1
          },
        }
      }
    },
    PresetInfo = {
      file = "Default.lua",
      name = "Default",
      description = "Default preset.",
      author = nil,
      id = "a000"
    },
  },
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

function Presets.AddPreset(pos, presetFileName, presetInfoTable)
  if Presets.List.File[pos] ~= nil then Config.Print(LogText.presets_skippedFilePos,nil,nil,Presets.__NAME) return end

  table.insert(Presets.List.File, pos, presetFileName)
  table.insert(Presets.List.ID, pos, presetInfoTable['id'])

  Presets.PresetsInfo[presetInfoTable['id']] = {
    name = presetInfoTable['name'],
    description = presetInfoTable['description'],
    author = presetInfoTable['author'],
  }
end

function Presets.GetDefaultPreset()
  local customizePresetPosition = 0
  local defaultPresetPosition = 1

  if VectorsCustomize then
    customizePresetPosition = 1
    defaultPresetPosition = 2

    Presets.AddPreset(customizePresetPosition, DefaultPresets.Customize.PresetInfo.file, DefaultPresets.Customize.PresetInfo)
    Presets.AddPreset(defaultPresetPosition, DefaultPresets.Default.PresetInfo.file, DefaultPresets.Default.PresetInfo)
  else
    Presets.AddPreset(defaultPresetPosition, DefaultPresets.Default.PresetInfo.file, DefaultPresets.Default.PresetInfo)
  end

  return Presets.List.ID[defaultPresetPosition]
end

function Presets.GetPresets()
  local presetsDir = dir('Presets')
  local i = 2

  if VectorsCustomize then
    i = 3
  end

  --to prevent loading presets files named as default ones that are already in the table
  local existingLowerCase = {}
  for _,presetFileName in ipairs(Presets.List.File) do
    existingLowerCase[string.lower(presetFileName)] = true
  end

  --to prevent loading presets with the same name as ones that are already in the table
  local existingName = {}

  for _, presetFile in ipairs(presetsDir) do
    if string.find(presetFile.name, '%.lua$') then
      local preset = string.gsub(presetFile.name, ".lua", "")
      local presetPath = "Presets/" .. preset
      local presetContents = require(presetPath)
      
      if not existingLowerCase[string.lower(preset)] and
        not existingName[presetContents.PresetInfo.name] and
        presetContents and
        presetContents.PresetInfo.id and
        presetContents.PresetInfo.name and
        Presets.PresetsInfo[presetContents.PresetInfo.id] == nil
        then
          Presets.AddPreset(i,presetFile.name,presetContents.PresetInfo)
          i = i + 1

          existingLowerCase[string.lower(preset)] = true
          existingName[presetContents.PresetInfo.name] = true
      else
        Config.Print(LogText.presets_skippedFile,presetFile.name,nil,Presets.__NAME)
      end
    end
  end
end

function Presets.PrintPresets()
  for i,_ in pairs(Presets.List.File) do
    local presetFileName = Presets.List.File[i]
    local presetId = Presets.List.ID[i]
    local displayedName = Presets.List.OnScreenName[i]
    local infoStack = Presets.PresetsInfo[presetId]
    print("| Position:",i,"| OnScreen Name:",displayedName,"| File:",presetFileName,"| ID:",presetId,"| Name:",infoStack.name,"| Description:",infoStack.description,"| Author:",infoStack.author)
  end

  if Presets.selectedPreset then
    Config.Print("Selected preset:",Presets.List.File[Presets.selectedPresetPosition], Presets.List.OnScreenName[Presets.selectedPresetPosition])
  end
end

function Presets.GetOnScreenNamesList()
  for i,_ in ipairs(Presets.List.ID) do
    local presetId = Presets.List.ID[i]
    local infoStack = Presets.PresetsInfo[presetId]
    Presets.List.OnScreenName[i] = infoStack.name
  end

  return Presets.List.OnScreenName
end

function Presets.SetSelectedPreset(selectedPresetPosition)
  local presetPosition

  if selectedPresetPosition == nil then
    presetPosition = Presets.selectedPresetOnScreenName
  else
    presetPosition = selectedPresetPosition
  end

  for i,preset in ipairs(Presets.List.OnScreenName) do
    if preset == presetPosition then
      Presets.selectedPresetPosition = i
      Presets.selectedPreset = Presets.List.ID[Presets.selectedPresetPosition]
      
      return
    end
  end
end

function Presets.GetSelectedPreset()
  for i,preset in ipairs(Presets.List.ID) do
    if preset == Presets.selectedPreset then
      Presets.selectedPresetPosition = i
      return Presets.selectedPreset, Presets.selectedPresetPosition
    end
  end
end

function Presets.ApplySelectedPreset()
  if Presets.selectedPreset == nil then
    Presets.selectedPreset = Presets.List.ID[1]

    if not VectorsCustomize then return end
    Presets.selectedPreset = Presets.List.ID[2]
  end
end

function Presets.LoadPreset()
  local presetPath = nil
  local customizePresetPosition = 0
  local defaultPresetPosition = 1

  if VectorsCustomize then
    customizePresetPosition = 1
    defaultPresetPosition = 2
  end

  if Presets.List.File[Presets.selectedPresetPosition] then
    presetPath = "Presets/" .. Presets.List.File[Presets.selectedPresetPosition]
  end

  if Presets.selectedPresetPosition == defaultPresetPosition or Presets.selectedPresetPosition == customizePresetPosition or not presetPath then
    if not presetPath then
      Presets.SetSelectedPreset(defaultPresetPosition)
    end

    Config.WriteWhiteBoard("Presets",DefaultPresets.Default)
  else
    presetPath = string.gsub(presetPath, ".lua", "")
    local Preset = require(presetPath)

    if Preset then
      Config.WriteWhiteBoard("Presets",Preset)
    end
  end
end

function Presets.GetUserSettings()
  UserSettings = {
    selectedPreset = Presets.selectedPreset
  }

  return UserSettings
end

function Presets.SaveUserSettings()
  Settings.WriteUserSettings("Presets",Presets.GetUserSettings())
end

function Presets.OnInitialize()
  Config.MergeTables(Presets,Settings.GetUserSettings("Presets"))
  Presets.GetDefaultPreset()
  Presets.GetPresets()
  Presets.GetSelectedPreset()
  Presets.ApplySelectedPreset()
  Presets.LoadPreset()
end

function Presets.OnOverlayOpen()
  --refresh UIText
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  --translate and refresh presets info and list
  if Translate then
    Translate.SetTranslation("Modules/Presets", "PresetsInfo")
    Presets.GetOnScreenNamesList()
  end
end

--Local UI
function Presets.DrawUI()
  if UI.Std.BeginTabItem(UIText.Vehicles.tabname) then

    UI.Ext.TextWhite(UIText.General.title_general)

    UI.Std.Separator()

    UI.Ext.TextWhite(UIText.Vehicles.MaskingPresets.name)
    if Presets.selectedPresetPosition == nil then
      Presets.GetSelectedPreset()
    end

    -- displays list of onScreen presets' names and sets a preset
    if UI.Std.BeginCombo("##", Presets.List.OnScreenName[Presets.selectedPresetPosition]) then
      for _,preset in ipairs(Presets.List.OnScreenName) do
        local presetSelected = (Presets.selectedPresetOnScreenName == preset)
        if UI.Std.Selectable(preset, presetSelected) then
          Presets.selectedPresetOnScreenName = preset
          Presets.SetSelectedPreset()
        end
        if presetSelected then
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
      Presets.SaveUserSettings()
      Vectors.ApplyPreset()

      Config.SetStatusBar(UIText.General.settings_applied_veh)
    end

    if Presets.selectedPreset then
      if Presets.PresetsInfo[Presets.selectedPreset].description then
        UI.Ext.TextWhite(UIText.Presets.infotabname)
        UI.Ext.TextWhite(Presets.PresetsInfo[Presets.selectedPreset].description)
      end

      if Presets.PresetsInfo[Presets.selectedPreset].author then
        UI.Ext.TextWhite(UIText.Presets.authtabname)
        UI.Std.SameLine()
        UI.Ext.TextWhite(Presets.PresetsInfo[Presets.selectedPreset].author)
      end
    end

    --VectorsCustomize interface starts------------------------------------------------------------------------------------------------------------------
    if VectorsCustomize and Presets.selectedPreset == "a001" then
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