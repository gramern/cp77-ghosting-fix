local Diagnostics = {
  __NAME = "Diagnostics",
  __VERSION = { 5, 0, 0 },
  isModsCompatibility = true,
  modfiles = {},
  isUpdateRecommended = false
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")

local UIText = Localization.UIText

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
end

function Diagnostics.OnInitialize()
  Diagnostics.CheckModsCompatibility()
  if Diagnostics.isModsCompatibility then return end
  Globals.SetModReady(false)
end

function Diagnostics.OnOverlayOpen()
  Localization = require("Modules/Localization")
  UIText = Localization.UIText
end

--Local UI
function Diagnostics.DrawUI()
  if ImGui.BeginTabItem(UIText.Diagnostics.tabname) then
    if not Diagnostics.isModsCompatibility then
      ImGuiExt.TextRed(UIText.Diagnostics.title_warning)
      ImGui.Text("")
      ImGuiExt.Text(UIText.Diagnostics.textfield_1)
      ImGui.Text("")
      ImGuiExt.Text(UIText.Diagnostics.textfield_2)
    else
      ImGuiExt.TextGreen(UIText.Diagnostics.title_info)
      ImGui.Text("")
      ImGuiExt.Text(UIText.Diagnostics.textfield_3)
      ImGui.Text("")
      ImGuiExt.Text(UIText.Diagnostics.textfield_4)
    end

    for _, mod in pairs(Diagnostics.modfiles) do
      ImGuiExt.Text(mod)
    end
   
    ImGui.EndTabItem()
  end
end

return Diagnostics