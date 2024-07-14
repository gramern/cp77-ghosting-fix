local Diagnostics = {
  __NAME = "Diagnostics",
  __VERSION_NUMBER = 500,
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

    for _, mod in pairs(Diagnostics.modfiles) do
      UI.Ext.TextWhite(mod)
    end
   
    UI.Std.EndTabItem()
  end
end

return Diagnostics