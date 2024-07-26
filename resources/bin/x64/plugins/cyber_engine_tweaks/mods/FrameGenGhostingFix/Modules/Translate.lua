Translate = {
  __NAME = "Translate",
  __VERSION = { 5, 0, 0 },
  gameOnScreenLanguage = nil,
  modDefaultLanguage = "en-us",
}

local Globals = require("Modules/Globals")
local Localization = require("Modules/Localization")
local LogText = Localization.LogText

-- stores default localizations in case of returning to the default or English language during game
local LocalizationFallback = {}

-- stores previous gameOnScreenLanguage for fallback checks for the module and each translated table
local LastGameOnScreenLanguage = {
  __module = Translate.modDefaultLanguage
}

-- temporary table to store received localization
local defaultLocalization

-- temporary table to store new localization
local translatedLocalization

-- Replace the default language values with the found translated values
local function MergeLanguages(default, selected)
  local merged = {}

  if selected == nil then Globals.Print(Translate.__NAME, LogText.translate_keyNotFound, selected, Translate.gameOnScreenLanguage) return end

  -- Add all used keys into merged with either translated values or the default values
  for key, defaultValue in pairs(default) do
    if type(defaultValue) == "table" then
      merged[key] = MergeLanguages(defaultValue, selected[key] or {})
    else
      merged[key] = selected[key] or defaultValue
    end
  end
  return merged
end

-- apply translation
local function ApplyTranslation(key)
  --loads a translation file for the current lang
  local translationFile = "Translations/" .. Translate.gameOnScreenLanguage .. ".lua"
  local chunk = loadfile(translationFile)

  --if the translation file exist, merges it with the default localization
  if chunk then
    local translation = chunk()

    translatedLocalization = MergeLanguages(defaultLocalization, translation[key])

    if LastGameOnScreenLanguage.__module == Translate.gameOnScreenLanguage then return end
    Globals.Print(Translate.__NAME, LogText.translate_translationFound, Translate.gameOnScreenLanguage)
  else
    translatedLocalization = MergeLanguages(defaultLocalization, {})

    if LastGameOnScreenLanguage.__module == Translate.gameOnScreenLanguage then return end
    Globals.Print(Translate.__NAME, LogText.translate_translationNotFound, Translate.gameOnScreenLanguage)
  end
end

-- Get the game's current onScreen language code
function Translate.GetOnScreenLanguage()
  Translate.gameOnScreenLanguage = Game.NameToString(Game.GetSettingsSystem():GetVar("/language", "OnScreen"):GetValue())
  return Translate.gameOnScreenLanguage
end

-- Translate seletected key (or table) from selected lua file (with a source table): function merges default localization with a translation if such exists for current language. sourceTablePath: string, key: string
function Translate.SetTranslation(sourceTablePath, key)
  -- decalres lua module that contains a default localization
  local sourceTable = require(sourceTablePath)

  if sourceTable and sourceTable[key] then
    -- adds fallback to the default localization for the source table if such doesn't exist yet
    if LocalizationFallback[key] == nil then
      LocalizationFallback[key] = sourceTable[key]
    end

    -- defines defaultLocalization table for sake of further steps
    defaultLocalization = LocalizationFallback[key]
  else
    Globals.PrintError(Translate.__NAME, LogText.translate_keyNotFound, key, sourceTablePath)
  end

  --get current language
  Translate.GetOnScreenLanguage()

  -- applies the new table back to the source table if needed
  if Translate.gameOnScreenLanguage ~= LastGameOnScreenLanguage[key] then
    if Translate.gameOnScreenLanguage ~= Translate.modDefaultLanguage then
      ApplyTranslation(key)
    else
      translatedLocalization = MergeLanguages(defaultLocalization, {})

      if LastGameOnScreenLanguage.__module == Translate.gameOnScreenLanguage then return end
      Globals.Print(Translate.__NAME, LogText.translate_baseLocalization, Translate.modDefaultLanguage)
    end

    sourceTable[key] = translatedLocalization
  end

  LastGameOnScreenLanguage[key] = Translate.gameOnScreenLanguage
  LastGameOnScreenLanguage.__module = Translate.gameOnScreenLanguage
end

return Translate

