local Localization = {
  defaultLang = "en-us",
  GameOnScreenLang = nil,
  UIText = nil,
  presetsList = {},
  presetsIDs = {}
}

function Localization.translate()
  local Config = require("Modules/Config")
  local loadedPresets = Config.presetInfoStack or {}
  --[=====[ 
  Config.presetInfoStack = { PresetID = {name = "Preset's Name", description = "Preset's description", author = "Preset's author name" }, PresetID = {name = "Preset's Name", description = "Preset's description", author = "Preset's author name" }, ... }

  For Example:

  local loadedPresets = {
      [90] = {
          name = "Test for 90",
          description = "Test with ID 90",
          author = "90s",
      },
      [2000] = {
          name = "Test for 2000",
          description = "Test with ID 2000",
          author = "2000s",
      },
  }

  local PresetName = loadedPresets[90].name

  --]=====]

  -- Load the default language file
  -- Once UIText.lua is now en-us.lua
  local defautlTranslation = require("Translations/" .. Localization.defaultLang)

  -- Add presets to the default translation
  defautlTranslation.Presets.Info = loadedPresets

  -- Try to load the selected game onscreen language file
  local selectedTranslation = require("Translations/" .. Localization.GameOnScreenLang)
  if not selectedTranslation then
      selectedTranslation = {}
  end


  -- Function to merge translation file with default text values
  local function mergeTranslations(fallback, selected)
      local merged = {}
      -- Add all keys of fallback into merged with selected values if possible else use fallback values
      for key, value in pairs(fallback) do
          if type(value) == "table" then
              merged[key] = mergeTranslations(value, selected[key] or {})
          else
              merged[key] = selected[key] or value
          end
      end
      -- Add all keys of selected if not already done using fallback keys
      for key, value in pairs(selected) do
          if merged[key] == nil then
              merged[key] = value
          end
      end

      return merged
  end

  local finalTranslation = mergeTranslations(defautlTranslation, selectedTranslation)
  Localization.UIText = finalTranslation
end

function Localization.presetsUpdate()
  local i = 1
  for id, preset in pairs(Localization.UIText.Presets.Info) do
    Localization.presetsIDs[i] = id
    Localization.presetsList[i] = preset.name
    i = i + 1
  end
end


return Localization