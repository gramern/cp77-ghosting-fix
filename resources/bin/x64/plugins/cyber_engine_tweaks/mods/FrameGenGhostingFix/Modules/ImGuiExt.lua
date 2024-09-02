local ImGuiExt = {
  __NAME = "ImGuiExt",
  __VERSION = { 5, 2, 0 },
}

local Themes = {
  Crimson = { pop = { 1, 0.30, 0.36 }, base = { 0.86, 0.08, 0.24 }, dim = { 0.62, 0.06, 0.22 } },
  Cyan = { pop = { 0.58, 0.98, 0.98 }, base = { 0.05, 0.87, 0.87 }, dim = { 0.16, 0.64, 0.64 } },
  Yellow = { pop = { 1, 0.85, 0.31 }, base = { 1, 0.78, 0 }, dim = { 0.73, 0.56, 0 } },
}

local Globals = require("Modules/Globals")
local Localization = require("Modules/Localization")
local Settings = require("Modules/Settings")
local Tracker = require("Modules/Tracker")

local GeneralText = Localization.GetGeneralText()

local isNotification = false
local notificationText = ""
local notificationTextWidth = 0

local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiStyleVar = ImGuiStyleVar

local screenWidth, screenHeight
local scaleFactor = 1

local selectedTheme = "Crimson"

local textRed, textGreen, textBlue, textAlpha = 0, 0, 0, 1
local textAltRed, textAltGreen, textAltBlue, textAltAlpha = 1, 1, 1, 1

local bgRed, bgGreen, bgBlue, bgAlpha = 0, 0, 0, 0.75

local popRed, popGreen, popBlue, popAlpha = 1, 0.85, 0.31, 1
local baseRed, baseGreen, baseBlue, baseAlpha = 1, 0.78, 0, 1
local dimRed, dimGreen, dimBlue, dimAlpha = 0.73, 0.56, 0, 1

------------------
-- Scaling
------------------

local function ApplyScreenResolution()
  screenWidth, screenHeight = Globals.GetScreenResolution()
end

local function ApplyScaleFactor()
  local screenWidthFactor = Globals.GetScreenWidthFactor()

  if screenWidthFactor == 2 then
    scaleFactor = 1 / screenWidthFactor
  elseif screenWidthFactor == 1.34 then
    scaleFactor = 1
  else
    if screenWidth < 3840 then
      scaleFactor = 1
    else
      scaleFactor = 1.5
    end
  end
end

-- @return number: A scaling factor for the mod's window and some widgets (buttons) for the current screen.
function ImGuiExt.GetScaleFactor()
  return scaleFactor
end

------------------
-- Draw widgets
------------------

--- Draws a checkbox in the mod's theme.
--
-- @param `string`: string; The label text for the checkbox.
-- @param `setting`: boolean; The current state of the checkbox.
-- @param `toggle`: boolean; The current toggle state.
--
-- @return `setting`: boolean; The updated state of the checkbox after user interaction.
-- @return `toggle`: boolean; The toggle state (unchanged by this function).
function ImGuiExt.Checkbox(string, setting, toggle)
  ImGui.PushStyleColor(ImGuiCol.Text, textAltRed, textAltGreen, textAltBlue, textAltAlpha)
  setting, toggle = ImGui.Checkbox(string, setting)
  ImGui.PopStyleColor()

  return setting, toggle
end

--- Sets a tooltip for the previously created ImGui item.
--
-- @param `string`: string; The text to display in the tooltip.
--
-- @return None
function ImGuiExt.SetTooltip(string)
  if ImGui.IsItemHovered() and Settings.IsHelp() then
    ImGui.BeginTooltip()
    ImGui.PushTextWrapPos(ImGui.GetFontSize() * 30)
    ImGui.TextWrapped(string)
    ImGui.PushTextWrapPos()
    ImGui.EndTooltip()
  end
end

--- Draws a status bar with white text proceeded by a separator.
--
-- @param `string`: string; The text to display in the status bar.
--
-- @return None
function ImGuiExt.StatusBar(string)
  ImGui.Separator()
  ImGui.PushStyleColor(ImGuiCol.Text, textAltRed, textAltGreen, textAltBlue, textAltAlpha)
  ImGui.TextWrapped(string)
  ImGui.PopStyleColor()
end

------------------
-- Draw text
------------------

--- Draws text in in the mod's theme with an option for text wrapping.
--
-- @param `string`: string; The text to display in white.
-- @param `wrap`: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
--
-- @return None
function ImGuiExt.Text(string, wrap)
  ImGui.PushStyleColor(ImGuiCol.Text, textAltRed, textAltGreen, textAltBlue, textAltAlpha)

  if not wrap then
    ImGui.Text(string)
  else
    ImGui.TextWrapped(string)
  end

  ImGui.PopStyleColor()
end

--- Draws text in green color with an option for text wrapping.
--
-- @param `string`: string; The text to display in green.
-- @param wrap: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
--
-- @return None
function ImGuiExt.TextGreen(string, wrap)
  ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 0.2, textAlpha)

  if not wrap then
    ImGui.Text(string)
  else
    ImGui.TextWrapped(string)
  end

  ImGui.PopStyleColor()
end

--- Draws text in red color with an option for text wrapping.
--
-- @param `string`: string; The text to display in red.
-- @param `wrap`: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
--
-- @return None
function ImGuiExt.TextRed(string, wrap)
  ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, textAlpha)

  if not wrap then
    ImGui.Text(string)
  else
    ImGui.TextWrapped(string)
  end

  ImGui.PopStyleColor()
end

--- Draws text in a custom color, with an option for text wrapping.
--
-- @param `string`: string; The text to display.
-- @param `red`: number; The red component of the text color (0.0 to 1.0).
-- @param `green`: number; The green component of the text color (0.0 to 1.0).
-- @param `blue`: number; The blue component of the text color (0.0 to 1.0).
-- @param `alpha`: number; The alpha (opacity) component of the text color (0.0 to 1.0).
-- @param `wrap`: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
--
-- @return None
function ImGuiExt.TextColor(string, red, green, blue, alpha, wrap)
  if not red and not green and not blue and not alpha then ImGui.Text("ImGuiExt.TextColor: Text's color isn't defined.") return end
  ImGui.PushStyleColor(ImGuiCol.Text, red, green, blue, alpha)

  if not wrap then
    ImGui.Text(string)
  else
    ImGui.TextWrapped(string)
  end

  ImGui.PopStyleColor()
end

------------------
-- Push/Pop Styles
------------------

--- Pushes the mod's style to the UI elements.
--
-- @param None
--
-- @return None
function ImGuiExt.PushStyle()
  ImGui.PushStyleVar(ImGuiStyleVar.WindowMinSize, 420 * scaleFactor, 100 * scaleFactor)
  ImGui.PushStyleColor(ImGuiCol.Button, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.ButtonHovered, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.ButtonActive, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.CheckMark, textRed, textGreen, textBlue, textAlpha)
  ImGui.PushStyleColor(ImGuiCol.FrameBg, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.FrameBgActive, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.Header, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.HeaderHovered, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.HeaderActive, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.PopupBg, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.ResizeGrip, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.ResizeGripHovered, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.ResizeGripActive, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.SliderGrab, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.Tab, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.TabHovered, popRed, popGreen, popBlue, popAlpha)
  ImGui.PushStyleColor(ImGuiCol.TabActive, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.TabUnfocused, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.TabUnfocusedActive, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.Text, textRed, textGreen, textBlue, textAlpha)
  ImGui.PushStyleColor(ImGuiCol.TitleBg, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.TitleBgActive, baseRed, baseGreen, baseBlue, baseAlpha)
  ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, dimRed, dimGreen, dimBlue, dimAlpha)
  ImGui.PushStyleColor(ImGuiCol.WindowBg, bgRed, bgGreen, bgBlue, bgAlpha)
end

--- Pops the mod's style.
--
-- @param None
--
-- @return None
function ImGuiExt.PopStyle()
  ImGui.PopStyleColor(26)
  ImGui.PopStyleVar(1)
end

------------------
-- Notifications logic
------------------

local function EnableNotification(isEnabled)
  isNotification = isEnabled
end

-- @param `timeSeconds`: number;
-- @param `text`: string;
--
-- @return None
function ImGuiExt.SetNotification(timeSeconds, text)
  EnableNotification(true)
  notificationText = text

  Globals.SetDelay(timeSeconds, "Notification", EnableNotification, false)
end

-- @return None
function ImGuiExt.DrawNotification()
  if isNotification then
    notificationTextWidth = ImGui.CalcTextSize(notificationText)
    ImGui.SetNextWindowPos(screenWidth / 2 - notificationTextWidth / 2 - 2 * ImGui.GetStyle().ItemSpacing.x, screenHeight / 2)
    ImGui.Begin("Notification", true, ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoTitleBar)
    ImGuiExt.Text(notificationText)
    ImGui.End()

    if Tracker.IsGameReady() then return end
    EnableNotification(false)
  end
end

------------------
-- Status Bar logic
------------------

-- Table to store current text of the mod's status bar.
local Status = {
  Main = {
    bar = nil,
    previousBar = nil,
  }
}

--- Resets the status bar to display the default state: the mod's version information.
--
-- @param 'barName': string; Optional: name of a separate status bar, which updates idependently
--
-- @return None
function ImGuiExt.ResetStatusBar(barName)
  local status
  if FrameGenGhostingFix.__VERSION_STRING then
    status = GeneralText.status_version .. " " .. FrameGenGhostingFix.__VERSION_STRING
  else
    status = GeneralText.status_version .. " " .. FrameGenGhostingFix.GetVersion(true)
  end

  if not barName then
    ImGuiExt.SetStatusBar(status)
  else
    ImGuiExt.SetStatusBar(status, barName)
  end
end

--- Sets the text of the mod's status bar, updating only if the new text is different from the previous.
--
-- @param `string`: string; The new text to display in the status bar.
-- @param 'barName': string; Optional: name of a separate status bar, which updates idependently
--
-- @return None
function ImGuiExt.SetStatusBar(string, barName)
  if not barName and Status.Main.previousBar == string then return end

  if not barName then
    Status.Main.bar = string
    Status.Main.previousBar = Status.Main.bar
  else
    if not Status[barName] then
      Status[barName] = {bar = "", previousBar = ""}
    end
    
    local otherStatus = Status[barName]

    if otherStatus.previousBar == string then return end

    otherStatus.bar = string
    otherStatus.previousBar = otherStatus.bar
  end
end

--- Retrieves the current text displayed in the status bar.
--
-- @param 'barName': string; Optional: name of a separate status bar, which updates idependently
--
-- @return string; The current text displayed in the status bar.
function ImGuiExt.GetStatusBar(barName)
  if not barName then
    return Status.Main.bar
  else
    local otherStatus = Status[barName]

    return otherStatus.bar or nil
  end
end

------------------
-- Themes logic
------------------

-- @return string; Selected Theme name
function ImGuiExt.GetTheme()
  return selectedTheme
end

--- Sets the current theme based on the provided theme name.
--
-- @param `themeName`: string; The name of the theme to be applied.
--
-- @return None
function ImGuiExt.SetTheme(themeName)
  local theme = Themes[themeName]

  if not theme then
    return false
  end

  selectedTheme = themeName

  popRed, popGreen, popBlue = theme.pop[1], theme.pop[2], theme.pop[3]
  baseRed, baseGreen, baseBlue = theme.base[1], theme.base[2], theme.base[3]
  dimRed, dimGreen, dimBlue = theme.dim[1], theme.dim[2], theme.dim[3]

  return true
end

--- Retrieves a list of all available theme names.
--
-- @param None
--
-- @return table; A numerically indexed table containing the names of all themes as strings.
function ImGuiExt.GetThemesList()
  local themesList = {}
  local i = 1

  for k, v in pairs(Themes) do
    local stringKey = tostring(k)
    themesList[i] = stringKey
    i = i + 1
  end

  return themesList
end

------------------
-- On... registers
------------------

function ImGuiExt.OnOverlayOpen()
  ApplyScreenResolution()
  ApplyScaleFactor()
  ImGuiExt.ResetStatusBar()
end

function ImGuiExt.OnOverlayClose()
  ImGuiExt.ResetStatusBar()
end

return ImGuiExt