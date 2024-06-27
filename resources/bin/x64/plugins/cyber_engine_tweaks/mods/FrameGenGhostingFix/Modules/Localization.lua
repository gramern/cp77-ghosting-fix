local Localization = {
  defaultLanguage = "en-us",
  game_screen_language = nil,
  defaultTranslationFallback = {},
  presetsList = {},
  presetIDs = {},
  UIText = {}
}

local Presets = require("Modules/Presets")

-- Get the default language file first
local default_translation_file = require("Translations/" .. Localization.defaultLanguage)
Localization.Text = default_translation_file


-- Initialize localization module after presets where loaded!
function Localization.init()
  -- Get the loaded Presets
  local LoadedPresets = Presets.presetStackInfo
  Localization.Text.Presets.Info = LoadedPresets

  -- Set the fallback translation with preset information for the translation on ui open
  Localization.defaultTranslationFallback = Localization.Text
end

-- Get the players curent set game onscreen language code
function Localization.getScreenLanguage()
  Localization.game_screen_language = Game.NameToString(Game.GetSettingsSystem():GetVar("/language", "OnScreen"):GetValue())
end

-- Translate the ui to the players screen language
function Localization.translateUI()
  -- Get the translated values for the UIText
  local selectedTranslation = require("Translations/" .. Localization.game_screen_language)
  if not selectedTranslation then
    selectedTranslation = {}
    print(Localization.Text.General.modname_log, Localization.Text.Localization.translation_not_found .. Localization.game_screen_language)
  else
    print(Localization.Text.General.modname_log, Localization.Text.Localization.translation_found .. Localization.game_screen_language)
  end

  -- Replace the default language values with the found translated values
  local function mergeLanguages(default, selected)
    local merged = {}
    -- Add all used keys into merged with either translated values or the default values
    for key, defaultValue in pairs(default) do
      if type(defaultValue) == "table" then
        merged[key] = mergeLanguages(defaultValue, selected[key] or {})
      else
        merged[key] = selected[key] or defaultValue
      end
    end

    return merged
  end
  -- End of replacing default language values

  -- Execute the replacement of default language values
  local finalTranslation = mergeLanguages(Localization.defaultTranslationFallback, selectedTranslation)
  -- set the translation as new UIText, this is seperated to prevent a bug that I wasn't able to redo after I rewrote this file
  Localization.UIText = finalTranslation
end



-- Update the presets information to the current known translation
function Localization.updatePresets()
  local i = 1
  for id, preset in pairs(Localization.UIText.Presets.Info) do
    table.insert(Localization.presetsList, i, preset.name)
    table.insert(Localization.presetIDs, i, id)
    i = i + 1
  end
end

return Localization
