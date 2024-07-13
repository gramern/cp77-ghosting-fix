local Diagnostics = {
  __NAME = "Diagnostics",
  __VERSION_NUMBER = 492,
  isModsCompatibility = true,
  modfiles = {},
  isUpdateRecommended = false
}

local Config = require("Modules/Config")
local Localization = require("Modules/Localization")
local UI = require("Modules/UI")

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

--Local UI
function Diagnostics.DrawUI()
  if UI.Std.BeginTabItem(UIText.Diagnostics.tabname) then
    if not Diagnostics.isModsCompatibility then
      UI.Ext.TextRed(UIText.Diagnostics.title_warning)
      UI.Std.Text("")
      UI.Ext.TextWhite(UIText.Diagnostics.textfield_1)
      UI.Std.Text("")
      UI.Ext.TextWhite(UIText.Diagnostics.textfield_2)
    else
      UI.Ext.TextGreen(UIText.Diagnostics.title_info)
      UI.Std.Text("")
      UI.Ext.TextWhite(UIText.Diagnostics.textfield_3)
      UI.Std.Text("")
      UI.Ext.TextWhite(UIText.Diagnostics.textfield_4)
    end

    for modfile,mod in pairs(Diagnostics.modfiles) do
      UI.Ext.TextWhite(mod)
    end
   
    UI.Std.EndTabItem()
  end
end

return Diagnostics