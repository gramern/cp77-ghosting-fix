local Diagnostics = {
  __NAME = "Diagnostics",
  __VERSION_NUMBER = 490,
  isModsCompatibility = true,
  modfiles = {},
  isUpdateRecommended = false
}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")

local UIText = Localization.UIText

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
  if ModArchiveExists('LimitedHUD.archive') then
    table.insert(Diagnostics.modfiles, 1, "Limited HUD")
    Diagnostics.isUpdateRecommended = true
  end

  if ModArchiveExists('basegame_hud_minimap_scanner_tweak.archive') then
    table.insert(Diagnostics.modfiles, 2, "Limited HUD's Scanner Tweak")
    Diagnostics.isUpdateRecommended = true
    Diagnostics.isModsCompatibility = false
  end

  if ModArchiveExists('###framegenghostingfix_LimitedHUD.archive') then
    table.insert(Diagnostics.modfiles, 3, "Limited HUD")
    Diagnostics.isUpdateRecommended = true
  end

  if ModArchiveExists('##ReduxUI_AddonSpeedometer.archive') then
    table.insert(Diagnostics.modfiles, 4, "Redux UI E3 Speedometer")
    Diagnostics.isUpdateRecommended = true

    if not ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
      Diagnostics.isModsCompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD.archive') then
    table.insert(Diagnostics.modfiles, 5, "Project E3 - HUD")
    Diagnostics.isUpdateRecommended = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3.archive') then
      Diagnostics.isModsCompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD-Lite.archive') then
    table.insert(Diagnostics.modfiles, 6, "Project E3 - HUD (Lite)")
    Diagnostics.isUpdateRecommended = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3Lite.archive') then
      Diagnostics.isModsCompatibility = false
    end
  end

  if ModArchiveExists('dxstreamlined.archive') then
    table.insert(Diagnostics.modfiles, 7, "Streamlined HUD")
    Diagnostics.isUpdateRecommended = true

    if not ModArchiveExists('###framegenghostingfix_StreamlinedHUD.archive') then
      Diagnostics.isModsCompatibility = false
    end
  end
end

function Diagnostics.OnInitialize()
  Diagnostics.CheckModsCompatibility()
  if Diagnostics.isModsCompatibility then return end
  Config.SetModReady(false)
end

function Diagnostics.OnOverlayOpen()
  Localization = require("Modules/Localization")
  UIText = Localization.UIText
end

--UI

local ImGui = ImGui
local ImGuiCol = ImGuiCol
local ImGuiExt = {

TextGreen = function(string)
  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
  ImGui.Text(string)
  ImGui.PopStyleColor()
end,

TextRed = function(string)
  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
  ImGui.Text(string)
  ImGui.PopStyleColor()
end,

TextWhite = function(string)
  ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
  ImGui.Text(string)
  ImGui.PopStyleColor()
end
}

function Diagnostics.DrawUI()
  if ImGui.BeginTabItem(UIText.Diagnostics.tabname) then
    if not Diagnostics.isModsCompatibility then
      ImGuiExt.TextRed(UIText.Diagnostics.title_warning)
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Diagnostics.textfield_1)
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Diagnostics.textfield_2)
    else
      ImGuiExt.TextGreen(UIText.Diagnostics.title_info)
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Diagnostics.textfield_3)
      ImGui.Text("")
      ImGuiExt.TextWhite(UIText.Diagnostics.textfield_4)
    end

    for modfile,mod in pairs(Diagnostics.modfiles) do
      ImGuiExt.TextWhite(mod)
    end
   
    ImGui.EndTabItem()
  end
end

return Diagnostics