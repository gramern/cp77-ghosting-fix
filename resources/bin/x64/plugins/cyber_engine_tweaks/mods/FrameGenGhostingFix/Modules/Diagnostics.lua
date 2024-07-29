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

local DiagnosticsText = Localization.GetDiagnosticsText()


function Diagnostics.IsUpdateRecommended()
  return Diagnostics.isUpdateRecommended
end

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
end

function Diagnostics.OnInitialize()
  -- Diagnostics.CheckModsCompatibility()
  if Diagnostics.isModsCompatibility then return end
  Globals.SetModReady(false)
end

--Local UI
function Diagnostics.DrawUI()
  if ImGui.BeginTabItem(DiagnosticsText.tabname) then
    if not Diagnostics.isModsCompatibility then
      ImGuiExt.TextRed(DiagnosticsText.title_warning)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.textfield_1)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.textfield_2)
    else
      ImGuiExt.TextGreen(DiagnosticsText.title_info)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.textfield_3)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.textfield_4)
    end

    for _, mod in pairs(Diagnostics.modfiles) do
      ImGuiExt.Text(mod)
    end
   
    ImGui.EndTabItem()
  end
end

return Diagnostics